package com.spring.dao;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.spring.dto.StreetlampVO;

@Repository("StreetlampDAO")
public interface StreetlampDAO {

	@Cacheable(value ="address")
	public List<StreetlampVO> selectMember2() throws Exception;
}
