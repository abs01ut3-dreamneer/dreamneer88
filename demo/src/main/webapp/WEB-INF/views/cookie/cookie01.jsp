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
		<h1 class="display-3">cookie</h1>
	</div>
</div>
<!--/// body /// -->
	<!-- 
	요청URI: /cookie01_process
	요청파라미터: request{id=admin&passwd=java}
	요청방식: post
	 -->
	<form action="/cookie/cookie01_process" method="post">
      <p>아이디 : <input type="text" name="idd" /></p>
      <p>비밀번호 : <input type="text" name="passwd" /></p>
      <p><input type="submit" value="전송" /></p>
   </form>
   <hr/>
   <a href="/cookie/cookie02">모든 쿠키 삭제</a>
<!-- /// body /// -->
<%@ include file="../footer.jsp"%>
</body>
</html>