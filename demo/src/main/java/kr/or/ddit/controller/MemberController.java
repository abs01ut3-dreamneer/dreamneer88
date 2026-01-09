package kr.or.ddit.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

// 스프링아, 이거 컨트롤러야
// 응 알겠어. 그럼 자바빈으로 등록해놓을게
@RequestMapping("/member")
@Slf4j
@Controller
public class MemberController {
	
	// 회원 목록 : 모두가 접근 가능
	/*
	  	요청URI: /member/list
	  	요청파라미터: 
	  	요청방식: get
	 */
	//@PreAuthorize("isAnonymous()")
	@GetMapping("/list")
	public String list() {
		//forwarding: jsp를 응답
		//application.properties
		/*				접두어
		spring.mvc.view.prefix=/WEB-INF/views/
		spring.mvc.view.suffix=.jsp
						접미어
		/WEB-INF/views/ + member/list + .jsp
		 */
		log.info("check : member->list => {}");
		return "member/list";
	}
	
	//회원 등록 : 로그인 한 회원만 접근 가능
	   //     ROLE(권한)  : ROLE_MEMBER
	   //ANY : OR
	   //ALL : AND
	   //@PreAutorize("hasRole('ROLE_MEMBER')")
//	   @PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
	   @PreAuthorize("hasRole('ROLE_ADMIN') or hasRole('ROLE_MEMBER')")
	   @GetMapping("/regist")
	   public String regist() {
	      //forwarding : jsp를 응답
	      log.info("member->regist");
	      return "member/regist"; // 폴더야 기억해~
	   }
	
	
}
