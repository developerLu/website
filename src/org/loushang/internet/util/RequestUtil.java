package org.loushang.internet.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class RequestUtil {

	/**
	 * 解析请求的uri路径（不含参数）
	 * @param request
	 * @return
	 */
	public static String getRequestUrl(HttpServletRequest request) {
		String servletPath = request.getServletPath();
		String pathInfo = request.getPathInfo();
		if (servletPath == null)
			servletPath = "";
		if (pathInfo == null)
			pathInfo = "";
		servletPath = servletPath + pathInfo;
		if (servletPath.startsWith("/"))
			servletPath = servletPath.substring(1);
		return servletPath;
	}

	/**
	 * 获取指定参数的请求字符串
	 * @param request
	 * @param paramName
	 * @return
	 */
	public static String excludeQueryString(HttpServletRequest request, String paramName) {
		if(request == null) return "";
		String queryStr = request.getQueryString();
		if(StringUtils.isEmpty(paramName)) return queryStr;
		if(queryStr != null && !queryStr.isEmpty()) {
			String[] queryArr = queryStr.split("&");
			List<String> queryList = new ArrayList<String>();
			for (String str : queryArr) {
				if(str != null) {
					str = str.trim();
					if(str.indexOf(paramName) != 0) {
						queryList.add(str);
					}
				}
			}
			queryStr = "";
			for(int i=0; i<queryList.size(); i++) {
				String str = queryList.get(i);
				queryStr += str;
				if(i != queryList.size() - 1) {
					queryStr += "&";
				}
			}
		}
		return queryStr;
	}

	/**
	 * 判断当前请求是否是异步请求
	 * @param request
	 * @return
	 */
	public static boolean isAjaxQuery(HttpServletRequest request) {
		String action = request.getParameter("action");
		String method = request.getParameter("method");
		String curUri = getRequestUrl(request);
		String suffix = "";
		if (StringUtils.isEmpty(curUri)) {
			curUri = "index.";
		}

		if (curUri.indexOf(".") > -1) {
			suffix = curUri.substring(curUri.lastIndexOf(".") + 1);
		}

		if (StringUtils.isNotEmpty(action)
				|| ("do".equalsIgnoreCase(suffix) && StringUtils.isNotEmpty(method))) {
			return true;
		}
		return false;
	}
	
	/**
	 * 判断当前请求是否是widget请求
	 * @param request
	 * @return
	 */
	public static boolean isWidgetQuery(HttpServletRequest request) {
		String isWidgetStr = request.getParameter("isWidget");
		return "true".equalsIgnoreCase(isWidgetStr);
	}
	
	/**
	 * 判断当前请求是否是静态资源文件请求
	 * @param request
	 * @return
	 */
	public static boolean isResourceQuery(HttpServletRequest request) {
		if(request != null) {
			String uri = request.getRequestURI();
			if(uri != null) {
				int suffixPos = uri.lastIndexOf(".");
				if(suffixPos > -1) {
					String suffix = uri.substring(suffixPos).toLowerCase();
					if(".js".equals(suffix) || ".css".equals(suffix) 
						|| ".jpg".equals(suffix) || ".png".equals(suffix) || ".gif".equals(suffix) 
						|| ".eot".equals(suffix) || ".woff".equals(suffix) || ".ttf".equals(suffix) || ".svg".equals(suffix) 
						|| ".ico".equals(suffix) || ".swf".equals(suffix)) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * 判断当前请求是否是html文件请求
	 * @param request
	 * @return
	 */
	public static boolean isHtmlQuery(HttpServletRequest request) {
		if(request != null) {
			String uri = request.getRequestURI();
			if(uri != null) {
				int suffixPos = uri.lastIndexOf(".");
				if(suffixPos > -1) {
					String suffix = uri.substring(suffixPos).toLowerCase();
					if(".html".equals(suffix)) {
						return true;
					}
				}
			}
		}
		return false;
	}

	/**
	 * 判断当前请求是否是jsp文件请求
	 * @param request
	 * @return
	 */
	public static boolean isJspQuery(HttpServletRequest request) {
		if(request != null) {
			String uri = request.getRequestURI();
			if(uri != null) {
				int suffixPos = uri.lastIndexOf(".");
				if(suffixPos > -1) {
					String suffix = uri.substring(suffixPos).toLowerCase();
					if(".jsp".equals(suffix)) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * 解析URL中参数，将其转换为Map
	 * @param url
	 * @return
	 */
	public static Map<String, Object> parseParameterMap(String url) {
		if(url == null) return null;
		Map<String, Object> parameterMap = null;
		
		int paramIndex = url.lastIndexOf("?");
		if(paramIndex > -1) {
			String paramsStr = url.substring(paramIndex+1);
			if(paramsStr != null) {
				String[] paramsArr = paramsStr.split("&");
				for(String paramStr : paramsArr) {
					String[] paramArr = paramStr.split("=");
					if(paramArr != null && paramArr.length > 0) {
						String name = paramArr[0];
						String value = null;
						if(paramArr.length > 1) {
							value = paramArr[1];
						}
						if(parameterMap == null) {
							parameterMap = new HashMap<String, Object>();
						}
						String[] values = new String[]{value};
						if(parameterMap.containsKey(name)) {
							Object paramObj = parameterMap.get(name);
							String[] paramValues = null;
							if(paramObj != null) {
								if(paramObj instanceof String[]) {
									paramValues = (String[]) paramObj;
								} else if(paramObj instanceof String) {
									paramValues = new String[]{(String) paramObj};
								} else {
									paramValues = new String[]{String.valueOf(paramObj)};
								}
							}
							values = ArrayUtils.concat(paramValues, values, String.class);
						}
						parameterMap.put(name, values);
					}
				}
			}
		}
		
		return parameterMap;
	}

	/**
	 * 为url添加isWidget参数
	 * @param url
	 * @return
	 */
	public static String addWidgeParam(String url) {
		if(url == null) return null;
		Map<String, Object> paramMap = parseParameterMap(url);
		if(paramMap == null || !"true".equals(paramMap.get("isWidget"))) {
			int paramIndex = url.lastIndexOf("?");
			if(paramIndex > -1 && (paramIndex + 1) != url.length()) {
				url += "&isWidget=true";
			} else if((paramIndex + 1) == url.length()) {
				url += "isWidget=true";
			} else {
				url += "?isWidget=true";
			}
		}
		return url;
	}
	
}
