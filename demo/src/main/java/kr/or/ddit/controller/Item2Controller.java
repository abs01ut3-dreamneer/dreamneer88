package kr.or.ddit.controller;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.config.BeanController;
import kr.or.ddit.service.Item2Service;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.Item2VO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/item2")
public class Item2Controller {

	// DI(의존성 주입) -> 메소드(getUploadFoler())를 사용할 수 있음
	@Autowired
	BeanController beanController;

	// 파일 업로드 유틸 DI
	@Autowired
	UploadController uploadController;

	@Autowired
	Item2Service item2Service;

	/*
	 * 요청URI: /item/register 요청파라미터: 요청방식: get
	 */
	@GetMapping("/register")
	public String register() {
		// forwarding: jsp 응답
		return "item2/register";
	}

	/*
	 * 요청URI : /item2/registerPost 요청파라미터 :
	 * {itemName=삼성태블릿,price=120000,description=쓸만함
	 * ,uploadFile=파일객체,uploadFile2=파일객체2} 요청방식 : post
	 */
//	@ResponseBody
	@PostMapping("/registerPost")
	public String registerPost(Item2VO item2VO) {
		log.info("check: item2VO, uploadFile => {}, {} ", item2VO);
		// Item2VO에 직접 파일을 직접 받아오는 방법!!!!!!!!

		// 연월일 폴더 생성 설계
		// 연월일 폴더 생성 실행
		File uploadPath = new File(this.beanController.getUploadFolder(), this.beanController.getFolder());

		// 연월일 폴더가 없으면 폴더 생성해주자
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}

		// 스프링 파일객체의 파일명 꺼내기
		MultipartFile multipartFile = item2VO.getUploadFile();
		String uploadFileName = multipartFile.getOriginalFilename();
		log.info("check : uploadFileName => {}", uploadFileName);

		MultipartFile multipartFile2 = item2VO.getUploadFile2();
		String uploadFileName2 = multipartFile2.getOriginalFilename();
		log.info("check : uploadFileName => {}", uploadFileName2);

		// 같은 날 같은 이미지 업로드 시 파일 중복 방지 시작////////
		// java.util.UUID => 랜덤값 생성
		UUID uuid = UUID.randomUUID();
		UUID uuid2 = UUID.randomUUID();

		// 원래의 파일 이름과 구분하기 위해 _를 붙임(asdflkjs_개똥이.jpg)
		uploadFileName = uuid.toString() + "_" + uploadFileName;
		uploadFileName2 = uuid2.toString() + "_" + uploadFileName2;

		// 같은 날 같은 이미지 업로드 시 파일 중복 방지 끝////////

		// 파일 복사 설계
		// , : \\ (파일 세퍼레이터)
		//
		File saveFile = new File(uploadPath, uploadFileName);
		File saveFile2 = new File(uploadPath, uploadFileName2);
		// 2. 파일 복사 실행(설계대로)
		// 스프링파일객체.transferTo(설계)
		try {
			multipartFile.transferTo(saveFile);
			multipartFile2.transferTo(saveFile2);
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// DB ITEM 테아블에 insert 해보자!
		/*
		 * Item2VO(itemId=0, itemName=커피맛곽정원, price=17000, description=커피는 역식 정워니TOP,
		 * pictureUrl=null, uploadFile=파일객체)
		 * 
		 * PictureUrl에 웹경로를 넣어주자
		 * 
		 * registry.addResourceHandler("/upload/**")
		 * .addResourceLocations("file:///D:/upload/");
		 * 
		 * 결과: /2025/09/08/UUID_파일명.확장자
		 */

		// 현재 getFolder() ==> 2025\\09\\08
		String pictureUrl = "/" + this.beanController.getFolder().replace("\\", "/") + "/" + uploadFileName;
		String pictureUrl2 = "/" + this.beanController.getFolder().replace("\\", "/") + "/" + uploadFileName2;

//		log.info("check : pictureUrl => {}", pictureUrl);

		item2VO.setPictureUrl(pictureUrl);
		item2VO.setPictureUrl2(pictureUrl2);
		/*
		 * Item2VO(itemId=0, itemName=커피맛곽정원, price=17000, description=커피는 역식 정워니TOP,
		 * pictureUrl=/2025/09/08/UUID_파일명.확장자, uploadFile=파일객체)
		 */

		// I/U/D의 경우 returnType = int
		int result = this.item2Service.registerPost(item2VO);

		log.info("check : result => {}", result);

		// 상세보기 redirect
		// 데이터 //방금 등록된 데이터의 기본키 값을 상세로 보내야 하므로
		return "redirect:/item2/detail?itemId=" + item2VO.getItemId();
	}

