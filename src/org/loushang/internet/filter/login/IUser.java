package org.loushang.internet.filter.login;

import java.util.Map;

import javax.servlet.http.HttpSession;

public interface IUser {
	/**
	 * 获取用户的信息
	 * @param uid
	 * @return
	 */
	public Map getUserInfo(String uid);
	
	/**
	 * 初始化session中的登录用户信息
	 * @param uid
	 * @param session
	 * @return
	 */
	public boolean initUserInfo(String uid, HttpSession session);
	
	/**
	 * 清除session中的登录用户信息
	 * @param session
	 * @return
	 */
	public boolean cleanUserInfo(HttpSession session);
}
