package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// POJO가 약해짐
@Getter
@Setter
@ToString
public class Item2VO {
	private int rnum;
	private int itemId;
	private String itemName;
	private int price;
	private String description;
	private String pictureUrl;
	private String pictureUrl2;
	private String writer;
	
	//대댓글
	private int parentItemId; //itemId가 부모글
	private int lvl; // 계층형 게시판의 level
	
	// <input type="file" name="uploadFile" placeholder="상품이미지"/>
	private MultipartFile uploadFile;
//	<input type="file" name="uploadFile2" placeholder="상품이미지2"/>
	private MultipartFile uploadFile2;
	
	// 요렇게 받아보자
	private MultipartFile[] uploadFiles;
	
	private long fileGroupNo;
	
	// File Group 1:1
	private FileGroupVO fileGroupVO;
	
	// Child Item2VO
	private List<Item2VO> item2VOList;
}
