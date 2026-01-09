package kr.or.ddit.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.config.BeanController;
import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.ItemVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/item")
public class ItemController {

	// DI(의존성 주입) -> 메소드(getUploadFoler())를 사용할 수 있음
	@Autowired
	BeanController beanController;

	// 파일 업로드 유틸 DI
	@Autowired
	UploadController uploadController;
	
	@Autowired
	ItemService itemService;

	/*
	 * 요청URI: /item/register 요청파라미터: 요청방식: get
	 */
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/register")
	public String register() {
		// forwarding: jsp 응답
		return "item/register";
	}

//	@ResponseBody
	@PostMapping("/registerPost")
	public String registerPost(ItemVO itemVO) {
		log.info("check: itemVO, uploadFile => {}, {} ", itemVO);
		// ItemVO에 직접 파일을 직접 받아오는 방법!!!!!!!!

		// 연월일 폴더 생성 설계
		// 연월일 폴더 생성 실행
		File uploadPath = new File(this.beanController.getUploadFolder(), this.beanController.getFolder());

		// 연월일 폴더가 없으면 폴더 생성해주자
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}

		// 스프링 파일객체의 파일명 꺼내기
		MultipartFile uploadFile = itemVO.getUploadFile();
		String uploadFileName = uploadFile.getOriginalFilename();
		log.info("check : uploadFileName => {}", uploadFileName);

		// 같은 날 같은 이미지 업로드 시 파일 중복 방지 시작////////
		// java.util.UUID => 랜덤값 생성
		UUID uuid = UUID.randomUUID();

		// 원래의 파일 이름과 구분하기 위해 _를 붙임(asdflkjs_개똥이.jpg)
		uploadFileName = uuid.toString() + "_" + uploadFileName;

		// 같은 날 같은 이미지 업로드 시 파일 중복 방지 끝////////

		// 파일 복사 설계
		// , : \\ (파일 세퍼레이터)
		//
		File saveFile = new File(uploadPath, uploadFileName);
		// 2. 파일 복사 실행(설계대로)
		// 스프링파일객체.transferTo(설계)
		try {
			uploadFile.transferTo(saveFile);
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// DB ITEM 테아블에 insert 해보자!
		/*
		 * ItemVO(itemId=0, itemName=커피맛곽정원, price=17000, description=커피는 역식 정워니TOP,
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

		log.info("check : pictureUrl => {}", pictureUrl);

		itemVO.setPictureUrl(pictureUrl);
		/*
		 * ItemVO(itemId=0, itemName=커피맛곽정원, price=17000, description=커피는 역식 정워니TOP,
		 * pictureUrl=/2025/09/08/UUID_파일명.확장자, uploadFile=파일객체)
		 */

		// I/U/D의 경우 returnType = int
		int result = this.itemService.registerPost(itemVO);

		log.info("check : result => {}", result);

		// 상세보기 redirect
		// 데이터 //방금 등록된 데이터의 기본키 값을 상세로 보내야 하므로
		return "redirect:/item/detail?itemId=" + itemVO.getItemId();
	}

	/*
	 * 상세보기 요청URI: /item/detail?itemId=1 요청파라미터: itemId=1 => 타입이 String 타입 (자동 형변환
	 * 된다, 단 데이터가 숫자형 문자일때) 요청방식 : get
	 */
	@GetMapping("/detail")
	public String detail(ItemVO itemVO, @ModelAttribute(value = "itemVO") 
			ItemVO itemVO2, // @ModelAttribute(value="itemVO2") 생략된거다 생략 가능하다
			int itemId, // @RequestParam 이 생략 (왜냐하면 요청 파라미터와 변수명이 같으므로)
			@RequestParam(value = "itemId") int itemId2, 
			@RequestParam(value = "itemId") String itemId3,
			@RequestParam Map<String, Object> map, Model model) {
		log.info("check: itemVO => {}", itemVO);
		log.info("check: itemVO2 => {}", itemVO2);
		log.info("check: itemId => {}", itemId);
		log.info("check: itemId2 => {}", itemId2);
		log.info("check: itemId3 => {}", itemId3);
		log.info("check: map => {}", map);
		log.info("check: model => {}", model);

		// select * from item where item_id = 1
		itemVO = this.itemService.detail(itemVO);
		log.info("check : itemVO (after) => {}", itemVO);

		model.addAttribute("itemVO", itemVO);

		// forwarding : jsp 응답
		return "item/detail";
	}

	/// item/edit?itemId=${itemVO.itemId }"
	@GetMapping("/edit")
	public String edit (ItemVO itemVO,
			@ModelAttribute(value="ItemVO") ItemVO itemVO2,
			@RequestParam Map<String, Object> map,
			Model model) {
		
		// get방식으로 itemId만 값을 전달
		log.info("check: itemVO (before) => {}", itemVO); 
		itemVO = this.itemService.detail(itemVO);
		log.info("check : itemVO (after) => {}", itemVO); //before와 after 값이 다르다!! get방식인거 집중하기
		model.addAttribute("itemVO", itemVO);
		//forwarding jsp응답 
		return "item/edit";
	}
	
