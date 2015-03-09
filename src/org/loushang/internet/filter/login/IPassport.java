package org.loushang.internet.filter.login;


public interface IPassport {
	
	/**
	 * cookie形式的sso登录
	 */
	public static final String SSO_COOKIE = "cookie";
	/**
	 * saml形式的sso登录
	 */
	public static final String SSO_SAML = "saml";
	
	/**
	 * 是否登录
	 * @return
	 */
	public boolean isLogged();
	/**
	 * 登录处理
	 */
	public void doLogin();
	/**
	 * 单点登录类型
	 */
	public String getSsoType();
}