	/*
	 * 상세보기 요청URI: /item/detail?itemId=1 요청파라미터: itemId=1 => 타입이 String 타입 (자동 형변환
	 * 된다, 단 데이터가 숫자형 문자일때) 요청방식 : get
	 */
	@GetMapping("/detail")
	public String detail(Item2VO item2VO, @ModelAttribute(value = "item2VO") Item2VO item2VO2, // @ModelAttribute(value="item2VO2")
																								// 생략된거다 생략 가능하다
			int itemId, // @RequestParam 이 생략 (왜냐하면 요청 파라미터와 변수명이 같으므로)
			@RequestParam(value = "itemId") int itemId2, @RequestParam(value = "itemId") String itemId3,
			@RequestParam Map<String, Object> map, Model model) {
		log.info("check: item2VO => {}", item2VO);
		log.info("check: item2VO2 => {}", item2VO2);
		log.info("check: itemId => {}", itemId);
		log.info("check: itemId2 => {}", itemId2);
		log.info("check: itemId3 => {}", itemId3);
		log.info("check: map => {}", map);
		log.info("check: model => {}", model);

		// select * from item where item_id = 1
		item2VO = this.item2Service.detail(item2VO);
		log.info("check : item2VO (after) => {}", item2VO);

		model.addAttribute("item2VO", item2VO);

		// forwarding : jsp 응답
		return "item2/detail";
	}

	/// item/edit?itemId=${item2VO.itemId }"
	@GetMapping("/edit")
	public String edit(Item2VO item2VO, @ModelAttribute(value = "Item2VO") Item2VO item2VO2,
			@RequestParam Map<String, Object> map, Model model) {

		// get방식으로 itemId만 값을 전달
		log.info("check: item2VO (before) => {}", item2VO);
		item2VO = this.item2Service.detail(item2VO);
		log.info("check : item2VO (after) => {}", item2VO); // before와 after 값이 다르다!! get방식인거 집중하기
		model.addAttribute("item2VO", item2VO);
		// forwarding jsp응답
		return "item2/edit";
	}

