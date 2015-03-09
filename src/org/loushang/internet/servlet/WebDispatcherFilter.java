package org.loushang.internet.servlet;

import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.bindingclass.ModuleBindingManager;
import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.cache.CacheManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.freemarker.FreeMarkerEngine;
import org.loushang.internet.request.RequestWrapper;
import org.loushang.internet.response.BufferedResponseImpl;
import org.loushang.internet.response.header.Header;
import org.loushang.internet.tags.HeadTag;
import org.loushang.internet.util.ErrCodeUtil;
import org.loushang.internet.util.RequestURIFilter;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.TerminalTesting;

import freemarker.template.TemplateException;

public class WebDispatcherFilter implements Filter {

	private static Log log = LogFactory.getLog(WebDispatcherFilter.class);
	
    private FilterConfig filterConfig;
    
    private String encode;
    private String fromEncode;
	
	private RequestURIFilter excludes;
	
	public static String FREEMARKER_SUFFIX = ".ftl";
	public static String JSP_SUFFIX = ".jsp";
	
	private static List<String> uriChain = null;

	public void destroy() {
		this.filterConfig=null;
		this.excludes=null;

	}

	private ServletContext sc = null;
	public static String SCREEN_ATTRIBUTE_NAME = "_website_screen_name_";

	public void init(FilterConfig conf) throws ServletException {
		this.filterConfig = conf;
		String excludes =  this.filterConfig.getInitParameter("excludes");
		encode = conf.getInitParameter("encode");
		fromEncode = conf.getInitParameter("fromEncode");
		if(encode == null){
			encode="UTF-8";
		}
		if(fromEncode == null) {
			fromEncode = "ISO8859-1";
		}
		this.setExcludes(excludes);
		sc = conf.getServletContext();
		ModuleBindingManager.init();
		ThemeBindingManager.init();
		TerminalTesting.init();
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

		//对于请求，进行过滤判断。
		if(this.excludes.matches(request)){
			chain.doFilter(request, response);
			return;
		}

		if(RequestUtil.isResourceQuery(hsreq)) {
			//处理资源文件（css、js、图片、字体文件）请求
			doResourceFilter(request, response, chain);
		} if(RequestUtil.isHtmlQuery(hsreq)) {
			//处理html文件请求
			doHtmlFilter(request, response, chain);
		} if(RequestUtil.isJspQuery(hsreq)) {
			//处理jsp文件请求
			doJspFilter(request, response, chain);
		} else {
			//根据框架规则处理请求
			doFrameworkFilter(request,response,chain);
		}
	}
	
