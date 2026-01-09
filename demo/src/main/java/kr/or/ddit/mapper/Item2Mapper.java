package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.Item2VO;

@Mapper
public interface Item2Mapper {

	public int registerPost(Item2VO itemVO);

	public Item2VO detail(Item2VO itemVO);

	public int editPost(Item2VO itemVO);

	public int deletePost(Item2VO itemVO);
	
	//상품 목록
	// 매퍼 인터페이스의 목적은 쿼리 실행이다
		// 매퍼XML 호출 시 파라미터를 던짐
	public List<Item2VO> list(Map<String, Object> map);
	
	/*<!--  전체 행의 수 -->
		<select id="getTotal" resultType="int">*/
	public int getTotal(Map<String, Object> map);

	public int editPostAjax(Item2VO item2VO);

	public int createPostAjax(Item2VO item2vo);

	

}
