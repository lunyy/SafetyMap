package com.spring.dto;

import java.sql.Date;

public class MemberVO {
	private int id;
	private String manageNm;
	private String newAddr;
	private String oldAddr;
	private String cctvType;
	private int cctvCnt;
	private int cctvPix;
	private String cctvInfo;
	private int storeDate;
	private Date installDate;
	private String manageNo;
	private float posx;
	private float posy;
	private Date baseDate;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getManageNm() {
		return manageNm;
	}
	public void setManageNm(String manageNm) {
		this.manageNm = manageNm;
	}
	public String getNewAddr() {
		return newAddr;
	}
	public void setNewAddr(String newAddr) {
		this.newAddr = newAddr;
	}
	public String getOldAddr() {
		return oldAddr;
	}
	public void setOldAddr(String oldAddr) {
		this.oldAddr = oldAddr;
	}
	public String getCctvType() {
		return cctvType;
	}
	public void setCctvType(String cctvType) {
		this.cctvType = cctvType;
	}
	public int getCctvCnt() {
		return cctvCnt;
	}
	public void setCctvCnt(int cctvCnt) {
		this.cctvCnt = cctvCnt;
	}
	public int getCctvPix() {
		return cctvPix;
	}
	public void setCctvPix(int cctvPix) {
		this.cctvPix = cctvPix;
	}
	public String getCctvInfo() {
		return cctvInfo;
	}
	public void setCctvInfo(String cctvInfo) {
		this.cctvInfo = cctvInfo;
	}
	public int getStoreDate() {
		return storeDate;
	}
	public void setStoreDate(int storeDate) {
		this.storeDate = storeDate;
	}
	public Date getInstallDate() {
		return installDate;
	}
	public void setInstallDate(Date installDate) {
		this.installDate = installDate;
	}
	public String getManageNo() {
		return manageNo;
	}
	public void setManageNo(String manageNo) {
		this.manageNo = manageNo;
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
	public Date getBaseDate() {
		return baseDate;
	}
	public void setBaseDate(Date baseDate) {
		this.baseDate = baseDate;
	}

}
