<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<script type="text/javascript" src="/js/validation02.js"></script>

<%@ include file="../menu.jsp"%>

<div class="jumbotron">
    <div class="container">
       <h1 class="display-3">유효성검사05(정규 표현식)</h1>
    </div>
 </div>

	<form action="validation05_process.jsp" name="Member" method="post">
		<p>아이디 : <input type="text" name="id" /></p>
		<p>비밀번호 : <input type="password" name="passwd" /></p>
		<p>이름 : <input type="text" name="name" /></p>
		<p>연락처 : 
			<select name="phone1">
				<option value="010">010</option>			
				<option value="011">011</option>			
				<option value="016">016</option>			
				<option value="017">017</option>			
				<option value="019">019</option>			
			</select> - 
			<input type="text" maxlength="4" size="4" name="phone2" /> -
			<input type="text" maxlength="4" size="4" name="phone3" />
		</p>
		<p>이메일 : <input type="text" name="email" /></p>
		<p><input type="submit" value="가입하기"/></p>
	</form>

<%@ include file="../footer.jsp"%>
	