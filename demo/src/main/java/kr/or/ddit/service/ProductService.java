package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.ProductVO;

public interface ProductService {

	List<ProductVO> products();

	ProductVO product(ProductVO productVO);

	public int processAddProduct(ProductVO productVO); 
}
