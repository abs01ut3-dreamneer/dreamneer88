<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script type="text/javascript">
/*
유효성 검사 처리 방법 : 사용자가 폼 페이지에 입력한 데이터 값이 서버(톰켓)로 전송되기 전에 
			웹 브라우저(크롬)에서 검증하는 방법
1) 기본 유효성 검사 : 폼 페이지에 입력된 데이터 값의 존재 유무를 검사함
2) 데이터 형식 유효성 검사 : 정규 표현식을 사용하여 폼 페이지에 입력된 데이터 값이
				특정 패턴에 적합한지 여부를 검사
*/
	//달러(function())
	document.addEventListener("DOMContentLoaded",()=>{
		//폼 엘리먼트를 가져와보자
		const loginForm = document.getElementById("loginForm");

		//폼 제출(submit) 이벤트를 감지함
		//event : submit 이벤트
		loginForm.addEventListener("submit",(event)=>{
			//폼 제출 동작을 막음
			event.preventDefault();
			
			//<input type="text" name="name" />
			let name = document.querySelector("input[name='name']");
			console.log("check : name => ", name.value);
			
			//이름은 숫자로 시작할 수 없습니다.
	        //정규표현식 생성 (문자형식) , [a-z] : a~z사이의 문자
	        let regExp = /^[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
	        //문자형식이 아니다. 1개똥이=>true
	        // 입력값이 형식에 맞지 않다면
	        if(!regExp.test(name.value)){//test()메소드:T/F
				alert("이름은 숫자로 시작할 수 없습니다.");
	        	return false;
	        }
			
			
		});//end submit
	});//end DOMContentLoaded
</script>

<%@ include file="../menu.jsp"%>

 <div class="jumbotron">
 	<!-- container : 이 안에 내용있다 -->
 	<div class="container">
 		<h1 class="display-3">유효성검사04_2(정규 표현식)</h1>
 	</div>
 </div>

<!-- /// body 시작 /// -->

<form name="loginForm" id="loginForm" action="/valid/validation04_process" method="post">
	<p>이름 : <input type="text" name="name" /></p>
	<p><input type="submit" value="전송" /></p>
</form>

<!-- /// body 끝 /// -->

<%@ include file="../footer.jsp"%>
