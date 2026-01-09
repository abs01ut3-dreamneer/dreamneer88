<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../qxinclude/header.jsp"%>

<!-- /// body 시작 /// -->
<div class="jumbotron">
    <!-- container : 이 안에 내용있다 -->
    <div class="container" id="divCarImg"></div>
 </div>

<!-- /// body 시작 /// -->
<div class="row">
   <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">차량 등록</h4>
                <div class="basic-form">
                   <!-- 
                   요청URI : /car/createPost
                   요청파라미터 : request{cusName=개똥이,addr=대전광역시,pne=010-111-2222}
                   요청방식 : post
                    -->
                    <form id="frm" action="/car/createPost" method="post">
                        <div class="form-group">
                            <input type="text" class="form-control input-default"
                               id="carNum" name="carNum" placeholder="자동차 번호" 
                               maxlength="20" />
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control input-default"
                               id="manuf" name="manuf" placeholder="제조사" />
                        </div>
                        <div class="form-group">
                            <input type="number" class="form-control input-default"
                                id="mkyr" name="mkyr" placeholder="연식" />
                        </div>
                        <div class="form-group">
                            <input type="number" class="form-control input-default"
                                id="driDist" name="driDist" placeholder="주행거리" />
                        </div>
                        <div class="form-group">
                            <label>고객 선택</label>
                            <!-- CUS 테이블의 기본키 cusNum 컬럼 -->
                            <select class="form-control" id="cusNum" name="cusNum">
                                <option value="" disabled>고객을 선택해주세요</option>
                                <!-- 반복 시작 -->                                
                                <!-- 반복 끝 -->
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="uploadFile">자동차 사진</label>
                            <input type="file" id="uploadFile" class="form-control-file" 
                               placeholder="자동차 대표 사진 선택" />
                        </div>
                        <button type="submit" class="btn btn-dark" id="btnSubmit">등록</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /// body 끝 /// -->
<!-- /// body 끝 /// -->

<%@ include file="../qxinclude/footer.jsp"%></body>
