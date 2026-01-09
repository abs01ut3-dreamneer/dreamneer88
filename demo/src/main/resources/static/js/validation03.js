/**
 * 
 */

//전역함수
function test() {
	document.querySelector(".ck-blurred").addEventListener("keydown", () => {
		console.log("str : " + window.editor.getData());
		// 		document.querySelector("#comment").value = window.editor.getData();
	});
	document.querySelector(".ck-blurred").addEventListener("focusout", () => {
		document.querySelector("#description").value = window.editor.getData();
	});
}

function checkAddProduct() {
	document.newProduct.submit(); //document에서 form 이름으로 바로 접근
}

document.addEventListener("DOMContentLoaded", () => {

	ClassicEditor.create(document.querySelector("#descriptionTemp"), { ckfinder: { uploadUrl: '/image/upload' } })
		.then(editor => window.editor = editor)
		.then(test)
		.catch(err => console.log(err.stack));

	const newProduct = document.querySelector("form[name='newProduct']");

	newProduct.addEventListener("submit", (e) => {
		e.preventDefault();

		//<input type="text" id="productId" name="productId" />
		let productId = document.querySelector("#productId");
		//<input type="text" id="name" name="name" />
		let pname = document.querySelector("#pname");
		let unitPrice = document.getElementById("unitPrice");
		let unitsInStock = document.getElementById("unitsInStock");

		//상품 아이디 체크.   
		//1) 첫글자는 P.  2) 숫자를 조합하여 5~12자까지 입력 가능
		//i) P1234 => if(!true) => if(false) => if문을 건너뜀
		//ii) S1234 => if(!false) => if(true) => if문을 수행
		let regExpProductId = /^P[0-9]{4,11}$/;

		if (!regExpProductId.test(productId.value)) {
			alert("[상품코드]\nP와 숫자를 조합하여 5~12자까지 입력하세요\n첫글자는 반드시 P로 시작하세요");
			productId.select();
			return false;
		}

		//상품명 체크
		//4~12자까지 입력 가능
		//ex)name.value : 삼성갤러시S22
		let regExpPname = /^[가-힣a-zA-Z0-9\s]{4,12}$/;

		if (!regExpPname.test(pname.value)) {
			alert("[상품명]\n최소 4자에서 최대 12자까지 입력하세요");
			pname.select();
			return false;
		}

		//상품 가격 체크
		//숫자만 입력 가능
		//ex) unitPrice.value : 1200000
		// let regExpUnitPrice = /^[0-9]+$/;

		// if (!regExpUnitPrice.test(unitPrice.value)) {
		//    alert("[가격]\n숫자만 입력하세요");
		//    unitPrice.select();
		//    return false;
		// }


		//ex) unitPrice.value : -1200000 막아보자
		if (unitPrice.value < 0) {
			alert("[가격]\n음수는 입력할 수 없습니다.");
			unitPrice.select();
			unitPrice.focus();
			return false;
		}

		//ex) unitPrice.value : 1200000.1234982174092837 => 1200000.35
		//?:이 뭔지 고민해보자 => spring VO에서 어노테이션으로 자동 처리
		//i) 1200000.35 => if(!true) => if(false) => 함수를 통과
		//ii) 1200000.357 => if(!false) => if(true) => 함수를 멈춤
		//소수점 둘째짜리까지만 입력하세요.
		let regExpUnitPrice2 = /^\d+(?:[.]?[\d]?[\d])?$/; //==> let regExpUnitPrice2 = /^\d+(\.\d{1,2})?$/; 이렇게 바꿔 쓸수 있음 .은 임의의 한 글자이니까 \.으로 마침표 표시

		if (!regExpUnitPrice2.test(unitPrice.value)) {
			alert("[가격]\n소수점 둘째자리까지 허용합니다");
			unitPrice.select();
			unitPrice.focus();
			return false;
		}

		let regExpUnitsInStoce = /^[0-9]+$/;

		//재고 수 체크
		//숫자만 입력 가능
		//isNaN : 이거숫자니? 
		if (unitsInStock.value == 0 || isNaN(unitsInStock.value)) {
			alert("[재고]\n숫자만 입력하세요");
			unitsInStock.select();
			unitsInStock.focus();
			return false;
		}

		newProduct.submit();

	});

});