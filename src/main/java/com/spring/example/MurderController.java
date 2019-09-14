
package com.spring.example;

import java.util.List;
import java.util.Locale;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.dto.CrimeVO;
import com.spring.service.CrimeService;


@Controller
public class MurderController {
	private static final Logger logger = LoggerFactory.getLogger(MurderController.class);
	
	@Autowired
	private CrimeService service2;
	
	@RequestMapping(value = "/murder", method = RequestMethod.GET)
	public String Murder(Locale locale, Model model) throws Exception {
		List<CrimeVO> memberList2 = service2.selectMember2();
		model.addAttribute("memberList2",memberList2);
		
		return "murder";
	}
}