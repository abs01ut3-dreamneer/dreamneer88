package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ProductMapper;
import kr.or.ddit.service.ProductService;
import kr.or.ddit.vo.ProductVO;

@Service //서비스impl 어노테이션 필요 까먹지 않기
public class ProductServiceImpl implements ProductService {

	@Autowired
	ProductMapper productMapper;
	
	@Override
	public List<ProductVO> products() {
		
		return this.productMapper.products();
	}
	
	@Override
	public ProductVO product(ProductVO productVO) {
		return this.productMapper.product(productVO);
	}

	@Override
	public int processAddProduct(ProductVO productVO) {
		
		return this.productMapper.processAddProduct(productVO);
	}
}
