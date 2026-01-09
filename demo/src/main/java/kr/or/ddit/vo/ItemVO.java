package kr.or.ddit.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// POJO가 약해짐
@Getter
@Setter
@ToString
public class ItemVO {
	private int rnum;
	private int itemId;
	private String itemName;
	private int price;
	private String description;
	private String pictureUrl;
	private long fileGroupNo;
	
	// <input type="file" name="uploadFile" placeholder="상품이미지"/>
	private MultipartFile uploadFile;
	private MultipartFile[] uploadFiles;
	
	//item : FILE_GROUP = 1 : 1
	private FileGroupVO fileGroupVO;
}
