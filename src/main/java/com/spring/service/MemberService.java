package com.spring.service;


import java.util.List;

import org.springframework.cache.annotation.Cacheable;

import com.spring.dto.MemberVO;
 
public interface MemberService {
    @Cacheable(value="address")
    public List<MemberVO> selectMember() throws Exception;
}
 
