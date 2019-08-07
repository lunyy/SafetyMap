package com.spring.dto;

import java.sql.Date;

public class StreetlampVO {
	private int id;
	private String st_location;
	private int st_cnt;
	private String newAddr;
	private float posx;
	private float posy;
	private String manageNo;
	private String manageNm;
	private Date baseDate;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getSt_location() {
		return st_location;
	}
	public void setSt_location(String st_location) {
		this.st_location = st_location;
	}
	public int getSt_cnt() {
		return st_cnt;
	}
	public void setSt_cnt(int st_cnt) {
		this.st_cnt = st_cnt;
	}
	public String getNewAddr() {
		return newAddr;
	}
	public void setNewAddr(String newAddr) {
		this.newAddr = newAddr;
	}
	public float getPosx() {
		return posx;
	}
	public void setPosx(float posx) {
		this.posx = posx;
	}
	public float getPosy() {
		return posy;
	}
	public void setPosy(float posy) {
		this.posy = posy;
	}
	public String getManageNo() {
		return manageNo;
	}
	public void setManageNo(String manageNo) {
		this.manageNo = manageNo;
	}
	public String getManageNm() {
		return manageNm;
	}
	public void setManageNm(String manageNm) {
		this.manageNm = manageNm;
	}
	public Date getBaseDate() {
		return baseDate;
	}
	public void setBaseDate(Date baseDate) {
		this.baseDate = baseDate;
	}
}
