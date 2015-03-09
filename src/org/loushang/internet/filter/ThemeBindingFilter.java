package org.loushang.internet.filter;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.request.RequestWrapper;
import org.loushang.internet.util.RequestURIFilter;
import org.loushang.internet.util.StringUtils;

public class ThemeBindingFilter implements Filter {
	
	private String encode = null;
	private String fromEncode = null;
	private ServletContext sc = null;
	private RequestURIFilter excludes = null;
	
	public void init(FilterConfig config) throws ServletException {
		encode = config.getInitParameter("encode");
		fromEncode = config.getInitParameter("fromEncode");
		if(encode == null){
			encode="UTF-8";
		}
		if(fromEncode == null) {
			fromEncode = "ISO8859-1";
		}
		String excludes =  config.getInitParameter("excludes");
		this.setExcludes(excludes);
		sc = config.getServletContext();
	}
	
	
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest hsreq = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		// 设置对应的默认的编码集
		setCharacterEncoding(hsreq,response,encode);

		RequestWrapper request = null;
		if(hsreq instanceof RequestWrapper) {
			request = (RequestWrapper)hsreq;
		} else {
			request = new RequestWrapper(hsreq);
		}
		request.setEncoding(fromEncode, encode);
		
		if(this.excludes.matches(request)){
			chain.doFilter(request, response);
			return;
		}

		//初始化ContextHolder
		ContextHolder.init(request, response, sc);

		String currentTheme = request.getParameter(ThemeBindingManager.getThemeParamKey());
		if(StringUtils.isNotEmpty(currentTheme)) {
			ThemeBindingManager.setCurrentTheme(currentTheme);
		}
		
		chain.doFilter(request, response);
	}
	
	public void destroy() {
		this.excludes = null;
		this.sc = null;
	}
	
	public void setExcludes(String excludes) {
		if(excludes==null){
			excludes = "*.jpg,*.jsp,*.ico,*.css,*.html,*.png,*.js,*.gif,*.swf";
		}
		this.excludes = new RequestURIFilter(excludes);
	}
	
	/**
	 * 设置编码集。
	 */
	private void setCharacterEncoding(HttpServletRequest request, HttpServletResponse response, String encode) throws UnsupportedEncodingException{
		request.setCharacterEncoding(encode);
        response.setContentType("text/html; charset=" + encode);
	}

}
