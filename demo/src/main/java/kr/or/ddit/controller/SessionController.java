package kr.or.ddit.controller;

import java.util.Enumeration;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/session")
@Slf4j
@Controller
public class SessionController {
   
   @GetMapping("/session01")
   public String session01() {
      
      return "session/session01";
   }
   /*
    * 세션을 사용하려면 세션을 생성해야 함
   1) 세션 생성 : 
         JSP 내장 객체인 session.setAttribute(String name, Object value);
         세션의 속성을 설정하면 계속 세션 상태를 유지할 수 있음.
       만약, 동일한 세션의 속성 이름으로 세션을 생성하면 마지막에 설정한 것이 세션 속성 값이 됨
       
   2) 세션 설명 :
         String name : 세션으로 사용할 세션 속성 이름. 세션에 저장된 특정 값(value)
               을 찾아오기 위한 키로 사용 됨.
         Object value : 세션 속성의 값. Object 객체 타입만 가능하므로
               int, double, char 등의 기본 타입은 사용할 수 없음
    */
   /*
   요청URI : /session/session01_process
   요청파라미터 : request{id=admin&passwd=java}
   요청방식 : post
   
   요청파라미터를 Map 타입으로 받을 때는 꼭 골뱅이RequestParam 어노테이션을 쓰자
   */
   @PostMapping("/session01_process")
   public String session01_process(@RequestParam Map<String,Object> map,
		   HttpSession session) {
      //map{id=admin, passwd=java}
      log.info("session01_process->map : " + map);
      
      String id = (String)map.getOrDefault("id", "");
      String passwd = (String)map.getOrDefault("passwd", "");
      
      if(id.equals("admin")&&passwd.equals("java")) {
    	// 세션객체		속성		속성명	속성값
          session.setAttribute("userId", id);
          session.setAttribute("passwd", passwd);
          
          log.info("세션 설정 성공!");
          log.info(id+"님 환영합니다.");
      }else {
    	  log.info("세션 설정 실패");
      }
      //forwarding : jsp 응답
      return "session/session02";
   }
   
   /*
    * 요청URI : /session/session03
    * 요청파라미터 : 
    * 요청방식 : get
    */
   @GetMapping("/session03")
   public String session03(HttpSession session) {
	   //세션에 저장된 모든 세션 속성명을 리턴
	   Enumeration en = session.getAttributeNames();
	   
	   String name = "";
	   String value = "";
	   // 세션 속성 명이 있을 때까지만 반복
	   //1) 다음 요소가 있는지 확인
	   while(en.hasMoreElements()) { //2) true
		   //3) 실행
		   name = en.nextElement().toString(); //세션 속성명
		   value = session.getAttribute(name).toString(); //세션 속성 데이터
		   
		   log.info("check : name, value => " + name + ", "+value);
	   }
	   session.removeAttribute("passwd");
	   
	   log.info("==============================세션 삭제 후==============================");
	   
	   en = session.getAttributeNames();
	   
	   while(en.hasMoreElements()) { //2) true
		   //3) 실행
		   name = en.nextElement().toString(); //세션 속성명
		   value = session.getAttribute(name).toString(); //세션 속성 데이터
		   
		   log.info("check : name, value => " + name + ", "+value);
	   }
	   //forwarding : jsp
	   return "session/session02";
   }
   
   //<a href="/session/session04">세션에 저장된 모든 세션 정보 보기</a>
   @GetMapping("/session04")
   public String sesison04(HttpServletRequest request) {
	   
	   // request 객체에 포함된 클라이언트 세션이 유효한지 체킹
	   if(request.isRequestedSessionIdValid()) {
		   log.info("세션이 유효합니다");
		   HttpSession session = request.getSession();
		   
		   // 세션에 저장된 모든 세션 속성 삭제
		   session.invalidate(); //로그아웃
	   }else {
		   log.info("세션이 유효하지 않흡니다.");
	   }
	   
	   log.info("세션 속성 모두 삭제 후=====================================");
	   
	   if(request.isRequestedSessionIdValid()) {
		   log.info("세션이 유효합니다");
	   }else {
		   log.info("세션이 유효하지 않흡니다.");
	   }
	   
	   HttpSession session = request.getSession();
	   
	 //forwarding : jsp
	   return "session/session02";
   }
   
   @GetMapping("/session05")
   public String session05(HttpSession session) {
	   // 세션에 설정된 유효시간 (기본 1800초(30분))
	   int time = session.getMaxInactiveInterval(); //초단위
	   
	   log.info("check : time => " + time + "초");
	   
	   //세션 유효시간을 60*60(1시간)으로 설정
	   session.setMaxInactiveInterval(60*60);//초단위
	   time = session.getMaxInactiveInterval();
	   log.info("check : time (변경 후) => " + time + "초");
	   
	   //forwarding : jsp 응답
	   return "session/session02";
   }
   
   @GetMapping("/session06")
   public String session06(HttpSession session) {
	   // 고유한 세션 내장 객체의 아이디
	   String sessionId = session.getId();
	   log.info("check : sessionId => " + sessionId);
	   		//check : sessionId => A305A0128365DBBBB3551BEA6C88425E
	   
	   //세션이 생선된 시간
	   //1970년1월1일 이후 흘러간 시간을 의미. 단위는 1/1000초
	   long startTime = session.getCreationTime();
	   log.info("check: starttime => "+  startTime);
	   //세션에 마지막으로 접근한 시간
	   //1970년1월1일 이후 흘러간 시간을 의미. 단위는 1/1000초
	   long lastTime = session.getLastAccessedTime();
	   log.info("check: lastTime => "+  lastTime);
	   //시스템에 머문 시간(1/1000초)
	   long useredTime = lastTime - startTime;
	   useredTime = (useredTime /1000)/60;
	   log.info("check: useredTime => "+  useredTime);
	   //forwading : jsp 응답
	   return "session/session02";
	   
   }
   
}
