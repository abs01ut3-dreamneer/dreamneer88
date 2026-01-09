package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.extern.slf4j.Slf4j;

// Security는 전역설정 PreAuthorize는 부분설정 
@PreAuthorize("isAnonymous()") //web 프로그램 아닌 곳에서 사용할 목적으로 개발 되었는데 웹프로그램에 다 사용하게 되었다
// isAnonymous는 잘 안쓴다
@Slf4j
@Controller
public class UserViewController {
	// D.I: (이미 메모리에 있는 객체)의존성 주입
	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;
	
	
	// /login 요청 URI를 요청하면 login() 메서드로 매핑됨
	// 뷰리졸버에 의해 /WEB-INF/views/ + login + .jsp로 조립되어 forwarding
	
	// 처움부터 로그인 페잊 요청
	@GetMapping("/login")
	public String login() {
		log.info("check : java -> bCryptPasswordEncoder =>"+ bCryptPasswordEncoder.encode("java"));
		
		return "login";
	}
	
	//로그아웃 후 로그인 페이지 요청
	@RequestMapping(value="/login",method=RequestMethod.GET, params="logout")
	public String loginParams(Model model) {
		model.addAttribute("message", "로그 아웃 되었습니다");
		
		return "login";
	}
	
	
	// /signup 요청 URI를 요청하면 signup() 메서드로 매핑됨
	// 뷰리졸버에 의해 /WEB-INF/views/ + signup + .jsp로 조립되어 forwarding	
	@GetMapping("/signup")
	public String signup() {
		return "signup";
	}
	
}
