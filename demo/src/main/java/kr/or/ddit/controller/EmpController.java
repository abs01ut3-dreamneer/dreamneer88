package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.EmpService;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/emp")
@Slf4j
@Controller
public class EmpController {
   
   @Autowired
   EmpService empService;
   
   @GetMapping("/create")
   public String create(EmpVO empVO) {
      return "emp/create";
   }
   
   @GetMapping("/detail")
   public String detail(EmpVO empVO) {
      return "emp/detail";
   }
   
   @PostMapping("/update")
   public String update(EmpVO empVO) {
      return "redirect:/emp/detail";
   }
   
   @PostMapping("/delete")
   public String delete(EmpVO empVO) {
      return "redirect:/emp/list";
   }
   
   @GetMapping("/list")
   public String list(EmpVO empVO) {
      return "emp/list";
   }
   
   @PostMapping("/createPost")
   public String createPost(EmpVO empVO) {
	   log.info("check :createPost/empVO => {}", empVO);
	   
	   int result = this.empService.createPost(empVO);
	   
	   
	   return null;
   }
}
