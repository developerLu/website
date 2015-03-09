package org.loushang.internet.filter.login;

import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.RequestURIFilter;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.inspur.common.utils.PropertiesUtil;

public class LoginFilterUtil {
	private static ApplicationContext context = null;
	
	public static boolean needSecurity(HttpServletRequest request){
		String uri = getCurUri(request);
		RequestURIFilter excludes = getSecurityExcludes();
		if( excludes != null && excludes.matches(uri)){
			return false;
		} else {
			return true;
		}
	}
	public static boolean needLogin(HttpServletRequest request){
		String uri = getCurUri(request);
		RequestURIFilter excludes = getExcludes();
		if( excludes != null && excludes.matches(uri)){
			return false;
		}
		return getIncludes().matches(uri);
	}
	public static boolean needLogin(){
		return needLogin(ContextHolder.getRequest());
	}
	public static RequestURIFilter getIncludes() {
		String includes = PropertiesUtil.getValue("login.properties","login.blackList");
		return new RequestURIFilter(includes);
	}
	public static RequestURIFilter getSecurityExcludes() {
		String excludes = PropertiesUtil.getValue("frame.properties","security.whiteList");
		if(excludes==null || excludes.isEmpty()){
			return null;
		}
		return new RequestURIFilter(excludes);
	}
	public static RequestURIFilter getExcludes() {
		String excludes = PropertiesUtil.getValue("login.properties","login.whiteList");
		if(excludes==null || excludes.isEmpty()){
			return null;
		}
		return new RequestURIFilter(excludes);
	}
	private static String getCurUri(HttpServletRequest request) {
		String action = request.getParameter("action");
		String method = request.getParameter("method");
		String curUri = RequestUtil.getRequestUrl(request);
		String suffix = "";
		// "" life/* life/ life life/index=life/index/
		// life/index.htm=life/index. life life/index/
		if (StringUtils.isEmpty(curUri)) {
			curUri = "index.";
		}

		if (curUri.indexOf(".") > -1) {
			suffix = curUri.substring(curUri.lastIndexOf(".") + 1);
			curUri = curUri.substring(0, curUri.lastIndexOf(".") + 1);
		} else if (!curUri.endsWith("/")) {
			curUri += "/";
		}
		
		if (action != null) {
			if(!"".equals(action))
				action = "act" + action.substring(0, 1).toUpperCase() + action.substring(1);
			curUri += curUri.endsWith(".") ? action : ("." + action);
		}
		if ("do".equalsIgnoreCase(suffix) && method != null) {
			if(!"".equals(method))
				method = "do" + method.substring(0, 1).toUpperCase() + method.substring(1);
			curUri += curUri.endsWith(".") ? method : ("." + method);
		}
		return curUri;
	}
	
	public static Object getBean(String beanId) {
		if(StringUtils.isEmpty(beanId)) return null;
		if(context == null) {
			context = new ClassPathXmlApplicationContext("conf/loginfilter.xml");
		}
		return context.getBean(beanId);
	}
	public static void main(String a[]){
		String u = "trade/index.";
		RequestURIFilter excludes = getExcludes();
		if(excludes!=null && excludes.matches(u)){
			System.out.println(false); ;
		}
		System.out.println(getIncludes().matches(u)); ;
	}
}
