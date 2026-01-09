<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>

<title>  </title>
</head>
<body>
<h1>Welcome Welcome Welcome</h1>
	<!-- 
		welcome.jsp -> 해석 -> welcome_jsp.java -> 컴파일 -> welcome_jsp.class
 	-->

<p><%= count%></p>
<!-- 스크립틀릿 -->
<%
	int count = 2; // 왜 충돌이 안나지? 지역변수랑 전역변수랑 이름이 같아도 충돌이 안나? 왜 안나?
	/*  
	- JSP 파일이 자바 서블릿 클래스로 변환될 때
		=> 스크립틀릿의 count: _jspService() 메소드의 지역 변수
		=> 선언문의 count: 클래스 인스턴스 변수 
	*/
	for(int i=1; i<=count; i++){
		out.print("<p>Java Server Pages"+i+"</p>");
	}
%>

<p><%= //표현문 태그 모양
	makeItLower("Hello World")
%></p>
<p><%= makeSum(1,2)%></p>
<p><%=count%></p>

<%!
// 클래스 레벨에서 선언됨
//선언문 태그 모양 기억하기
// 전역 메소드 선언 (위치 상관없음!)
	int count = 3;

	String makeItLower(String data){
		return data.toLowerCase();
	}
	
	int makeSum(int a, int b){
		return a+b;
	}
%>
</body>
</html>