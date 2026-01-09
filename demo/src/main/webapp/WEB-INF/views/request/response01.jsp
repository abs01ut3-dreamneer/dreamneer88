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
<%@ include file="./menu.jsp"%>

<div class="jumbotron">
	<div class="container">
		<h1 class="display-3">${title}</h1>
	</div>
</div>
<!--/// body /// -->

	<!-- 
		폼페이지
		요청 URI: request/response01Post
		요청 파라미터: request(body){id=a001, password=java}
		요청 방식: post
	 -->
	<form action="/response/response01Post" method="post">
		<p>아이디: <input type="text" name="id" required placeholder="아이디"/> </p>
		<p>비밀번호: <input type="password" name="password" required placeholder="비밀번호"/> </p>
		<p><input type="submit" value="전송"/> </p>
	</form>
<!-- /// body /// -->
<%@ include file="./footer.jsp"%>
</body>
</html>