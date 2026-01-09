<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

	<!-- //header// 시작 -->
		<%@include file="./menu.jsp" %>
	<!-- //header// 끝 -->

<!-- ///////////////////////////////////////////////////////////////////////// -->
	
	<div class="jumbotron">
		<!-- container 안에 내용 넣기 -->
		<div class="container">
			<h1 class="display-5">상품 목록</h1>
		</div>		
	</div>
	<!-- //상품 목록 시작// -->
	<div class="container">
		<!-- 행별 처리 -->
		<div class="row" align="center">
			<!-- 열별 처리 
			col-md-4 : 4/12 => 33.3% 
			-->
			<c:forEach var="productVO" items="${productVOList }">
			<div class="col-md-4">
				<c:choose>
					<c:when test="${productVO.filename ne null}">
						<img src="/images/${productVO.filename }" 
					style="width:100%;" alt="${productVO.pname }" title="${productVO.pname }"/>
					</c:when>
					<c:otherwise>
						<img src="/images/noimage.jpg" 
					style="width:100%;" alt="이미지가 없습니다" title="이미지가 없습니다"/>
					</c:otherwise>
				</c:choose>
				
				<h3>${productVO.pname }</h3>
				<p>${productVO.description}</p>
				<p>
					<fmt:formatNumber value="${productVO.unitPrice}" type="currency"/>
				</p>
				<!-- 상품 상세
				요청URI: /product/product?productId=P1234
				요청파라미터: productId=P1234
				요청방식: get
				 -->
				<p><a href="/product/product?productId=${productVO.productId}" class="btn btn-secondary" role="button">상세정보&raquo;</a></p>
			</div>
			</c:forEach>
		</div>
	</div>
	<div class="form-group row">
	<!-- 
       📌 col-sm-10
         그리드 시스템에서 12칸 중 10칸을 차지하겠다는 의미입니다.
         sm은 "small" 이상의 화면 크기에서 적용된다는 뜻 (≥576px).
         즉, 작은 화면 이상에서 이 div는 가로 폭의 10/12 (약 83.3%)를 차지합니다.
      📌 col-sm-offset-2
         이건 예전 Bootstrap (v3)에서 사용하는 문법입니다.
         offset-2는 왼쪽에 2칸을 비워서 여백을 만들겠다는 뜻입니다.
         즉, 총 12칸 중 왼쪽 2칸은 비우고, 나머지 10칸을 차지하는 구조.
         -->
         <!-- 
         	요청URI: /product/addproduct
         	요청파라미터:
         	요청방식: get
          -->
		<div class="col-sm-offset-2 col-sm-10">
			<a href="/product/addProduct" class="btn btn-primary">상품 등록</a>
		</div>
	</div>
	<!-- //상품 목록 끝// -->
			
<!-- ///////////////////////////////////////////////////////////////////////// -->

	<!-- //footer// 시작 -->
		<%@include file="./footer.jsp" %>
	<!-- //footer// 끝 -->