package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.ProductVO;

@Mapper //메퍼에 어노테이션 필요, 까먹지 않기
public interface ProductMapper {

	List<ProductVO> products();
	
	//<select id="product" parameterType="productVO" resultType="productVO">
	ProductVO product(ProductVO productVO);

	public int processAddProduct(ProductVO productVO); 
}
