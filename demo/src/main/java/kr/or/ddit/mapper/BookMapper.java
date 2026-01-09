package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BookVO;

//스프링 메퍼 인터페이스. 매퍼xml의 SQL을 실행해주는 역할
@Mapper
public interface BookMapper {

	//BOOK 테이블에 도서를 등록
	public int createPost(BookVO bookVO);

	//상세 데이터 불러오기
	public BookVO detail(BookVO bookVO);

	//update 실행
	public int modifyPost(BookVO bookVO);

	public Object deletePost(BookVO bookVO);

	public List<BookVO> list();

	public List<BookVO> list(Map<String, Object> param);

	public int getTotal(Map<String, Object> param);
	
}





