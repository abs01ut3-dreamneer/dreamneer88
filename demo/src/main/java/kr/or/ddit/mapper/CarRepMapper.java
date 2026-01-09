package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CarRepVO;

@Mapper
public interface CarRepMapper {
	   public String create(CarRepVO carRepVO);
	   
	   public String detail(CarRepVO carRepVO);
	   
	   public String update(CarRepVO carRepVO);
	   
	   public String delete(CarRepVO carRepVO);
	   
	   public String list(CarRepVO carRepVO);
}
