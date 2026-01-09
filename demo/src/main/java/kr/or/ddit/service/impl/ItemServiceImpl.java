package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.ItemMapper;
import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.ExamPassFailVO;
import kr.or.ddit.vo.FinalTestVO;
import kr.or.ddit.vo.FloodInfoVO;
import kr.or.ddit.vo.HoichaAmtDataVO;
import kr.or.ddit.vo.ItemVO;
import kr.or.ddit.vo.UtilityVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ItemServiceImpl implements ItemService {
	@Autowired
	ItemMapper itemMapper;
	
	@Autowired
	UploadController uploadController;
	
	@Override
	public int registerPost(ItemVO itemVO) {
		
		return this.itemMapper.registerPost(itemVO);
	}

	@Override
	public ItemVO detail(ItemVO itemVO) {
		
		return this.itemMapper.detail(itemVO);
	}

	@Override
	public int editPost(ItemVO itemVO) {
		// TODO Auto-generated method stub
		return this.itemMapper.editPost(itemVO);
	}

	@Override
	public int deletePost(ItemVO itemVO) {
		// TODO Auto-generated method stub
		return this.itemMapper.deletePost(itemVO);
	}

	@Override
	public List<ItemVO> list(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.itemMapper.list(map);
	}
	
	/*<!--  전체 행의 수 -->
	<select id="getTotal" resultType="int">*/
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.itemMapper.getTotal(map);
	}

	@Override
	public List<ExamPassFailVO> getExamPassFail() {
		
		return this.itemMapper.getExamPassFail();
	}

	@Override
	public List<HoichaAmtDataVO> hoichaAmtData() {
		// TODO Auto-generated method stub
		return this.itemMapper.hoichaAmtData();
	}

	@Override
	public List<FloodInfoVO> floodInfo() {
		// TODO Auto-generated method stub
		return this.itemMapper.floodInfo();
	}

	@Override
	public List<FinalTestVO> finalTest() {
		// TODO Auto-generated method stub
		return this.itemMapper.finalTest();
	}

	@Override
	public List<UtilityVO> utility() {
		// TODO Auto-generated method stub
		return this.itemMapper.utility();
	}

	@Override
	public FinalTestVO getFinalTest(FinalTestVO finalTestVO) {
		// TODO Auto-generated method stub
		return this.itemMapper.getFinalTest(finalTestVO);
	}
	
	//스프링이 트랜잭션 처리를 알아서 해줌
	@Transactional
	@Override
	public int updateFinalTest(FinalTestVO finalTestVO) {
		
		//1. 파일이 있을때만 실행해야 함 시작//
		MultipartFile[] uploadFiles = finalTestVO.getUploadFiles();
		
		if(uploadFiles != null) {//수정할 파일이 있으면
			//  첫번째 파일 객체  . 원본파일명			   .길이	 	가 0보다 커야함
			if(uploadFiles[0].getOriginalFilename().length()>0) {
				//파일업로드 및 DB작업 수행
				//Insert가 2회 이상 발생
				long fileGroupNo = this.uploadController.multiImageUpload(finalTestVO.getUploadFiles());
				log.info("updateFinalTest->fileGroupNo : " + fileGroupNo);
				
				//FINAL_TEST 테이블의 FILE_GROUP_NO 값 보정
				//update가 1회 발생
				finalTestVO.setFileGroupNo(fileGroupNo);
			}//end if
		}// end if
		//1. 파일이 있을때만 실행해야 함 시작//
		
		//2. 파일이 없다면?
		//finalTestVO의 fileGroupNo 프로퍼티의 value는 null임
		int result = this.itemMapper.updateFinalTest(finalTestVO);
		
		return result;
	}

	@Override
	public int deleteFinalTest(FinalTestVO finalTestVO) {
		// TODO Auto-generated method stub
		return this.itemMapper.deleteFinalTest(finalTestVO);
	}

	// 파일업로드 + insert + update
	@Transactional
	@Override
	public int editPostAjax(ItemVO itemVO) {
		// TODO Auto-generated method stub
		//1. 파일 업로드 + FILE_GROUP insert + FILE_DETAIL insert
		MultipartFile[] uploadFiles = itemVO.getUploadFiles();
		
		if(uploadFiles!=null) {
			if(uploadFiles[0].getOriginalFilename().length()>0) {
				long fileGroupNo = this.uploadController.multiImageUpload(itemVO.getUploadFiles());
				
				itemVO.setFileGroupNo(fileGroupNo);
			}
		}
		
		//ITEM테이블 update
		int result = this.itemMapper.editPostAjax(itemVO);
		
		return result;
	}	


}
