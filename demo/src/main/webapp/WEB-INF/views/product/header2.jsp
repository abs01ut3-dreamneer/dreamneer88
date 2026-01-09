<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<!-- /// header 시작 /// -->
		<nav class ="navbar navbar-expand navbar-dark bg-dark">
			<div class="container">
				<div class="navebar-header">
					<a class="navbar-brand" href="/product/welcome">Home</a>
				</div>
				<div>
					<ul class="navbar-nav mr-auth">
					
					<!-- 로그인 안되었다면 -->
					<c:if test="${isLogin!='Y'}">
						<li class="nav-item"><a class="nav-link" href="#">로그인</a></li>
					</c:if>
						
					<!-- 로그인 되었다면 -->
					<c:if test="${isLogin=='Y'}">
							<li class="nav-item"><a class="nav-link" href="#">개똥이님 환영합니다.</a></li>
					</c:if>
					
					<c:choose>
						
						<c:when test="${auth=='ROLE_ADMIN' }">
							<!-- //관리자// -->
							<li class="nav-item"><a class="nav-link" href="#">상품 목록</a></li>
							<li class="nav-item"><a class="nav-link" href="#">상품 등록</a></li>
						</c:when>
						
						<c:otherwise>
							<!-- //일반// -->
							<li class="nav-item"><a class="nav-link" href="#">상품 목록</a></li>
						</c:otherwise>
					</c:choose>
					</ul>
				</div>
			</div>
		</nav>
	<!-- /// header 끝 /// -->