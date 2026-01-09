<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <!DOCTYPE html>
        <html>

        <head>

          <title> </title>
          <script type="text/javascript" src="/js/axios.min.js"></script>
          <script>
            //전역함수: 총점, 평균을 계산
            /*
             * @param 숫자 배열
             @return 합계와 평균
             */
            function getSumAndAvg(numbers) {
              //1.합계
              console.log("numbers : ", numbers);

              //reduce(누산기, 현재값)
              const sum = numbers.reduce((acc, cur) => acc + cur, 0);

              //2. 평균 계산
              let count = numbers.length;//6
              let avg = sum / count;

              console.log("avg : ", avg);
              avg = avg.toFixed(2);

              // JSON object로 리턴
              return {
                "sum": sum,
                "avg": avg
              };
            }

            //전역 함수: 학생 상세 정보 확인 모달
            function showStudent() {
              //<td class="tdStudentId" data-student-id="11">11</td>
              //<td class="tdStudentId" data-student-id="12">12</td>
              //<td class="tdStudentId" data-student-id="13">13</td>
              //...
              const studentIds = document.querySelectorAll(".tdStudentId");

              console.log("studentIds.length : " + studentIds.length);
            }

            //전역 함수 (async 키워드 사용)
            // asynchronous(비동기). 해당 함수가 항상 promise를 반환하게 됨
            //          이 함수 내에서 await를 사용할 수 있음
            // await : promise가 해결 될 떄까지 함수의 실행을 일시 중지함
            //        그래서 비동기 코드를 마치 동기 코드처럼 순서대로 읽고 작성할 수 있음
            async function fetchMemberData() {
              // console.log("개똥이");

              //요청URI
              const apiUrl = "/kmeans/kmeansPredict";

              try {
                //1. fetch로 요청을 보내고 응답을 기다림
                const response = await fetch(apiUrl, {
                  method: "POST"
                });

                //2. 응답 상태 확인
                if (!response.ok) {
                  throw new Error(`HTTP 오류! 상태 : \${response.status}`);
                }

                //3. 응답 본문(JSON String)을 JSON Object형식으로 파싱 (deserialize)
                const memberData = await response.json();

                //4. 최종 데이터 처리
                console.log("memberData : ", memberData);

                //6. Object.groupBy() 사용
                //일부 : {"studentId": 1, "x":519, "y":115, clusterID:"1"}
                const clusteredDataNew = Object.groupBy(memberData.clusteredData, (clusteredDataPoint) => {
                  //그룹화할 키 값을 반환
                  return clusteredDataPoint.clusterId;
                });

                //결과확인
                console.log("clusteredDataNew : ", clusteredDataNew);
                //====================수학, 과학 탭
                console.log("clusteredDataNew[0] : ", clusteredDataNew[0]);//수학, 과학
                const clusteredDataMS = clusteredDataNew[0];//tab0

                const divMS = document.querySelector("#clusteredDataMS");

                let strMS = `
        <div class="card">
          <div class="card-body">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>학번</th>
                  <th>이름</th>
                  <th>X 값</th>
                  <th>Y 값</th>
                  <th>추천 계열</th>
                </tr>
              </thead>
              <tbody>`;

                clusteredDataMS.forEach((element) => {
                  strMS += `
                <tr>
                  <td class="tdStudentId" data-student-id="\${element.studentId}" style="cursor:pointer;">\${element.studentId}</td>
                  <td>\${element.studentName}</td>
                  <td>\${element.x}</td>
                  <td>\${element.y}</td>
                  <td>\${element.clusterId}</td>
                </tr>
        `;
                });


                strMS += `</tbody>
            </table>
          </div>
        </div>
        `;


                divMS.innerHTML = "<h2>수학, 과학</h2>" + strMS;
                //====================수학, 과학 탭
                //====================국어, 영어 탭
                console.log("clusteredDataNew[1] : ", clusteredDataNew[1]);//국어, 영어
                const clusteredDataKE = clusteredDataNew[1];//tab1

                const divKE = document.querySelector("#clusteredDataKE");

                let strKE = `
    <div class="card">
      <div class="card-body">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>학번</th>
              <th>이름</th>
              <th>X 값</th>
              <th>Y 값</th>
              <th>추천 계열</th>
            </tr>
          </thead>
          <tbody>`;

                clusteredDataKE.forEach((element) => {
                  strKE += `
            <tr>
    	  	  <td class="tdStudentId" data-student-id="\${element.studentId}" style="cursor:pointer;">\${element.studentId}</td>
              <td>\${element.studentName}</td>
              <td>\${element.x}</td>
              <td>\${element.y}</td>
              <td>\${element.clusterId}</td>
            </tr>
    `;
                });


                strKE += `</tbody>
        </table>
      </div>
    </div>
    `;

                divKE.innerHTML = "<h2>국어, 영어</h2>" + strKE;
                //====================국어, 영어 탭
                //====================한국사, 세계사 탭
                console.log("clusteredDataNew[2] : ", clusteredDataNew[2]);//한국사, 세계사
                const clusteredDataHW = clusteredDataNew[2];//tab2

                const divHW = document.querySelector("#clusteredDataHW");

                let strHW = `
        <div class="card">
          <div class="card-body">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>학번</th>
                  <th>이름</th>
                  <th>X 값</th>
                  <th>Y 값</th>
                  <th>추천 계열</th>
                </tr>
              </thead>
              <tbody>`;

                clusteredDataHW.forEach((element) => {
                  strHW += `
                <tr>
        	  	  <td class="tdStudentId" data-student-id="\${element.studentId}" style="cursor:pointer;">\${element.studentId}</td>
                  <td>\${element.studentName}</td>
                  <td>\${element.x}</td>
                  <td>\${element.y}</td>
                  <td>\${element.clusterId}</td>
                </tr>
        `;
                });


                strHW += `</tbody>
            </table>
          </div>
        </div>
        `;


                divHW.innerHTML = "<h2>한국사, 세계사</h2>" + strHW;
                //====================한국사, 세계사 탭

              } catch (error) {
                //5. 네트워크 오류나 위으 throw된 에러처리
                console.error("데이터를 가져오는 중 오류가 발생했습니다 :", error.message);
              }
            };

            let originSrc;
            //전역 함수
            function handleImgFileSelect(e) {
              console.log("개똥이")
              //1. 이벤트가 발생 된 타겟 안에 들어있는 이미지 파일들을 가져와보자
              let files = e.target.files;

              //2. 이미지가 여러개가 있을 수 있으므로 이미지들을 각각 분리해서 배열로 만듦
              //files : {개똥이.jpg, 개똥삼.jpg, 개똥오.jpg}
              //fileArr : [개똥이.jpg, 개똥삼.jpg, 개똥오.jpg]
              let fileArr = Array.prototype.slice.call(files);
              let str = "";

              originSrc = $("#divProfile").children("img").eq(0).attr("src");
              console.log("check : originSrc => " + originSrc);
              $("#divProfile").html("");

              //3. 파일 타입의 배열 반복. f : 배열 안에 들어있는 각각의 이미지 파일 객체
              fileArr.forEach(elem => {
                //이미지 파일이 아닌 경우 이미지 미리보기 실패 처리(MIME타입)
                if (!elem.type.match("image.*")) {
                  //함수 종료
                  return;
                }//end if

                //이미지 객체를 읽을 자바스크립트의 reader 객체 생성
                let reader = new FileReader();
                //e : reader가 이미지 객체를 읽는 이벤트
                reader.onload = function (e) {
                  //e.target : f(이미지 객체)
                  //e.target.result : reader가 이미지를 다 읽은 결과
                  str = `
        <img class="profile-user-img img-fluid img-circle" src="\${e.target.result}" style="width:100px; height:100px; object-fit:cover; margin:5px;"/>
        `;

                  //마지막 자식 요소로 추가
                  //p 사이에 이미지가 렌더링되어 화면에 보임
                  //객체.append : 누적, .html : 새로고침, .innerHTML : J/S
                  $("#divProfile").append(str);
                }//end onload
                reader.readAsDataURL(elem);

              })//end fileArr

            }// end handleImgFileSelect

            document.addEventListener("DOMContentLoaded", () => {
              //삭제하지
              //<button type="button" id="delete" class="btn btn-danger">정보 삭제</button>
              //버튼 요소 선택
              const btnDelete = document.querySelector("#delete");

              //클릭 이벤트 리스너 등록
              btnDelete.addEventListener("click", function () {

                //삭제 의사 여부 확인
                let chk = confirm("삭제하겠습니까?");//true, false
                console.log("check : btnDelete => chk ", chk);
                if (!chk) { //취소: false

                  //밑의 구문 실행 안함
                  return;
                }
                //어떤 정보를 삭제 할 것인가?
                //<input type="text" .. id="studentId" value="1" readonly="" placeholder="학번">
                let studentId = document.querySelector("#studentId").value;
                console.log("check : studentId => ", studentId);

                //JSON Object
                const data = {
                  "studentId": studentId
                };
                console.log("btnDelete -> data : ", data);

                /* [Axios]
                   Axios는 node.js와 브라우저를 위한 Promise 기반 HTTP 클라이언트 입니다. 
                   그것은 동형 입니다(동일한 코드베이스로 브라우저와 node.js에서 실행할 수 있습니다). 
                   서버 사이드에서는 네이티브 node.js의 http 모듈을 사용하고, 
                   클라이언트(브라우저)에서는 XMLHttpRequests를 사용합니다.
                   
                   [특징]
                   - 브라우저를 위해 XMLHttpRequests 생성
                   - node.js를 위해 http 요청 생성
                   - Promise API를 지원
                   - 요청 및 응답 인터셉트
                   - 요청 및 응답 데이터 변환
                   - 요청 취소
                   - JSON 데이터 자동 변환
                   - XSRF를 막기위한 클라이언트 사이드 지원
                   
                   [변경 내역]
                      1. 달러.ajax({...}) → axios.post(url, data, config) 형태로 간결하게 변경
        
                      2. data: JSON.stringify(data) → axios는 객체를 자동으로 JSON으로 변환하므로 JSON.stringify() 불필요
        
                      3. success: → .then()으로 처리
        
                      4. error 처리는 .catch()에서 담당
                   */

                //axios를 이용한 post 요청
                /*
                   요청URI : /kmeans/deleteFinalTest
                   요청파라미터 : JSONString{studentId=1}
                   요청방식 : post
                   */
                axios.post("/kmeans/deleteFinalTest", data, {
                  headers: {
                    "Content-Type": "application/json;charset=utf-8"
                  }
                })
                  .then(function (response) {
                    //요청 성공 시 응답 데이터 출력
                    //response.data  => 성공 : 1 / 삭제없으면 : 0
                    console.log("result : " + response.data);

                    if (response.data == 1) {//삭제 성공 시 목록URL을 재요청
                      location.href = "/kmeans/kmeansList";
                    } else {
                      alert("삭제 실패!");
                    }
                  })
                  .catch(function (error) {
                    //오류 발생 시 콘솔에 출력
                    console.log("오류발생 : ", error);
                  })
              });

              //변경하기
              //               $("#btnSubmit").on("click", function () {
              document.querySelector("#btnSubmit").addEventListener("click", function () {

                //가상 폼
                let formData = new FormData();

                // $(".clsStud").each(function(idx, obj){
                const studnetElements = document.querySelectorAll(".clsStud");

                studnetElements.forEach(function (obj, idx) {
                  // let id = $(this).prop("id");
                  let id = obj.id;
                  // let value = $(this).val();
                  let value = obj.value;

                  console.log("idx : " + idx + ", id : " + id + ", value:" + value);

                  //append: 마지막 자식 요소로 추가
                  /*
                    <form>
                      <input type="text" name="studentId" value="10" />
                      <input type="text" name="studentName" value="한지우" />
                    <form>
                  */
                  formData.append(id, value);
                });
                //<input type="file" class="custom-file-input" id="uploadFiles" multiple="" style="width:300px;">
                let inputImgs = $("#uploadFiles");
                //이미지 파일들을 꺼내보자
                let files = inputImgs[0].files;  //개똥이1.jpg,개똥이2.jpg,개똥이3.jpg
                //가상폼인 formData에 각각의 이미지를 넣자
                for (let i = 0; i < files.length; i++) {
                  formData.append("uploadFiles", files[i]); //i번째 파일객체
                }

                //formData 확인하기
                for (const [key, value] of formData.entries()) {
                  console.log(`\${key} : \${value}`);
                }

                $.ajax({
                  url: "/kmeans/updateFinalTest",
                  processData: false,
                  contentType: false,
                  data: formData, // 요청 데이터 기억하자!!!
                  type: "post",
                  dataType: "text", // 응답 데이터 기억하자!!! 틀리지마!!
                  success: function (result) {
                    console.log("result : ", result);

                    if (result == 1) {
                      // var Toast = Swal.mixin({
                      //     toast: true,
                      //     position: 'top-end',
                      //     showConfirmButton: false,
                      //     timer: 3000
                      // });
                      // Toast.fire({
                      //     icon: 'success',
                      //     title: '변경 성공!'
                      // });

                      // 일반 모드 -> 가려짐
                      document.querySelector("#div1").style.display = 'flex';

                      // 변경모드 -> 보임
                      document.querySelector("#div2").style.display = "none";
                      document.querySelector("#div3").style.display = "none";

                      //입력란의 readonly를 추가
                      //<input type="text" class="form-control clsStud" ..  placeholder="이름">
                      // $(".clsStud").attr("readonly", "readonly");
                      const asd = document.querySelectorAll(".clsStud");

                      asd.forEach(e => {
                        e.setAttribute("readonly", "readonly");

                        // console.log("check: e.hasAttribute(readonly) =>", e.hasAttribute("readonly"));
                      })
                    }
                  }
                });
              });


              //프로필 이미지 미리보기
              //<input type="file" class="custom-file-input" id="uploadFiles" multiple="" style="width:300px;">
              //  $("#uploadFiles").on("change",handleImgFileSelect);
              $(document).on("change", "#uploadFiles", handleImgFileSelect);

              //함수 호출
              fetchMemberData();

              //첫 로딩 시 없던 엘리먼트에 접근 시 달러(document)를 사용함
              //   $(document).on("click", ".tdStudentId", function(){
              // 	let studentId = $(this).data("studentId");
              // 	console.log("studentId: ", studentId);
              //   })

              // 변경 버튼 클릿 -> 변경 모드로 전환
              // <button type="button" id="edit"..>
              document.querySelector("#edit").addEventListener("click", function () {

                // 일반 모드 -> 가려짐
                document.querySelector("#div1").style.display = 'none';

                // 변경모드 -> 보임
                document.querySelector("#div2").style.display = "flex";

                //<input type="file" .. id="uploadFiles" multiple />.. -> 보임
                document.querySelector("#div3").style.display = "flex";

                //입력란의 readonly를 제거
                //<input type="text" class="form-control clsStud" .. readonly="" placeholder="이름">
                //       $(".clsStud").removeAttr("readonly");

                // 클래스가 "clsStud"인 모든 요소를 선택합니다. (NodeList 반환)
                const studInputs = document.querySelectorAll(".clsStud");
                // 선택된 각 요소에 대해 반복을 수행합니다.
                studInputs.forEach(elem => {

                  // 요소에서 "readonly" 속성을 제거합니다.
                  elem.removeAttribute("readonly");

                  // (선택 사항) 해당 요소의 readonly 상태가 제거되었는지 콘솔로 확인
                  // console.log("check : elem.attributes =>", elem.attributes);
                })
              });

              //취소 버튼 클릭 -> 일반 모드로 전환
              // <button type="button" id="btnCancel"..>
              document.querySelector("#btnCancel").addEventListener("click", function () {
                // 일반 모드 -> 가려짐
                document.querySelector("#div1").style.display = 'flex';

                // 변경모드 -> 보임
                document.querySelector("#div2").style.display = "none";
                document.querySelector("#div3").style.display = "none";

                //입력란의 readonly를 추가
                //<input type="text" class="form-control clsStud" ..  placeholder="이름">
                // $(".clsStud").attr("readonly", "readonly");
                const asd = document.querySelectorAll(".clsStud");

                asd.forEach(e => {
                  e.setAttribute("readonly", "readonly");

                  // console.log("check: e.hasAttribute(readonly) =>", e.hasAttribute("readonly"));
                })

                //프로필 이미지 되돌리기
                str = `
         <img class="profile-user-img img-fluid img-circle" src="\${originSrc}" style="width:100px; height:100px; object-fit:cover; margin:5px;" />
      `;

                //마지막 자식 요소로 추가
                $("#divProfile").html(str);

              });

              //첫 로딩시 없던 엘리먼트에 접근 시 상위 요소인 document에 이벤트를 위임한
              document.addEventListener("click", function () {
                // console.log("개똥이!");
                //event.target(클릭된 요소)이 ".tdStudentId"클래스를 가지고 있는가?
                //closest: 현재 요소 + 가장 가까운 상위 요소 중에 지정한 선택자와 일치하고 있는 요소를 선택
                const clickedElement = event.target.closest(".tdStudentId");

                if (!clickedElement) {//null
                  return;
                }

                console.log("clickedElement : ", clickedElement);

                let studentId = clickedElement.dataset.studentId;
                console.log("studentId : ", studentId);

                //fetch API를 사용하여 post요청을 보내보자
                //JSON Object
                let data = {
                  "studentId": studentId
                };
                console.log("data : ", data);

                //JSON.stringify(data) : JSON Object를 JSON String으로 serialize
                //response.json() : JSON String을 JSON Object로 변환 deserialize
                fetch("/kmeans/getFinalTest", {
                  method: "post",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify(data)
                })
                  .then(response => response.json())
                  .then(data => { //바뀌는걸 데이터에 넣고 찍어보기
                    console.log("data : ", data);
                    //                     console.log("koreanScore : ", data.koreanScore);
                    //data{"studentId": 12,"studentName": "김태민",
                    //"koreanScore": 55,"englishScore": 62,
                    //"mathScore": 88,"scienceScore": 90,
                    //"historyKr": 60,"historyWorld": 58,
                    //"colx": 0,"coly": 0,"clusterDataPoint": null}
                    // 			let tot = data.koreanScore+data.englishScore+data.mathScore+data.scienceScore+data.historyKr+data.historyWorld;
                    // 			console.log("tot : ", tot);
                    // 			let avg = tot/6;
                    // 			avg = avg.toFixed(2);
                    // 			console.log("avg : ", avg);
                    //점수 배열 생성
                    let numbers = [];
                    //배열 맨 뒤에 추가 [62]
                    numbers.push(data.englishScore);
                    //배열 맨 앞에 추가 [55. 62]
                    numbers.unshift(data.koreanScore);
                    //인덱스 1 위치(62)에 가서 88, 90 추가
                    //0개를 삭제 (삭제 없음) [55, 88, 90, 62]
                    numbers.splice(1, 0, data.mathScore, data.scienceScore);

                    let newNumber = data.historyKr;
                    //새 배열을 만들어서 기존 요소
                    let numbersNew = [...numbers, newNumber];
                    numbersNew.push(data.historyWorld);
                    console.log("check : numbersNew =>", numbersNew);

                    let results = getSumAndAvg(numbersNew);
                    console.log("check : results => ", results);
                    let str = `
				<div class="card card-primary">
				  <form>
				   <div class="card-body">
				     <div class="form-group">
				      <div class="text-center" id="divProfile" style="margin:5px;">
				        `;
                    //data                         : finalTestVO (1)
                    //data.fileGroupVO                : fileGroupVO (1)
                    //data.fileGroupVO.fileDetailVOList   : List<FileDetailVO> (N)
                    if (data.fileGroupVO == null) {
                      str += `<img class="profile-user-img img-fluid img-circle" 
                      			style="width:100px; height:100px; object-fit:cover; margin:5px;" 
                      			src="/upload/noimage.jpg" alt="User profile picture">`;
                    } else {
                      $.each(data.fileGroupVO.fileDetailVOList, function (idx, fileDetailVO) {
                        str += `<img class="profile-user-img img-fluid img-circle" 
                        style="width:100px; height:100px; object-fit:cover; margin:5px;" 
                        src="/upload\${fileDetailVO.fileSaveLocate}" alt="User profile picture">`;
                      });//end each
                    }
                    str += `
               </div>
               <div class="input-group" id="div3" style="display: none;">
                  <div class="custom-file">
                    <input type="file" class="custom-file-input" id="uploadFiles" multiple>
                    <label class="custom-file-label" for="uploadFiles">Choose file</label>
                  </div>
                </div>
				     </div>     
				     <div class="form-group">
				      <label for="studentId">학번</label>
				      <input type="email" class="form-control clsStud" id="studentId" 
				      value="\${data.studentId}" readonly placeholder="학번">
				     </div>     
				     <div class="form-group">
				      <label for="studentName">이름</label>
				      <input type="email" class="form-control clsStud" id="studentName" 
				    	  value="\${data.studentName}" readonly placeholder="이름">
				     </div>     
				     <div class="form-group">
				      <label for="koreanScore">국어점수</label>
				      <input type="email" class="form-control clsStud" id="koreanScore" 
				    	  value="\${data.koreanScore}" readonly placeholder="국어점수">
				     </div>     
				     <div class="form-group">
				      <label for="englishScore">영어점수</label>
				      <input type="email" class="form-control clsStud" id="englishScore"
				    	  value="\${data.englishScore}" readonly placeholder="영어점수">
				     </div>     
				     <div class="form-group">
				      <label for="mathScore">수학점수</label>
				      <input type="email" class="form-control clsStud" id="mathScore"
				    	  value="\${data.mathScore}" readonly placeholder="수학점수">
				     </div>     
				     <div class="form-group">
				      <label for="scienceScore">과학점수</label>
				      <input type="email" class="form-control clsStud" id="scienceScore"
				    	  value="\${data.scienceScore}" readonly placeholder="과학점수">
				     </div>     
				     <div class="form-group">
				      <label for="historyKr">한국사점수</label>
				      <input type="email" class="form-control clsStud" id="historyKr"
				    	  value="\${data.historyKr}" readonly placeholder="한국사점수">
				     </div>     
				     <div class="form-group">
				      <label for="historyWorld">세계사점수</label>
				      <input type="email" class="form-control clsStud" id="historyWorld"
				    	  value="\${data.historyWorld}" readonly placeholder="세계사점수">
				     </div>     
				     <div class="form-group">
				      <label for="tot">총점</label>
				      <input type="email" class="form-control clsStud" id="tot" value="\${results.sum}"
				      readonly placeholder="총점">
				     </div>     
				     <div class="form-group">
				      <label for="avg">평균</label>				      
				      <input type="email" class="form-control clsStud" id="avg" value="\${results.avg}"
				      readonly placeholder="평균">
				     </div>     
				  </form>
				</div>
			`;

                    // <div class="modal-body" id="modalBdy"><p></p></div>
                    let modalBdy = document.querySelector("#modalBdy");
                    modalBdy.innerHTML = str;
                  })
                  .catch(error => {
                    console.log("error : ", error);
                  });


                //학생 상세 정보 모달 띄우기
                //<div class="modal fade" id="modalStudent">
                //1. JQuery
                //$("#modalStudent").modal("show");

                //2. vanillaJS
                const modalStudent = document.querySelector("#modalStudent");
                const myModal = new bootstrap.Modal(modalStudent);
                myModal.show();
              });

            });
          </script>
        </head>

        <body>
          <%@ include file="../menu.jsp" %>

            <div class="jumbotron">
              <div class="container">
                <h1 class="display-3">공부 고수들</h1>
              </div>
            </div>
            <!--/// body /// -->
            <div class="row">
              <div class="col-md-12">
                <div class="card card-primary card-tabs">
                  <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                      <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill"
                          href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home"
                          aria-selected="true">Home</a>
                      </li>
                      <li class="nav-item">
                        <a class="nav-link" id="clusteredDataMS-tab" data-toggle="pill" href="#clusteredDataMS"
                          role="tab" aria-controls="clusteredDataMS" aria-selected="false">이공계열</a>
                      </li>
                      <li class="nav-item">
                        <a class="nav-link" id="clusteredDataKE-tab" data-toggle="pill" href="#clusteredDataKE"
                          role="tab" aria-controls="clusteredDataKE" aria-selected="false">문과계열</a>
                      </li>
                      <li class="nav-item">
                        <a class="nav-link" id="clusteredDataHW-tab" data-toggle="pill" href="#clusteredDataHW"
                          role="tab" aria-controls="clusteredDataHW" aria-selected="false">공무계열</a>
                      </li>
                    </ul>
                  </div>
                  <div class="card-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                      <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel"
                        aria-labelledby="custom-tabs-one-home-tab">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin malesuada lacus ullamcorper dui
                        molestie, sit amet congue quam finibus. Etiam ultricies nunc non magna feugiat commodo. Etiam
                        odio magna, mollis auctor felis vitae, ullamcorper ornare ligula. Proin pellentesque tincidunt
                        nisi, vitae ullamcorper felis aliquam id. Pellentesque habitant morbi tristique senectus et
                        netus et malesuada fames ac turpis egestas. Proin id orci eu lectus blandit suscipit. Phasellus
                        porta, ante et varius ornare, sem enim sollicitudin eros, at commodo leo est vitae lacus. Etiam
                        ut porta sem. Proin porttitor porta nisl, id tempor risus rhoncus quis. In in quam a nibh cursus
                        pulvinar non consequat neque. Mauris lacus elit, condimentum ac condimentum at, semper vitae
                        lectus. Cras lacinia erat eget sapien porta consectetur.
                      </div>
                      <div class="tab-pane fade" id="clusteredDataMS" role="tabpanel"
                        aria-labelledby="clusteredDataMS-tab">

                      </div>
                      <div class="tab-pane fade" id="clusteredDataKE" role="tabpanel"
                        aria-labelledby="clusteredDataKE-tab">

                      </div>
                      <div class="tab-pane fade" id="clusteredDataHW" role="tabpanel"
                        aria-labelledby="clusteredDataHW-tab">

                      </div>
                    </div>
                  </div>
                  <!-- /.card -->
                </div>
              </div>

            </div>
            <!-- /// 학생 상세 정보 모달 시작 /// -->
            <div class="modal fade" id="modalStudent">
              <div class="modal-dialog modal-lg">
                <div class="modal-content">
                  <div class="modal-header">
                    <h4 class="modal-title">학생 성적 정보</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body" id="modalBdy">
                    <p></p>
                  </div>
                  <!-- // 일반 모드 시작-->
                  <div id="div1" class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                    <button type="button" id="edit" class="btn btn-warning">정보 변경</button>
                    <button type="button" id="delete" class="btn btn-danger">정보 삭제</button>
                  </div>
                  <!-- // 일반 모드 끝-->
                  <!-- //변경 모드 시작-->
                  <div id="div2" class="modal-footer justify-content-between" style="display: none;">
                    <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                    <button type="button" id="btnSubmit" class="btn btn-primary">확인</button>
                    <button type="button" id="btnCancel" class="btn btn-danger">취소</button>
                  </div>
                  <!-- //변경 모드 끝-->
                </div>
              </div>
            </div>
            <!-- /// 학생 상세 정보 모달 끝 /// -->
            <!-- /// body /// -->
            <%@ include file="../footer.jsp" %>
        </body>

        </html>