<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../qxinclude/header.jsp"%>

<!-- /// body 시작 /// -->
<div class="row">
   <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">고객 등록</h4>
                <div class="basic-form">
                    <!-- 
                    	요청URI: /cus/createPost
                    	요청파라미터: request{cusName=개똥이, addr=대전, pne=010-111-2222}
                    	방식: post
                    	
                    	private String cusName;
						private String addr;
						private String pne;
                     -->                    
                    <form action="/cus/createPost" method="post" >
                        <div class="form-group">
                            <input type="text" class="form-control input-default" 
                            id="cusName" name="cusName" placeholder="고객명">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control input-default" 
                            id="addr" name="addr" placeholder="주소">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control input-default" 
                            id="pne" name="pne" placeholder="연락처">
                        </div>
                        <button type="submit" class="btn btn-dark" id="btnSubmit">등록</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /// body 끝 /// -->

<%@ include file="../qxinclude/footer.jsp"%></body>