	private void doFrameworkFilter(RequestWrapper request, HttpServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		//是否是include方式
		boolean isInclude = request.isInclude();
		
		try {
			//获取当前的请求uri路径
			String uri = RequestUtil.getRequestUrl(request);
			//是否是widget请求
			String widget = request.getParameter("isWidget");
			
			if(isInclude) {
				//对于screen或者其他的include方式的，直接返回
				if(widget==null||!widget.equals("true")){
					chain.doFilter(request, response);
					return;
				}
			} else {
				//不是通过include的方式引入而是一般情况下的访问页面，则初始化ContextHolder
				ContextHolder.init(request, response, sc);
			}
			
			//处理widget请求
			if(widget != null && widget.equals("true")) {
				ModuleBindingManager moduleMgr = null;
				
				if(!isInclude){
					moduleMgr = ModuleBindingManager.getCurrentManager(uri, sc);
				}else{
					//moduleMgr = ModuleBindingManager.getCurrentManager();
					uri = (String) request.getAttribute("javax.servlet.include.servlet_path");
					moduleMgr = ModuleBindingManager.getManagerByWidgetPath(uri, sc);//做这个修改的原因是因为引用的widget可以使其他模块中的。			
					ContextHolder.setContextParameter(ContextHolder.KEY_REQUEST, request);
				}
				
				//执行对应的java类，提供数据服务
				moduleMgr.executeWidget(uri);
				
				if(!isInclude) {
					//如果不是通过include的方式访问widget，则根据uri获取对应模板
					String widgetPath = moduleMgr.getWidgetPath(uri);
					String suffix = StringUtils.getFileSuffix(widgetPath);
					
					if(JSP_SUFFIX.equals(suffix)) {
						doJspRender(request, response, widgetPath);
					} else if(FREEMARKER_SUFFIX.equals(suffix)) {
						doFreemakerRender(request, response, widgetPath);
					}
				} else {
					chain.doFilter(request, response);
				}
				return;
			}
			if("/".equals(uri)) {
				// 如果访问的是根目录，则做客户终端检测
				uri = TerminalTesting.getTerminalModule(request) + uri;
				if(!"/".equals(uri)) {
					int index = uri.indexOf(".");
					if(index != -1 && index < uri.indexOf("/") && !uri.startsWith("http://")) {
						uri = "http://" + uri;
					}
					response.sendRedirect(uri);
					return;
				}
			}
			
			//获取对应的模块管理类
			ModuleBindingManager moduleMgr = ModuleBindingManager.getCurrentManager(uri,sc);
			
			moduleMgr.executeAction(uri);
			//如果执行Action的时候发生跳转，或不需要渲染界面，则返回
			if(ContextHolder.getRunData().getIsRedirect()) {
				return;
			}
			
			moduleMgr.executeDoMethod(uri);
			//如果执行Action的时候发生跳转，或不需要渲染界面，则返回
			if(ContextHolder.getRunData().getIsRedirect() || !ContextHolder.getRunData().isCanRenderer()) {
				return;
			}
			//添加uri请求链
			addUriChain(uri);
			//重新获取模板信息
			if(ContextHolder.getRunData().getIsForward()) {
				//如果已发生forward跳转，则获取新的uri
				uri = ContextHolder.getRunData().getForwardUri();
				if(uriChain.contains(uri)) {
					request.setAttribute("errCode", ErrCodeUtil.ERR_ELLP);
					List<String> errReplacements = new ArrayList<String>();
					errReplacements.add("："+uri);
					request.setAttribute("errReplacements", errReplacements);
					ContextHolder.forwardErrUrl();
					return;
				} else {
					addUriChain(uri);
				}
			}
			
			//获取模板的上下文路径
			String screenPath = moduleMgr.getScreenPath(uri);
			
			String method = request.getMethod();
			//进行缓存判断
			if(method !=null && method.equals("GET") && moduleMgr.getAllowCache()){
				CacheManager cache = moduleMgr.getCacheManager();
				boolean iscache = cache.allowCache("screen/"+uri);
				if(iscache&&!isUpdate(request,response,cache)){
				//if(!isUpdate(request,response,cache)){
					return;
				}
			}

			String layoutPath = null, tplSuffix = null;
			
			do {
				if (screenPath == null) {
					// 如果找不到对应的Screen
					List<String> errReplacements = new ArrayList<String>();
					if(ContextHolder.getRunData().getIsForward()) {
						log.debug("内部跳转地址无对应的Screen文件:" + uri);
						request.setAttribute("errCode", ErrCodeUtil.ERR_NFSC);
					} else {
						log.debug("请求地址无对应的Screen文件:" + uri);
						request.setAttribute("errCode", ErrCodeUtil.ERR_NOSC);
					}
					errReplacements.add("："+uri);
					request.setAttribute("errReplacements", errReplacements);
					ContextHolder.forwardErrUrl();
					return;
				} else if(!ModuleBindingManager.getIsScreen(screenPath)) {
					// 如果查找不到对应的资源，那么就直接交给应用服务器处理。
					// throw new RuntimeException("访问的不是正确的Screen地址：" + screenUri);
					log.debug("访问的不是正确的Screen地址：" + screenPath);
					if(ContextHolder.getRunData().getIsForward() && !response.isCommitted()) {
						request.getRequestDispatcher(screenPath).forward(request, response);
					}
					return;
				}
				
				ContextHolder.getRunData().setIsForward(false);

				// 设置screen当前path
				request.setAttribute(SCREEN_ATTRIBUTE_NAME, screenPath);

				tplSuffix = StringUtils.getFileSuffix(screenPath);
				
				// 获取对应的布局path
				if(!ContextHolder.getRunData().getIsAsync()) {
					layoutPath = moduleMgr.getLayoutPath(screenPath, tplSuffix);
				}
				
				if(layoutPath != null) {
					//执行layout的处理类
					moduleMgr.executeLayout(layoutPath);
					// 如果执行Screen的时候发生跳转，或不需要渲染界面，则返回
					if(ContextHolder.getRunData().getIsRedirect()) {
						return;
					}
				}
				
				//执行对应的screen处理类
				moduleMgr.executeScreen(uri);
				
				// 如果执行Screen的时候发生跳转，或不需要渲染界面，则返回
				if(ContextHolder.getRunData().getIsRedirect()) {
					return;
				}
				
				if(ContextHolder.getRunData().getIsForward()) {
					//如果发生了forward跳转，则重新设置请求地址
					uri = ContextHolder.getRunData().getForwardUri();
					if(uriChain.contains(uri)) {
						request.setAttribute("errCode", ErrCodeUtil.ERR_ELLP);
						List<String> errReplacements = new ArrayList<String>();
						errReplacements.add("："+uri);
						request.setAttribute("errReplacements", errReplacements);
						ContextHolder.forwardErrUrl();
						return;
					} else {
						addUriChain(uri);
					}
					screenPath = moduleMgr.getScreenPath(uri);
				}
				
			// 如果发生了forward跳转，则继续执行Screen
			} while(ContextHolder.getRunData().getIsForward());
			
			// 如果找不到模板，那么就直接显示screen
			if (layoutPath == null) {
				layoutPath = screenPath;
			}
			
			request.setInclude(true);
			
			if(JSP_SUFFIX.equals(tplSuffix)) {
				doJspRender(request, response, layoutPath);
			} else if(FREEMARKER_SUFFIX.equals(tplSuffix)) {
				doFreemakerRender(request, response, layoutPath);
			}
		} catch (Exception t) {		
			request.setAttribute("jframe.exception", t);
			log.error("出错了：",t);
			if(!response.isCommitted()) {
				ContextHolder.forwardErrUrl();
			}
		} finally {
			//清空线程变量的数据
			if(!isInclude){
				ContextHolder.clear();
			}
		}
	}
	
