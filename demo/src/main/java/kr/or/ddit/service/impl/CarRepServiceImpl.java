package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.CarRepMapper;
import kr.or.ddit.service.CarRepService;
import kr.or.ddit.vo.CarRepVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CarRepServiceImpl implements CarRepService {

	@Autowired
	CarRepMapper carRepMapper;
	
	@Override
	public String create(CarRepVO carRepVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String detail(CarRepVO carRepVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String update(CarRepVO carRepVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String delete(CarRepVO carRepVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String list(CarRepVO carRepVO) {
		// TODO Auto-generated method stub
		return null;
	}

}
