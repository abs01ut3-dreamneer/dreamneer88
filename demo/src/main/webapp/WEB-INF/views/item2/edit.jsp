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
	
	//이미지 미리보기
	//e : onchange 이벤트 객체
	
	function handleImgFileSelect(e, divId){
   //1. 이벤트가 발생 된 타겟 안에 들어있는 이미지 파일들을 가져와보자
		let files = e.target.files;
   		console.log("check: files", files);
   //2. 이미지가 여러개가 있을 수 있으므로 이미지들을 각각 분리해서 배열로 만듦
   //files : {개똥이.jpg, 개똥삼.jpg, 개똥오.jpg}
   //fileArr : [개똥이.jpg, 개똥삼.jpg, 개똥오.jpg]
		let fileArr = Array.prototype.slice.call(files);
   	console.log("check : fileArr", fileArr);
		/* 위의 Array.prototype.slice.call(files) 정확히 같은 결과
		// 1. 전개연산자 사용
			let fileArr = [...files];

		// 2. Array.from() 사용  
			let fileArr = Array.from(files);

		*/
   	let str = "";
	
	let div =  $('#'+divId);
	div.empty();
		
   //3. 파일 타입의 배열 반복. f : 배열 안에 들어있는 각각의 이미지 파일 객체
    
	fileArr.forEach(elem => {
      //이미지 파일이 아닌 경우 이미지 미리보기 실패 처리(MIME타입)
		if(!elem.type.match("image.*")){
        	alert("이미지 확장자만 가능합니다");
         //함수 종료
		}
   
      //이미지 객체를 읽을 자바스크립트의 reader 객체 생성
		let reader = new FileReader();
      
      //e : reader가 이미지 객체를 읽는 이벤트
       // 1) onload 핸들러 등록
		reader.onload=function(e){
			//e.target : f(이미지 객체)
	        //e.target.result : reader가 이미지를 다 읽은 결과
			 str = `
			 	<img src="\${e.target.result}" style="width:50%" /><br/>
			 `
			 
			//마지막 자식 요소로 추가
			div.append(str);
		}
            	
      //reader 객체로 f(파일 한 개)을 읽음
      // 2) 파일 읽기 시작
      reader.readAsDataURL(elem);
      
      /*
      	reader.onload = …: 파일 읽기 완료 시 실행될 콜백을 먼저 등록
		reader.readAsDataURL(elem): 콜백 등록 후에 실제 읽기 작업 시작
      */
      
   });

	
     //p 사이에 이미지가 렌더링되어 화면에 보임
     //객체.append : 누적, .html : 새로고침, .innerHTML : J/S
		
   /*[참고]******
   arr.forEach(function(str,idx){
      console.log("str : " + str);
   });
   
   $.each(arr,function(idx,str){
      console.log("str[" + idx + "] : " + str);
   });
   */
	}//end handleImgFileSelect

