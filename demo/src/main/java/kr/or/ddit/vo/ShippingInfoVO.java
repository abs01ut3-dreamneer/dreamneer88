package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class ShippingInfoVO {
	private String cartId;			
	private String name;			
	private Date shippingDate;	
    private String zipCode;			
    private String addressName;		
    private String addressDetName;
    
}

