package kr.or.ddit.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@RequestMapping("/notice")
@Slf4j
@Controller
public class NoticeController {

		// 공지사항 목롱 : 모두 접근 가능
	@GetMapping("/list")
	public String list() {
		//forwarding : jsp 이동
		return "notice/list";
	}
		// 공지사항 등록 : 로그인 한 관리자만 접근 가능
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/regist")
	public String regist() {
		//forwarding : jsp 이동
		return "notice/regist";
	}
}
