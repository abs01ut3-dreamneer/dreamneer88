<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title>병호의 쇼핑몰</title>
</head>
<body>
	<!-- /// menu.jsp 시작  -->
	<%@ include file="../menu.jsp" %>
	<!-- /// menu.jsp 끝 /// -->
	
<script type="text/javascript">
//$(function(){
document.addEventListener("DOMContentLoaded",function(){
	//<a href=... data-item-id="272" class="btn btn-danger btn-xs clsDelete">삭제</a>
	//<a href=... data-item-id="273" class="btn btn-danger btn-xs clsDelete">삭제</a>
	//...
	document.addEventListener("click",function(event){
		console.log("클릭함!");
		
		//실제로 클릭한 요소를 특정
		const clickedElement = event.target;
		
		//클릭된 요소가 ".clsDelete" 클래스를 가지고 있는지 체킹
		const deleteButton = clickedElement.closest(".clsDelete");
		
		if(deleteButton!=null){
			//<a href="#modalDelete" data-toggle="modal" data-item-id="274" class="btn btn-danger btn-xs clsDelete">삭제</a>
			//           data-   item-id
			let itemId = deleteButton.dataset.itemId;
			
			// parentElement : 특정 엘리먼트의 부모 엘리먼트를 찾아감
			let postDiv = deleteButton
							.parentElement
							.parentElement;
			let firstChild = postDiv.firstElementChild;
			
			let itemName = "";
			if(firstChild){
				itemName = firstChild.textContent.trim();
			}
			
			//JSON Object
			let data = {
				"itemId":itemId
			}
			
			console.log("deleteButton->itemId : ", itemId);
			
			document.querySelector("#modalDeleteItemId").value = itemId;
			document.querySelector("#modalDeleteItemName").value = itemName;
		}//end if
	});
	
	//댓글 삭제 실행
	document.querySelector("#modalDeleteConfirm").addEventListener("click",function(){

		let itemId = document.querySelector("#modalDeleteItemId").value;
		
		let data = {
			"itemId":itemId
		};
		
		//클릭된 요소가 .clsDelete 클래스를 가진 요소일 경우에만 로직 수행
		/*
		요청URI : /item2/deleteAjax
		요청파라미터 : JSONObject{"itemId":272}
		요청방식 : post
		*/
		fetch("/item2/deleteAjax",{
			method:"POST",
			headers:{"Content-Type":"application/json;charset=UTF-8"},
			body:JSON.stringify(data),
		})
		.then(response=>{
			// HTTP 상태 코드 확인 (4xx, 5xx 에러를 잡아내기 위함)
			if(!response.ok){
				throw new Error(`HTTP error! Status: \${response.status}`);
			}
			// dataType: "json" 처리: 응답 본문을 JSON 객체로 파싱함
			return response.json();
		})
		.then(result=>{
			/*
			map.put("result", result);
			map.put("item2VO", item2VO);
			*/
			//map.put("result", result);
			//result{"result":"1","item2VO":item2VO데이터}
			console.log("result : ", result);
			
			// 필요한 성공 후 로직을 여기에 작성
			// 예: alert("성공!");
			
			if(result.result=="1"){//삭제 성공
				//<div class="card" id="card_272">
				document.querySelector("#card_"+result.item2VO.itemId).remove();
			
				//모달창 닫기
				document.querySelector("#modalDeleteClose").click();
			}
		})
		.catch(error=>{
			// 오류 발생 시 콘솔에 출력 (네트워크 오류 또는 HTTP 오류)
			console.error("Fetch 요청 오류 발생:",error);
		});
	});
	
	
	//댓글 수정 실행
	//<button type="button" id="modalEditConfirm" class="btn btn-primary">확인</button>
	$("#modalEditConfirm").on("click",function(){
		//<input type="text" id="modalEditItemId">
		let itemId = $("#modalEditItemId").val();
		//<input type="text" id="modalEditItemName" class="form-control" placeholder="댓글을 작성해주세요">
		let itemName = $("#modalEditItemName").val();
		
		//JSON Object
		let data = {
			"itemId":itemId,
			"itemName":itemName
		}
		
		console.log("modalEditConfirm->data : ", data);
		
		/*
		요청URI : /item2/modifyAjax
		요청파라미터 : JSONObject{"itemId":272,"itemName":"댓글입니다."}
		요청방식 : post
		*/
		fetch("/item2/modifyAjax",{
			method:"POST",
			headers:{"Content-Type":"application/json;charset=UTF-8"},
			body:JSON.stringify(data),
		})
		.then(response=>{
			// HTTP 상태 코드 확인 (4xx, 5xx 에러를 잡아내기 위함)
			if(!response.ok){
				throw new Error(`HTTP error! Status: \${response.status}`);
			}
			// dataType: "json" 처리: 응답 본문을 JSON 객체로 파싱함
			return response.json();
		})
		.then(result=>{
			/*
			map.put("result", result);
			map.put("item2VO", item2VO);
			*/
			//map.put("result", result);
			//result{"result":"1"}
			console.log("result : ", result);
			
			// 필요한 성공 후 로직을 여기에 작성
			// 예: alert("성공!");
			
			if(result.result=="1"){//수정 성공
				//<p id="p_278">ㅁㄴㅇㄹ</p>
				document.querySelector("#p_"+itemId).innerHTML = result.item2VO.itemName;
				//<button type="button" id="modalEditClose" class="btn btn-default" data-dismiss="modal">Close</button>
				document.querySelector("#modalEditClose").click();
			}
		})
		.catch(error=>{
			// 오류 발생 시 콘솔에 출력 (네트워크 오류 또는 HTTP 오류)
			console.error("Fetch 요청 오류 발생:",error);
		});
	});
	
	//댓글 수정(동적으로 생성된 버튼들일 수도 있음)
	$(document).on("click",".clsEdit",function(){
		//<a href="... class="... clsEdit"
		//<a href="... class="... clsEdit" 클릭 -> 달러(this)
		//<a href="... class="... clsEdit"
		let itemId = $(this).data("itemId");//기본키 데이터 272
		
		console.log("clsEdit->itemId : ", itemId);
		
		let data = {
			"itemId":itemId
		};
		console.log("clsEdit->data : ", data);
		
		//해당 댓글 정보 select
		/*
		SELECT * FROM ITEM2 WHERE ITEM_ID = 272
		
		요청URI : /item2/detailAjax
		요청파라미터 : JSONString{"itemId":272}
		요청방식 : post
		*/
		fetch("/item2/detailAjax",{
			method:"post",
			headers:{"Content-Type":"application/json;charset=UTF-8"},
			body:JSON.stringify(data)
		})
		.then(response=>{
			return response.json();
		})
		.then(data=>{
			/*
			data{
			    "result": 1,
			    "item2VO": {
			        "itemId": 274,
			        "itemName": "가볍네요",
			        ...
			    }
			}
			*/
			console.log("data : ", data);
			
			//vanillaJS로 바꿔보자
			//<input type="text" id="modalEditItemId" />
			document.querySelector("#modalEditItemId").value = data.item2VO.itemId;//274
			//<input type="text" id="modalEditItemName" class="form-control" placeholder="댓글을 작성해주세요" />
			document.querySelector("#modalEditItemName").value = data.item2VO.itemName;//가볍네요
		})
		.catch(error=>{
			console.log("error : " , error);
		});
	});
	
	//댓글 등록 실행
	//<input class="form-control form-control-sm" id="itemName" placeholder="댓글을 작성해주세요" />
	//<button type="button" id="btnReply" data-item-id="1" class="btn btn-danger">댓글등록</button>
	const btnReply = document.querySelector("#btnReply");
	
	btnReply.addEventListener("click",function(){
		console.log("btnReply->click!");
		// data-item-id 속성은 JS에서 카멜 케이스(camelCase)인 .dataset.itemId로 접근
		let itemId = btnReply.dataset.itemId;//1
		let itemName = document.querySelector("#itemName").value;//댓글입니다.
		
		//JSON Object
		let data = {
			"parentItemId":itemId,
			"itemName":itemName
		};
		/*
		data{"parentItemId": 1,"itemName": "개동이"}
		*/
		console.log("btnReply->data : ", data);
		
		/*
		요청URI : /item2/createPostAjax
		요청파라미터 : JSON String{"parentItemId": 1,"itemName": "개똥이"}
		요청방식 : post
		
		(m)모두가 (h)함께 (b)밝게 (r)레 (d)디 (e)이~
		*/
		fetch("/item2/createPostAjax",{
			method:"post",
			headers:{
				"Content-type":"application/json;charset=utf-8"
			},
			body:JSON.stringify(data)
		})
		.then(response=>{
			return response.json()
		})
		.then(data=>{
			//data
			//1) result : int result = this.item2Service.createPostAjax(item2VO);//댓글 등록(1은 등록 성공)
			//2) item2VO : 부모글 + 댓글들
			//3) username : 로그인 아이디
			console.log("data : ", data);
			
			let str = "";
			
			if(data.result > 0){//등록 성공
				//<div class="col-md-6" id="divReplys">
				//data.item2VO.item2VOList : List<Item2VO>
				data.item2VO.item2VOList.forEach(function(item2VO,idx){
					str += `
						<div class="card">
							<div class="card-body">
								<div class="post">
							      <p>
							        \${item2VO.itemName}
							      </p>
							
							      <p>
							        <a href="#" class="link-black text-sm mr-2"><i class="fas fa-share mr-1"></i> Share</a>
							        <a href="#" class="link-black text-sm"><i class="far fa-thumbs-up mr-1"></i> Like</a>
						`;
					
					// 로그인 아이디      댓글 작성자
					if(data.username==item2VO.writer){
						str += `
							        <span class="float-right">
							          <a href="#" class="btn btn-warning btn-xs">수정(로그인 아이디 : \${data.username})</a>
							          <a href="#" class="btn btn-danger btn-xs">삭제(글 작성자 : \${item2VO.writer})</a>
							        </span>
						`;
					}//end if
					
					str	+= `
							      </p>
							
							      <input class="form-control form-control-sm" type="text" placeholder="Type a comment">
							    </div>
					    	</div>
					    </div>
					`;
				});//end forEach
				
				document.querySelector("#divReplys").innerHTML = str;
			}else{//end if
				console.log("등록 실패!");
			}
		})
		.catch(error=>{
			console.log("error : ", error);
		});
	});
	
	
	//<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
	$("#btnDelete").on("click",function(){
		console.log("개똥이");
		//<form id="frmSubmit" action="/item2/registerPost"..
		
		let chk = confirm("삭제하시겠습니까?");
		
		if(chk){//확인 -> true
			//속성 : attribute / property
			$("#frmSubmit").attr("action","/item2/deletePost");
			
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
	요청URI : /item2/deletePost
	요청파라미터 : {itemId=1,itemName=삼성태블릿,price=120000,description=쓸만함,uploadFile=파일객체}
	요청방식 : post
	-->
	<!-- 파일업로드
	1) method는 꼭 post!
	2) enctype="multipart/form-data"
	3) <input type="file" name="uploadFile".. name속성이 꼭 있어야 함!
	4) <sec땡땡csrfInput />
	5) action 속성의 uri 뒤에 token 추가
	
	ItemVO(itemId=1, itemName=삼성태블릿, price=120000, description=쓸만함
		, pictureUrl=/2025/09/08/asdldfksj_개똥이.jpg, uploadFile=
	model.addAttribute("item2VO", item2VO);
	
	readonly vs disabled
	--------------------
	변경불가		변경불가
	submit 시    submit 시
	값이 넘어감	값이 안 넘어감
	 -->
	<p>${item2VO.item2VOList}</p>
	<form id="frmSubmit" action="/item2/registerPost"
		method="post" enctype="multipart/form-data">
		<input type="hidden" name="itemId" value="${item2VO.itemId}" />
		<table>
			<tr>
				<th>상품명</th>
				<td><input type="text" name="itemName" value="${item2VO.itemName}"
					readonly required placeholder="상품명" /></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="text" name="price" value="${item2VO.price}"
					readonly required placeholder="가격" /></td>
			</tr>		
			<tr>
				<th>상품이미지</th>
				<td>
					<!-- 
					/upload + /2025/09/08/asdldfksj_개똥이.jpg
					D:/upload/2025/09/08/asdldfksj_개똥이.jpg
					 -->
					<img src="/upload${item2VO.pictureUrl}" style="width:50%;" />
					<input type="file" name="uploadFile" placeholder="상품이미지"
					style="display:none;" />
				</td>
			</tr>
			<tr>
				<th>상품이미지</th>
				<td>
					<!-- 
					/upload + /2025/09/08/asdldfksj_개똥이.jpg
					D:/upload/2025/09/08/asdldfksj_개똥이.jpg
					 -->
					<img src="/upload${item2VO.pictureUrl2}" style="width:50%;" />
					<input type="file" name="uploadFile2" placeholder="상품이미지"
					style="display:none;" />
				</td>
			</tr>
			<tr>
				<th>개요</th>
				<td><input type="text" name="description" value="${item2VO.description}"
					readonly placeholder="개요" /></td>
			</tr>
		</table>
		<a href="/item2/edit?itemId=${item2VO.itemId}" class="btn btn-warning">수정</a>
		<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
		<a href="/item2/list" class="btn btn-success">목록</a>
	</form>
	<hr />
	<!-- ///// 댓글 영역 시작 /////  -->
	<div class="col-md-6">
		<form class="form-horizontal">
		  <div class="input-group input-group-sm mb-0">
			  <a href="#" class="link-black text-sm">
			  												<!-- JSTL에서 prefix="fn" -->
	            <i class="far fa-comments mr-1"></i> Comments (${fn:length(item2VO.item2VOList)})
	          </a>
          </div>
          <div class="input-group input-group-sm mb-0">
            <input class="form-control form-control-sm" id="itemName" placeholder="댓글을 작성해주세요" />
            <div class="input-group-append">
            					<!-- item2VO.itemId -->
              <button type="button" id="btnReply" data-item-id="${item2VO.itemId}" class="btn btn-danger">댓글등록</button>
            </div>
          </div>
        </form>
	</div>
	<hr />
	<div class="col-md-6" id="divReplys">
		<!-- /// 댓글 반복 시작 /// item2VO.item2VOList -->
		<c:forEach var="item2VO" items="${item2VO.item2VOList}">
			<div class="card" id="card_${item2VO.itemId}">
				<div class="card-body">
					<div class="post">
						<!-- p_272 -->
				      <p id="p_${item2VO.itemId}">
				        ${item2VO.itemName}
				      </p>
				
				      <p>
				        <a href="#" class="link-black text-sm mr-2"><i class="fas fa-share mr-1"></i> Share</a>
				        <a href="#" class="link-black text-sm"><i class="far fa-thumbs-up mr-1"></i> Like</a>
				        <!-- 로그인 했는지 체킹 ,댓글, 목록의 체크박스, 다수리분석/설계-->
				        <!-- 
				        isAuthenticated() : 로그인 함
				        isAnonymous() :  로그인 안 함
				         -->
				        <sec:authorize access="isAuthenticated()">
				        	<!-- 						 CustomUser.프로퍼티          JSTL변수 -->
				        	<sec:authentication property="principal.memberVO" var="memberVO" />
				        	<p>로그인아이디 : ${memberVO.userId} / 작성자 : ${item2VO.writer}</p>
				        	<c:if test="${memberVO.userId eq item2VO.writer}">
						        <span class="float-right">
						          <a href="#modalEdit" data-toggle="modal" data-item-id="${item2VO.itemId}" class="btn btn-warning btn-xs clsEdit">수정</a>
						          <a href="#modalDelete" data-toggle="modal" data-item-id="${item2VO.itemId}" class="btn btn-danger btn-xs clsDelete">삭제</a>
						        </span>
					        </c:if>
				        </sec:authorize>
				      </p>
				
				      <input class="form-control form-control-sm" type="text" placeholder="Type a comment">
				    </div>
		    	</div>
		    </div>
	    </c:forEach>
	    <!-- /// 댓글 반복 끝 /// -->
	</div>
	<!-- ///// 댓글 영역 끝 /////  -->
	
	<!-- ///// 수정 모달 시작 ///// -->
	<div class="modal fade" id="modalEdit">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">댓글 수정</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <p>
            	<input type="text" id="modalEditItemId" />
            	<input type="text" id="modalEditItemName" class="form-control" placeholder="댓글을 작성해주세요" />
            </p>
          </div>
          <div class="modal-footer justify-content-between">
            <button type="button" id="modalEditClose" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" id="modalEditConfirm" class="btn btn-primary">확인</button>
          </div>
        </div>
      </div>
    </div>
	<!-- ///// 수정 모달 끝 ///// -->
	
	<!-- ///// 삭제 모달 시작 ///// -->
	<div class="modal fade" id="modalDelete">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">댓글 삭제</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
          	<div class="alert alert-danger alert-dismissible">
                  <h5><i class="icon fas fa-ban"></i>삭제하시겠습니까?</h5>
            </div>
            <p>
            	<input type="text" id="modalDeleteItemId" />
            	<input type="text" id="modalDeleteItemName" class="form-control" readonly />
            </p>
          </div>
          <div class="modal-footer justify-content-between">
            <button type="button" id="modalDeleteClose" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" id="modalDeleteConfirm" class="btn btn-primary">확인</button>
          </div>
        </div>
      </div>
    </div>
	<!-- ///// 삭제 모달 끝 ///// -->
	
	<!-- /// footer.jsp 시작 /// -->
	<%@ include file="../footer.jsp" %>
	<!-- /// footer.jsp 끝 /// -->
</body>
</html>











