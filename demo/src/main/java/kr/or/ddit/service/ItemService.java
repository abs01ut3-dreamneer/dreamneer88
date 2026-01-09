package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.ExamPassFailVO;
import kr.or.ddit.vo.FinalTestVO;
import kr.or.ddit.vo.FloodInfoVO;
import kr.or.ddit.vo.HoichaAmtDataVO;
import kr.or.ddit.vo.ItemVO;
import kr.or.ddit.vo.UtilityVO;

public interface ItemService {

	int registerPost(ItemVO itemVO);

	ItemVO detail(ItemVO itemVO);

	int editPost(ItemVO itemVO);

	int deletePost(ItemVO itemVO);

	List<ItemVO> list(Map<String, Object> map);
	
	/*<!--  전체 행의 수 -->
	<select id="getTotal" resultType="int">*/
	int getTotal(Map<String, Object> map);

	List<ExamPassFailVO> getExamPassFail();

	List<HoichaAmtDataVO> hoichaAmtData();

	List<FloodInfoVO> floodInfo();

	List<FinalTestVO> finalTest();

	List<UtilityVO> utility();

	FinalTestVO getFinalTest(FinalTestVO finalTestVO);

	int updateFinalTest(FinalTestVO finalTestVO);

	int deleteFinalTest(FinalTestVO finalTestVO);

	int editPostAjax(ItemVO itemVO);
}
