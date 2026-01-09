<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>

<title>도서 목록</title>
<script type="text/javascript">
	function detail(pr){
		const bookId = pr.querySelector("#bookId").value;
		console.log(bookId);
		location.href="/detail?bookId="+bookId;
	}
	
</script>
</head>
<body>
	<h2>도서 목록</h2>
	<p>
		<form action="/list" method="get">
			<!-- 검색 창에 value="${param.keyword}" 신기하니까 한번 더 보기! -->
			<input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력하세요">
			
			<!-- 검색할 때는 currentPage == 1 -->
			<input type="hidden" name="currentPage" value="1"/>
			<button type="submit" id="btnSearch">검색</button>
		</form>
	</p>
	<p><button type="button" onclick="location.href='/create'">책 추가하기</button></p>
	<table border=1 width=600>
		<thead>
			<th>번호</th>
			<th>제목</th>
			<th>카테고리</th>
			<th>가격</th>
		</thead>
		<!-- JSTL(JSP Standard Tag Library) : JSP에서 자주 쓰는 표준 태그들을 쉽게 사용할 수 있도록 제공됨
		forEach 태그? 배열(String[], int[][]), Collection(List, Set) 또는
		Map(HashTable, HashMap, SortedMap)에 저장되어 있는 값들을
		순차적으로 처리할 때 사용함. 자바의 for, do~while을 대신해서 사용함
		var : 변수
		items : 아이템(배열, Collection, Map)
		varStatus : 루프 정보를 담은 객체 활용
		    - index : 루프 실행 시 현재 인덱스(0부터 시작)
		    - count : 실행 회수(1부터 시작. 보통 행번호 출력)
		-->
		<!-- 기존 => data: mav.addObject("books", books) -->
		<!--
        	select 결과 데이터
				private List<T> content
				articlePage 객체에서 content 프로퍼티의 값을 꺼내면(get) => bookVOList

        	페이징객체  => data : mav.addObject("articlePage", articlePage); 
        -->
		<!-- data : mav.addObject("bookVOList", bookVOList); -->
		<!-- row : bookVO 1행 -->
		<tbody id="bookTbody">
			<c:forEach var="book" items="${articlePage.content}">
				<tr name="book" onclick="detail(this)">
					<input type="hidden" id="bookId" value="${book.bookId }">
					<td>${book.rnum}</td>
					<td>${book.title}</td>
					<td>${book.category}</td>
					<td>${book.price}</td>
				</tr>	
			</c:forEach>
		</tbody>
		<!-- 페이지네이션 -->
		<tfoot>
			<tr>
				<td colspan="4" style="text-align: center">
					
					<c:if test="${articlePage.startPage!=1}">
						<a href="/list?currentPage=${articlePage.startPage-5}&keyword=${param.keyword}">[이전]</a>
					</c:if>
					
					<c:forEach var="pNo" begin="${articlePage.startPage}" end="${articlePage.endPage}" step="1">
						<a href="list?currentPage=${pNo}&keyword=${param.keyword}">[${pNo}]</a>
					</c:forEach>
					
					<c:if test="${articlePage.endPage!=articlePage.totalPages}">
						<a href="/list?currentPage=${articlePage.startPage+5}&keyword=${param.keyword}">[이후]</a>
					</c:if>
				</td>
				
			</tr>
		</tfoot>
	</table>
	
</body>
</html>