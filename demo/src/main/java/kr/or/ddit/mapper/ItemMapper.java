package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.ExamPassFailVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.FinalTestVO;
import kr.or.ddit.vo.FloodInfoVO;
import kr.or.ddit.vo.HoichaAmtDataVO;
import kr.or.ddit.vo.ItemVO;
import kr.or.ddit.vo.UtilityVO;

@Mapper
public interface ItemMapper {

	public int registerPost(ItemVO itemVO);

	public ItemVO detail(ItemVO itemVO);

	public int editPost(ItemVO itemVO);

	public int deletePost(ItemVO itemVO);
	
	//상품 목록
	// 매퍼 인터페이스의 목적은 쿼리 실행이다
		// 매퍼XML 호출 시 파라미터를 던짐
	public List<ItemVO> list(Map<String, Object> map);
	
	/*<!--  전체 행의 수 -->
		<select id="getTotal" resultType="int">*/
	public int getTotal(Map<String, Object> map);

	public List<ExamPassFailVO> getExamPassFail();

	public List<HoichaAmtDataVO> hoichaAmtData();

	public List<FloodInfoVO> floodInfo();

	public List<FinalTestVO> finalTest();

	public List<UtilityVO> utility();

	public FinalTestVO getFinalTest(FinalTestVO finalTestVO);

	public int insertFileGroup(FileGroupVO fileGroupVO);

	public int insertFileDetail(FileDetailVO fileDetailVO);

	public int updateFinalTest(FinalTestVO finalTestVO);

	public int deleteFinalTest(FinalTestVO finalTestVO);

	public int editPostAjax(ItemVO itemVO);

}
