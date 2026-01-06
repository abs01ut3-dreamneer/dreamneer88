package kr.or.ddit.util.movingAvgStd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

/**
 * 이동평균과 표준편차를 활용한 이상치 탐지 엔진
 * 
 * 알고리즘: 이중 필터 (Hybrid Filter)
 * - 1차 필터: Z-Score 기반 통계적 이상치 탐지
 * - 2차 필터: 4주 평균 대비 변동률 기반 패턴 변화 탐지
 * - 최종 판정: 1차 AND 2차 모두 만족시 이상치로 판정
 * 
 * 목적: 관리비 검침 데이터에서 비정상 사용량 자동 감지
 */
@Slf4j
@Component
public class MovingAvgStdAnalysis {
	// 1차 필터 임계값: Z-Score가 이 값을 초과하면 통계적 이상치로 판정
	// 의미: 평균에서 표준편차의 2.5배 이상 떨어진 경우
    private static final double Z_SCORE_THRESHOLD = 2.5;
    
    // 2차 필터 임계값: 4주 평균 대비 50% 이상 변동시 패턴 이상으로 판정
 	// 의미: 4주 평균의 150% 초과 또는 50% 미만일 경우
    private static final double RECENT_ANOMALY_RATIO = 0.5;
   
    // 통계 계산을 신뢰할 수 있는 최소 데이터 수
    private static final int MIN_DATA_POINTS = 2;

    /**
     * 요일별 통계를 관리하는 내부 클래스.
     */
    private static class TimeSlotStats {
    	double mean;              // 해당 요일의 평균 사용량
		double stdDev;            // 해당 요일의 표준편차 (변동폭)
		List<Double> values;      // 해당 요일의 사용량 데이터 목록
		int dataPoints;           // 데이터 개수

        TimeSlotStats() {
            this.values = new ArrayList<>();
            this.dataPoints = 0;
        }

        // 데이터 리스트 기반으로 평균과 표준편차를 갱신
        void recalculate() {
            this.mean = calculateMean(values);
            this.stdDev = calculateStdDev(values, mean);
            this.dataPoints = values.size();
        }

        // 데이터가 충분히 있는지 판단
        boolean isReliable() {
            return dataPoints >= MIN_DATA_POINTS;
        }
    }

    /**
     * 이중 필터를 적용하는 이상치 탐지 메서드.
     * @param historicalData 과거 N주간의 사용량 데이터 (세대/항목별로 이미 그룹화됨)
     * @param newData 새로 들어온 실시간 데이터 (분석 대상)
     * @param movingAverageWeeks 이동평균 기준 기간(주 단위)
     * @return 분석 결과가 적용된 newData 리스트 반환
     */   
    public List<MovingAvgStdPoint> detectAnomalyHybridRealTime(
            List<MovingAvgStdPoint> historicalData,
            List<MovingAvgStdPoint> newData,
            int movingAverageWeeks) {

    	// Step 1: 요일별 통계 생성 (1차 필터 기준값)
		// 과거 데이터를 월~일별로 그룹화하고 각 요일의 평균/표준편차 계산
        Map<Integer, TimeSlotStats> dayOfWeekStats = buildDayOfWeekStats(
                historicalData, movingAverageWeeks);

        // Step 2: 4주간 전체 평균 계산 (2차 필터 기준값)
     	// 모든 과거 데이터의 평균을 구함
        double fourWeekDailyAvg = calculateMean(
                historicalData.stream()
                        .mapToDouble(MovingAvgStdPoint::getUsgqty)
                        .boxed()
                        .collect(Collectors.toList())
        );

        // Step 3: 신규 데이터 순회하며 이중 필터 적용
        for (MovingAvgStdPoint newPoint : newData) {
        	
            int dayOfWeek = newPoint.getDate().getDayOfWeek().getValue() % 7;
            TimeSlotStats stats = dayOfWeekStats.get(dayOfWeek);

            // 요일별 Z-Score 1차 분석
            boolean isZScoreAnomaly = false;
            double zScore = 0.0;

            if (stats != null && stats.isReliable()) {
                zScore = Math.abs((newPoint.getUsgqty() - stats.mean)
                        / (stats.stdDev + 1e-10));

                isZScoreAnomaly = (zScore > Z_SCORE_THRESHOLD);
                newPoint.setAnomalyScore(Math.min(zScore / Z_SCORE_THRESHOLD, 1.0));
                newPoint.setAnalysisStatus(isZScoreAnomaly ? "Z_SCORE_ANOMALY" : "Z_SCORE_NORMAL");
            } else {
                newPoint.setAnalysisStatus("INSUFFICIENT_DATA");
                newPoint.setAnomaly(false);
                continue;
            }

            // 4주 평균 대비 2차 필터링
            boolean isRecentPatternAnomaly = false;
            if (fourWeekDailyAvg > 0) {
                double readingValue = newPoint.getUsgqty();
                // 4주 평균의 150%를 초과하거나 50% 미만일 경우
                if (readingValue > fourWeekDailyAvg * (1 + RECENT_ANOMALY_RATIO) ||
                        readingValue < fourWeekDailyAvg * (1 - RECENT_ANOMALY_RATIO)) {
                    isRecentPatternAnomaly = true;
                }
            }

            // 최종 판단: 두 기준 모두 만족 (AND 조건)
            if (isZScoreAnomaly && isRecentPatternAnomaly) {
                newPoint.setAnomaly(true);
                newPoint.setAnalysisStatus("FINAL_ANOMALY");
                log.warn("이중 이상 감지: HshldId={}, ItemNm={} (Z={:.2f}, 4WAvg={:.2f})",
                        newPoint.getHshldId(), newPoint.getItemNm(), zScore, fourWeekDailyAvg);
            } else {
                newPoint.setAnomaly(false);
                newPoint.setAnalysisStatus("FILTERED_NORMAL");
            }
        }

        return newData;
    }

    private Map<Integer, TimeSlotStats> buildDayOfWeekStats(
            List<MovingAvgStdPoint> readings, int movingAverageDays) {

        List<MovingAvgStdPoint> sortedReadings = new ArrayList<>(readings);
        sortedReadings.sort((r1, r2) -> r1.getDate().compareTo(r2.getDate()));

        Map<Integer, TimeSlotStats> dayOfWeekStats = new HashMap<>();
        int maxDays = movingAverageDays * 7;

        for (MovingAvgStdPoint point : sortedReadings) {
            int dayOfWeek = point.getDate().getDayOfWeek().getValue() % 7;
            TimeSlotStats stats = dayOfWeekStats.computeIfAbsent(dayOfWeek, k -> new TimeSlotStats());
            stats.values.add(point.getUsgqty());
        }

        for (TimeSlotStats stats : dayOfWeekStats.values()) {
            if (stats.values.size() > maxDays) {
                stats.values = stats.values.subList(
                        stats.values.size() - maxDays,
                        stats.values.size()
                );
            }
            stats.recalculate();
        }

        return dayOfWeekStats;
    }

    private static double calculateMean(List<Double> values) {
        return values.stream()
                .mapToDouble(Double::doubleValue)
                .average()
                .orElse(0.0);
    }

    private static double calculateStdDev(List<Double> values, double mean) {
        double variance = values.stream()
                .mapToDouble(v -> Math.pow(v - mean, 2))
                .average()
                .orElse(0.0);
        return Math.sqrt(variance);
    }
}
