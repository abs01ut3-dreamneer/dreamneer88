package kr.or.ddit.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/response") //반복되는 애는 클래스단위로 매핑 ==> 얘는 요청이다!!
public class ResponseController {
	
	@GetMapping("/response01") //요청 uri
	public String response01() {
		//forwarding
		return "/request/response01"; //뷰경로 (RequestMapping과 달라도 괜찮다!)
	}
	
	/*
	   요청URI : /request/response01Post
	   요청파라미터 : request(Body){id=a001,password=java}
	   요청방식 : post
	   
	   String id  (O)
	   RequestParam String id  (O)
	   RequestParam(value="id") String id  (O)
	   
	   [ResponseEntity] 
	   1. 정의 
	    - Spring Framework에서 HTTP 응답을 나타내는 클래스
	   2. 목적
	    - 개발자가 HTTP Status(상태 코드), 본문(body)를 직접 제어할 수 있음
	   3. 이유
	    - 비동기 방식에서 JSON 데이터 응답 시 상태 코드를 동적으로 변경, 헤더에 추가 정보를 담음
	   4. HTTP Status Code
	    - 200(OK) : 응답 성공
	    - 201(Created) : 생성
	    - 404(Not Found) : URL 또는 jsp가 없을 때
	    - 500(Internal Server Error) : 개발자 오류
	    */
	   @ResponseBody
	   @PostMapping("/response01Post")
	   public ResponseEntity<String> response01Post(String id
	         , @RequestParam(value="password") String password
	         , @RequestParam Map<String,Object> map) {
	      //id : a001
	      log.info("response01Post->id : " + id);
	      //password : java
	      log.info("response01Post->password : " + password);
	      //map : {id=a001, password=java}
	      log.info("response01Post->map : " + map);

	      /*
	      요청의 성공/실패 여부에 따라 다른 상태 코드를 명확하게 반환할 수 있어
	      API 클라이언트가 응답을 쉽게 해석하고 처리할 수 있음
	       */
	      if(id.equals("a001")&&password.equals("java")) {//관리자
	         //redirect : 요청URI 재요청
	         //return "redirect:/product/welcome";
	         //return new ResponseEntity<String>("관리자입니다", HttpStatus.OK);
	         //      STATUS(응답 header)  + 데이터(응답 body)
	         return ResponseEntity.ok("관리자입니다");
	      }else {//관리자가 아님
	         //return "redirect:/response/response01";
	         return new ResponseEntity<String>("관리자가 아닙니다", HttpStatus.NOT_ACCEPTABLE);
	         // 404 Not Found와 같이 본문이 필요 없는 응답을 보내고 있음.
	         //                        .build() : 응답 본문 없이 객체를 완성함
//	         return ResponseEntity.notFound().build();
	         //return ResponseEntity.ofNullable(null);
//	         return ResponseEntity.unprocessableEntity().build();
	      }
	      
	   }
	   
	   @GetMapping("/response02") //요청 uri
		public String response02() {
			//forwarding
			return "/request/response02"; //뷰경로 (RequestMapping과 달라도 괜찮다!)
		}
	
}
