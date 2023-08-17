package com.liferay.dynamic.data.mapping.internal.notification;

import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

public class LocalizedData {
	private String formName;
	private List<Object> pages;
	private String siteName;
	private String userName;
	private ResourceBundle rb;
	private Locale locale;
	
	public String getFormName() {
		return formName;
	}
	public void setFormName(String formName) {
		this.formName = formName;
	}
	public List<Object> getPages() {
		return pages;
	}
	public void setPages(List<Object> pages) {
		this.pages = pages;
	}
	public String getSiteName() {
		return siteName;
	}
	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public ResourceBundle getRb() {
		return rb;
	}
	public void setRb(ResourceBundle rb) {
		this.rb = rb;
	}
	public Locale getLocale() {
		return locale;
	}
	public void setLocale(Locale locale) {
		this.locale = locale;
	}
}
