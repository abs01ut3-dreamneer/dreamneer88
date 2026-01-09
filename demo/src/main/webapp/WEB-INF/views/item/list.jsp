<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>

<title></title>
</head>
<body>
	<%@ include file="../menu.jsp"%>

	<div class="jumbotron">
		<div class="container">
			<h1 class="display-3">상품 목록</h1>
		</div>
	</div>
	<!--/// body /// -->
	<%-- <p>${itemVOList}</p> --%>
	<!-- 시멘틱 태그 : 의미를 가진 태그 -->
	<section class="content" style="margin: 20px">
		<div class="container-flud">
			<div class="row">
				<div class="col-sm-12">
					<div id="example1_filter" class="dataTables_filter"
						style="float: right;">
						<form id="frm" name="frm" method="get" action="/item/list">
							<label> 
							<!--  검색 시 currentPage = 1로 초기화 -->
<!-- 								<input type="hidden" name='currentPage' value='1'/> -->
								<input type="search" name="keyword"
									class="form-control form-control-sm" placeholder="검색어를 입력해주세요"
									aria-controls="example1" value="${param.keyword }"/>
							</label>
							<button type="submit" class="btn btn-primary btn-sm">검색</button>
						</form>
					</div>
				</div>
				<!-- 12=>100% -->
				<div class="col-md-12">
					<!-- card 시작 -->
					<div class="card">
						<!-- /.card-header -->
						<div class="card-body">
							<table class="table table-bordered">
								<thead>
									<tr>
										<th style="width: 10px">#</th>
										<th>상품명</th>
										<th>가격</th>
									</tr>
								</thead>
								<tbody>
									<!-- 
									var: 변수
									items: 배열, Collection(list, set), Map(HashMap, HashTable, SortedMap)
									varStatus: stat 
													1. count (1, 2, 3, ...)
													2. index (0, 1, 2, ...)
									
									articlePage.content => List<ItemVO>
								 -->
									<c:forEach var="itemVO" items="${articlePage.content}">
										<tr>
											<td>${itemVO.rnum }</td>
											<td><a href="/item/detail?itemId=${itemVO.itemId }">${itemVO.itemName }</a></td>
											<td><fmt:formatNumber value="${itemVO.price}"
													type="currency"></fmt:formatNumber></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<!-- /.card-body -->
<%-- 						<p>${articlePage }</p> --%>
						<div class="card-footer clearfix">${articlePage.pagingArea }
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- /// body /// -->
	<%@ include file="../footer.jsp"%>
</body>
</html>