	/*
	 * 상품 변경 요청URI: /item/editPost 요청파라미터: {itemId=4, itemName=garden맛 커피,
	 * price=3700, description=커피는 역시 티오피 garden,
	 * pictureUrl=/2025/09/09/23424be8-feb7-4934-a9ad-a0df508bdd14_수박주스.PNG,
	 * uploadFile=null 요청방식 : post
	 */
	@PostMapping("/editPost")
	public String editPost(Item2VO item2VO) {
		log.info("check : item2VO => {}", item2VO);

		// 1. 파일 업로드
		MultipartFile uploadFile = item2VO.getUploadFile();
		MultipartFile uploadFile2 = item2VO.getUploadFile2();

//		log.info("check : item2VO.getUploadFile => {}", uploadFile);
//		log.info("check : item2VO.uploadFile.getOriginalFilename => {}", uploadFile.getOriginalFilename());
		// check : item2VO.uploadFile.getOriginalFilename =>
//		log.info("check : item2VO.getUploadFile.getOriginalFilename().length() => {}", 
//				uploadFile.getOriginalFilename().length());
		// check : item2VO.getUploadFile.getOriginalFilename().length() => 0 <-- 이걸로 파일이
		// 있는지 없는지 확인하는거 추천
		// 1-1) 파일이 있을 때
		// uploadFile이 null인지 아닌지 먼저 확인하자. 왜냐하면 nullpointer 에러 발생 가능
		// null.getOriginalFileName ==> 에러 발생
		String pictureUrl = "";
		if (uploadFile != null && uploadFile.getOriginalFilename().length() > 0) {
			pictureUrl = this.uploadController.singleFileUpload(uploadFile);
			item2VO.setPictureUrl(pictureUrl);
		} else {// 1-2) 파일이 없을 때
			pictureUrl = "";
			item2VO.setPictureUrl(null);
		}

		String pictureUrl2 = "";
		if (uploadFile2 != null && uploadFile2.getOriginalFilename().length() > 0) {
			pictureUrl2 = this.uploadController.singleFileUpload(uploadFile2);
			item2VO.setPictureUrl2(pictureUrl2);
		} else {// 1-2) 파일이 없을 때
			pictureUrl2 = "";
			item2VO.setPictureUrl2(null);
		}

		// 확인
		log.info("check : item2VO(before insert) +> {}", item2VO);

		// 2. DB 테이블 update
		// I, U , D -> return 타입은 int
		int result = this.item2Service.editPost(item2VO);
		log.info("check : editPost.result => {}", result);
		// redirect : 상세 URI를 재요청
		return "redirect:/item2/detail?itemId=" + item2VO.getItemId();
	}

	/*
	 * 요청URI : /item2/editPostAjax 요청파라미터 :
	 * formData{itemId=1,itemName=삼성태블릿2,price=120002,description=쓸만함2,
	 * uploadFiles=파일객체들}
	 */
	@ResponseBody
	@PostMapping("/editPostAjax")
	public Map<String, Object> editPostAjax(Item2VO item2VO) {
		// 매개변수 출력
		log.info("check : editPostAjax/item2VO => {}", item2VO);

		int result = this.item2Service.editPostAjax(item2VO);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);

		return map;
	}

	/*
	 * 요청URI : /item/deletePost 요청파라미터 :
	 * {itemId=6,itemName=삼성태블릿,price=120000,description=쓸만함,uploadFile=파일객체} 요청방식 :
	 * post
	 */
	@PostMapping("/deletePost")
	public String deletePost(@ModelAttribute Item2VO item2VO) {
		log.info("deletePost->item2VO : " + item2VO);

		// DELETE FROM ITEM
		// WHERE ITEM_ID = 6;
		int rslt = this.item2Service.deletePost(item2VO);
		log.info("check : deletePost => {}", rslt);

		// 목록URI 재요청 : redirect
		return "redirect:/item2/list";
	}

	/*
	 * 요청 URI: item/list or item/list?keyword=송 요청 파라미터 : 요청 방식 : get
	 * 
	 * required=false => 필수가 아님(없을수도 있다) String keyword=""; // 최소한 whitespace라고
	 * 있음(null이 아님)
	 */

	@GetMapping("/list")
	public String list(Model model, @RequestParam(required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "") String keyword) {

		log.info("check : currentPage => {}", currentPage);
//		   log.info("check : keyword +> {}", keyword);
		// 한 화면에 보여질 행의 수
		int size = 10;

		// 상품목록
		/*
		 * select * from item order by 1 desc
		 */

		Map<String, Object> map = new HashMap<>();
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);

		// 전체 행의 수
		int total = this.item2Service.getTotal(map);
		log.info("check : getTotal => total {}", total);

		List<Item2VO> item2VOList = this.item2Service.list(map);
