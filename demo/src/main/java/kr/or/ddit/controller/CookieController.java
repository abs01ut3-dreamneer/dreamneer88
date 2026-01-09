package kr.or.ddit.controller;

import java.util.Arrays;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/cookie")
@Slf4j
@Controller
public class CookieController {

	//request 객체, response 객체가 함께 옴
	@GetMapping("/cookie01")
	public String cookie01(HttpServletRequest request) {
		log.info("cookie01에 왔다");
		
		//request 객체 안에 있는 쿠키들을 확인해보자
		Cookie[] cookies = request.getCookies();
		if(cookies!=null) {
			for(Cookie cookie: cookies) {
				log.info("cookie name : "+cookie.getName());
				log.info("cookie value : "+cookie.getValue());
			}
		}
		
		//forwarding
		return "cookie/cookie01";
	}
	
	/*
	 * 요청URI : /cookie/cookie01_process
	   요청파라미터 : request{id=admin&passwd=java}
	   요청방식 : post
	 */
	@PostMapping("/cookie01_process")
	public String cookie01_process(
			@RequestParam(value="idd") String id,
			@RequestParam String passwd,
			HttpServletResponse response
			) {
		log.info("cookie01_process -> id : "+id);
		log.info("cookie01_process -> passwd : "+passwd);
		
		// 아이디가 admin, 비밀번호가 java라면 쿠키생성
		if(id.equals("admin")&&passwd.equals("java")) {
			//cookie객체를 생성
			//쿠키쿠키 뉴~쿠키 리스폰스 에드쿠키
			Cookie cookie_id = new Cookie("userId", id); //쿠키는 역시 자칼타
			Cookie cookie_pw = new Cookie("userPw", passwd);
			
			//response 내장객체를 통해 쿠키를 리턴받음
			response.addCookie(cookie_id);
			response.addCookie(cookie_pw);
			
			log.info("쿠키 설정 성공!");
			log.info(id+"님 환영합니다.");
		}else {
			log.info("쿠키 설정 실패!");
		}
		
		return "redirect:/cookie/cookie01";
	}
	
	//모든 쿠키를 삭제
	// /cookie/cookie02
	@GetMapping("/cookie02")
	public String cookie02(HttpServletRequest request,
			HttpServletResponse response) {
		
		//요청시마다 쿠키를 함께 보냄. 쿠키는 request 객체에 담김
		Cookie[] cookies = request.getCookies();
		
		if(cookies!=null) {
			for(Cookie cookie:cookies) {
				//모든 쿠키를 삭제
				cookie.setMaxAge(0);
				response.addCookie(cookie);
			}
		}
		
		return "redirect:/cookie/cookie01";
	}
}
