package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.BookService;
import kr.or.ddit.service.impl.BookServiceImpl;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.BookVO;
import lombok.extern.slf4j.Slf4j;

/*
Controller 어노테이션
스프링 프레임워크에게 "이 클래스는 웹 브라우저의 요청(request)를
받아들이는 컨트롤러야" 라고 알려주는 것임.
이 클래스를 자바빈 객체로 등록(메모리에 바인딩).

log.info : 썰
써ㄹ풀4람
*/
@Slf4j
@Controller
public class BookController {

    private final BookServiceImpl bookServiceImpl;
	
	//서비스를 호출하기 위해 의존성 주입(Dependency Injection-DI)
	//IoC(Inversion of Control) - 제어의 역전.(개발자가 객체생성하지 않고 스프링이 객체를 미리 생성해놓은 것을 개발자가 요청)
	@Autowired
	BookService bookService;

    BookController(BookServiceImpl bookServiceImpl) {
        this.bookServiceImpl = bookServiceImpl;
    }
	
	//책 입력 화면
	/*
	 요청URI : /create
	 요청파라미터 : 없음
	 요청방식 : get
	 */
	//RequesetMapping 어노테이션 : 웹 브라우저의 요청에 실행되는 자바 메소드 지정
	/*
	method 속성은 http 요청 메소드를 의미함. 일반적인 웹 페이지 개발에서 GEt 메소드는
	데이터를 변경하지 않는 경우에, POST 메소드는 데이터가 변경될 경우 사용
	책 생성 화면은 웹 브라우저에 화면을 보여줄 뿐 데이터의 변경이 일어나지 않으므로
		GET 메소드를 사용함
	 */
	@RequestMapping(value="/create",method=RequestMethod.GET)
	public ModelAndView create() {
		
		log.info("도서 입력");
		
		/*
		 ModelAndView
		 1) Model : Controller가 반환할 데이터(String, int, List, Map, VO..)를 담당
		 2) View : 화면을 담당(뷰(View : JSP)의 경로)
		 */
		ModelAndView mav = new ModelAndView();
//		<beans:property name="prefix" value="/WEB-INF/views/" />
//		<beans:property name="suffix" value=".jsp" />
		// prefix(접두어) : /WEB-INF/views/
		// suffix(접미어) : .jsp
		// /WEB-INF/views/ + book/create + .jsp
		//forwarding
		mav.setViewName("book/create");
		
		return mav;
	}
	
	/*
	요청URI : /create
	요청파라미터(HTTP파라미터) : {title=개똥이의 모험, category=소설, price=12000}
	요청방식 : post
	 */
	@RequestMapping(value="/create",method=RequestMethod.POST)
	public ModelAndView createPost(BookVO bookVO, ModelAndView mav) {
		/*
		BookVO(bookId=0, title=개똥이, category=소설, price=12000, insertDate=null)
		 */
		log.info("createPost->bookVO(전) : " + bookVO);
		
		//JPA(Java Persistence API) : 엔티티(Book)가 리턴
		//MyBatis : insert/update/delete 시 return 타입은 int
		//BOOK 테이블에 도서를 등록
		int result = this.bookService.createPost(bookVO);
		//BookVO(bookId=0, title=2, category=3, price=5, insertDate=null)
		log.info("createPost->bookVO(후) : " + bookVO);
		log.info("createPost->result : " + result);
		
		//redirect : URI를 재요청
		mav.setViewName("redirect:/detail?bookId="+bookVO.getBookId());
		
		return mav;
	}
	
	/* 도서 상세페이지
	 요청URI : /detail?bookId=5
	 요청파라미터 : bookId=5
	 요청방식 : get	 
	 */
	@RequestMapping(value="/detail",method=RequestMethod.GET)
	public ModelAndView detail(BookVO bookVO, ModelAndView mav) {
		/*
		BookVO(bookId=5, title=null, category=null, price=0, insertDate=null)
		 */
		log.info("detail->bookVO : " + bookVO);
		
		//상세 데이터 불러오기
		//SELECT * FROM BOOK WHERE BOOK_ID = 5;
		bookVO = this.bookService.detail(bookVO);
		
		/*
		BookVO(bookId=5, title=개똥이의 모험5, category=소설, price=15000, insertDate=25/08/27)
		 */
		log.info("detail->bookVO(후) : " + bookVO);
		
		mav.addObject("bookVO", bookVO);
		
		//forwarding : jsp
		//application.properties => 설정
		//View Resolver가 조립을 해줌
		// /WEB-INF/views/ + book/detail + .jsp
		mav.setViewName("book/detail");
		
		return mav;
	}
	
	/* 도서 수정
	 요청URI : /modify?bookId=3
	 요청파라미터 : bookId=3
	 요청방식 : get
	*/
	@RequestMapping(value="/modify",method=RequestMethod.GET)
	public ModelAndView modify(BookVO bookVO, ModelAndView mav) {
		/*
		BookVO(bookId=3, title=null, category=null, price=0, insertDate=null)
		 */
		log.info("modify->bookVO : " + bookVO);
		
		//상세 불러오기
		//SELECT * FROM BOOK WHERE BOOK_ID = 3;
		bookVO = this.bookService.detail(bookVO);
		log.info("modify->bookVO(후) : " + bookVO);
		
		//model에 담기(속성명 : bookVO)
		mav.addObject("bookVO", bookVO);
		
		//forwarding : jsp 응답
		mav.setViewName("book/modify");
		
		return mav;
	}
	
