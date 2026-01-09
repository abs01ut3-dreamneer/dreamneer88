<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!-- page 디렉티브 -->

<%@ include file="./menu.jsp" %>

   <!-- 표현문 -->
   <div class="jumbotron">
      <!-- container : 본문이 들어갈 영역 -->
      <div class="container">
         <h1 class="display-3">${greeting}</h1>
      </div>
   </div>
   <!-- container : 본문이 들어갈 영역 -->
   <div class="container">
      <!-- 본문 정렬 -->
      <div class="text-center">
         <h3>${tagline}</h3>
      </div>
   </div>

<%@ include file="./footer.jsp" %> 

