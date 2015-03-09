package org.loushang.internet.filter;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.ErrCodeUtil;
import org.loushang.internet.util.JsonUtils;
import org.loushang.internet.util.RequestURIFilter;
import org.loushang.internet.util.RequestUtil;

import com.inspur.common.utils.PropertiesUtil;
import org.loushang.internet.filter.login.IPassport;
import org.loushang.internet.filter.login.LoginFilterUtil;

public class LoginFilter implements Filter {
	
	private ServletContext sc = null;
	private RequestURIFilter excludes;
	private FilterConfig filterConfig;
	private String encode = null;
	private String fromEncode = null;
	
	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
		sc = filterConfig.getServletContext();
		String excludes =  this.filterConfig.getInitParameter("excludes");
		this.setExcludes(excludes);
		encode = filterConfig.getInitParameter("encode");
		fromEncode = filterConfig.getInitParameter("fromEncode");
		if(encode == null){
			encode="UTF-8";
		}
		if(fromEncode == null) {
			fromEncode = "ISO8859-1";
		}
	}
	public void setExcludes(String excludes) {
		this.excludes = new RequestURIFilter(excludes);
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		setCharacterEncoding(httpRequest,httpResponse,encode);
		
		if(this.excludes.matches(httpRequest)){
			filterChain.doFilter(request, response);
			return;
		}
		
		//初始化ContextHolder
		ContextHolder.init(httpRequest, httpResponse, sc);
		
		IPassport passport = (IPassport) LoginFilterUtil.getBean(
				PropertiesUtil.getValue("login.properties","login.passportImpl"));

		boolean isLogin = passport.isLogged();
		if (!isLogin && LoginFilterUtil.needLogin()) {
			//如果请求的是widget，没有登录返回needLogin字符串
			if(RequestUtil.isWidgetQuery(httpRequest)) {
				httpResponse.getWriter().write("needLogin");
				return;
			} else if(RequestUtil.isAjaxQuery(httpRequest)) {
				String errCode = ErrCodeUtil.ERR_LOGIN;
				String errInfo = ErrCodeUtil.getErrInfo(errCode);
				httpResponse.setStatus(500);
				Map<String,Object> result = new HashMap<String,Object>();
				result.put("errCode", errCode);
				result.put("errInfo", errInfo);
				httpResponse.getWriter().write(JsonUtils.convertToString(result));
				return;
			} else {
				passport.doLogin();
			}
		} else {
			if(passport.getSsoType().equals(IPassport.SSO_SAML)) {
				//如果是saml形式的单点登录且有已登录标记，则进行登录处理
				String uclogin = request.getParameter("uclogin");
				if("1".equals(uclogin)) {
					passport.doLogin();
					return;
				}
			}
			filterChain.doFilter(request, response);
		}
	}
	/**
	 * 设置编码集。
	 */
	private void setCharacterEncoding(HttpServletRequest request, HttpServletResponse response, String encode) throws UnsupportedEncodingException{
		request.setCharacterEncoding(encode);
        response.setContentType("text/html; charset=" + encode);
	}
	public void destroy() {
		this.excludes=null;
		this.filterConfig=null;
	}
}