	/* 도서 수정 실행
	요청URI : /modifyPost
	요청파라미터 : request{bookId=3,title=개똥이 모험55,category=소설,price=15000}
	요청방식 : post
	 */
	@RequestMapping(value="/modifyPost",method=RequestMethod.POST)
	public ModelAndView modifyPost(BookVO bookVO, ModelAndView mav) {
		/*
		BookVO(bookId=3, title=개똥이의 모험5, category=소설, price=15000
		, insertDate=null)
		 */
		//modifyPost->bookVO : BookVO(bookId=3, title=22, category=33, price=55, insertDate=null)
		log.info("modifyPost->bookVO : " + bookVO);
						
		/*
		UPDATE BOOK
		SET    TITLE=..,CATEGORY=..,PRICE=..,INSERT_DATE=SYSDATE
		WHERE  BOOK_ID=3;
		 */
		//update 실행
		//I/U/D의 리턴 타입 : int
		int result = this.bookService.modifyPost(bookVO);
		log.info("modifyPost->result : " + result);
		
		//상세 페이지 URI를 재요청
		mav.setViewName("redirect:/detail?bookId="+bookVO.getBookId());
		
		return mav;
	}
	
	/* 도서 삭제
	   요청URI : /deletePost
	   요청파라미터 : request{bookId=5, title=개똥이의 모험5, category=소설, price=15000, insertDate=}
	   요청방식 : post
	   */
	@RequestMapping(value="/deletePost", method=RequestMethod.POST)
	public ModelAndView deletePost(BookVO bookVO, ModelAndView mav) {
		log.info("deletePost-> bookVO: " + bookVO);
		
		//삭제 실행
		this.bookService.deletePost(bookVO);
		
		//목록URI를 재요청
		mav.setViewName("redirect:/list");
		
		return mav;
	}
	
	/*
	 * 요청URI: /list
	 * 요청파라미너:
	 * 요청방식: get
	 * 
	 * ModelAndView mav: 매개변수 형태로 객체를 생성
	 */
//	@RequestMapping(value="/list", method=RequestMethod.GET)
//	public ModelAndView list(ModelAndView mav) {
//		List<BookVO> books = this.bookService.list();
//		
//		mav.addObject("books", books);
//		
//		//forwarding: list.jsp를 응답		
//		mav.setViewName("/book/list");
//		return mav;
//	}
//	
	
	/*
	 * 요청URI: /list?currentPage=1&keyword=개똥이 or /list or /list?currentPage=1&keyword=
	 * 요청(Request)파라미터(Param): currentPage=1&^keyword=개똥이 
	 * 요청방식: get
	 * defaultValue="" => String keyword="";(O) / String keyword = null;(X)
	 * required(필수인가?)=false => 선택사항
	 * 
	 * EL(Expression Language)에서 keyword=개똥이 => param
	 */
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public ModelAndView listSearch(ModelAndView mav,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage) { //defaultValue="1"이지만 int로 자동 형변환된다
		log.info("list->keyword : "+keyword);
		
		//한 화면에 보여질 행의 개수
		int size = 10;
		
		Map<String, Object> param = new HashMap<>();
		param.put("keyword", keyword);
		param.put("currentPage", currentPage);
		
		// map{currentPage=1, keyword=개똥이}
		log.info("list->map :"+param);
		
		List<BookVO> books = this.bookService.list(param);
		
		// 전체 행의 수
		int total = this.bookService.getTotal(param);
		log.info("list->total : {}",total);
		//페이징 객체 등장!
	    ArticlePage<BookVO> articlePage = 
	    		new ArticlePage<BookVO>(total, currentPage, size, books, keyword);
	    
	    //ArticlePage [total=210, currentPage=1, totalPages=21, startPage=1, endPage=3, 
	    //	keykword=에세이, url=, 
	    //	content=[BookVO(rnum=1, bookId=140, title=우슬춘의 여행140, category=에세이, price=90000, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=2, bookId=139, title=우슬춘의 여행139, category=에세이, price=89500, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=3, bookId=138, title=우슬춘의 여행138, category=에세이, price=89000, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=4, bookId=137, title=우슬춘의 여행137, category=에세이, price=88500, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=5, bookId=136, title=우슬춘의 여행136, category=에세이, price=88000, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=6, bookId=135, title=우슬춘의 여행135, category=에세이, price=87500, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=7, bookId=134, title=우슬춘의 여행134, category=에세이, price=87000, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=8, bookId=133, title=우슬춘의 여행133, category=에세이, price=86500, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=9, bookId=132, title=우슬춘의 여행132, category=에세이, price=86000, insertdate=Thu Aug 28 17:11:12 KST 2025), BookVO(rnum=10, bookId=131, title=우슬춘의 여행131, category=에세이, price=85500, insertdate=Thu Aug 28 17:11:12 KST 2025)], 
	    //	pagingarea=]

	    log.info("list->articlePage : {}",articlePage);
		
//	    mav.addObject("books", books);
	    
		mav.addObject("articlePage", articlePage);
		//forwarding: list.jsp를 응답		
		mav.setViewName("/book/list");
		return mav;
	}
	
}














