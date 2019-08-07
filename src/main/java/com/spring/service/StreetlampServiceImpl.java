package com.spring.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.spring.dao.StreetlampDAO;
import com.spring.dto.StreetlampVO;


@Service
public class StreetlampServiceImpl implements StreetlampService {
 
    @Inject
    private StreetlampDAO dao;
    
    @Override
    @Cacheable(value = "address")
    public List<StreetlampVO> selectMember2() throws Exception {
 
        return dao.selectMember2();
    }
 
}
