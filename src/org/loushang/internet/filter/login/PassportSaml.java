package org.loushang.internet.filter.login;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;

import com.inspur.common.utils.PropertiesUtil;

public class PassportSaml implements IPassport {
	
	private static Logger log = Logger.getLogger(PassportSaml.class);
	
	public boolean isLogged() {
		HttpServletRequest request = ContextHolder.getRequest();

		boolean isLogin = false;

		HttpSession session = request.getSession();
		String _uidSession = session.getAttribute("uid") == null ? "" : String.valueOf(session.getAttribute("uid"));
		IUser user = (IUser) LoginFilterUtil.getBean(
				PropertiesUtil.getValue("login.properties","login.userImpl"));
		if(!_uidSession.isEmpty()) {
			isLogin = true;
		}
		
		if(!isLogin) {
			//未登录 则清除掉session信息
			user.cleanUserInfo(session);
		}
		
		return isLogin;
	}
	
	public void doLogin() {
		doLogin(null);
	}
	
	public void doLogin(String callbackurl) {
		try{
			HttpServletResponse response = ContextHolder.getResponse();
			HttpServletRequest request = ContextHolder.getRequest();
			PrintWriter out = response.getWriter();
			
			// 组装回调页面的url和参数
			StringBuffer curUrl = null;
			if(StringUtils.isEmpty(callbackurl)) {
				curUrl = request.getRequestURL();
				String query = RequestUtil.excludeQueryString(request, "uclogin"); //去除登录标记
				if(StringUtils.isNotEmpty(query)){
					curUrl.append("?").append(query);
				}
			} else {
				curUrl = new StringBuffer(callbackurl);
			}
			request.getSession().setAttribute("RelayState", curUrl.toString());
			
			String loginSamlUrl = PropertiesUtil.getValue("login.properties","global.sso.loginUrl");
			if(StringUtils.isEmpty(loginSamlUrl)){
				out.write("<font size='22px' color='red'>没有设置UC_SAML地址</font>");
				out.flush();out.close();
				return;
			}
			response.setHeader(
					"P3P",
					"CP=\"CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR\"");
			
			// 在用户中心登录成功，回调AssertionConsumerServiceURL实现页面内用户信息存储和页面跳转
			String AssertionConsumerServiceURL = "http://"
					+ request.getServerName() + ":"
					+ request.getServerPort() + request.getContextPath()
					+ "/filter/UserAction.htm?action=samlLogin";
			
			//将登录框返回给前台，这时候用到的是UC外网地址
			StringBuffer form = new StringBuffer();
			form.append("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><title>发送SAML请求</title></head><body onload='document.forms[0].submit()'><form action=\"")
				.append(loginSamlUrl).append("\" method=\"post\"><input type=\"hidden\" name=\"SAMLRequest\" value=\"")
				.append(AssertionConsumerServiceURL).append("\"></form></body></html>");
			
			String outputform = form.toString();
			out.write(outputform);
			out.flush();out.close();
		}catch(Exception ex){
			ex.printStackTrace();
			log.error("saml doLogin()出错！",ex);
		}
	}
	
	public String getSsoType() {
		return SSO_SAML;
	}
	
}
