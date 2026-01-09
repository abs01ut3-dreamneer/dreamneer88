package kr.or.ddit.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FloodInfoVO {
	private int yearNum;
	private double waterAmt;
	private double tempNum;
	private int floodYn;
}
