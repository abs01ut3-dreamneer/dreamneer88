/**
 * 
 */

document.addEventListener("DOMContentLoaded",()=>{
    const frm = document.querySelector("form[name='Member']");
   //<input type="submit" value="가입하기" />
   //submit(버튼 클릭 시 submit 이벤트가 발생)
   frm.addEventListener("submit",(event)=>{
      //폼 제출 동작을 막음
      event.preventDefault();
      //<input type="text" name="id" />
      let id = document.querySelector("input[name='id']");
      //<input type="password" name="passwd" />
      let passwd = document.querySelector("input[name='passwd']");
      //<input type="text" name="name" />
      let name = document.querySelector("input[name='name']");
      //<select name="phone1"..
      let phone1 = document.querySelector("select[name='phone1']");
      let phone2 = document.querySelector("input[name='phone2']");
      let phone3 = document.querySelector("input[name='phone3']");

      let email = document.querySelector("input[name='email']");
      //JSON Object
      let data = {
         "id":id.value,
         "passwd":passwd.value,
         "name":name.value,
         "phone1":phone1.value,
         "phone2":phone2.value,
         "phone3":phone3.value,
         "email":email.value
      };
      //                   오브젝트 값 확인 시 ,(쉼표)를 써야한다. 
      console.log("data : ", data);

      //아이디는 문자로 시작
      let regExpId = /^[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;   
        //이름은 한글만 입력. 웃음으로 시작하여 돈으로 끝나자
      //+ : 1 이상(필수), * : 0 이상(선택)
      let regExpName = /^[가-힣]+$/;
        //비밀번호는 숫자만 입력
      let regExpPasswd = /^[0-9]+$/;
        //연락처 형식 준수(010-111-2222, 010-1111-2222)
        //{3} : 딱 3회, {3,4} : 3이상 4이하
      let regExpPhone = /^\d{3}-\d{3,4}-\d{4}$/;   
        //이메일 형식 준수(02test-_\.02test@naver-_\..com(kr))
        //i : ignore(대소문자 구분 안함)
      //역슬러시. : 문자. 
         
      let regExpEmail 
      = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

      //data : JSON Object
        //{"id": "a001","passwd": "java","name": "개똥이","phone1": "010","phone2": "1235",
        //   "phone3": "6780","email": "sangsikmom@gmail.com"}
      //아이디는 문자로 시작
      if(!regExpId.test(data.id)){
         alert("아이디는 문자로 시작해주세요");
         frm.id.select();
         return;
      }
        //이름은 한글만 입력
        if(!regExpName.test(data.name)){
         alert("이름은 한글만 입력해주세요");
         return;
       }
        //비밀번호는 숫자만 입력
        if(!regExpPasswd.test(data.passwd)){
         alert("비밀번호는 숫자만 입력해주세요");
         return;
      } 
        //연락처 형식 준수(010-111-2222, 010-1111-2222)
      let phone = data.phone1 + "-" + data.phone2 + "-" + data.phone3;
      console.log("phone : ", phone);
      
      //JSON 오브젝트인 data 오브젝트에 phone이라는 키와 값을 추가
      data.phone = phone;

        if(!regExpPhone.test(data.phone)){
         alert("연락처를 확인해주세요");
         return;
      } 
        //이메일 형식 준수(02test-_\.02test@naver-_\..com(kr))
        if(!regExpEmail.test(data.email)){
         alert("이메일을 확인해주세요");
         return;
      } 
        
      console.log("data : ", data);
        //유효성검사 통과
      });

   });