	/*
	 * 상품 변경
	 * 요청URI: /item/editPost
	 * 요청파라미터: {itemId=4, itemName=garden맛 커피, price=3700, description=커피는 역시 티오피 garden, pictureUrl=/2025/09/09/23424be8-feb7-4934-a9ad-a0df508bdd14_수박주스.PNG, uploadFile=null
	 * 요청방식 : post
	 */
	@PostMapping("/editPost")
	public String editPost(ItemVO itemVO) {
		log.info("check : itemVO => {}", itemVO);
		
		//1. 파일 업로드
		MultipartFile uploadFile = itemVO.getUploadFile();
		log.info("check : itemVO.getUploadFile => {}", uploadFile);
		log.info("check : itemVO.uploadFile.getOriginalFilename => {}", uploadFile.getOriginalFilename());
		//check : itemVO.uploadFile.getOriginalFilename => 
		log.info("check : itemVO.getUploadFile.getOriginalFilename().length() => {}", 
				uploadFile.getOriginalFilename().length());
		//check : itemVO.getUploadFile.getOriginalFilename().length() => 0 <-- 이걸로 파일이 있는지 없는지 확인하는거 추천
		//1-1) 파일이 있을 때
			//uploadFile이 null인지 아닌지 먼저 확인하자. 왜냐하면 nullpointer 에러 발생 가능 
			//null.getOriginalFileName ==> 에러 발생
		String pictureUrl = "";
			if(uploadFile !=null && uploadFile.getOriginalFilename().length()>0) {
				pictureUrl = this.uploadController.singleFileUpload(uploadFile);
				itemVO.setPictureUrl(pictureUrl);
			}else {//1-2) 파일이 없을 때
				pictureUrl="";
				itemVO.setPictureUrl(null);
			}
			
		//2. DB 테이블 update
		// I, U , D -> return 타입은 int
		int result = this.itemService.editPost(itemVO);
		log.info("check : editPost.result => {}", result);
		//redirect : 상세 URI를 재요청
		return "redirect:/item/detail?itemId="+itemVO.getItemId();
	}
	
	 /*
	   요청URI : /item/deletePost
	   요청파라미터 : {itemId=6,itemName=삼성태블릿,price=120000,description=쓸만함,uploadFile=파일객체}
	   요청방식 : post
	    */
	   @PostMapping("/deletePost")
	   public String deletePost(@ModelAttribute ItemVO itemVO) {
	      log.info("deletePost->itemVO : " + itemVO);
	      
	      //DELETE FROM ITEM 
	      //WHERE  ITEM_ID = 6;
	      int rslt = this.itemService.deletePost(itemVO);
	      log.info("check : deletePost => {}", rslt);
	      
	      //목록URI 재요청 : redirect
	      return "redirect:/item/list";
	   }
	   
	   /*
	    * 요청 URI: item/list or item/list?keyword=송
	    * 요청 파라미터 :
	    * 요청 방식 : get
	    * 
	    * required=false => 필수가 아님(없을수도 있다)
	    * String keyword=""; // 최소한 whitespace라고 있음(null이 아님)
	    */
	   
	   @GetMapping("/list")
	   public String list(Model model, 
			   @RequestParam(required=false, defaultValue = "1")int currentPage,
			   @RequestParam(required=false, defaultValue="")String keyword) {
		   
		   log.info("check : currentPage => {}", currentPage);
//		   log.info("check : keyword +> {}", keyword);
		   //한 화면에 보여질 행의 수
		   int size = 10;
		   
		   // 상품목록
		   /* select * from item order by 1 desc
		    */
		   
		   Map<String, Object> map = new HashMap<>();
		   map.put("currentPage", currentPage);
		   map.put("keyword", keyword);
		   
		   //전체 행의 수
		   int total = this.itemService.getTotal(map);
		   log.info("check : getTotal => total {}", total);
		   
		   List<ItemVO> itemVOList = this.itemService.list(map);
//		   log.info("check : list => {}", itemVOList);
		   
		   //페이지네이션
		   ArticlePage<ItemVO> articlePage = 
				   new ArticlePage<ItemVO> (total, currentPage, size, itemVOList, keyword);
		   
		   
		   model.addAttribute("itemVOList",itemVOList);
		   model.addAttribute("articlePage",articlePage);
		   
		   // forwarding : jsp리턴
		   return "item/list";
	   }
	   
	   /*아작났어유..피씨다타써
	      요청URI : /item/editPostAjax
	      요청파라미터 : {itemId=1,itemName=삼성태블릿2,price=120002,description=쓸만함2,uploadFiles=파일객체들}
	      요청방식 : post
	      
	      dataType : 응답타입
	      */
	   @PostMapping("/editPostAjax")
	   public ResponseEntity<Map<String, Object>> editPostAjax(
			   @ModelAttribute ItemVO itemVO
			   ){
		   log.info("editPostAjax -> ItemVO : "+itemVO);
		   
		   //update
		   int result=this.itemService.editPostAjax(itemVO);
		   
		   Map<String, Object> map = new HashMap<String, Object>();
		   map.put("result", result);
		   
		   return new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
	   }
	   
}
