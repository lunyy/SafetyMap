package com.spring.dto;

import java.sql.Date;

public class CrimeVO {
	private int is_criminal;
	private Date date;
	private String headline;
	private String message;
	private String message_;
	private String link;
	
	public void setIs_criminal(int is_criminal) {
		this.is_criminal = is_criminal;
	}
	public int getIs_criminal() {
		return is_criminal;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public Date getDate() {
		return date;
	}
	public void setHeadline(String headline) {
		this.headline = headline;
	}
	public String getHeadline() {
		return headline;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage_(String message_) {
		this.message_ = message_;
	}
	public String getMessage_() {
		return message_;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getLink() {
		return link;
	}
}
