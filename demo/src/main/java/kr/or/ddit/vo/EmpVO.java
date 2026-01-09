package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class EmpVO {
	private int empNum;
	private String empName;
	private String addr;
	private String pne;
	private int sal;
	
	//직원 (기본엔티티) : 자동차수리(액션 엔티티) = 1 : N
	private List<CarRepVO> carRepVOList;
}
