package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.CarMapper;
import kr.or.ddit.service.CarService;
import kr.or.ddit.vo.CarVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CarServiceImpl implements CarService {

	@Autowired
	CarMapper carMapper;
	
	@Override
	public String create(CarVO carVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String detail(CarVO carVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String update(CarVO carVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String delete(CarVO carVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String list(CarVO carVO) {
		// TODO Auto-generated method stub
		return null;
	}

}
