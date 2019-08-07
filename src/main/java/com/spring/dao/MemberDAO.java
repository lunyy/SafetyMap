package com.spring.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.spring.dto.MemberVO;

@Repository("MemberDAO")
public interface MemberDAO {

	@Cacheable(value ="address")
	public List<MemberVO> selectMember() throws Exception;
}
