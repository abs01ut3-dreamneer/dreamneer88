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
			<h1 class="display-5">상품 상세</h1>
		</div>		
	</div>
	 
	<div class="container">
		<div class="row">
			<!-- 삼푸이미지 div 5 : 12 = x : 100 == 100에서 약 41% 넓이 -->
			<div class="col-md-5">
				<c:if test="${product.filename ne null}">
					
					<img src="/images/${product.filename }" 
					style="width:100%; cursor:pointer;" alt="${product.pname }" title="${product.pname }"/>
				</c:if>
				<c:if test="${product.filename eq null}">
					<img src="/images/noimage.jpg" 
					style="width:100%; cursor:pointer;" alt="이미지가 없습니다" title="이미지가 없습니다"/>
				</c:if>
			</div>
			<div class="col-md-6">
				<h3>${product.pname }</h3>
				<p>${product.description }</p>
				<p>
					<b>상품 코드 :</b>
					<span class="badge badge-danger">
						${product.productId }
					</span>
				</p>
				<p><b>제조사 : </b>${product.manufacturer }</p>
				<p><b>분 류 : </b>${product.category }</p>
				<p><b>재 고 : </b>${product.unitsInStock }</p>
				<h4> <fmt:formatNumber type="currency" >${product.unitPrice }</fmt:formatNumber> 
				</h4>
					<form name="addForm" action='/product/addCart' method='post'>
						<input type="hidden" name="productId" value="${product.productId }"/>
						<button type="submit" class="btn btn-info" id="cartInput">상품 주문&raquo;</button>
						<a href="/product/cart" class="btn btn-warning">장바구니&raquo;</a>
						<a href="/product/products" class="btn btn-secondary">상품 목록&raquo;</a>
					</form>
			</div>
		</div>
	</div>

<script>
	document.addEventListener("DOMContentLoaded", ()=>{
		//<form name="addForm" action='/product/addCart' method='post'>
		const loginForm = document.querySelector("form[name='addForm']");
		
		loginForm.addEventListener("submit", (event)=>{
			//폼 제출 동작을 막음
			event.preventDefault();
			
			console.log("개똥이");
			
			let productId = document.querySelector("input[name='productId']").value;
			console.log("productId :"+productId);
			
			if(productId==null || productId==""){
				alert("상품 아이디가 없습니다.");
				return;
			}
			
			loginForm.submit();
		})
	})	
</script>
	
<!-- ///////////////////////////////////////////////////////////////////////// -->

	<!-- //footer// 시작 -->
		<%@include file="./footer.jsp" %>
	<!-- //footer// 끝 -->