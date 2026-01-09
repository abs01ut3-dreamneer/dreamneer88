package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.CusService;
import kr.or.ddit.vo.CusVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/cus")
@Slf4j
@Controller
public class CusController {
   
   @Autowired
   CusService cusService;
   
   @GetMapping("/create")
   public String create(CusVO cusVO) {
      return "cus/create";
   }
   
   @PostMapping("/createPost")
   public String createPost(
		  CusVO cusVO
		   ) {
	   log.info("check : createPost/cusVO => {}", cusVO);
	   
	   int result = this.cusService.createPost(cusVO);
	   
	   return null;   
   }
   
   @GetMapping("/detail")
   public String detail(CusVO cusVO) {
      return "cus/detail";
   }
   
   @PostMapping("/update")
   public String update(CusVO cusVO) {
      return "redirect:/cus/detail";
   }
   
   @PostMapping("/delete")
   public String delete(CusVO cusVO) {
      return "redirect:/cus/list";
   }
   
   @GetMapping("/list")
   public String list(CusVO cusVO) {
      return "cus/list";
   }
}
