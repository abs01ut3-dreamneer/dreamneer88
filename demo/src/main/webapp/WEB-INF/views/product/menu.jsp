<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<!DOCTYPE html>
<html>

<head>

<title></title>
<!-- CDN방식으로 import -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/adminlte/dist/js/adminlte.min.js"></script>
<script type="text/javascript"
	src="/adminlte/plugins/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/ckeditor5/ckeditor.js"></script>
<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", () => {
			console.log("개똥이");
		
		//<button type="button" class="btn btn-info btn-sm" id="btnUseGemini">제미나이활성화</button>
		const btnUseGeminiElement = document.querySelector("#btnUseGemini");
		//버튼 있으면 실행
		if(btnUseGeminiElement!=null){
			btnUseGeminiElement.addEventListener("click", ()=>{
				//에미나이 사용 모달 띄우기
				//id="modalGeminiOn"
				const geminiModal = document.querySelector("#modalGeminiOn"); // div 엘리먼트
				const modalInstance = new bootstrap.Modal(geminiModal); // 모달 엘리먼트
				
				modalInstance.show();
			});
		}
		
		//모달 확인버튼 클릭 이벤트 처리
		//<button type="button" class="btn btn-primary" id="btnGeminiOn">확인</button>
		document.querySelector("#btnGeminiOn").addEventListener("click", ()=>{
			console.log("check : 모달 확인 버튼");
			// 입력한 gemini key를 불러오자
			// <input type="text" class="form-group" id="geminiApiKey" />
			let geminiApiKey = document.querySelector("#geminiApiKey").value;
			console.log("check : geminiApiKey =>", geminiApiKey);
			
			/*JSON Object
		      <p>JSON은 JavaScript Object Notation의 약자.</p>
		      <p>JSON은 텍스트에 기반을 둔 데이터 저장 및 교환을 위한 구문임</p>
		      <p>JSON은 자바스크립트 객체 표기법으로 작성된 텍스트임</p>
		      <p>JSON은 브라우저와 서버 간에 데이터를 교환할 때 데이터는 텍스트일 뿐임</p>
		      <p>모든 자바스크립트 객체를 JSON으로 변환하고 JSON을 서버로 보낼 수 있음</p>
		      <p>서버에서 받은 JSON을 자바스크립트 객체로 변환할 수 있음</p>
		      
		      client -> server (string 형식으로 전달)
		      server -> client (string 형식으로 전달)
		      string으로 받아온 데이터를 다시 Object로 변환하여 브라우저에 표기!
		      object -> string 으로 변환하는 방식을 serialize 라고 한다!
		      string -> object로 다시 변환하는 방식을 deserialize라고 함!
		     */
			
		     let data = {
					"geminiApiKey": geminiApiKey
		     }
		     console.log("check : data => ", data);
			
		     // 비동기(Asynchronous Java and Xml)통신 => AJAX
		     // 아작나써유.피씨다타써
		     // contentType: 보내는 타입
		     // dataType: 응답 타입
		     $.ajax({
				url: "/geminiApi",
				contentType:"application/json;charset=UTF-8",
				data: JSON.stringify(data),
				type: "post",
				success: function(rslt){
					console.log("check : rslt", rslt);
					
					let str = "";
					// 세션에 key 등록 성공 시					
					if(rslt.result=="success"){
						str=`
							<input type="text" style="width:50%" class="form-group" id="txtGeminiSearch" placeholder="검색어를 입력해주세요" />
							<button type="button" class="btn btn-success btn-sm" id="btnGeminiSearch">Gemini검색</button>
						`;
						
						//<span id="spnGemini">...</span>
						document.querySelector("#spnGemini").innerHTML = str;
						//모달(id="modalGeminiOn")닫기
						//<button type="button" class="btn ..." id="btnGeminiClose" .../>
						const geminiClose = document.querySelector("#btnGeminiClose"); // div 엘리먼트
						geminiClose.click();
					}
				}
		     })
		})
		
		//gemini검색
		//<button type="button" class="..." id="btnGeminiSearch">Gemini검색</button>
		const searchElement = document.querySelector("#btnGeminiSearch");
		
		if(searchElement!=null){
			searchElement.addEventListener("click", function(){
				console.log("제미나이 검색 실행");
			
				//로딩 중 보이기
				if(document.querySelector("#btnSpinner")!=null){
					document.querySelector("#btnSpinner").style.display="block";
				}
				
				//입력한 검색어
				let txtGeminiSearch = document.querySelector("#txtGeminiSearch").value;
				console.log("check : txtGeminiSearch => ", txtGeminiSearch);
				
				if(txtGeminiSearch==null||txtGeminiSearch==""){
					alert("검색어를 입력해주세요");
					return;
				}
				
				let data={
					"txtGeminiSearch":txtGeminiSearch
				};
				
				console.log("check : data => ", data);
				
				$.ajax({
					url:"/geminiApiPost",
					contentType:"application/json;charset=utf-8",
					data:JSON.stringify(data),
			        type:"post",
			        dataType:"text",
					success: function(rslt){
						console.log("check : rslt => ", rslt);
						
						//div 초기화
						//<div id="divGeminiShow">
						document.querySelector("#divGeminiShow").innerHTML ="";
						
						ClassicEditor.create(
							document.querySelector("#divGeminiShow"),
							{ckfinder:"/image/upload"}
						).then(editor=>{window.editor=editor;window.editor.setData(`\${rslt}`);} // 자바스크립트 `` 에서 씉때는 백슬러시 필요!
						).catch(err=>{console.error(err.stack);}
						);
						//<div class="modal fade" id="modalGeminiResult">
						const modalGeminiResult = document.getElementById("modalGeminiResult");
						let modalShowInstance = new bootstrap.Modal(modalGeminiResult);
						modalShowInstance.show();
					}
				})
			});//end click
		}//end searchElement
	});
