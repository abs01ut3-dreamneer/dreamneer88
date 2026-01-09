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
	
	function handleImgFileSelect(e){
   //<input type="text" name="fileGroupNo" value="20250226070">

   //1. 이벤트가 발생 된 타겟 안에 들어있는 이미지 파일들을 가져와보자
		let files = e.target.files;
   
   //2. 이미지가 여러개가 있을 수 있으므로 이미지들을 각각 분리해서 배열로 만듦
   //files : {개똥이.jpg, 개똥삼.jpg, 개똥오.jpg}
   //fileArr : [개똥이.jpg, 개똥삼.jpg, 개똥오.jpg]
		let fileArr = Array.prototype.slice.call(files);
		/* 위의 Array.prototype.slice.call(files) 정확히 같은 결과
		// 1. 전개연산자 사용
			let fileArr = [...files];

		// 2. Array.from() 사용  
			let fileArr = Array.from(files);

		*/
   	let str = "";

   //3. 파일 타입의 배열 반복. f : 배열 안에 들어있는 각각의 이미지 파일 객체
   $("#img").innerHTML = ""; 
   
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
			 	<p><img src="\${e.target.result}" style="width:50%" /></p>
			 `
			 
			//마지막 자식 요소로 추가
			$("#img").append(str);
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

	$(function(){
		// <input type='file' name="uploadfile" placeholder="상품이미지"/>
		$("input[name='uploadFile']").on("change", handleImgFileSelect);
		
		//정보 변경 실행
// 		<button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
		$("#btnSubmit").on("click", function(){
			console.log("변경 확인~~");

			//<form></form> 가상의 폼 데이터를 만들자
			let formData = new FormData();

			//class="form-control clsItems"
			$(".clsItems").each(function(idx, elem){
				console.log("clsItems -> idx : ", idx);
				//<input type="text" class="form-control clsItems" name="itemName" value="개똥이"...
				let name = $(this).attr("name");// itemName, price, description
				let value = $(this).val(); //개똥이 펜슬, 12000, 개똥이 펜슬 좋으다~
			
				formData.append(name, value);
			}); //end each

			//파일들 처리
			//<input type="file" name="uploadFile" placeholder="상품이미지" multiple />
			let fileElement = $("input[name='uploadFile']");
			let files = fileElement[0].files;

			//가상폼인 formData에 각각의 이미지 객체를 넣자
			for(let i =0; i<files.length; i++){
				formData.append("uploadFiles", files[i]);
			}

			//구조분해 형식을 이용
			for(const [key, value] of formData.entries()){
				console.log(key + " : " + value);
			};

			/*아작났어유..피씨다타써
			요청URI : /item/editPostAjax
			요청파라미터 : {itemId=1,itemName=삼성태블릿2,price=120002,description=쓸만함2,uploadFiles=파일객체들}
			요청방식 : post
			*/

			$.ajax({
				url:"/item/editPostAjax",
				processData:false,
				contentType:false,
				data:formData,
				type:"post",
				dataType:"json",
				success:function(result){
					//result{result:1}
					//JSON String -> JSON Object : 키, 값
					console.log("result : ", result);
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
						setTimeout(()=>location.href = '/item/detail?itemId=${itemVO.itemId}', 1000);
						
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
				}
			})

		})// end click
	})
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
	<form action="/item/editPost"
		method="post" enctype="multipart/form-data">
		<input type="hidden" class="form-control clsItems" name="itemId" value="${itemVO.itemId }"/>
		<table>
			<tr>
				<th>상품명</th>
				<td><input type="text" class="form-control clsItems" name="itemName" value="${itemVO.itemName}" required placeholder="상품명"/></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="number" class="form-control clsItems" name="price" value="${itemVO.price }" required placeholder="가격" /></td>
			</tr>		
			<tr>
				<th>상품이미지</th>
				<td>
				<c:forEach var="fileDetail" items="${itemVO.fileGroupVO.fileDetailVOList }">
					<p><img src="/upload${fileDetail.fileSaveLocate}" style="width:50%;"></p>
				</c:forEach>	
				<p/>
				<div id="img"></div>
				<input type="file" name="uploadFile" placeholder="상품이미지" multiple />
				</td>
			</tr>
			<tr>
				<th>개요</th>
				<td>
					<input type="text" class="form-control clsItems" name="description" value="${itemVO.description }" placeholder="개요" />
				</td>
			</tr>
		</table>
		
		<button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
		<a href="/item/detail?itemId=${itemVO.itemId }" class="btn btn-warning">취소</a>
	</form>
	<hr />

	<!-- /// footer.jsp 시작 /// -->
	<%@ include file="../footer.jsp" %>
	<!-- /// footer.jsp 끝 /// -->
	
	
	
</body>
</html>