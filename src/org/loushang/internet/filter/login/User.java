package org.loushang.internet.filter.login;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

public class User implements IUser{

	private static Logger log = Logger.getLogger(User.class);
	
	public Map getUserInfo(String uid){
		return null;
	}

	/**
	 * 初始化session中的登录用户信息
	 * @param uid
	 * @param session
	 * @return
	 */
	public boolean initUserInfo(String uid, HttpSession session) {
		if(uid == null || session == null) return false;
		try {
			Map userInfo = this.getUserInfo(uid);
			if (userInfo != null) {
				String user_type = String.valueOf(userInfo.get("user_type"));
				if (user_type.startsWith("22") || user_type.startsWith("3")) {
					session.setAttribute("user_type", "department");
				}
				userInfo.remove("login_email");
				userInfo.remove("login_phone");
				userInfo.remove("password");
				userInfo.remove("password_strength");
				userInfo.remove("data_from");
				userInfo.remove("space");
				
				session.setAttribute("userInfo", userInfo);
				session.setAttribute("uid", uid);
				return true;
			}
		} catch (NumberFormatException e) {
			log.error(e);
		}
		return false;
	}
	
	/**
	 * 清除session中的登录用户信息
	 * @param session
	 * @return
	 */
	public boolean cleanUserInfo(HttpSession session) {
		if(session == null) return false;
		session.removeAttribute("user_type");
		session.removeAttribute("userInfo");
		session.removeAttribute("uid");
		return true;
	}
	
}