	private void doJspRender(HttpServletRequest request,HttpServletResponse response,String templateUri) throws ServletException, IOException{
		//对response进行封装,目的是将jsp的输出放在缓存中，这样可以进行html的header的封装。
		BufferedResponseImpl responseWraper = new BufferedResponseImpl(response);
		ContextHolder.setContextParameter(ContextHolder.KEY_RESPONSE, responseWraper);
		
		//转向到布局对应的jsp。
		request.getRequestDispatcher(templateUri).forward(request, responseWraper);
		//处理header头部信息
		Header header = (Header) request.getAttribute(HeadTag.HEADER_NAME);
		StringWriter sw = new StringWriter();
		if(header!=null)
			header.write(sw,request);
		responseWraper.commitBuffer(sw.toString());
	}
	
	private void doFreemakerRender(HttpServletRequest request,HttpServletResponse response,String templateUri) throws ServletException, IOException{
		//对response进行封装,目的是将freemarker的输出放在缓存中，这样可以进行html的header的封装。
		BufferedResponseImpl responseWraper = new BufferedResponseImpl(response);
		ContextHolder.setContextParameter(ContextHolder.KEY_RESPONSE, responseWraper);
		//System.out.println(templateUrl+"doExcuteFreemaker");	
		//第一次加载模板，首先去云存储中获取模板，然后再存放在本地，就加载本地的文件。
		
		
		//在运行过程中，考虑推送，也就是云存储推送文件到本系统中，这个可以在mq中实现，目前不考虑，因为引入的技术太多了。
		
		
		try {
			if(!FreeMarkerEngine.inited) {
				FreeMarkerEngine.initConfig(sc, "/");
			}
			FreeMarkerEngine.getInstance().process(templateUri, request, responseWraper);
			//处理header头部信息
			Header header = (Header) request.getAttribute(HeadTag.HEADER_NAME);
			StringWriter sw = new StringWriter();
			if(header != null)
				header.write(sw,request);
			responseWraper.commitBuffer(sw.toString());
		} catch (TemplateException e) {
			// TODO Auto-generated catch block
			request.setAttribute("jframe.exception", e);
			log.error("出错了：",e);
			if(!response.isCommitted()) {
				ContextHolder.forwardErrUrl();
			}
		}
	}
	
