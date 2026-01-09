<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<title> </title>
<script type="text/javascript">
	function checkform(){
		let id= document.loginForm.id.value;
		let passwd = document.loginForm.password.value;
		
		console.log("id : "+id+", passwd : "+passwd);
	}

	document.addEventListener("DOMContentLoaded", ()=>{
		// 폼 엘리먼트를 가져오자
		const loginForm = document.getElementById("loginForm");

		// 폼 제출(submint) 이벤트를 감지함
		loginForm.addEventListener("submit", (event)=>{
			event.preventDefault(); // 폼 제출을 일단 막자
			//<input type="text" name="id">
			const id = document.querySelector("input[name='id']").value;
			const passwd = document.querySelector("input[name='password']").value;

			console.log("id : "+id+", passwd : "+passwd);
		})
	});

</script>
</head>
<body>
<%@ include file="../menu.jsp"%>

<div class="jumbotron">
	<div class="container">
		<h1 class="display-3">유효성검사01</h1>
	</div>
</div>
<!--/// body /// -->
	<form id="loginForm"  action="" name="loginForm">
		<p>아이디: <input type="text" name="id"> </p>
		<p>비밀번호: <input type="text" name="password"></p>
		<p><input type="submit" value="전송"></p><!-- onclick="checkform()" -->
	</form>
<!-- /// body /// -->
<%@ include file="../footer.jsp"%>
</body>
</html>