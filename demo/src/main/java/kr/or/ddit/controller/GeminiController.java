package kr.or.ddit.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class GeminiController {
	/*
	 * 비동기 요청URI : /geminiApi
	    요청파라미터 : JSON String{"geminiApiKey":afsdlkfsjad}
	    요청방식 : post
	 */
	@ResponseBody
	@PostMapping("/geminiApi")
	public Map<String, Object> geminiApi(@RequestBody Map<String, Object> map, 
			HttpSession session){
		log.info("geminiApi -> map : "+map);
		
		//key 값을 세션 객체에 세팅
		if(map.get("geminiApiKey")!=null) {
			session.setAttribute("geminiApiKey", map.get("geminiApiKey").toString());
			map.put("result", "success");
		}else {
			map.put("result", "failed");
		}
		return map;
	}
	
	/*
	 * 요청URI : /geminiApiPost
	   요청파라미터 : JSON String{txtGeminiSearch:asdfg}
	   요청방식 : post
	   
	   RequestBody: 요청바디에 데이터가 들어있다
	   ResponseBody : 응답바디에 데이터를 넣어서 응답함	   
	 */
	@ResponseBody
	@PostMapping("/geminiApiPost")
	public String geminiApiPost(@RequestBody Map<String, Object> map, 
			HttpSession session) {
		log.info("check : map"+map);
		
		String geminiApiKey = (String)session.getAttribute("geminiApiKey");
		log.info("check : geminiApiKey"+geminiApiKey);
		
		if(geminiApiKey!=null && map.get("txtGeminiSearch")!=null) {
			String txtGeminiSearch = map.get("txtGeminiSearch").toString()+
					"html형식으로만 보내줘. div에 그냥 띄울거니까 보기 좋게 보내줘";
			
			log.info("check : txtGeminiSearch => "+txtGeminiSearch);
			
			//    객체
			/*
			Client.builder() : 빌더 패턴을 시작함. 객체를 생성함. 여러개의 설정을 메소드 체인 방식으로 구현할 수 있음
								복잡한 객체 생성 시, 생성자의 매개변수 개수가 많을 때
			Client client = new Client(art1, arg2, arg3, arg4, ....); 
			*/

			Client client = Client.builder().apiKey(geminiApiKey).build();
			GenerateContentResponse response = client.models.generateContent(
					"gemini-2.5-flash", txtGeminiSearch, null);
			
			log.info("check : gemini -> response => "+response.text());
			
			return response.text();
		}
		
		return null;
	}
}
