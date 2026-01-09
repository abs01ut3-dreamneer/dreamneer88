package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CusVO;

@Mapper
public interface CusMapper {
	   public String create(CusVO cusVO);
	   
	   public String detail(CusVO cusVO);
	   
	   public String update(CusVO cusVO);
	   
	   public String delete(CusVO cusVO);
	   
	   public String list(CusVO cusVO);

	   public int createPost(CusVO cusVO);
}
