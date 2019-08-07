package com.spring.service;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;

import com.spring.dto.StreetlampVO;

public interface StreetlampService {
	@Cacheable(value="address")
    public List<StreetlampVO> selectMember2() throws Exception;
}
