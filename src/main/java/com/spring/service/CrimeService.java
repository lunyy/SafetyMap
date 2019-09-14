package com.spring.service;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;

import com.spring.dto.CrimeVO;

public interface CrimeService {
	@Cacheable(value="address")
    public List<CrimeVO> selectMember2() throws Exception;
}
