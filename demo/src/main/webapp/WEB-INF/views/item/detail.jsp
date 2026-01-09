<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title>성실의 쇼핑몰</title>
</head>
<body>
	<!-- /// menu.jsp 시작  -->
	<%@ include file="../menu.jsp" %> <!-- ../ 이거는 부모 폴더를 가르킨다 -->
	<!-- /// menu.jsp 끝 /// -->
	<script type="text/javascript">
		$(function(){
		   //<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
		   
		   $("#btnDelete").on("click",function(){
		      console.log("개똥이");
		      //<form id="frmSubmit" action="/item/registerPost"..
		      
		      let chk = confirm("삭제하시겠습니까?");
		      
		      if(chk){//확인 -> true
		      //속성 : attribute / property
		      $("#frmSubmit").attr("action", "/item/deletePost");
		      
		      $("#frmSubmit").submit();
		      }else{ //취소 -> false
		         alert("삭제가 취소되었습니다.");
		      }
		   });
		});
</script>
	<!-- /// 제목 시작 /// -->
	<div class="jumbotron">
		<!-- container : 내용이 들어갈 때 -->
		<div class="container">
			<h1 class="display-3">단일 파일업로드</h1>
		</div>
	</div>
	<!-- /// 제목 끝 /// -->
	
	<!-- 
	요청URI : /item/registerPost
	요청파라미터 : {itemName=삼성태블릿,price=120000,description=쓸만함,uploadFile=파일객체}
	요청방식 : post
	-->
	<!-- 파일업로드
	1) method는 꼭 post!
	2) enctype="multipart/form-data"
	3) <input type="file" name="uploadFile".. name속성이 꼭 있어야 함!
	4) <sec땡땡csrfInput />
	5) action 속성의 uri 뒤에 token 추가
	
	readonly = > submit시 data 전송
	disabled => submit시 data 전송 안함
	 -->
	<form id="frmSubmit" 
		action="/item/registerPost"
		method="post" enctype="multipart/form-data">
		<input type="hidden" name="itemId" value="${itemVO.itemId }"/>
		<table>
			<tr>
				<th>상품명</th>
				<td><input type="text" name="itemName" value="${itemVO.itemName}" readonly/></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="text" name="price" value="${itemVO.price }" readonly /></td>
			</tr>		
			<tr>
				<th>상품이미지</th>
				<td>
					<%--
					<p>${itemVO.fileGroupVO.fileDetailVOList }</p>
					itemVO 안에 
					FileGroupVO=FileGroupVO(
											fileGroupNo=20251013008, 
											fileRegdate=Mon Oct 13 12:14:07 KST 2025, 
		     								fileDetailVOList=[
																FileDetailVO(fileSn=1, fileGroupNo=20251013008, fileOriginalName=모래알갱이.png, fileSaveName=0ae749c9-1ead-4bae-8997-0adfe148c116_모래알갱이.png, fileSaveLocate=/2025/10/13/0ae749c9-1ead-4bae-8997-0adfe148c116_모래알갱이.png, fileSize=15516, fileExt=png, fileMime=image/png, fileFancysize=null, fileSaveDate=Mon Oct 13 12:14:07 KST 2025, fileDowncount=0), 
																FileDetailVO(fileSn=2, fileGroupNo=20251013008, fileOriginalName=모래알갱이2.png, fileSaveName=ff99bf2d-a1a4-4a44-a565-65e4a7eddf97_모래알갱이2.png, fileSaveLocate=/2025/10/13/ff99bf2d-a1a4-4a44-a565-65e4a7eddf97_모래알갱이2.png, fileSize=15546, fileExt=png, fileMime=image/png, fileFancysize=null, fileSaveDate=Mon Oct 13 12:14:07 KST 2025, fileDowncount=0), 
																FileDetailVO(fileSn=3, fileGroupNo=20251013008, fileOriginalName=모래알갱이3.png, fileSaveName=1ee2bc68-d588-4a14-b92e-4e639670ddd6_모래알갱이3.png, fileSaveLocate=/2025/10/13/1ee2bc68-d588-4a14-b92e-4e639670ddd6_모래알갱이3.png, fileSize=13963, fileExt=png, fileMime=image/png, fileFancysize=null, fileSaveDate=Mon Oct 13 12:14:07 KST 2025, fileDowncount=0)
															]
											)
					
					 --%>
					<c:forEach var="fileDetailVO" items="${itemVO.fileGroupVO.fileDetailVOList }" varStatus="stat"> <%-- <c:forEach v i v> --%>
						<p><img src="/upload${fileDetailVO.fileSaveLocate}" style="width:100%;"></p>
					</c:forEach>				
					<input type="file" name="uploadFile" style="display:none" />
				</td>
			</tr>
			<tr>
				<th>개요</th>
				<td>
					<input type="text" name="description" value="${itemVO.description }" readonly />
				</td>
			</tr>
		</table>
		<a href="/item/edit?itemId=${itemVO.itemId }" class="btn btn-warning" >수정</a>
		<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
		<a href="/item/list" class="btn btn-success">목록</a>
	</form>
	<hr />

	<!-- /// footer.jsp 시작 /// -->
	<%@ include file="../footer.jsp" %>
	<!-- /// footer.jsp 끝 /// -->
</body>
</html>