</script>

</head>

<body>

	<!-- /// header 시작 /// -->
	<nav class="navbar navbar-expand navbar-dark bg-dark">
		<div class="container">
			<div class="navebar-header">
				<a class="navbar-brand" href="/product/welcome">Home</a>
			</div>
			<div>
				<ul class="navbar-nav mr-auth">
					<!-- /// 제미나이 API 버튼 시작 /// -->
					<li class="nav-item"><c:set var="geminiApiKey"
							value='<%=(String) session.getAttribute("geminiApiKey")%>'></c:set>
						<p>geminiApiKey : ${geminiApiKey}</p> 
						<c:if test="${geminiApiKey==null}">
							<span id="spnGemini">
								<button class="btn btn-primary" type="button" id="btnSpinner"
									style="display: none;" disabled>
									<span class="spinner-border spinner-border-sm"
										aria-hidden="true"></span> <span role="status">Loading...</span>
								</button>
								<button type="button" class="btn btn-info btn-sm"
									id="btnUseGemini">제미나이 활성화</button>
							</span>
						</c:if> 
						<c:if test="${geminiApiKey!=null}">
							<!-- session에 key가 안담김 -->
							<span id="spnGemini"> <input type="text"
								style="width: 50%;" class="form-group" id="txtGeminiSearch"
								placeholder="검색어를 입력해주세요" />
								<button type="button" class="btn btn-success btn-sm"
									id="btnGeminiSearch">Gemini검색</button>
							</span>
						</c:if> </span></li>
					<!-- /// 제미나이 API 버튼 끝 /// -->
					<li class="nav-item"><a class="nav-link" href="#">로그인</a></li>
					<li class="nav-item"><a class="nav-link" href="/item2/list">아이템2</a></li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- /// header 끝 /// -->
	<!-- /// 제미나이 모달 -->
	<div class="modal fade" id="modalGeminiOn">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Large Modal</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p>
						<label class="form-check-label" for="geminiApiKey">GEMINI_API_KEY</label>
						<input type="text" class="form-group" id="geminiApiKey" />
					</p>
				</div>
				<div class="modal-footer justify-content-between">
					<button type="button" class="btn btn-default" id="btnGeminiClose"
						data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" id="btnGeminiOn">확인</button>
				</div>
			</div>
		</div>
	</div>
	<!-- /// 제미나이 모달 -->
	
	<!-- /// 제미나이 결과 모달-->
	<div class="modal fade" id="modalGeminiResult">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">제미나이 검색 결과</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p>
						<div id="divGeminiShow">
						
						</div>
					</p>
				</div>
				<div class="modal-footer justify-content-between">
					<button type="button" class="btn btn-default" id="btnGeminiClose" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<!-- /// 제미나이 결과 모달 -->