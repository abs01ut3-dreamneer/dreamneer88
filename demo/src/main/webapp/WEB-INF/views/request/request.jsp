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
		요청 URI: request/requstProcess
		요청 파라미터: request{name=개똥이, uploadFile=파일객체}
		요청 방식: post
	 -->
	 <!-- 파일업로드
		1) method는 꼭 post! **중요**
		2) enctype="multipart/form-data" 
		3) <input type="file" name="uploadFile".. name속성이 꼭 있어야 함!
		
		참고,시큐리티1) <sec땡땡csrfInput />
		참고,시큐리티2) action 속성의 uri 뒤에 token 추가
   	-->
	<form action="/request/requestProcess" method="post" 
		enctype="multipart/form-data">
		<p>이름: <input type="text" name="name"/> </p>
		<p>이미지: <input type="file" name="uploadFile"/> </p>
		<p><input type="submit" value="전송"/> </p>
	</form>
<!-- /// body /// -->
<%@ include file="./footer.jsp"%>
</body>
</html>