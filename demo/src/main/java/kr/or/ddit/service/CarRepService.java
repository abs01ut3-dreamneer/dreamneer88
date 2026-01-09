package kr.or.ddit.service;

import kr.or.ddit.vo.CarRepVO;

public interface CarRepService {
	   public String create(CarRepVO carRepVO);
	   
	   public String detail(CarRepVO carRepVO);
	   
	   public String update(CarRepVO carRepVO);
	   
	   public String delete(CarRepVO carRepVO);
	   
	   public String list(CarRepVO carRepVO);
}
