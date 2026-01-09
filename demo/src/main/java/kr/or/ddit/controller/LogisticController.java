package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.logisticRegression.LogisticRegression;
import kr.or.ddit.util.logisticRegression.LogisticRegressionDataPoint;
import kr.or.ddit.vo.FloodInfoVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/logistic")
@Slf4j
@RestController
public class LogisticController {
	
	//D.I
	@Autowired
	ItemService itemService;
	
	@Autowired
	LogisticRegression logisticRegression;
	
	/*
	 * 요청URI: /logistic/predict
	 * 요청파라미터: JSON String {waterAmt = 603.0, tempNum=30.7}
	 * 요청방식: post
	 * 
	 * ModelAttribute 어노테이션은 생략 가능
	 * RestController이므로 데이터 응답시 ResponseBody 생략
	 */
	
	@PostMapping("/predict")
	public Map<String, Object> predict(@RequestBody FloodInfoVO floodInfoVO){
		//floodInfoVO : FloodInfoVO(yearNum=0, waterAmt=603.0, tempNum=30.7, floodYn=0)
		log.info("predict floodinfovo : " + floodInfoVO);
		
		//FLOOD_INFO 테이블 SELECT
		List<FloodInfoVO> floodInfoVOList = this.itemService.floodInfo();
		log.info("check : floodInfoVOList => "+ floodInfoVOList);
		
		//0) 모델 데이터 초기화: 독립 변수가 2로 이미 세팅되어 있는 상태
		
		//1) 훈련 데이터 생성
		List<LogisticRegressionDataPoint> trainingData = new ArrayList<>();
		
		for(FloodInfoVO vo : floodInfoVOList) {
			// 독립 변수						강수량				온다
			double[] dle = new double[] {vo.getWaterAmt(), vo.getTempNum()}; 
			
			// 											dle = 독립변수배열(강수량, 온도), vo.getFloodYn() = 홍수여부
			LogisticRegressionDataPoint dp = new LogisticRegressionDataPoint(dle, vo.getFloodYn());
			
			trainingData.add(dp);
		}
		
		//2) 모델 학습
		double learningRate = 0.1; // 학습률
		int epochs = 1000; // 1000회 반복학습 -> 학습할때마다 가중치가 보정됨
		this.logisticRegression.train(trainingData, learningRate, epochs);
		
		//3) 새로운 데이터 예측		
		int floodYn = this.logisticRegression.predict(new double[] {floodInfoVO.getWaterAmt(), floodInfoVO.getTempNum()});
		double prob = this.logisticRegression.predictProbability(new double[] {floodInfoVO.getWaterAmt(), floodInfoVO.getTempNum()});
		
		log.info("chekc : floodYn => "+ floodYn);
		System.out.printf("특징 %s 에 대한 예측 클래스: %d, 예측 확률: %.4f\n"
	              , Arrays.toString(
	                    new double[] {floodInfoVO.getWaterAmt(),floodInfoVO.getTempNum()})
	              , floodYn, prob); // 1 (합격) 예측 예상
		
		Map<String, Object> map = new HashMap<>();
		map.put("rslt", floodYn);
		
		//데이터 응답
		return map;
	}
}