	private void doResourceFilter(RequestWrapper request, HttpServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		//是否是include方式
		boolean isInclude = request.isInclude();
		
		try {
			String uri = RequestUtil.getRequestUrl(request);
			
			if(!isInclude) {
				//初始化ContextHolder
				ContextHolder.init(request, response, sc);
				
				//获取资源文件在项目中的上下文路径
				ModuleBindingManager moduleMgr = ModuleBindingManager.getCurrentManager(uri, sc);
				uri = moduleMgr.getResourceUrl() + uri;
				
				//按照主题规则获取文件路径
				String currentTheme = ThemeBindingManager.getCurrentTheme();
				uri = ThemeBindingManager.getTemplateUri(uri, currentTheme);
				
				//转向到对应的资源文件。
				request.getRequestDispatcher(uri).forward(request, response);
			}
			chain.doFilter(request, response);
		}catch (Exception t) {		
			request.setAttribute("jframe.exception", t);
			log.error("出错了：",t);
			if(!response.isCommitted()) {
				ContextHolder.forwardErrUrl();
			}
		} finally {
			if(!isInclude) {
				ContextHolder.clear();
			}
		}
	}

	private void doHtmlFilter(RequestWrapper request, HttpServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		//是否是include方式
		boolean isInclude = request.isInclude();

		try {
			String uri = RequestUtil.getRequestUrl(request);

			if(!isInclude) {
				//初始化ContextHolder
				ContextHolder.init(request, response, sc);
				//获取html文件上下文路径
				StringBuffer htmlUri = new StringBuffer();
				htmlUri.append(ThemeBindingManager.getThemePath()).append("/html/");
				if(uri.startsWith("/")) {
					uri = uri.substring(1);
				}
				htmlUri.append(uri);
				uri = htmlUri.toString();
				
				//按照主题规则获取文件路径
				String currentTheme = ThemeBindingManager.getCurrentTheme();
				uri = ThemeBindingManager.getTemplateUri(uri, currentTheme);
				
				//转向到对应的资源文件。
				request.getRequestDispatcher(uri).forward(request, response);
			}
			chain.doFilter(request, response);
		}catch (Exception t) {		
			request.setAttribute("jframe.exception", t);
			log.error("出错了：",t);
			if(!response.isCommitted()) {
				ContextHolder.forwardErrUrl();
			}
		} finally {
			if(!isInclude) {
				ContextHolder.clear();
			}
		}
	}
	
