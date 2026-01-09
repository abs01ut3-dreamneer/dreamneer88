package kr.or.ddit.vo;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.util.unsupervisedLearning.ClusterDataPoint;
import lombok.Data;

@Data
public class FinalTestVO {
	private int studentId;
	private String studentName;
	private int koreanScore;
	private int englishScore;
	private int mathScore;
	private int scienceScore;
	private int historyKr;
	private int historyWorld;
	private long fileGroupNo;
	
	//FinalTest : ClusterDataPoint = 1 : 1
	private ClusterDataPoint clusterDataPoint;
	
	private double colx;   //((1+2)*2) + (5+6)
	private double coly;   //3 + 4
	private double tot;
	private double avg;
	
	private MultipartFile[] uploadFiles;
	
	//FINAL_TEST : FILE_GROUP = 1 : 1
	private FileGroupVO fileGroupVO;
}
