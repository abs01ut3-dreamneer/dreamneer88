package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.CusMapper;
import kr.or.ddit.service.CusService;
import kr.or.ddit.vo.CusVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CusServiceImpl implements CusService {

	@Autowired
	CusMapper cusMapper;
	
	@Override
	public String create(CusVO cusVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String detail(CusVO cusVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String update(CusVO cusVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String delete(CusVO cusVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String list(CusVO cusVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int createPost(CusVO cusVO) {
		// TODO Auto-generated method stub
		return this.cusMapper.createPost(cusVO);
	}

}
