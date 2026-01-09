package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.simpleLinearRegression.RegressionDataPoint;
import kr.or.ddit.util.simpleLinearRegression.SimpleLinearRegression;
import kr.or.ddit.vo.HoichaAmtDataVO;
import lombok.extern.slf4j.Slf4j;

//선형회귀분석
/*
 * RestController  = Controller + ResponseBody (두 어노테이션이 합쳐진 슈퍼 울트라 짱편한 어노테이션)
 * RestController를 쓰는 순간 REST API 서버가 구동된다
 * ReponseBody: Spring은 기본적으로 Jackson 라이브러리를 통해 자바 객체(Object)를 JSON(String)으로 자동 변환함 => Serialize(직렬화) 
 */
@RequestMapping("/slr")
@Slf4j
@RestController
public class SlrController {
	
	@Autowired
	SimpleLinearRegression regressor;
	
	@Autowired
	ItemService itemService;
		
	/*
	 * 요청URI: /slr/predict
	 * 요청파라미터: JSON String{varX=31}
	 * 요청방식: post
	 * 
	 * varX=31 => 문자열이다!! 
	 * 문자로 보이지만 사실 숫자다!
	 * 
	 * [요청]
	 * 1) RequestHeader : 요청정보
	 * 2) RequestBody: 요청데이터
	 */
	
	@PostMapping("/predict")
	public Map<String, Object> predict(@RequestBody Map<String, Object> map){
		log.info("check : predict/map =>"+map);
		
		// HOICHA_AMT_DATA를 select
		List<HoichaAmtDataVO> hoichaAmtDataVOList = this.itemService.hoichaAmtData(); // map은 독립 변수 그리고 결과로 종속변수인 amt
		log.info("check : predict/hoichaAmtDataVOList =>"+hoichaAmtDataVOList);
		
		List<RegressionDataPoint> trainingData = new ArrayList<>();
		// 훈련데이터(DB)
		for(HoichaAmtDataVO vo : hoichaAmtDataVOList) {
			trainingData.add(new RegressionDataPoint(vo.getHoicha(), vo.getAmt()));
		}
		
		// 모델 학습
		regressor.train(trainingData);
		
		// 방법 1.
//		log.info("check : map.get(\"varX\").getClass() => "+ map.get("varX").getClass());
//		
//		Double var = Double.parseDouble(map.get("varX").toString());
//		double amt = regressor.predict(var);
		
		// 방법 2. 모든 숫자의 래퍼 클래스 : Number
		Object obj = map.get("varX");
		
		if(obj instanceof Number) {
			Number num = (Number)obj; //Object를 Number로 캐스팅
			
			double var = num.doubleValue();
			double amt = regressor.predict(var);
			map.put("amt", amt);
		}
		
		return map;
	}
}
