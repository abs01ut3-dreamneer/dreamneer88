package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FileDetailVO {
	private int fileSn;			// PK
	private long fileGroupNo;	// PK, FK
	private String fileOriginalName;
	private String fileSaveName;
	private String fileSaveLocate;
	private long fileSize;
	private String fileExt;
	private String fileMime;
	private String fileFancysize;
	private Date fileSaveDate;
	private int fileDowncount;
}
