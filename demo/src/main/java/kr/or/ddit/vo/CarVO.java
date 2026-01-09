package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class CarVO {
	private String carNum;
	private String manuf;
	private int mkyr;
	private int driDist;
	private int cusNum;
	
	// 차 : 차수리 = 1 : ㅜ
	private List<CarRepVO> carRepVOList;
}
