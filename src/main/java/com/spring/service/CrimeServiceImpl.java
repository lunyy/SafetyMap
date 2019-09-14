package com.spring.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.spring.dao.CrimeDAO;
import com.spring.dto.CrimeVO;


@Service
public class CrimeServiceImpl implements CrimeService {
 
    @Inject
    private CrimeDAO dao;
    
    @Override
    @Cacheable(value = "address")
    public List<CrimeVO> selectMember2() throws Exception {
 
        return dao.selectMember2();
    }
 
}
