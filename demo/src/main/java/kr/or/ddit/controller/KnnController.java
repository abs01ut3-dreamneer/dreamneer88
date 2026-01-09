package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.ItemService;
import kr.or.ddit.util.knn.DataPoint;
import kr.or.ddit.util.knn.KNNClassifier;
import kr.or.ddit.vo.ExamPassFailVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/knn")
@Slf4j
@Controller
public class KnnController {

   //DI, IoC
   @Autowired
   KNNClassifier classifier;
   
   @Autowired
   ItemService itemService;
   
   /*
   요청URI : /knn/predict01
   요청파라미터 : JSON String{studyTime:7,libInvCnt:5}
   요청방식 : post
   */
   @ResponseBody
   @PostMapping("/predict01")
   public String predict01(@RequestBody ExamPassFailVO examPassFailVO) {
      log.info("predict01->examPassFailVO : " + examPassFailVO);
      
      //EXAM_PASS_FAIL 테이블 SELECT
      List<ExamPassFailVO> examPassFailVOList = this.itemService.getExamPassFail(); //원래는 서비스를 만들어야하는데 임시로 ItemService써서 연습
      log.info("predict01->examPassFailVOList : " + examPassFailVOList);
      
      //1. 훈련 데이터들
      List<DataPoint> trainingData = new ArrayList<>();
      for(ExamPassFailVO vo : examPassFailVOList) {
          // 훈련데이터
    	  DataPoint dp = new DataPoint(vo.getStudyTime(), vo.getLibInvCnt(), vo.getPassFail());
    	  trainingData.add(dp);
       }
      
      //2. 예측 대상
      DataPoint newPoint = new DataPoint(examPassFailVO.getStudyTime(), examPassFailVO.getLibInvCnt(), null);
      
      // KNN 사용
      //              List<DataPoint> trainingData, DataPoint newPoint, int kString passFail = this.classifier.classify(null, null, 5);
      String passFail = this.classifier.classify(trainingData, newPoint, 5);
      log.info("predict01->passFail : " + passFail);
      
      //데이터 응답
      return passFail;
   }
}
