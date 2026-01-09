package kr.or.ddit.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j 
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	//HttpSessionRequestCache : 로그인 하기 전에 사용자가 요청했던 URL(/product/addProduct)을 세션에 저장해주는 객체
	   // /product/addProduct -> /login -> 로그인 성공 및 권한이 있으면 -> /product/addProduct
	   private final HttpSessionRequestCache requestCache 
	      = new HttpSessionRequestCache(); 
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		
		//ex1) JSON 형식의 성공 메시지 반환(api 로그인 시 사용하자)
//		response.setStatus(HttpServletResponse.SC_OK);
//		response.setContentType("application/json;charset=UTF-8");
//		response.getWriter().write("{\"message\":\"로그인 성공!\"}");
		
		/*
		 * principal : 로그인한 자신
		 * 사용자가 인증되면, Spring Security는 해당 사용자를 나타내는 Principal 객체를 생성
		 * 현재 로그인한 사용자가 누구인지 알수있음
		 * 
		 * Authentication : 인증(로그인) 정보를 담는 컨테이너. .getPrincipal()로 principal 정보를
		 * 					꺼낼 수 있음 -> .getPrincipal() 시 UserDetails 객체가 반환 됨
		 * 
			UserDetails : Spring Security가 사용자 정보를 관리하는 데 사용하는 핵심 인터페이스
					username, password, authorities가 있음
					
			UserDetails (Interface) =상속=> User (Class) =상속=> CustomUser(Class 우리가 만든)
		 */
		
		CustomUser customUser = (CustomUser)auth.getPrincipal();
		MemberVO memberVO = customUser.getMemberVO();

		log.info("onAuthenticationSuccess->tblUsersVO : " + memberVO);

		
		//ex2) 특정 페이지로 리다이렉트
//		response.sendRedirect("/notice/list");
		
		// reqeustCache : 세션에 저장되어 있는 로그인 전 요청 객체
		//                               요청을 get(요청객체, 응답객체)
	    //savedRequest : 사용자가 인증 없이 접근했던 URL(/product/addProduct)이 여기에 저장되어 있음
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		if(savedRequest != null) { // 저장된 요청이 있으면 
			//					그 요청의 리다이렉션 URL을 꺼냄
			String targetUrl = savedRequest.getRedirectUrl();
			
			response.sendRedirect(targetUrl);
		}else {// 로그인 전에 저장된 요청이 없다? /login URL 자체를 요청한 것
			response.sendRedirect("/product/welcome");
		}
	}

}
