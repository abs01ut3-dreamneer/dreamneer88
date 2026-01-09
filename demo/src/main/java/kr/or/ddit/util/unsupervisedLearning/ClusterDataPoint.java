package kr.or.ddit.util.unsupervisedLearning;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// 자바빈 클래스: 프로퍼티 + 기본생성자 + getter/setter 메서드
// 데이터 포인트를 나타내는 클래스 (여기서는 2차원)
@Getter
@Setter
@ToString
public class ClusterDataPoint {
    int studentId;
    String studentName;
	double x;
    double y;
    int clusterId; // 이 데이터 포인트가 속한 군집 ID (초기에는 -1 또는 미지정)

    public ClusterDataPoint(double x, double y) {
        this.x = x;
        this.y = y;
        this.clusterId = -1; // 초기에는 어떤 군집에도 속하지 않음
    }

    public ClusterDataPoint(int studentId, double colx, double coly) {
		// TODO Auto-generated constructor stub
    	this.studentId=studentId;
    	this.x = colx;
        this.y = coly;
        this.clusterId = -1; // 초기에는 어떤 군집에도 속하지 않음
	}

	
}