// 	$(function(){
	document.addEventListener("DOMContentLoaded", function(){
		// <input type='file' name="uploadfile" placeholder="상품이미지"/>
		let uploadFiles = document.querySelector("input[name='uploadFiles']");
		uploadFiles.addEventListener("change", function(e){
			handleImgFileSelect(e, "img3");
		});
		
		
		//<button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
		// 확인버튼 처리
		const submitInput = document.querySelector("#btnSubmit");
		submitInput.addEventListener("click", function(){
			let formData = new FormData();
			
			document.querySelectorAll(".clsItems").forEach((elem, idx)=>{
			//$(".clsItems").each(function(idx, elem){
				console.log("clsItems -> idx : ", idx);
				//<input type="text" class="form-control clsItems" name="itemName" value="개똥이"...
				// let name = $(this).attr("name");// itemName, price, description
				let name = elem.getAttribute("name");
				console.log("clsItems -> name : ", name);
				// let value = $(this).val(); //개똥이 펜슬, 12000, 개똥이 펜슬 좋으다~
				let value = elem.value;
				console.log("clsItems -> value : ", value);

				formData.append(name, value);
			});

			//파일들 처리
			//<input type="file" name="uploadFile" placeholder="상품이미지" multiple />
			let fileElement = document.querySelector("input[name='uploadFiles']");
			let files = fileElement.files;
			
			let file1 = document.querySelector("input[name='uploadFile']").files[0];
			if(file1){
			formData.append("uploadFile", file1);
			}
			
			let file2 = document.querySelector("input[name='uploadFile2']").files[0];
			if(file2){
			formData.append("uploadFile2", file2);
			}
			
			//가상폼인 formData에 각각의 이미지 객체를 넣자
			// for(let i =0; i<files.length; i++){
			// 	formData.append("uploadFiles", files[i]);
			// }

			for(const file of files){
				formData.append("uploadFiles", file);
			}			

			console.log("check: Array.from(formData.entries =>", Array.from(formData.entries()));
			const formDataArr = Array.from(formData.entries());
			/*
			ES6는 2015년에 발표된 자바스크립트의 표준인 ECMAScript 6를 줄여 부르는 말로
			2009년 발표된 ES5 이후의 주요 개정판. 
			var 대신 let과 const, 화살표 함수, 템플릿 리터럴, 클래스, 모듈 시스템 등 다양한 새로운 문법과 기능을 도입
			자바스크립트 개발을 더 효율적이고 편리하게 만듦
			*/
			// for(let i = 0; i < formDataArr.length; i++){
			// 	let key = formDataArr[i][0];   // 첫 번째 요소가 key
			// 	let value = formDataArr[i][1]; // 두 번째 요소가 value
			// 	console.log(key, " : ", value);
			// }
			for(const[key, value] of formDataArr){
				console.log(key, " : ", value);
			}
			
			/*참고 - JSON obj를 보낼때
			fetch("/api/articles",{
				method:"POST",
				headers:{
					"Content-Type":"application/json",
				},
				body:JSON.stringify(data)
			})
			*/
			
			//fetch API를 사용하여 /item2/editPostAjax 엔드포인트로 POST 요청을 보냄
			fetch("/item2/editPostAjax", {
				method: "POST",
				// Content-Type:"application/json;charset=utf-8",
				body: formData
			})
			.then(response=>{
				if(!response.ok){
					throw new Error(`Status Error : \${response.status}`);
				}
				return response.json(); //여기서는 res가 response 객체 자체라서 실제 서버 결과(데이터)는 body를 파싱필요!
			})
			.then(result=>{
				console.log("check : result => ", result);
				console.log("result.result : ", result.result);
				
				if(result.result=="1"){
					var Toast = Swal.mixin({
					      toast: true,
					      position: 'top-end',
					      showConfirmButton: false,
					      timer: 3000
					    });
					
					Toast.fire({
						icon:'success',
						title:'성공적으로 변경되었습니다'
					});

					/* 
					setTimeOut()
		               - 어떤 코드를 바로 실행하지 않고 일정 시간 기다린 후 실행
		               - 첫 번재 인자로 실행할 코드를 담고 있는 함수를 받고
		               - 두 번째 인자로 지연 시간을 밀리초(ms) 단위로 받음
		               - 세 번째 인자부터는 가변 인자를 받음. 첫번째 인자로 넘어온 함수가 인자를 받는 경우, 
		                  이 함수에 넘길 인자를 명시해주기 위해서 사용함
		            */						
					setTimeout(()=>location.href = '/item2/detail?itemId=${item2VO.itemId}', 1000);
					
				}else{
					var Toast = Swal.mixin({
					      toast: true,
					      position: 'top-end',
					      showConfirmButton: false,
					      timer: 3000
					    });
					
					Toast.fire({
						icon:'warning',
						title:'변경되니 않았습니다. 다시 확인해주세요'
					});

				}
			})
			.catch(error=>{
				console.log("Error 발생 : ", error);
			})

		}); 

			
	});
		
	
	
	
	</script>


	
	
	
	<!-- /// 제목 시작 /// -->
	<div class="jumbotron">
		<!-- container : 내용이 들어갈 때 -->
		<div class="container">
			<h1 class="display-3">다중 파일 에디트</h1>
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
	<form action="/item2/editPost"
		method="post" enctype="multipart/form-data">
		<input type="hidden" class="form-control clsItems" name="itemId" value="${item2VO.itemId }"/>
		<table>
			<tr>
				<th>상품명</th>
				<td><input type="text" class="form-control clsItems" name="itemName" value="${item2VO.itemName}" required placeholder="상품명"/></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="text" class="form-control clsItems" name="price" value="${item2VO.price }" required placeholder="가격" /></td>
			</tr>		
			<tr>
				<th>상품이미지</th>
				<td>
				<img src="/upload${item2VO.pictureUrl }" style="width:50%;">
				<p/>
				<div id="img1"></div>
				<input type="file" name="uploadFile" placeholder="상품이미지"
				onchange="handleImgFileSelect (event, 'img1')" />
				</td>
			</tr>
			<tr>
				<th>상품이미지2</th>
				<td>
				<img src="/upload${item2VO.pictureUrl2 }" style="width:50%;">
				<p/>
				<div id="img2"></div>
				<input type="file" name="uploadFile2" placeholder="상품이미지"
				onchange="handleImgFileSelect (event, 'img2')" />
				</td>
			</tr>
			<tr>
	            <th>다중이미지</th>
	            <td>
	               <!-- 
	               /upload + /2025/09/08/asdldfksj_개똥이.jpg
	               D:/upload/2025/09/08/asdldfksj_개똥이.jpg
	                -->
	               <img src="#" style="width:50%;" />
	               <p />
	               <div id="img3" class="images"></div>
	               <input type="file" name="uploadFiles" placeholder="상품이미지" multiple />
	            </td>
         	</tr>
			<tr>
				<th>개요</th>
				<td>
					<input type="text" name="description" class="form-control clsItems"
					value="${item2VO.description }" placeholder="개요" />
				</td>
			</tr>
		</table>
		
		<button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
		<a href="/item2/detail?itemId=${item2VO.itemId }" class="btn btn-warning">취소</a>
	</form>
	<hr />

	<!-- /// footer.jsp 시작 /// -->
	<%@ include file="../footer.jsp" %>
	<!-- /// footer.jsp 끝 /// -->
	
	
	
</body>
</html>