//		   log.info("check : list => {}", item2VOList);

		// 페이지네이션
		ArticlePage<Item2VO> articlePage = new ArticlePage<Item2VO>(total, currentPage, size, item2VOList, keyword);

		model.addAttribute("item2VOList", item2VOList);
		model.addAttribute("articlePage", articlePage);

		// forwarding : jsp리턴
		return "item2/list";
	}

	@ResponseBody
	@PostMapping("/createPostAjax")
	public Map<String, Object> reply(@RequestBody Item2VO item2VO, Principal principal,
			@AuthenticationPrincipal CustomUser customUser) {

		log.info("check : reply/item2VO => {}", item2VO);

		// 1. writer
		String writer = principal.getName();
		item2VO.setWriter(writer);

		// 2. CustomerUser 객체에서 MemverVO를 바로 꺼내자
		MemberVO memberVO = customUser.getMemberVO(); // Getter를 통해 접근

		// insert 수행
		int result = this.item2Service.createPostAjax(item2VO);
		log.info("check : item2VO/itemId => {}", item2VO.getItemId());

		// 상세정보 select 부모 item2VO 불러오기
		item2VO.setItemId(item2VO.getParentItemId()); // 부모 itemId를 set하기

		item2VO = this.item2Service.detail(item2VO); // 부모글의 상세정보 select
		log.info("check : createPostAjax -> item2VO : {}", item2VO);

		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		map.put("item2VO", item2VO);
		map.put("username", writer);

		return map;
	}

	/*
	 * 요청URI: /item2/detailAjax 
	 * 요청파라미터(인자값): JSON String {"itemId": itemId} 
	 * 요청방식: post
	 */
	@ResponseBody // 굳이 Map으로 보내지 않아도, Item2VO로 보내도 서버에서 JSON 파싱(잭슨)함
	@PostMapping("/detailAjax") //요청URI: /item2/detailAjax 
//	  public Item2VO detailAjax(
	public Map<String, Object> detailAjax( //<== 무슨 메소드? 댓글 조회할거야! 인자값은 (PK)itemID, 결과 item2VO  
			@RequestBody Item2VO item2VO //요청파라미터(인자값): JSON String {"itemId": itemId} 
			) {
		log.info("check(before) : detailAjax/item2VO => {}", item2VO); // 인자값

		item2VO = this.item2Service.detail(item2VO); // itemId를 갖고 상세정보를 같은 이름 item2VO에 담기
		log.info("check(after) : detailAjax/item2VO => {}", item2VO); // 결과
		
		Map<String, Object> map = new HashMap<>();
		map.put("item2VO", item2VO); // 진짜 중요한 데이터
		map.put("result", 1); // 전송 잘되는 지 체크용 가라 data
		return map;
//		  return item2VO;
	}
	/* 					인자값						결과값
	 * 단일 select => 	PK(VO)						VO
	 * 다중 select => 	없음							List<VO>
	 * insert => 		VO							int / void							
	 * update =>		VO							int / void
	 * delete =>		PK(VO)						int / void
	 */
	
	
	/*
	요청URI : /item2/modifyAjax
	요청파라미터 : JSON Object
	*/
	@ResponseBody
	@PostMapping("/modifyAjax")
	public Map<String, Object> modifyAjax( //<== 무슨 메소드? 댓글 수정!! 인자값은? (수정된)item2VO 결과값이 없거나 
			// 그냥 확인용으로 int를 보내야하는데 int 바로 못보내 왜?! JSON이니까 그래서 int값과 그 int값의 이름(Key)을 같이 묶는 Map
			@RequestBody Item2VO item2VO
			){
		log.info("check : modifyAjax/item2VO => {}", item2VO);
		
		int result = this.item2Service.editPostAjax(item2VO); // 업데이트문은 결과가 없거나 또는 수정된 행의 갯수 반환
				
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		map.put("item2VO", item2VO);
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/deleteAjax")
	public Map<String, Object> deleteAjax(
			@RequestBody Item2VO item2VO
			){
		
		log.info("check : deleteAjax/item2VO => {}", item2VO);
		// 상세정보 select 부모 item2VO 불러오기
		Item2VO item2VOP = new Item2VO(); 
		item2VOP.setItemId(item2VO.getParentItemId());
				
		int result = this.item2Service.deletePost(item2VO);
		log.info("check : result => {}", result);
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("result", result);
		return map;
	}
	
}
