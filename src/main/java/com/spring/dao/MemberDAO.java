package com.spring.dao;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;

import com.spring.dto.MemberVO;

public interface MemberDAO {
	@Cacheable(value ="address")
	public List<MemberVO> selectMember() throws Exception;
}
