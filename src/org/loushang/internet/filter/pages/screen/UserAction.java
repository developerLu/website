package org.loushang.internet.filter.pages.screen;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.ErrCodeUtil;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.el.Function;
import org.loushang.internet.util.filter.SecurityUtil;
import org.loushang.internet.view.ViewHandler;

import com.inspur.common.utils.PropertiesUtil;
import org.loushang.internet.filter.login.IUser;
import org.loushang.internet.filter.login.LoginFilterUtil;
import org.loushang.internet.filter.login.PassportSaml;

public class UserAction implements ViewHandler {

	public void execute(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}
	
	/**
	 * saml单点登录方式的登录处理
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void doSamlLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String callbackurl = request.getParameter("callbackurl");
		PassportSaml passport = new PassportSaml();
		if(StringUtils.isEmpty(callbackurl)) {
			passport.doLogin(Function.getHome());
		} else {
			passport.doLogin(callbackurl);
		}
	}
	
	/**
	 * saml单点登录方式的登录响应处理
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void actSamlLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//获取request中断言
		String SMAL = request.getParameter("SAMLResponse");
		if(StringUtils.isEmpty(SMAL)) {
			request.setAttribute("errCode", ErrCodeUtil.ERR_LOGSAML);
			ContextHolder.forwardErrUrl();
			return;
		}

		HttpSession session = request.getSession();
		
		//解析断言，分割断言
		String uid = SecurityUtil.jiemi(SMAL).split("\\|")[0];

		IUser user = (IUser) LoginFilterUtil.getBean(
				PropertiesUtil.getValue("login.properties","login.userImpl"));
		//获取用户信息
		user.initUserInfo(uid, session);
		
		//页面跳转
		String RelayState = (String) session.getAttribute("RelayState");
		if(StringUtils.isEmpty(RelayState)) {
			RelayState = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
		}
		ContextHolder.sendRedirect(RelayState);
	}
	
	/**
	 * 注销session中的登录信息
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void doLogout(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		//注销session中的登录信息
		IUser user = (IUser) LoginFilterUtil.getBean(
				PropertiesUtil.getValue("login.properties","login.userImpl"));
		user.cleanUserInfo(session);
		
		//页面跳转
		String relayState = request.getParameter("relayState");
		if(StringUtils.isEmpty(relayState)) {
			relayState = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
		}
		ContextHolder.sendRedirect(relayState);
	}
}
