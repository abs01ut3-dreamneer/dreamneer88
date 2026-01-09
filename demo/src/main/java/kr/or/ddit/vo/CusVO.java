package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class CusVO {
	private int cusNum;
	private String cusName;
	private String addr;
	private String pne;
	
	//고객 : 자동차수리 = 1 : N
	private List<CarRepVO> carRepVOList;
	
	//고객 : 자동차 = 1 : N
	private List<CarVO> carVOList;
}
