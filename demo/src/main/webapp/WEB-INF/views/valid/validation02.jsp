<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<title> </title>
<script type="text/javascript">
/*
유효성 검사 처리 방법 : 사용자가 폼 페이지에 입력한 데이터 값이 서버(톰켓)로 전송되기 전에 
         웹 브라우저(크롬)에서 검증하는 방법
1) 기본 유효성 검사 : 폼 페이지에 입력된 데이터 값의 존재 유무를 검사함
2) 데이터 형식 유효성 검사 : 정규 표현식을 사용하여 폼 페이지에 입력된 데이터 값이
            특정 패턴에 적합한지 여부를 검사
*/
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
			const passwd = document.querySelector("input[name='passwd']").value;

			console.log("id : "+id+", passwd : "+passwd);
			
			if(id==""){
				alert("아이디를 입력해주세요");
				document.querySelector("input[name='id']").focus();//해당 입력 항목에 커서가 위치함
				return false;
			}else if(passwd==""){
				alert("비밀번호를 입력하세욬");
				document.querySelector("input[name='passwd']").focus();
			}
			
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
		<p>비밀번호: <input type="text" name="passwd"></p>
		<p><input type="submit" value="전송"></p><!-- onclick="checkform()" -->
	</form>
<!-- /// body /// -->
<%@ include file="../footer.jsp"%>
</body>
</html>