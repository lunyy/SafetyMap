package com.spring.dao;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.spring.dto.CrimeVO;

@Repository("CrimeDAO")
public interface CrimeDAO {

	@Cacheable(value ="address")
	public List<CrimeVO> selectMember2() throws Exception;
}
