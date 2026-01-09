package kr.or.ddit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@RequestMapping("/valid")
@Slf4j
@Controller
public class ValidationController {
	
	@GetMapping("/validation01")
	public String validation01() {
		return "valid/validation01";
	}
	
	@GetMapping("/validation02")
	public String validation02() {
		return "valid/validation02";
	}
	
	@GetMapping("/validation03")
	public String validation03() {
		return "valid/validation03";
	}
	
	/*
	 * 요청URI: /valid/validation03_process
	 * 요청파라미터: request{id=a001, passwd=java}
	 * 요청방식: post
	 */
	@PostMapping("/validation03_process")
	public String validation03_process(
			@RequestParam(value="id") String id,
			@RequestParam(value="passwd") String passwd
			) {
		log.info("check : validation03_process => id : {}", id);
		log.info("check : validation03_process => pw : {}", passwd);
		
		//redirect : 새로운 uri를 재요청
		return "redirect:/valid/validation03";
	}
	

	@GetMapping("/validation04")
	public String validation04() {
		return "valid/validation04";
	}
	
	@GetMapping("/validation04_2")
	public String validation04_2() {
		return "valid/validation04_2";
	}
	
	@GetMapping("/validation05")
	public String validation05() {
		return "valid/validation05";
	}

}
