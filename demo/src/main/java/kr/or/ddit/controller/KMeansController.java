package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.util.unsupervisedLearning.ClusterDataPoint;
import kr.or.ddit.util.unsupervisedLearning.KMeansClustering;
import kr.or.ddit.vo.FinalTestVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/kmeans")
@Slf4j
//@RestController
@Controller
public class KMeansController {

	// D.I (의존성 주입)
	@Autowired
	KMeansClustering kMeans;

	@Autowired
	ItemService itemService;
	
	@Autowired
	UploadController uploadController; //파일 업로드 및 DB작업전용 객체 D.I
	
	/*
	 * 요청URI: /kmeans/kmeansPredict 요청파라미터: 요청방식: post
	 */
	@ResponseBody
	@PostMapping("/kmeansPredict")
	public Map<String, Object> kmeansPredict() {

		// 군집 개수
		int k = 3; // 인문, 이공, 공무
		int maxIterations = 300; // centeroids 찾아가기 위한 반복 횟수 (30명 * 100회 = 3000번)

		// 훈련 데이터 준비
		List<FinalTestVO> finalTestVOList = this.itemService.finalTest();
		log.info("check : kmeansPredict/finalTest => " + finalTestVOList);

		Map<String, Object> map = new HashMap<>();
		map.put("result", "success");
		map.put("finalTestVOList", finalTestVOList);

		List<ClusterDataPoint> dataPoints = new ArrayList<>();

		for (FinalTestVO vo : finalTestVOList) {
			dataPoints.add(new ClusterDataPoint(vo.getStudentId(), vo.getColx(), vo.getColy()));
		}

		/*
		 * private int k; // 군집의 개수 private int maxIterations; // 최대 반복 횟수 private
		 * List<Centroid> centroids; // 각 군집의 중심점 private Random random;
		 */

		KMeansClustering kmeans = new KMeansClustering(k, maxIterations);

		// k-평균 군집화 알고리즘 실행 -> k개의 군집으로 나눔
		// -> 각 dp인 (x, y)를 가장 가까운 군집의 중심에 할당

		List<ClusterDataPoint> clusteredData = kmeans.cluster(dataPoints);

		for (ClusterDataPoint cdp : clusteredData) {
			// List<FinalTestVO> finalTestVOList
			for (FinalTestVO ftv : finalTestVOList) {
				if (cdp.getStudentId() == ftv.getStudentId()) {
					cdp.setStudentName(ftv.getStudentName());
					break;
				}
			}
		}

		map.put("clusteredData", clusteredData);
		// 데이터 응답
		return map;
	}

	/*
	 * 요청URI : /kmeans/kmeansList 요청파라미터 : 요청방식 : get
	 */
	@GetMapping("/kmeansList")
	public String kmeansList() {

		// forwarding : jsp 응답
		return "member/kmeansList";
	}

	/*
	 * 요청URI: /kmeans/getFinalTest 요청파라미터: JSON string{studentId=12} 요청방식: post
	 * 
	 * 요청headers:{"Content-Type":"application/json"} 요청body: JSON.stringify(data)
	 * 
	 * 숫자형 문자를 스프링에서 자동으로 int타입으로 형변환 가능 but RequestBody의 경우 Map또는 VO타입으로 받아야함
	 * studentId="12"
	 */

	@ResponseBody
	@PostMapping("/getFinalTest")
	public FinalTestVO getFinalTest(@RequestBody FinalTestVO finalTestVO) {
		log.info("check: getFinalTest/finalTestVO => " + finalTestVO);

		// FINAL_TEST 테이블 Select
		FinalTestVO asdf = this.itemService.getFinalTest(finalTestVO);
		// 데이터 응답
		return asdf;
	}

	/*
	 * 요청URI : /kmeans/updateFinalTest 요청파라미터 : formData 요청방식 : post
	 * 
	 * 응답타입 => dataType:"json",
	 */

	@ResponseBody
	@PostMapping("/updateFinalTest")
	public int updateFinalTest(FinalTestVO finalTestVO) {
		log.info("check : updateFinaleTest/finalTestVO => " + finalTestVO);
		
//		//파일 업로드 및 DB 작업 수행
//		long fileGroupNo = this.uploadController.multiImageUpload(finalTestVO.getUploadFiles());
//		log.info("check : updateFinalTest/fileGroupNO => "+fileGroupNo);
		
		//Controler의 동일한 메소드에서 여러개의 SQL을 실행하지 않고,
	      //Service 레이어에서 실행함, 트랜잭션 처리는 Service 레이어에서 수행함
	      int result = this.itemService.updateFinalTest(finalTestVO);
	      log.info("updateFinalTest->result : " + result);
		
		return result;
	}
	
	/*
	   요청URI : /kmeans/deleteFinalTest
	   요청파라미터 : JSONString{studentId=1}
	   요청방식 : post
	   */
	@ResponseBody
	@PostMapping("/deleteFinalTest")
	public int deleteFinalTest(@RequestBody FinalTestVO finalTestVO) {
		log.info("check : deletefinalTest/finalTestVO => "+finalTestVO);
		
		//delete 수행
		int result = this.itemService.deleteFinalTest(finalTestVO);
		//1행을 삭제 성정
		
		//데이터 응답
		return result;
	}
}
