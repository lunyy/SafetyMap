package com.spring.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.spring.dto.CrimeVO;

@Repository("CrimeDAOImpl")
public class CrimeImpl implements CrimeDAO {

	@Autowired
	@Qualifier("sqlSession2")
	private SqlSession sqlSession;
	
	private static final String Namespace = "com.spring.mappers2.crimeMapper";
	
	@Override
	@Cacheable(value = "address")
	public List<CrimeVO> selectMember2() throws Exception{
		return sqlSession.selectList(Namespace+".selectMember2");
	}
}