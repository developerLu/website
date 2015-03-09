package org.loushang.internet.filter.login;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.loushang.internet.util.CookieUtil;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.filter.SecurityUtil;

import com.inspur.common.utils.PropertiesUtil;

import org.loushang.internet.context.ContextHolder;

public class PassportCookie implements IPassport {
	
	private static Logger log = Logger.getLogger(PassportCookie.class);
	
	public boolean isLogged() {
		HttpServletRequest request = ContextHolder.getRequest();

		boolean isLogin = false;

		String cookie_sso_key = PropertiesUtil.getValue("login.properties","cookie_sso_key");
		if(cookie_sso_key == null || cookie_sso_key.isEmpty()){
			cookie_sso_key = "sso_token";
		}
		HttpSession session = request.getSession();
		Cookie uidCookie = CookieUtil.getCookieByName(request, cookie_sso_key);
		String _uidCookie = "";
		if(uidCookie != null) {
			try {
				if(cookie_sso_key.equals("sso_token")){
					_uidCookie = SecurityUtil.jiemi(URLDecoder.decode(uidCookie.getValue(), "utf-8")).trim();
				}else{
					_uidCookie = SecurityUtil.jiemiOld(URLDecoder.decode(uidCookie.getValue(), "utf-8")).trim();
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e);
			}
			_uidCookie = _uidCookie == null ? "" : _uidCookie;
		}
		String _uidSession = session.getAttribute("uid") == null ? "" : String.valueOf(session.getAttribute("uid"));
		IUser user = (IUser) LoginFilterUtil.getBean(
				PropertiesUtil.getValue("login.properties","login.userImpl"));
		if(!"".equals(_uidCookie)) {
			String uid = _uidCookie.replaceAll("\\D", "");
			if("".equals(_uidSession)) {
				//cookie中有登录信息而session中没有, 则设置session中登录信息
				isLogin = user.initUserInfo(uid, session);
			} else {
				if(_uidCookie.equals(_uidSession)) {
					//cookie中的登录信息和session中的登录信息一致
					if(session.getAttribute("userInfo") == null) {
						//如果session中没有登录用户的信息，则设置session中的用户信息
						isLogin = user.initUserInfo(uid, session);
					} else {
						isLogin = true;
					}
				} else {
					//cookie中的登录信息和session中的登录信息不一致，则重新设置session中的登录信息
					user.cleanUserInfo(session);
					isLogin = user.initUserInfo(uid, session);
				}
			}
		}
		
		if(!isLogin) {
			//未登录 则清除掉session信息
			user.cleanUserInfo(session);
		}
		
		return isLogin;
	}
	
	public void doLogin() {
		HttpServletResponse response = ContextHolder.getResponse();
		HttpServletRequest request = ContextHolder.getRequest();
//		HttpSession session = request.getSession();
		StringBuffer curUrl = request.getRequestURL();
		String query = request.getQueryString();
		if(StringUtils.isNotEmpty(query)){
			curUrl.append("?").append(query);
		}
		try {
			String loginUrl = PropertiesUtil.getValue("login.properties","global.sso.loginUrl");
//			session.setAttribute("RelayState", curUrl.toString());
//			response.sendRedirect(loginUrl);
			response.sendRedirect(loginUrl+(loginUrl.indexOf("?")>-1?"":"?")+"&RelayState="+URLEncoder.encode(curUrl.toString(), "UTF-8"));
		} catch (IOException e) {
			log.error("登录跳转出错",e);
		}
	}
	
	public String getSsoType() {
		return SSO_COOKIE;
	}
	
}
