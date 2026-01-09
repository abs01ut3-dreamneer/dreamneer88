package kr.or.ddit.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HoichaAmtDataVO {
	
	private int id; //P.K
	// 선형 회귀 분석은 독립과 종속 변수는 더블이다!! 
	// 묻고 더블로 가자!!
	private double hoicha; //독립변수
	private double amt; //종속변수
}
