package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.dbscan.DbscanClustering;
import kr.or.ddit.util.dbscan.DbscanPoint;
import kr.or.ddit.util.dbscan.DbscanPoint.PointState;
import kr.or.ddit.vo.UtilityVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/utility")
@Slf4j
@RestController
public class UtilityController {
	
	@Autowired
	ItemService itemService;
	
	@Autowired
	DbscanClustering dbscan;
	
	/*
	 * 요청URI: /dbscan
	 * 요청파라미터: 없고
	 * 요청방식: post
	 */	
	@PostMapping("/utilDbscan")
	public Map<String, Object> utilDbscan(){
		
		Map<String, Object> map = new HashMap<>();
		
		List<UtilityVO> utilityVOList = this.itemService.utility();
		log.info("check: utility => {} ", utilityVOList);
		
		List<DbscanPoint> dps = new ArrayList<>();
		
		for(UtilityVO db : utilityVOList) {
			dps.add(new DbscanPoint(db.getId(), db.getElectricityUsage(), db.getWaterUsage()));
		}
		
		List<DbscanPoint> clusteredDps = this.dbscan.cluster(dps);
		log.info("check: clusteredDps => {} ", clusteredDps);
		
		map.put("result", "success");
		map.put("clusteredDps", clusteredDps);
		
		List<Integer> noiseId = new ArrayList<>();
		
		for(DbscanPoint cDp : clusteredDps) {
			if(cDp.getState()==DbscanPoint.PointState.NOISE) {
				noiseId.addLast(cDp.getId());
			}
		}
		
		map.put("noiseIds", noiseId);
		
		return map;
	}	
}
