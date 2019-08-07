package com.spring.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.spring.dto.StreetlampVO;

@Repository("StreetlampDAOImpl")
public class StreetlampDAOImpl implements StreetlampDAO {

	@Autowired
	@Qualifier("sqlSession2")
	private SqlSession sqlSession;
	
	private static final String Namespace = "com.spring.mappers2.streetlampMapper";
	
	@Override
	@Cacheable(value = "address")
	public List<StreetlampVO> selectMember2() throws Exception{
		return sqlSession.selectList(Namespace+".selectMember2");
	}
}