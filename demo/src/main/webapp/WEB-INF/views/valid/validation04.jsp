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
	document.addEventListener("DOMContentLoaded", ()=>{
		// 폼 엘리먼트를 가져오자
		const loginForm = document.getElementById("loginForm");

		// 폼 제출(submint) 이벤트를 감지함
		loginForm.addEventListener("submit", (event)=>{
			event.preventDefault(); // 폼 제출을 일단 막자
			
			//<input type="text" name="name">
			let name = document.querySelector("input[name='name']");
			console.log('name : ', name.value);
			//정규표현시(Regular Expression)
			//1) test() : 판단(true/false)
			//2) exex() : 추출ㄴ
			let regExp = /Java/i; // 대소문자 무관;
			
			// null처리
			if(name.value!=null){
				// 패턴.함수(대상)
				let result = regExp.exec(name.value); //ajavas
				
				if(result!=null){
					console.log("result : ", result[0]);
				}
			}
			
			//regExp : 슬러시Java슬러시i
			//			  ajavas
			// Java.test("ajavas")=> true;
			// Java.test("ajas")=> false;
			if(regExp.test(name.value)){
				console.log("입력 ㅌ대상이 패턴에 맞음");
			}else{
				console.log("입력 ㅌ대상이 패턴에 틀림");
			}
			
			// 아이디는 영문 소문자만 가능
			// <p>아이디: <input type="text" name="id"> </p>
			let id = loginForm.id.value;
			console.log("check : id => ", id);
			
			for(let i=0; i<id.length; i++){
				// id : a001
				let ch = id.charAt(i); // i: 0 ~ 3
				console.log("check : ch => ", ch);
				if((ch<'a'||ch>'z')&&(ch>='A'||ch<='Z')&&(ch>='0'||ch<='9')){
					alert("아이디는 영문 소문자만 입력 가능합니다.");
					loginForm.id.select();
					return false;
				}
			}
			
			// 비밀번호는 숫자만 입력 가능, 이것은 숫자가 아니다 (isNaN)
			let passwd = loginForm.passwd.value;
			
			console.log("check : passwd => ", passwd);
			
			if(isNaN(passwd)){
				alert("비밀번호는 숫자만 입력 가능합니다.");
				loginForm.passwd.select();
				return false;
			}
		})
	});

</script>
</head>
<body>
<%@ include file="../menu.jsp"%>

<div class="jumbotron">
	<div class="container">
		<h1 class="display-3">유효성검사04</h1>
	</div>
</div>
<!--/// body /// -->
	<form id="loginForm"  action="/valid/validation04_process" name="loginForm">
		<p>아이디: <input type="text" name="id"> </p>
		<p>비밀번호: <input type="text" name="passwd"></p>
		<p>이름: <input type="text" name="name"> </p>
		<p><input type="submit" value="전송"></p><!-- onclick="checkform()" -->
	</form>
<!-- /// body /// -->
<%@ include file="../footer.jsp"%>
</body>
</html>