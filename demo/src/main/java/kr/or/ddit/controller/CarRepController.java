package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.CarRepService;
import kr.or.ddit.vo.CarRepVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/carRep")
@Slf4j
@Controller
public class CarRepController {
   
   @Autowired
   CarRepService carRepService;
   
   @GetMapping("/create")
   public String create(CarRepVO carRepVO) {
      return "carRep/create";
   }
   
   @GetMapping("/detail")
   public String detail(CarRepVO carRepVO) {
      return "carRep/detail";
   }
   
   @PostMapping("/update")
   public String update(CarRepVO carRepVO) {
      return "redirect:/carRep/detail";
   }
   
   @PostMapping("/delete")
   public String delete(CarRepVO carRepVO) {
      return "redirect:/carRep/list";
   }
   
   @GetMapping("/list")
   public String list(CarRepVO carRepVO) {
      return "carRep/list";
   }
}
