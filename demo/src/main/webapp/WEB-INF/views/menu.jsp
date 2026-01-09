<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<!DOCTYPE html>
<html>
<head>

<title></title>
<!-- CDN방식으로 import -->
<!-- Font Awesome -->
<link rel="stylesheet" href="/adminlte/plugins/fontawesome-free/css/all.min.css">
<!-- Theme style -->
<link rel="stylesheet" href="/adminlte/dist/css/adminlte.min.css">

<link rel="stylesheet" href="/css/sweetalert2.min.css">
<script type="text/javascript" src="/js/sweetalert2.min.js"></script>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<script type="text/javascript" src="/js/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="/adminlte/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="/adminlte/dist/js/adminlte.min.js"></script>
</head>
<body>

	<!-- /// header 시작 /// -->
	<nav class="navbar navbar-expand navbar-dark bg-dark">
		<div class="container">
			<div class="navebar-header">
				<a class="navbar-brand" href="/product/welcome">Home</a>
			</div>
			<div style="width: 45%; float: right;">
				<!-- 로그인 안했을 떄 보임 시작 (로그인 안했지? 그럼 이 영역을 보여줄게=>isAnonymous())-->
				<sec:authorize access="isAnonymous()">
					<ul class="navbar-nav mr-auth">
						<!-- //제미나이 API 시작
						<p>geminiApiKey: ${geminiApiKey}</p>
						<span id="spnGemini">
							<button class="btn btn-primary" type="button" id="btnSpinner"
								style="display: none;" disabled>
								<span class="spinner-border spinner-border-sm"
									aria-hidden="true"></span> <span role="status">Loading...</span>
							</button>
							<button type="button" class="btn btn-info btn-sm"
								id="btnUseGemini">제미나이 활성화</button>
						</span>
						//제미나이 API 끝 -->
						<li class="nav-item"><a class="nav-link" href="/login">로그인</a></li>
					</ul>
				</sec:authorize>
				<!-- 로그인 안햇을 때 보임 끝 -->
				<!-- 로그인 했을 떄 보임 시작 (로그인 했지? 그럼 이 영역을 보여줄게=>isAuthenticated())-->
				<sec:authorize access="isAuthenticated()">
					<!-- 
						CustomUser의 객체 = principal
						CustomUSer의 객체의 tblUSersVO 프로퍼티 = principal.tblUsersVO
					 -->
					<sec:authentication property="principal.memberVO" var="memberVO" />

					<ul class="navbar-nav mr-auth">
						<li class="nav-item" style="width: 100%;">
							<form action="/logout" method="post">
								<div class="col-md-12">
									<div class="col-md-6" style="float: left;">
										<a class="nav-link" href="#">${memberVO.userName}(${memberVO.userId})님</a>
									</div>
									<!-- 로그아웃 시작
								 logout.logoutUrl("/logout") //로그아웃을 처리할 URL
							 -->
									<div class="col-md-6" style="float: right;">
										<button type="submit"
											class="btn btn-block btn-outline-primary btn-sm"
											style="width: 100px; height: 30px; float: left">로그아웃</button>
										<!-- 원래 존재해야하지만 생략한다~
								SecurityConfig에서 .csrf(csfr->csrf.disable())의해
								<sec:csrfInput/>를 생략 (토크값 생성)
							
								 -->
									</div>
									<!-- 로그아웃 끝 -->
								</div>
							</form>
						</li>
					</ul>
				</sec:authorize>
				<!-- 로그인 햇을 때 보임 끝 -->
			</div>
		</div>
	</nav>
	<!-- /// header 끝 /// -->