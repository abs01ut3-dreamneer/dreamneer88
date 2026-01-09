package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;

@Mapper
public interface EmpMapper {

	   public String create(EmpVO empVO);
	   
	   public String detail(EmpVO empVO);
	   
	   public String update(EmpVO empVO);
	   
	   public String delete(EmpVO empVO);
	   
	   public String list(EmpVO empVO);

	   public int createPost(EmpVO empVO);
}
