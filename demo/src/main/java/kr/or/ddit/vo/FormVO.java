package kr.or.ddit.vo;

import lombok.Data;

/*
 * request{id=a001, password=java, name=개똥이, phone1=010,phone2=1234,phone3=1234,
					gender=male, hobby=read,movie, city=city01, food=ddeukboki,kmichijjigae}
 */
@Data
public class FormVO {

	private String id;
	private String password;
	private String name;
	private String phone1;
	private String phone2;
	private String phone3;
	private String gender;
	private String[] hobby;
	private String city;
	private String[] food;
	private String comment;//가입인사
}
