package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.Item2VO;

public interface Item2Service {

	int registerPost(Item2VO item2VO);

	Item2VO detail(Item2VO item2VO);

	int editPost(Item2VO item2VO);

	int deletePost(Item2VO item2VO);

	List<Item2VO> list(Map<String, Object> map);
	
	/*<!--  전체 행의 수 -->
	<select id="getTotal" resultType="int">*/
	int getTotal(Map<String, Object> map);

	int editPostAjax(Item2VO item2VO);

	int createPostAjax(Item2VO item2VO);

	
}
