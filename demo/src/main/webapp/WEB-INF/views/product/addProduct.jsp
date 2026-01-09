<%@ page language="java" contentType="text/html; charset=UTF-8" %>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
         <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html>

            <head>
               <script type="text/javascript" src="/ckeditor5/ckeditor.js"></script>
               <link type="text/css" rel="stylesheet" href="/ckeditor5/sample/css/sample.css" />
               <title> </title>

               <script type="text/javascript" src="/js/validation03.js"></script>

            </head>

            <body>
               <%@ include file="./menu.jsp" %>

                  <div class="jumbotron">
                     <div class="container">
                        <h1 class="display-3">상품 등록</h1>
                     </div>
                  </div>
                  <!--/// body /// -->
                  <!-- -------------- 상품 등록 시작 ------p.203----------------- -->
                  <!-- 내용 -->
                  <div class="container">
                     <!-- 
   요청URI : /product/processAddProduct
   요청파라미터 : request{productId=P1234,pname=삼성노트북..}
   요청방식 : post
    -->

                     <form name="newProduct" action="<%=request.getContextPath()%>/product/processAddProduct"
                        class="form-horizontal" method="post">
                        <div class="form-group row">
                           <label class="col-sm-2">상품 코드</label>
                           <div class="col-sm-3">
                              <input type="text" id="productId" name="productId" class="form-control" />
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">상품명</label>
                           <div class="col-sm-3">
                              <input type="text" id="pname" name="pname" class="form-control" />
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">가격</label>
                           <div class="col-sm-3">
                              <input type="number" id="unitPrice" name="unitPrice" class="form-control" />
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">상세 정보</label>
                           <div class="col-sm-3">
                              <div id="descriptionTemp"></div>
                              <textarea rows="5" cols="30" id="description" name="description" class="form-control"
                                 style="display:none;"></textarea>
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">제조사</label>
                           <div class="col-sm-3">
                              <input type="text" name="manufacturer" class="form-control" />
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">분류</label>
                           <div class="col-sm-3">
                              <select id='category' name='category' class="form-control">
                                 <option value="" selected disabled>선택해주세요</option>
                                 <option value="Smart Phone">Smart Phone</option>
                                 <option value="Notebook">Notebook</option>
                                 <option value="Tablet">Tablet</option>
                              </select>
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">제고수</label>
                           <div class="col-sm-3">
                              <input type="number" id="unitsInStock" name="unitsInStock" class="form-control" />
                           </div>
                        </div>
                        <div class="form-group row">
                           <label class="col-sm-2">상태</label>
                           <div class="col-sm-5">
                              <input type="radio" id="condition1" name="condition" value="New" />
                              <label for="conditon1">신규 제품</label>
                              <input type="radio" id="condition2" name="condition" value="Old" />
                              <label for="condition2">중고 제품</label>
                              <input type="radio" id="condition3" name="condition" value="Refurbished" />
                              <label for="condition3">재생 제품</label>
                           </div>
                        </div>
                        <div class="form-group row">
                           <div class="col-sm-offset-2 col-sm-10">
                              <!-- checkAddProduct() : 핸들러 함수-->
                              <input type="submit" class="btn btn-primary" value="등록" />
                              <a href="/product/products" class="btn btn-info">목록보기</a>
                           </div>
                        </div>
                     </form>
                  </div>
                  <!-- -------------- 상품 등록 끝 ----------------------- -->
                
                  <!-- /// body /// -->
                  <%@ include file="./footer.jsp" %>
            </body>

            </html>