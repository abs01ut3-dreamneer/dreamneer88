package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.Item2Mapper;
import kr.or.ddit.service.Item2Service;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.Item2VO;
import kr.or.ddit.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class Item2ServiceImpl implements Item2Service {
	@Autowired
	Item2Mapper itemMapper;
	
	@Autowired
	UploadController uploadController;
	
	@Override
	public int registerPost(Item2VO itemVO) {
		
		return this.itemMapper.registerPost(itemVO);
	}

	@Override
	public Item2VO detail(Item2VO itemVO) {
		
		return this.itemMapper.detail(itemVO);
	}

	@Override
	public int editPost(Item2VO itemVO) {
		// TODO Auto-generated method stub
		return this.itemMapper.editPost(itemVO);
	}

	@Override
	public int deletePost(Item2VO itemVO) {
		// TODO Auto-generated method stub
		return this.itemMapper.deletePost(itemVO);
	}

	@Override
	public List<Item2VO> list(Map<String, Object> map) {
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
	public int editPostAjax(Item2VO item2VO) {
		MultipartFile uploadFile = item2VO.getUploadFile();
		MultipartFile uploadFile2 = item2VO.getUploadFile2();
		
		String pictureUrl = "";
		if(uploadFile !=null && uploadFile.getOriginalFilename().length()>0) {
			pictureUrl = this.uploadController.singleFileUpload(uploadFile);
			item2VO.setPictureUrl(pictureUrl);
		}else {//1-2) 파일이 없을 때
			pictureUrl="";
			item2VO.setPictureUrl(null);
		}
		
		String pictureUrl2 = "";
		if(uploadFile2 !=null && uploadFile2.getOriginalFilename().length()>0) {
			pictureUrl2 = this.uploadController.singleFileUpload(uploadFile2);
			item2VO.setPictureUrl2(pictureUrl2);
		}else {//1-2) 파일이 없을 때
			pictureUrl2="";
			item2VO.setPictureUrl2(null);
		}
		
		
		 //0. item2VO 객체 안에 들어있는 uploadFiles 객체를 꺼냄
	     //   파일이 있는지 체킹 후 있으면 1.을 실행
		MultipartFile[] multipartFiles = item2VO.getUploadFiles();
		if(multipartFiles!=null) { 
			if(multipartFiles[0].getOriginalFilename().length()>0) {
				//1. 파일업로드 + FILE_GROUP insert + FILE_DETAIL insert
			      //fileGroupNo 받기
				long fileGroupNo = this.uploadController.multiImageUpload(multipartFiles);
			      // item2VO객체의 fileGroupNo 프로퍼티에 fileGroupNo를 setting	
				item2VO.setFileGroupNo(fileGroupNo);
			      // ITEM2 테이블에 FILE_GROUP_NO 컬럼도 있어야 함(NUMBER형, null 허용)
			}
					
		} 	
	      
	      //2. ITEM2 테이블 update
	      int result = this.itemMapper.editPostAjax(item2VO);
	      log.info("editPostAjax->result : {}", result);
	      
	      return result;
	}

	@Override
	public int createPostAjax(Item2VO item2VO) {
		log.info("check : createPostAjax/item2VO => {}", item2VO);
		//3. Security Context에서 Authentication 객체를 가져옴
		//SecurityContext 누구니?
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		// 로그인이 되어있나?
		if(authentication == null || !authentication.isAuthenticated()) {
			return 0;
		}
		
		// Authentication에서 principal 가져오기
		//principal은 뭐야?
		Object principal = authentication.getPrincipal();
		
		MemberVO memberVO = new MemberVO();
		
		//principal(사용자 정보) 객체가 CustomUser 타입의 객체인지 체킹
		if(principal instanceof CustomUser) {
			CustomUser customUser = (CustomUser)principal;
			
			memberVO = customUser.getMemberVO();
			log.info("check : createPostAjax/memberVO => {}", memberVO);
			item2VO.setWriter(memberVO.getUserId());
		}
		
		// TODO Auto-generated method stub
		return this.itemMapper.createPostAjax(item2VO);
	}

	
}
