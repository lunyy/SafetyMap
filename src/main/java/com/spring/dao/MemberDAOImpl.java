package com.spring.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.spring.dto.MemberVO;

@Repository("MemeberDAOImpl")
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	@Qualifier("sqlSession")
	private SqlSession sqlSession;
	
	private static final String Namespace = "com.spring.mappers.memberMapper";
	
	@Override
	@Cacheable(value = "address")
	public List<MemberVO> selectMember() throws Exception{
		return sqlSession.selectList(Namespace+".selectMember");
	}
}
