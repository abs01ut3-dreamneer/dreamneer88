<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/ckeditor5/ckeditor.js"></script>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<link type="text/css" rel="stylesheet" href="/ckeditor5/sample/css/sample.css"/>
<title> </title>

</head>
<body>
<%@ include file="./menu.jsp"%>

<div class="jumbotron">
	<div class="container">
		<h1 class="display-3">title</h1>
	</div>
</div>
<!--/// body /// -->
<h3>회원 가입</h3>
<!-- 
	요청URL: /request/form01Post
	요청파라미터: request{id=a001, password=java, name=개똥이, phone1=010,phone2=1234,phone3=1234,
					gender=male, hobby=read,movie, city=city01, food=ddeukboki,kmichijjigae}
	요청방식: post
 -->
   <form action="/request/form01Post" name="member" method="post">
      <p>
         아이디 : <input type="text" name="id" />
         <input type="button" value="아이디 중복 검사" />
      </p>
      <p>비밀번호 : <input type="password" name="password" /></p>
      <p>이름 : <input type="text" name="name" /></p>
      <p>
         연락처 : <input type="text" maxlength="4" size="4" name="phone1" />
         - <input type="text" maxlength="4" size="4" name="phone2" />
         - <input type="text" maxlength="4" size="4" name="phone3" />
      </p>
      <p>
         성별 : <input type="radio" name="gender" value="male" checked />남성
              <input type="radio" name="gender" value="female" />여성
      </p>
      <p>
      <!-- 
      	CKEditor5 : 텍스트를 편집할 수 있게 해주는 자바스크립트 기반의 오픈 소소 위지위그(WYSIWYG) 리치 텍스트 편집기
      	WYSIWYG = what you see is what you get
      	ex) summernote
       -->
       	<div id="commentTemp"></div>
      	<textarea rows="3" cols="30" name="comment" id="comment" placeholder="가입인사"></textarea>
      </p>
      <p>
         취미 : 독서<input type="checkbox" name="hobby" value="read"checked />
         운동<input type="checkbox" name="hobby" value="exercise"/>
         영화<input type="checkbox" name="hobby" value="movie"/>
      </p>
      <p>
         <!-- p.190 -->
         <!-- size속성 : 해당 개수대로 미리 보여줌 -->
         <select name="city" size="3">
            <option value="city01">대전광역시</option>
            <option value="city02">서울</option>
            <option value="city03">경기</option>
            <option value="city04">인천</option>
            <option value="city05">충청</option>
            <option value="city06">전라</option>
            <option value="city07">경상</option>
         </select>
      </p>
      <p>
      <!-- select에서 multiple은 다중 선택 가능 속성 -->
         <select name="food" multiple>
            <optgroup label="분식류">
               <option value="ddeukboki">떡볶이</option>
               <option value="sundai">순대</option>
            </optgroup>
            <optgroup label="안주류">
               <option value="oddolpyeo">오돌뼈</option>
               <option value="odaengtang">오뎅탕</option>
            </optgroup>
            <optgroup label="찌개류"><!-- 이거 신기하다!! 잘 기억하자! -->
               <option value="kmichijjigae">김치찌개</option>
               <option value="doinjangjjigae">된장찌개</option>
            </optgroup>
         </select>
      </p>
      <p>
         <input type="submit" value="가입하기" />
         <input type="reset" value="다시 쓰기" />
         <button type="button" id="autoFill">자동입력</button>
      </p>
   </form>
   <script type="text/javascript">
	//document의 모든 엘리먼트들이 로딩된 후에 실행
	// 	$(function(){
		document.addEventListener("DOMContentLoaded", ()=>{
			ClassicEditor.create(
					//<div id="commentTemp"></div>
					document.getElementById("commentTemp"),{ckfinder:{uploadUrl:'/image/upload'}})
					.then(editor=>{window.editor=editor})
					.then(test)
					.catch(err=>{console.log(err.stack)})
			document.querySelector("#autoFill").addEventListener("click", ()=>{
				console.log("자동입력");
				//<input type="text" name="id"
				document.querySelector("input[name='id']").value="a001";
				//<input type="password" name="passwd">
				document.querySelector("input[name='password']").value="java";
				//<input type="text" name="name">
				document.querySelector("input[name='name']").value="개똥이"; 
				document.querySelector("input[name='phone1']").value="010"; 
				document.querySelector("input[name='phone2']").value="2727"; 
				document.querySelector("input[name='phone3']").value="7272";  
				
				//<input type="radio" name="gender" value="male" checked />남성
				// 기억하기
// 					$("input[name='gender'][value='female']").prop("checked", true); 
				document.querySelector("input[name='gender'][value='female']").checked=true;
				
				let temp = "";
// 				$.each($("input[name='hobby']"),function(obj, ind){
// 					temp = $(this).val();
// 					if(temp=="read"){
// 						$(this).prop("checked", true);
// 					}
// 					if(temp=="movie"){
// 						$(this).prop("checked", true);
// 					}
// 				});
				const hobbies = document.querySelectorAll("input[name='hobby']");
				hobbies.forEach(function(hobby, index){
					temp=hobby.value;
					if(temp==="read"||temp==="movie"){
						hobby.checked = true;
					}
				});
				
				//<textarea rows="3" cols="30" name="comment" id="comment" placeholder="가입인사"></textarea>
				// 기억하기
				document.querySelector("#comment").innerHTML="<p>랄랄랄랄라라 즐거운 코딩~</p>";
				
				//<select name="city" size="3">
				// 기억하기
				document.querySelector("select[name='city']").value='city01';
	           
				//<select name="food" multiple="">
// 	           	$.each($("select[name='food'] option"), function(obj, index){
// 					// this : select 엘리먼트의 자식 엘리먼트인 option이 여러개이므로
// 					// 반복하는 가운데 포커스된 바로 그 option 엘리먼트
// 					if($(this).val()=="ddeukboki"||$(this).val()=="odaengtang"){
// 						$(this).prop("selected", true)
// 					}
// 				})
				
				const foods = document.querySelectorAll("select[name='food'] option");
				foods.forEach(function(food, index){
					if(food.value==="ddeukboki"||food.value==="odaengtang"){
						food.selected = true;
					}
				});
				
			});
		});
		function test(){
			document.querySelector(".ck-blurred").addEventListener("keydown",()=>{
				console.log("str : "+ window.editor.getData());
// 				document.querySelector("#comment").value = window.editor.getData();
			});
			document.querySelector(".ck-blurred").addEventListener("focusout",()=>{
				document.querySelector("#comment").value = window.editor.getData();
			});
		}
	// 	});//end function
	</script>
<!-- /// body /// -->
<%@ include file="./footer.jsp"%>

</body>
</html>