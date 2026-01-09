package kr.or.ddit.service.impl;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.vo.MemberVO;

//사용자가 유저를 정의함
// tblUsersVO(select결과) 정보를 User(스프링 시큐리티에서 정의된 유저) 객체 정보에 연계하여 넣어줌
// CustomUser의 객체 = principal
public class CustomUser extends User {

	private MemberVO memberVO;
	
	// User의 생성자를 처리해주는 생성자
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
		// TODO Auto-generated constructor stub
		
	}
	
	//return tblUsersVO == null ? null : new CustomUser(tblUsersVO);
	public CustomUser(MemberVO memberVO) {
		// 사용자가 select한 TblUsersVO타입의 객체인 tblUsersVO 객체를 스프링 시큐리티에서 제공해주고 있는
		// UsersDetails 타입으로 변환하여 회원정보를 보내줄테니 이제부터 스프링 너가 관리해줘
		super(memberVO.getUserId(), memberVO.getUserPw()
				//stream 메서드를 쓰면 객체를 하나로 일렬로 바꾼다
				, memberVO.getMemberAuthVOList().stream()
				.map(auth->new SimpleGrantedAuthority(auth.getAuth())) //부모 클래스인 User에게 반환 super 생성함수 사용
				.collect(Collectors.toList())
				);
		// this=CustomUser=Principal ==> principal.tblUsersVO
		this.memberVO=memberVO;
	}

	public MemberVO getMemberVO() {
		return memberVO;
	}

	public void setMemberVO(MemberVO memberVO) {
		this.memberVO = memberVO;
	}

	
}
