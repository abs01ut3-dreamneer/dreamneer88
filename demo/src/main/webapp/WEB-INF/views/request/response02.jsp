<%@page import="java.util.Date"%>
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

	<p>이 페이지는 5초마다 새로고침 됩니다.</p>
	<%//스크립틀릿
// 		response.setIntHeader("Refresh", 1);	
	%>
	<!-- 표현문 -->
<%-- 	<p><%=new Date().toLocaleString() %></p> --%>
	
	<!-- 2025-09-03- 15:25:27 -->
	<p id="p1"></p>
<!-- /// body /// -->
<script type="text/javascript">
	function gogo(){
		console.log("가나다")
		
		let today = new Date();
		
		console.log("check : today => " + today)
		
		let year = today.getFullYear();
		let month = ("0"+ (today.getMonth()+1)).slice(-2);
		let day = ("0" + today.getDate()).slice(-2);
		
		let dateStr = year+"-"+ month +"-"+ day;
		console.log("check : dateStr => ", dateStr);
		
		let hours = ("0"+today.getHours()).slice(-2);
		let minutes = ("0"+today.getMinutes()).slice(-2);
		let seconds = ("0"+today.getSeconds()).slice(-2);
		
		let timeStr = hours + ":" + minutes + ":" + seconds;
		console.log("check : timeStr => ", timeStr);
		
		document.querySelector("#p1").innerHTML = dateStr + " " + timeStr;
	}
	
	//1초마다 gogo함수 요청
	setInterval(gogo, 1000); //=> gogo() 쓰면 안되는 이유는 함수호출이 아니라 함수 참조여야 한다!!
// 	gogo();
</script>

<%@ include file="./footer.jsp"%>
</body>
</html>