	private void doJspFilter(RequestWrapper request, HttpServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		//是否是include方式
		boolean isInclude = request.isInclude();

		try {
			String uri = RequestUtil.getRequestUrl(request);
			if(RequestUtil.isWidgetQuery(request) && !isInclude) {
				//如果是加载widget，并且include标记为false，则将其设为true，以兼容url方式请求的widget页面中引入其他widget的情况
				request.setInclude(true);
				isInclude = request.isInclude();
			}
			
			if(!isInclude) {
				//初始化ContextHolder
				ContextHolder.init(request, response, sc);
				
				//获取jsp文件上下文路径
				StringBuffer jspUri = new StringBuffer();
				jspUri.append(ThemeBindingManager.getThemePath()).append("/jsp/");
				if(uri.startsWith("/")) {
					uri = uri.substring(1);
				}
				jspUri.append(uri);
				uri = jspUri.toString();
				//按照主题规则获取文件路径
				String currentTheme = ThemeBindingManager.getCurrentTheme();
				uri = ThemeBindingManager.getTemplateUri(uri, currentTheme);
				
				//转向到对应的资源文件。
				request.getRequestDispatcher(uri).forward(request, response);
			} else {
				if(RequestUtil.isWidgetQuery(request)) {
					doFrameworkFilter(request, response, chain);
					return;
				}
			}
			chain.doFilter(request, response);
		} catch (Exception t) {		
			request.setAttribute("jframe.exception", t);
			log.error("出错了：",t);
			if(!response.isCommitted()) {
				ContextHolder.forwardErrUrl();
			}
		} finally {
			if(!isInclude) {
				ContextHolder.clear();
			}
		}
	}
	/**
	 * 设置编码集。
	 */
	private void setCharacterEncoding(HttpServletRequest request, HttpServletResponse response, String encode) throws UnsupportedEncodingException{
		request.setCharacterEncoding(encode);
        response.setContentType("text/html; charset=" + encode);
	}
	/**
	 * 打印请求的头信息
	 */
	public void printRequestInfo(HttpServletRequest request){
		Enumeration enums= request.getHeaderNames();
		log.debug("请求头信息");
		while(enums.hasMoreElements()){
			String name = (String) enums.nextElement();
			log.debug(name+":"+request.getHeader(name));
		}
		log.debug("请求头信息");
	}
	public void setExcludes(String excludes) {
		this.excludes = new RequestURIFilter(excludes);
	}
	/**
	 * 用于判断缓存是否更新
	 * @param request
	 * @param response
	 * @param cache
	 * @return
	 */
	private boolean isUpdate(HttpServletRequest request, HttpServletResponse response,CacheManager cache){
		String match = request.getHeader("if-none-match");
		if(match==null){
			Long time =  request.getDateHeader("if-modified-since");
			if(time>0)
				match = Long.toString(time);
		}
		String etag =getCurrentRequestEtag(request,cache);
		response.setHeader("Cache-Control", "max-age=0");
		long expire = System.currentTimeMillis() + 10000000;
		response.setDateHeader("Expires", expire);
		Long time = 0L;
		if(etag!=null&&!etag.trim().equals(""))time = Long.valueOf(etag);
		response.setDateHeader("Last-Modified", time);
		if(match!=null&&match.equals(etag)){
			response.setStatus(304);
			return false;
		}else{
			if(etag==null){
				//设置成新的etag
				etag  = setRequestEtag(request,cache);
				response.setDateHeader("Last-Modified", Long.valueOf(etag));
				if(match!=null){
					//这里需要添加一个判断，就是这个设置只执行一次。
					response.setDateHeader("Expires", 0);
					response.setDateHeader("Last-Modified", 0);
				}
			}		
			response.setHeader("Etag", etag);	
			
			return true;
		}
	} 
	/**
	 * 获取缓存中的信息。
	 * @param request
	 * @param cache
	 * @return
	 */
	private String getCurrentRequestEtag(HttpServletRequest request,CacheManager cache){
		String uri = "screen/"+request.getRequestURI()+"?"+request.getQueryString();
		String etag = cache.get(uri);
		return etag;
	}
	/**
	 * 如果缓存不存在，那么就清空缓存。
	 * @param request
	 * @param cache
	 * @return
	 */
	private String setRequestEtag(HttpServletRequest request,CacheManager cache){
		String uri = "screen/"+request.getRequestURI()+"?"+request.getQueryString();
		StringBuffer sb = new StringBuffer();
		sb.append(System.currentTimeMillis());
		sb.replace(sb.length()-3, sb.length(), "000");
		String etag =sb.toString();
		cache.put(uri, etag, 30000);
		return etag;
	}
	private static void addUriChain(String uri) {
		if(uri == null) return;
		if(uriChain == null) {
			uriChain = new ArrayList<String>();
		}
		if(uri.equals("") || uri.endsWith("/")){
			uri += "index.htm";
		}
		if(!uriChain.contains(uri)) {
			uriChain.add(uri);
		}
	}
	private static void clearUriChain() {
		if(uriChain != null) {
			uriChain = null;
		}
	}
}
