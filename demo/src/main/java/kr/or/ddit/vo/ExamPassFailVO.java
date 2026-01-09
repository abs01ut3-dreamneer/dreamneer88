package kr.or.ddit.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamPassFailVO {
	private int seq;
	private int studyTime;
	private int libInvCnt; //
	private String passFail;
}
