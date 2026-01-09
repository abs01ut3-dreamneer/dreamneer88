<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>

<title> </title>
</head>
<body>
<%@ include file="../menu.jsp"%>

<div class="jumbotron">
	<div class="container">
		<h1 class="display-3">session 02</h1>
	</div>
</div>
<!--/// body /// -->
<!-- 
session.setAttribute("userId", id);
session.setAttribute("passwd", passwd);
-->

<%
// 	String userId = (String)session.getAttribute("userId");//admin
// 	String passwd = (String)session.getAttribute("passwd");//java
%>
<%-- <p>설정된 세션의 속성 값[1] : <%=userId%></p> --%>
<%-- <p>설정된 세션의 속성 값[2] : <%=passwd%></p> --%>
<p>설정된 세션의 속성 값[1] : ${sessionScope.userId}</p>
<p>설정된 세션의 속성 값[2] : ${sessionScope.passwd}</p>
<p>
   <a href="/session/session03">세션에 저장된 모든 세션 정보 보기</a>
</p>
<p>
   <a href="/session/session04">세션에 저장된 모든 세션 정보 삭제</a>
</p>
<p>
   <a href="/session/session05">세션 유효 시간 변경</a>
</p>
<p>
   <a href="/session/session06">세션 아이디 확인</a>
</p>
<!-- /// body /// -->
<%@ include file="../footer.jsp"%>
</body>
</html>