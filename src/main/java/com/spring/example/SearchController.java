package com.spring.example;

import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.dto.MemberVO;
import com.spring.dto.CrimeVO;
import com.spring.service.MemberService;
import com.spring.service.CrimeService;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Autowired
	private MemberService service;
	@Autowired
	private CrimeService service2;
	
	@RequestMapping(value = "/search", method = RequestMethod.GET, produces="text/json;charset=UTF-8")
	public String search(Locale locale, Model model) throws Exception{
		logger.info("search");
	

		List<MemberVO> memberList = service.selectMember();
		List<CrimeVO> memberList2 = service2.selectMember2();
	
		model.addAttribute("memberList",memberList);
		model.addAttribute("memberList2",memberList2);
		
		return "search";
	}
}
