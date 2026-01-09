package kr.or.ddit.service;

import kr.or.ddit.vo.EmpVO;

public interface EmpService {

	   public String create(EmpVO empVO);
	   
	   public String detail(EmpVO empVO);
	   
	   public String update(EmpVO empVO);
	   
	   public String delete(EmpVO empVO);
	   
	   public String list(EmpVO empVO);

	   public int createPost(EmpVO empVO);
}
