<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>

<title> </title>
</head>
<body>
<!-- 스크립틀릿 -->
<%
	// 지역 변수
	int a = 2;
	int b = 3;
	int sum = a+b;
	//JSP 내장객체 중 하나
	out.print("<p>2 + 3 = "+sum+"</p>");
%>
<hr/>
<%
	for(int i=0; i<=10; i++){
		//jsp 내장 객체
		if(i%2==0)
		out.print("<p>"+i+"</p>");
	}
%>
<hr/>
	<%! int count = 0; %>

	<p>
		<!-- 지역 변수 a를 1 증가시킴 -->
		Page Count is <%= ++a %>
	</p>
	<hr/>
	<p>
		<!-- 전역 변수 count를 1 증가시킴 -->
		Page Count is <%= ++count %>
	</p>
	<hr/>
	<p>
		Today's date : <%=new Date() %>
	</p>
</body>
</html>