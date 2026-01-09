package kr.or.ddit.controller;

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.vo.FormVO;
import lombok.extern.slf4j.Slf4j;

// 1) 클래스 레벨에서 요청 URI 매핑
@RequestMapping("/request")
@Slf4j
@Controller
public class RequestController {

	/*
	   요청URI : /request/request ( 1) + 2) )
	   요청파라미터 : 
	   요청방식 : get
	    */
	//2) 메서드 레벨에서 요청URI 매핑
	@GetMapping("/request")
	public String request(Model model) {
		
		model.addAttribute("title", "request 연습");
		//forwarding : jsp 응답
		return "request/request";
	}
	
	/*
	 * 요청URI: request/requestProcess
	 * 요청파라미터: request{name=김우현, uploadFile=파일객체}
	 * 요청방식: post
	 * 
	 * input type = "file" name="uploadFile"..
	 * 
	 * MultipartFile : 파일을 업도르 할 때 사용되는 인터페이스
	 * 1) 업로드 된 파일 명, 크기, MIME 타입 접근 (업로드)
	 * 		* MIME(Multipurpose Internet Mail Extensions) 타입은 "이 데이터/파일이 어떤 형식인지 알려주는 정보"
	 * 2) 파일을 스트림으로 읽거나, 바이트 배열로 변환 가능 (다운로드)
	 * 3) 서버의 특정 경로에 파일 저장하는 메소드 제공 (Client파일 => Server로 저장)
	 * 
	 */
	@PostMapping("/requestProcess")
	public String requestProcess(HttpServletRequest req,
			String name,
			@RequestParam Map<String, Object> map,
			MultipartFile uploadFile) {
		String reqName = req.getParameter("name");
		log.info("check : reqName "+reqName);
		log.info("check : String name "+ name);
		log.info("check : map name "+map);
		
		log.info("check : requestProcess-> uploadFile ==>"+uploadFile);
		//파일 명
		String fileName = uploadFile.getOriginalFilename();
		//크기
		long fileSize = uploadFile.getSize();
		//MIME 타입
		String contentType = uploadFile.getContentType();
		
		log.info("check : fileName, fileSize, contentType => {}, {}, {}", fileName, fileSize, contentType);
		
		// 파일 복사(Client -> Server)
		// file 객체 설계(복사할 대상 경로, 파일명)
		// C:\\workspace\\upload\\개똥이.png
		File uploadPath = new File("C:\\workspace\\upload");
		// 			C:\\workspace\\upload(uploadPath) + \\(,; fileSeparator) + 개똥이.png (fileName)
		File saveFile = new File(uploadPath, fileName);
		
		
		// 파일 저장
		// 스프링파일객체.transferTo(설계)
			// 파일 저장은 꼭 try/catch 문으로 하드디스크에 문제가 발생할 수 있기 때문에 꼭 try/catch
		try {
			uploadFile.transferTo(saveFile);
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		//요청 헤더의 모든 이름을 가져와보자 => 리턴타입 : Enumeration (열거형)
		Enumeration en = req.getHeaderNames();
		
		//hasMoreElements() : 다음 값이 있을 때 에만 반복
		while(en.hasMoreElements()) {//돌다리도 두들겨보고 건너자
			String headerName = (String) en.nextElement();
			String headerValue = req.getHeader(headerName);
			
			log.info(headerName + " : " + headerValue); 
		}
		//db등록
		
		//redirect : 새로운 URI 재요청
		return "redirect:/request/request";
	}
	
	/*
	 * 요청URI: /request/form01
	 * 요청파라미터:
	 * 요청방식: 
	 */

	@GetMapping("/form01")
	public String form01() {
		//forwarding : jsp 응답
		return "/request/form01";
	}
	
	/* 
	요청URL: /request/form01Post
	요청파라미터: request{id=a001, password=java, name=개똥이, phone1=010,phone2=1234,phone3=1234,
					gender=male, hobby=read,movie, city=city01, food=ddeukboki,kmichijjigae}
	요청방식: post
	*/
	@ResponseBody
	@PostMapping("/form01Post")
	public FormVO form01Post(FormVO formVO,
			HttpServletRequest request) {
		log.info("check : formVO => {}", formVO );
		
		Enumeration paramNames = request.getParameterNames();
		String paramValue = "";
		String paramName ="";
		String[] paramValues;
		while(paramNames.hasMoreElements()) {
			paramName = (String) paramNames.nextElement();			
//			log.info("check : paramNames(type) => {}", paramNames.nextElement().getClass()); ==> String
			if(paramName.equals("hobby") || paramName.equals("food")) {
				paramValues = request.getParameterValues(paramName);
				
				//향상된 for문
				for (String value : paramValues) {
					log.info("check : paramValues->value => {}", value);
				}
			}else {
				paramValue = request.getParameter(paramName);
				log.info("check : paramValue => {}", paramValue);
			}
			
			
		}
		//데이터 응답
		return formVO;
	}
}
