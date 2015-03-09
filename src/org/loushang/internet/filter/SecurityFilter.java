package org.loushang.internet.filter;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.request.RequestWrapper;
import org.loushang.internet.util.ErrCodeUtil;
import org.loushang.internet.util.JsonUtils;
import org.loushang.internet.util.RequestURIFilter;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;

import com.inspur.common.utils.PropertiesUtil;
import org.loushang.internet.filter.login.LoginFilterUtil;

/**
 * URL过滤器
 * @author jinzk
 * 防止sql注入、url跨站攻击
 */
public class SecurityFilter implements Filter {
	
	private static Logger log = Logger.getLogger(SecurityFilter.class);
	private String encode = null;
	private String fromEncode = null;
	private ServletContext sc = null;
	private RequestURIFilter excludes;
	//需要过滤的字符，可放在xml文件中，也可以放在本class中
	// "|\\\\r|\\\\n|\\\\t|\\\\f|\\\\v"
	private String xss = "(((%3D)|(=))[^\n]*((%27)|(')|(--)|(%3B)|(:)|(%23)|(#)))|(\\w*((%27)|('))((%6F)|o|(%4F))((%72)|r|(%52)))|(exec((\\s)|(%20))+(s|x)p\\w+)|((<|%3c)/?(script|iframe|frame|body))|(set-cookie)|(src=(\'|\")javascript:)";
	private Pattern xssPattern = null;
	
	public void destroy() {

	}

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
		// 初始化非法字符集  优先取用配置文件中的参数配置
		String _xss = PropertiesUtil.getValue("frame.properties", "global.xss");
		if(StringUtils.isNotEmpty(_xss)) {
			xss = _xss;
			xssPattern = Pattern.compile(xss,Pattern.CASE_INSENSITIVE);
		}
	}
	public void setExcludes(String excludes) {
		if(excludes==null){
			excludes = "*.jpg,*.jsp,*.ico,*.css,*.html,*.png,*.js,*.gif,*.swf";
		}
		this.excludes = new RequestURIFilter(excludes);
	}

	@SuppressWarnings("unchecked")
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
		if(!LoginFilterUtil.needSecurity(request)){
			chain.doFilter(request, response);
			return;
		}

		//初始化ContextHolder
		ContextHolder.init(request, response, sc);

		//获取所有请求的参数名
		Enumeration<String> paramNames = request.getParameterNames();
		//组合所有的参数的值
//		StringBuffer illegalstr = new StringBuffer();
//		illegalstr.append(request.getRequestURI());
		while(paramNames.hasMoreElements()) {
			String paramName = paramNames.nextElement();
			String[] paramValues = request.getParameterValues(paramName);
			for(String paramValue : paramValues) {
				if(validateXss(paramValue)) {
					String errCode = ErrCodeUtil.ERR_XSS;
					String errInfo = ErrCodeUtil.getErrInfo(errCode);
					log.error(errInfo + "：" + paramValue);
					if(RequestUtil.isAjaxQuery(request)) {
						response.setStatus(500);
						Map<String,Object> result = new HashMap<String,Object>();
						result.put("errCode", errCode);
						result.put("errInfo", errInfo);
						response.getWriter().write(JsonUtils.convertToString(result));
					} else {
						request.setAttribute("errCode", errCode);
						ContextHolder.forwardErrUrl();
					}
					return;
				}
			}
		}
		
		chain.doFilter(req,res);
//		//非法参数处理
//		if(URLFilter.illegalValidate(illegalstr.toString())) {
//			String errCode = ErrCodeUtil.ERR_XSS;
//			String errInfo = ErrCodeUtil.getErrInfo(errCode);
//			log.error(errInfo + "：" + illegalstr.toString());
//			if(RequestUtil.isAjaxQuery(request)) {
//				response.setStatus(500);
//				Map<String,Object> result = new HashMap<String,Object>();
//				result.put("errCode", errCode);
//				result.put("errInfo", errInfo);
//				response.getWriter().write(JsonUtils.convertToString(result));
//			} else {
//				request.setAttribute("errCode", errCode);
//				request.getRequestDispatcher(Function.getErrUrl()).forward(request, response);
//			}
//			return;
//		} else {
//			chain.doFilter(arg0,arg1);
//		}
	}
	
	/**
	 * 非法字符校验
	 * @param String illegalstr
	 * @return
	 */
	protected boolean validateXss(String illegalstr) {
//		illegalstr = illegalstr.toLowerCase();
		Matcher matcher = xssPattern.matcher(illegalstr);
		boolean isFind = matcher.find();
		if(isFind){
			log.error(illegalstr+"  中包含非法字符："+matcher.group());
		}
		return isFind;
//		System.out.println(illegalstr);
//		for(String badStr : illegalStr) {
//			System.out.println(badStr);
//			if(illegalstr.indexOf(badStr) >= 0 || illegalstr.indexOf(SecurityUtil.str2Hexstr(badStr, "%")) >= 0)	{
//				log.error(illegalstr+"  中包含非法字符："+badStr);
//				return true;
//			}
//		}
//		return false;
	}
	
	/**
	 * 设置编码集。
	 */
	private void setCharacterEncoding(HttpServletRequest request, HttpServletResponse response, String encode) throws UnsupportedEncodingException{
		request.setCharacterEncoding(encode);
        response.setContentType("text/html; charset=" + encode);
	}
}
