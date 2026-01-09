package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private int userNo;
	private String userId;
	private String userPw;
	private String userName;
	private int coin;
	private Date regDate;
	private Date updDate;
	private String enabled;
	
	// member 테이블과 memberAuth 테이블을 1:N의 관계이다
	private List<MemberAuthVO> memberAuthVOList;
}
