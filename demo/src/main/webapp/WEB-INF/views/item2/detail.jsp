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

// 		$(function(){
		document.addEventListener("DOMContentLoaded", function(){
		
			//----
			document.addEventListener("click",function(event){
				console.log("클릭함!");
				
				//실제로 클릭한 요소를 특정
				// const clickedElement = event.target;
				
				//클릭된 요소가 ".clsDelete" 클래스를 가지고 있는지 체킹
				// const deleteButton = clickedElement.closest(".clsDelete");
				
				if(event.target.matches(".clsDelete")){
					//<a href="#modalDelete" data-toggle="modal" data-item-id="274" class="btn btn-danger btn-xs clsDelete">삭제</a>
					//           data-   item-id
					let itemId = event.target.dataset.itemId;
					
					let card = event.target.closest(".card")
					card.setAttribute("id", "card_"+itemId);
					
					let ch = document.querySelector("#card_"+itemId);
					console.log("check : ch", ch);

					// parentElement : 특정 엘리먼트의 부모 엘리먼트를 찾아감
					let postDiv = event.target
									.parentElement //span
									.parentElement; //div
									
					let firstChild = postDiv.firstElementChild;
					console.log("check : firstElementChild => ", firstChild);
					
					let itemName = "";
					if(firstChild){
						console.log("check : firstChild.textContent.trim() => ",firstChild.textContent.trim());
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
				console.log("(댓글 삭제 컨펌) check : itemId => ", itemId);
				
				let card = document.querySelector("#card_"+itemId);

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
					headers: {
						"Content-Type":"application/json;charset=UTF-8"
					},
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
						// document.querySelector("#card_"+result.item2VO.itemId).remove();
						card.remove();			
						//모달창 닫기
						document.querySelector("#modalDeleteClose").click();
					}
				})
				.catch(error=>{
					// 오류 발생 시 콘솔에 출력 (네트워크 오류 또는 HTTP 오류)
					console.error("Fetch 요청 오류 발생:",error);
				});
			});

			//----
				
			// 댓글 수정 실행		
			//<button type="button" id="modalEditConfirm" class="btn btn-primary">확인</button>
			document.querySelector("#modalEditConfirm").addEventListener("click", function(){
			// $("#modalEditConfirm").on("click", function(){
				//<input type="text" id="modaleditItemId">
				let itemId = document.querySelector("#modalEditItemId").value; //$("#modalEditItemId").val();

				//<input type="text" id="modalEditItemName" class="form-control" placeholder="...">
				let itemName = document.querySelector("#modalEditItemName").value; //$("#modaleditItemName").val();

				//JSON object
				let data ={
					"itemId" : itemId,
					"itemName" : itemName
				}

				console.log("modalEditeconfirm -> data : ", data);

				/*
				요청URI : /item2/modifyAjax
				*/
				fetch("/item2/modifyAjax", {
					method: "post",
					headers: {
						"Content-Type" : "application/json;charset=UTF-8"
					},
					body: JSON.stringify(data)
				})
				.then(response =>{
					return response.json();
				})
				.then(data=>{
					if(data.result==1)	{
						console.log("수정완료! 수정된 행의 갯수 : ", data.result);
						// <a href="#modalEdit" data-toggle="modal" data-item-id="${item2VO.itemId}" class="btn btn-warning btn-sm clsEdit">수정</a>
						// 위와 같은 수정버튼이 많이 존재함
						
						document.querySelector("#p_"+itemId).innerHTML=data.item2VO.itemName;
						document.querySelector("#modalEditClose").click();
					}
				})
				.catch(error=>{
					console.log("error 발생 : ", error);
				})

			});

			
			//댓글 수정(동적으로 생성된 버튼들일 수도 있음)
			//동적으로 생성된 태그들은 $(".clsEdit") 이렇게 직접 접근할수 없다
			//대신 $(document)로 접근한다
			$(document).on("click", ".clsEdit", function(){
				//<a href="....." class="... clsEdit"
				//<a href="....." class="... clsEdit" <==클릭 이런 경우 this를 활용하자
				//<a href="....." class="... clsEdit"
				let itemId = $(this).data("itemId");

				console.log("clsEdit -> itemId : ", itemId); //272

				let data = {
					"itemId" : itemId // {"itemId" : 272}
				}

				//해당 댓글 정보 select
				/*
				요청URI: /item2/detailAjax
				요청파라미터: JSON String {"itemId": itemId}
				요청방식: post
				*/
				fetch("/item2/detailAjax", {
					method: "post",
					headers: {
						"Content-Type" : "application/json;charset=UTF-8"
					},
					body: JSON.stringify(data)
				})
				.then(response=>{
					return response.json(); // map {{"result": 1}} 
				})
				.then(data=>{
					console.log("check: detailAjax/data.result =>", data.result);
					console.log("check: detailAjax/data.result =>", data.item2VO);

					//<input type="text" id="modalEditItemId" />
//                   $("#modalEditItemId").val(data.item2VO.itemId);//274
					document.querySelector("#modalEditItemId").value = data.item2VO.itemId;
                  //<input type="text" id="modalEditItemName" class="form-control" placeholder="댓글을 작성해주세요"/>
//                   $("#modalEditItemName").val(data.item2VO.itemName);//가볍네요
					document.querySelector("#modalEditItemName").value = data.item2VO.itemName;
				})
				.catch(error=>{
					console.log("error 발생 : ", error);
				})
			})

			//댓글 등록 실행
			   //<input class="form-control form-control-sm" id="itemName" placeholder="댓글을 작성해주세요" />
			   //<button type="button" id="btnReply" data-item-id="1" class="btn btn-danger">댓글등록</button>

			   	//    $("#btnReply").on("click", function(){
			    document.querySelector("#btnReply").addEventListener("click", function(){
	   			let itemId = document.querySelector("#btnReply").dataset.itemId;
							// $("#btnReply").data("itemId");
				let itemName= document.querySelector("#itemName").value;
							//$("#itemName").val();//댓글입니다.
				
				//JSON Object
				let data = {
					"parentItemId": itemId,
					"itemName": itemName				
				}

				/*
				요청uri: /item2/createPostAjax
				요청파라미터: Json String
				요청방식: post

				(m)모두가 (h)함께 (b)밝게 (r)레 (d)뒤 (e)이~
				*/
				fetch("/item2/createPostAjax",{
					method: "POST",
					headers: {
						"Content-type":"application/json;charset=utf-8"
					},
					body: JSON.stringify(data)
				})
				.then(resp=>{
					return resp.json(); // map{{"result" : }}
				})
				.then(rslt=>{
					console.log(rslt);
					console.log(rslt.item2VO);
					let str ="";
					if(rslt.result>0){
						//rslt.result : int result = this.item2Service.createPostAjax(item2VO);
						//rslt.item2VO : 부모글 + 댓글
						//rslt.username : writer (로그인 아이디)
						let reply = document.querySelector("#divReply")
						reply.innerHTML="";
						//rslt.item2VO.item2VOList : List<Item2VO>
						rslt.item2VO.item2VOList.forEach(elem => {
							
							str += `
								<div class="card">
								 <div class="card-body">
									<div class="post">
									   <p>
										 \${elem.itemName }
									   </p>
									   <p>
										 <a href="#" class="link-black text-sm mr-2"><i class="fas fa-share mr-1"></i> Share</a>
										 <a href="#" class="link-black text-sm"><i class="far fa-thumbs-up mr-1"></i> Like</a>
										 
							`;
							// 로그인 아이디	댓글 작성자
							if(rslt.username==elem.writer){
								str += `
									<span class="float-right">
										<a href="#modalEdit" data-toggle="modal" data-item-id="\${elem.itemId}" class="btn btn-warning btn-sm clsEdit">수정</a>
										<a href="#modalDelete" data-toggle="modal" data-item-id="\${elem.itemId}" class="btn btn-danger btn-sm clsDelete">삭제</a>
									</span>
									
								`;
							}//endif

							str +=`
								 </p>
										<input class="form-control form-control-sm" type="text" placeholder="Type a comment">
									</div>
								</div>
							</div>
							`
							
						});
						reply.innerHTML=str;
					}else{
						console.log("등록 실패");
					}
					
// 					let child = rslt.item2VO;
// 					console.log("check : child.itemName", child.itemName);
// 				    // 새로운 card 노드 생성
// 				    let card = document.createElement("div");
// 				    card.className = "card";
// 				    card.innerHTML = `
// 				     <div class="card-body">
// 				        <div class="post">
// 				           <p>
// 				             \${child.itemName}
// 				           </p>
// 				           <p>
// 				             <a href="#" class="link-black text-sm mr-2"><i class="fas fa-share mr-1"></i> Share</a>
// 				             <a href="#" class="link-black text-sm"><i class="far fa-thumbs-up mr-1"></i> Like</a>
// 				             <span class="float-right">
// 				               <a href="#" class="link-black text-sm">
// 				                 <i class="far fa-comments mr-1"></i> Comments (5)
// 				               </a>
// 				             </span>
// 				           </p>
// 				           <input class="form-control form-control-sm" type="text" placeholder="Type a comment">
// 				         </div>
// 				      </div>
// 				    `;
// 				    document.querySelector("#reply").appendChild(card);
				    
				})
				.catch(err=>{
					console.log("error 발생 : ", err);
				})
			});
			
		   //<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>		   
		   $("#btnDelete").on("click",function(){
		      console.log("개똥이");
		      //<form id="frmSubmit" action="/item2/registerPost"..
		      
		      let chk = confirm("삭제하시겠습니까?");
		      
		      if(chk){//확인 -> true
		      //속성 : attribute / property
		      $("#frmSubmit").attr("action", "/item2/deletePost");
		      
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
			<h1 class="display-3">다중 파일 디테일</h1>
		</div>
	</div>
	<!-- /// 제목 끝 /// -->
	
	<!-- 
	요청URI : /item2/registerPost
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
		action="/item2/registerPost"
		method="post" enctype="multipart/form-data">
		<input type="hidden" name="itemId" value="${item2VO.itemId }"/>
		<table>
			<tr>
				<th>상품명</th>
				<td><input type="text" name="itemName" value="${item2VO.itemName}" readonly/></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="text" name="price" value="${item2VO.price }" readonly /></td>
			</tr>		
			<tr>
				<th>상품이미지</th>
				<td>
				<img src="/upload${item2VO.pictureUrl }" style="width:50%;">
				<input type="file" name="uploadFile" style="display:none" />				
				</td>
			</tr>
			<tr>
				<th>상품이미지2</th>
				<td>
				<img src="/upload${item2VO.pictureUrl2 }" style="width:50%;">
				<input type="file" name="uploadFile2" style="display:none" />				
				</td>
			</tr>
			<tr>
            <th>다중이미지</th>
	            <td>
	               <!-- 
	               /upload + /2025/09/08/asdldfksj_개똥이.jpg
	               D:/upload/2025/09/08/asdldfksj_개똥이.jpg
	                -->
	                <c:forEach var="fileDetailVO" items="${item2VO.fileGroupVO.fileDetailVOList}" varStatus="stat">
	               	 	<p><img src="/upload${fileDetailVO.fileSaveLocate}" style="width:50%;" /></p>
	                </c:forEach>
	               
	               <p />
	               <div id="img3"></div>
<!-- 	               <input type="file" name="uploadFiles" placeholder="상품이미지" multiple /> -->
	            </td>
	        </tr>
			<tr>
				<th>개요</th>
				<td>
					<input type="text" name="description" value="${item2VO.description }" readonly />
				</td>
			</tr>
		</table>
		
			<a href="/item2/edit?itemId=${item2VO.itemId }" class="btn btn-warning" >수정</a>
			<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
			<a href="/item2/list" class="btn btn-success">목록</a>
		
	</form>
	<hr />

	<!-- ///// 댓글 영역 시작 /////  -->
		<div class="col-md-6">
	      <form class="form-horizontal">
			  <div class="input-group input-group-sm mb-0">
				  <a href="#" class="link-black text-sm">
																  <!-- JSTL에서 prefix="fn"-->
					  <i class="far fa-comments mr-1"></i> Comments (${fn:length(item2VO.item2VOList)})
				  </a>
			  </div>
	          <div class="input-group input-group-sm mb-0">				
	            <input class="form-control form-control-sm" id="itemName" placeholder="댓글을 작성해주세요" />
	            <div class="input-group-append">
	            						<%-- item2VO.itemId --%>
	              <button type="button" id="btnReply" data-item-id="${item2VO.itemId }" class="btn btn-danger">댓글등록</button>
	            </div>
	          </div>
	        </form>
	   </div>
	   <hr />
	   <div class="col-md-6" id="divReply">
	   <!-- 댓글반복시작 -->
	   <c:forEach var="item2VO" items="${item2VO.item2VOList }" varStatus="stat">
	      <div class="card" id="d_${item2VO.itemId}">
	         <div class="card-body">
	            <div class="post">
	               <p id="p_${item2VO.itemId}"> <!-- p태그에 아이디를 부여하여 수정한 내용을 비동기로 바꿀수 있도록 하자 -->
					${item2VO.itemName } 
	               </p>
	               <p>
	                 <a href="#" class="link-black text-sm mr-2"><i class="fas fa-share mr-1"></i> Share</a>
	                 <a href="#" class="link-black text-sm"><i class="far fa-thumbs-up mr-1"></i> Like</a>
					 <!-- 로그인 했는지 체킹, 댓글, 목록의 체크박스, 다수의분석/설계 -->
                     <!-- 
						isAuthenticated() : 로그인 함
						isAnonymous() : 로그인 안함
                     -->
					<sec:authorize access="isAuthenticated()">
						<!-- 						  CustomUser.프로퍼티		JSTL변수-->
						<sec:authentication property="principal.memberVO" var="memberVO" />
							<p>로그인ID : ${memberVO.userId} / 작성자 : ${item2VO.writer}</p>
							<c:if test="${memberVO.userId eq item2VO.writer}">
								<span class="float-right">
									<!-- 아래 <a>태그들은 반복되기 때문에 id 속성을 부여하는 것은 올바르지 않다. 대신 class속성을 대신하자 -->
									<a href="#modalEdit" data-toggle="modal" data-item-id="${item2VO.itemId}" class="btn btn-warning btn-sm clsEdit">수정</a>
									<a href="#modalDelete" data-toggle="modal" data-item-id="${item2VO.itemId}" class="btn btn-danger btn-sm clsDelete">삭제</a>
								</span>
							</c:if>
					 </sec:authorize>
	               </p>
	               <input class="form-control form-control-sm" type="text" placeholder="Type a comment">
	             </div>
	          </div>
	       </div>
	   </c:forEach>
	   <!-- 댓글반복끝 -->
	   </div>
   <!-- ///// 댓글 영역 끝 /////  -->

	<!-- /// 수정 모달 시작 /// -->
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
						<input type="text" id="modalEditItemId" readonly/>
            			<input type="text" id="modalEditItemName" class="form-control" placeholder="댓글을 작성해주세요"/>
					</p>
				</div>
				<div class="modal-footer justify-content-between">
				<button type="button" id="modalEditClose" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" id="modalEditConfirm" class="btn btn-primary">확인</button>
				</div>
			</div>
			</div>
		</div>
	<!-- /// 수정 모달 끝 /// -->

	<!-- /// 삭제 모달 시작 /// -->
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
	<!-- /// 삭제 모달 끝 /// -->


	<!-- /// footer.jsp 시작 /// -->
	<%@ include file="../footer.jsp" %>
	<!-- /// footer.jsp 끝 /// -->
</body>
</html>