<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>도서 수정</title>
</head>
<body>
	
	<h1>도서 수정</h1>
	<!-- mav.addObject("bookVO", bookVO); -->
	
	<!-- 폼 페이지 
	요청URI : /modifyPost
	요청파라미터 : request{bookId=3,title=개똥이 모험55,category=소설,price=15000}
	요청방식 : post
	-->
	<form action="/modifyPost" method="post">
		<!-- 폼데이터 -->
		<!-- 
		bookVO : (bookId=5, title=개똥이의 모험5, category=소설, price=15000, insertDate=25/08/27)
		 -->
		<input type="hidden" name="bookId" value="${bookVO.bookId}" />
		<p>제목 : <input type="text"    name="title" value="${bookVO.title}" required placeholder="제목" /></p>
		<p>카테고리 : <input type="text" name="category" value="${bookVO.category}" required placeholder="카테고리" /></p>
		<p>가격 : <input type="number"  name="price" value="${bookVO.price}" required placeholder="가격" /></p>
		<p>
			<input type="submit" value="저장" />
			<input type="button" value="목록" onclick="javascript:location.href='/list'" />
		</p>
	</form>
</body>
</html>










