package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.CarService;
import kr.or.ddit.vo.CarVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/car")
@Slf4j
@Controller
public class CarController {
   
	@Autowired
	CarService carService;
   
   @GetMapping("/create")
   public String create(CarVO carVO) {
      return "car/create";
   }
   
   @GetMapping("/detail")
   public String detail(CarVO carVO) {
      return "car/detail";
   }
   
   @PostMapping("/update")
   public String update(CarVO carVO) {
      return "redirect:/car/detail";
   }
   
   @PostMapping("/delete")
   public String delete(CarVO carVO) {
      return "redirect:/car/list";
   }
   
   @GetMapping("/list")
   public String list(CarVO carVO) {
      return "car/list";
   }
}
