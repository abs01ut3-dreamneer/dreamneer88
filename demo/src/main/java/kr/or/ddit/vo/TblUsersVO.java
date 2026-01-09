package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class TblUsersVO {
	
	private int id;
	private String email;
	private String password;
	private Date createdAt;
	private Date updatedAt;
	private String name;
	private String imgUrl;
	private String accessToken;
	private String enabled;
	
	//TBL_USERS : TBL_USERS_AUTH = 1 : N
	private List<TblUsersAuthVO> tblUsersAuthVOList;
	
}
