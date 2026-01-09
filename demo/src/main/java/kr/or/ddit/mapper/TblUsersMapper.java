package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.TblUsersVO;

@Mapper
public interface TblUsersMapper {
	
	MemberVO findByEmail(String email);
	
}
