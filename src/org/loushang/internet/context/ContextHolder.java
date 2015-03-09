package org.loushang.internet.context;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.servlet.WebDispatcherFilter;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.crypto.MD5Utils;
import org.loushang.internet.util.el.Function;

public class ContextHolder {

	private static class OurContext extends ThreadLocal<Map> {
		protected Map initialValue() {
			return new HashMap();
		}
	}

	public static final String KEY_REQUEST = "_request_";
	public static final String KEY_RESPONSE = "_response_";
	public static final String KEY_SERVLET_CONTEXT = "_servletcontext_";
	public static final String KEY_RUNDATA = "_rundata_";
	public static final String KEY_REQUESTURI = "_requesturi_";

	private static OurContext context = new OurContext();
	
	/**
	 * 获取上下文的所有变量名称
	 * 
	 * @return
	 */
	public static Set keys() {
		return context.get().keySet();
	}

	/**
	 * 获取某个上下文参数
	 * 
	 * @param key
	 * @return
	 */
	public static Object get(Object key) {
		return context.get().get(key);
	}

	/**
	 * 设置某个上下文参数
	 * 
	 * @param key
	 *            参数名
	 * @param value
	 *            参数值
	 */
	public static void put(Object key, Object value) {
		context.get().put(key, value);
	}

	/**
	 * 清空上下文
	 */
	public static void clear() {
		context.remove();
	}

	/**
	 * 获取当前请求对象
	 * 
	 * @return
	 */
	public static HttpServletRequest getRequest() {
		return (HttpServletRequest) get(KEY_REQUEST);
	}

	/**
	 * 获取当前的Locale
	 * 
	 * @return
	 */
	public static Locale getLocale() {
		if (getRequest() != null)
			return getRequest().getLocale();
		return Locale.getDefault();
	}

	/**
	 * 获取当前响应对象
	 * 
	 * @return
	 */
	public static HttpServletResponse getResponse() {
		return (HttpServletResponse) get(KEY_RESPONSE);
	}

	/**
	 * 获取应用上下文
	 * 
	 * @return
	 */
	public static ServletContext getServletContext() {
		return (ServletContext) get(KEY_SERVLET_CONTEXT);
	}

	/**
	 * 获取用户请求的URL
	 * 
	 * @return
	 */
	public static String getRequestURI() {
		return (String) get(KEY_REQUESTURI);
	}
	
	/**
	 * 获取应用上下文的数据
	 * 
	 * @return
	 */
	public static RunData getRunData() {
		return (RunData) get(KEY_RUNDATA);
	}

	/**
	 * 初始化上下文
	 * 
	 * @param request
	 *            请求对象
	 * @param response
	 *            响应对象
	 * @param sc
	 */
	public static void init(HttpServletRequest request,
			HttpServletResponse response, ServletContext sc) {
		put(KEY_REQUEST, request);
		put(KEY_RESPONSE, response);
		put(KEY_SERVLET_CONTEXT, sc);
		
		put(KEY_REQUESTURI, request.getRequestURI());
		
		RunData rundata = new RunData(request, response, sc);
		put(KEY_RUNDATA, rundata);
		
	}
	
	
	/**
	 * 获取所有上下文参数的集合
	 * 
	 * @param name
	 *            上下文参数名称
	 */
	public static OurContext getAllContextParameter(){
		return context;
	}
	
	/**
	 * 设置某个上下文参数
	 * 
	 * @param obj
	 *            上下文参数值
	 * @param name
	 *            上下文参数名称
	 */
	public static void setContextParameter(String name,Object obj){
		context.get().put(name,obj);
	}

	/**
	 * 获取某个上下文参数
	 * 
	 * @param name
	 *            上下文参数名称
	 */
	public static Object getContextParameter(String name){
		return context.get().get(name);
	}
	
	/**
	 * 设置客户端url跳转，使用该方法代替response.sendRedirect()方法
	 * 
	 * @param url
	 * @throws IOException
	 */
	public static void sendRedirect(String url) throws IOException {
		getRunData().setIsRedirect(true);
		getResponse().sendRedirect(url);
	}

	/**
	 * 判断文件是否存在。
	 * 20140529修改，从ModuleBingdingManager类中转移到了ContextHolder类中，并改为了静态方法
	 * 20140429修改，添加了对其他格式文件的支持（以前只判断jsp文件是否存在）
	 * 20130620 修改，Windows下不区分大小写的问题（JSP区分大小写，所以可能会出现错误）
	 * 新修改的方式不如原来的方式效率高
	 * @param name 文件名（含路径）
	 * @param suffix 文件后缀（文件格式）
	 * @return
	 */
	public static boolean isFileExist(String name, String suffix) {
		/*
		String fileName = servletContext.getRealPath(name);
		File file = new File(fileName);
		return file.exists();
		*/
		ServletContext servletContext = getServletContext();
		if(servletContext == null) return false;
		//如果文件路径中包含参数，则去除参数
		int paramIndex = name.lastIndexOf("?");
		if(paramIndex >= 0) {
			name = name.substring(0, paramIndex);
		}
		
		if(suffix == null || suffix.isEmpty()) {
			//如果后缀名为空，则将name作为路径进行判断
			String pathName = servletContext.getRealPath(name);
			File path = new File(pathName);
			return path.exists();
		}
		
		int index = name.lastIndexOf("/");
		if(index < 0) return false;
		
		final String thisSuffix = suffix.startsWith(".") ? suffix : "." + suffix;
		
		String name2 = name.substring(0, index);
		
		if(index == name.length() - 1) {
			name = null;
		} else {
			name = name.substring(name.lastIndexOf("/")+1);
		}
		
		String fileName = servletContext.getRealPath(name2);
		File file = new File(fileName);
		
		boolean b = false;
		if(file.isDirectory()) {
			File[] files = file.listFiles(new FilenameFilter() {
				
				public boolean accept(File arg0, String arg1) {
					// TODO Auto-generated method stub
					return arg1.endsWith(thisSuffix);
				}
			});
			int len = files.length;
			for(int i=0; i<len; i++) {
				if(name.equals(files[i].getName())) {
					b = true;
					break;
				}
			}
		}
		return b;
	}
	
	/**
	 * 设置服务器端url跳转
	 * @param url
	 * @throws ServletException
	 * @throws IOException
	 */
	public static void forward(String url) throws ServletException, IOException {
		ContextHolder.getRunData().setForwardUri(url);
		ContextHolder.getRunData().setIsForward(true);
		//getRequest().getRequestDispatcher(url).forward(getRequest(), getResponse());
	}
	
	/**
	 * 跳转至错误处理页面
	 * @throws ServletException
	 * @throws IOException
	 */
	public static void forwardErrUrl() throws ServletException, IOException {
		String errUrl = ThemeBindingManager.getThemePath() + "/jsp/error.jsp"; 
		errUrl = ThemeBindingManager.getTemplateUri(errUrl, ThemeBindingManager.getCurrentTheme());
		HttpServletRequest request = getRequest();
		if(request != null) {
			//设置主题标记，处理浏览器缓存问题
			String currentTheme = ThemeBindingManager.getCurrentTheme();
			String themeMark = MD5Utils.md5(currentTheme);
			request.setAttribute("themeMark", themeMark);
			request.getRequestDispatcher(errUrl).forward(request, getResponse());
		} else {
			throw new ServletException("错误：未初始化ContextHolder！");
		}
	}
}
