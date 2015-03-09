package org.loushang.internet.util.el;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.bindingclass.ModuleBindingManager;
import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.crypto.MD5Utils;

import com.inspur.common.utils.PropertiesUtil;

public class Function {
	private static String appContext;
	
	// 应用的地址
	private static String appRootUrl;
	private static String appRootUrl_https;
	// 静态文件的地址
	private static String rootUrl;
	
	private static String fileUrl;
	
	private static String skinName = "/build/skins";
	private static String CONTENT_IMAGE_PREFIX = "images/etravel";
	private static boolean isInit = false;
	
	private static String serverName;

	/**
	 * 构造方法，如果是开发模式，那么就从request中获取，否则从配置文件里面读取。
	 */
	public static void init() {
		// 可以从配置文件获取，或者使用请求进行组装。\
		HttpServletRequest request = ContextHolder.getRequest();
		appContext = request.getContextPath();
		
		ModuleBindingManager moduleMgr = ModuleBindingManager.getCurrentManager();
		
		String url = moduleMgr.getProperties("url");
		if(StringUtils.isEmpty(url)) {
			// 20130715 换成appRootUrl带上协议和域名（因为在Https的页面下，生成的URL也是Https，但应该是Http）
			if(!request.getServerName().equals(serverName)) {
				StringBuffer sb = new StringBuffer();
				sb.append("http://");
				sb.append(request.getServerName());
				if(!("80".equals(request.getServerPort()))) {
					sb.append(":");
					sb.append(request.getServerPort());
				}
				sb.append(appContext);
				appRootUrl = sb.toString();
				
				sb = new StringBuffer();
				sb.append("https://");
				sb.append(request.getServerName());
				sb.append(appContext);
				appRootUrl_https = sb.toString();
				
				serverName = request.getServerName();
			}
			
			// 2012-06-18修改获取url时，只取context，不带域名
			//appRootUrl = request.getContextPath();
		} else {
			appRootUrl = url;
			appRootUrl_https = appRootUrl.replaceFirst("http://", "https://");
		}
		
		rootUrl = moduleMgr.getResourceUrl();
		if(rootUrl == null || rootUrl.equals("")) {
			rootUrl = appContext + skinName;
		} else {
			rootUrl = appContext + rootUrl;
		}
		
		fileUrl = moduleMgr.getProperties("fileUrl");
		
		if(fileUrl == null || fileUrl.equals("")) {
			fileUrl = appContext;
		}
		
		isInit=true;
	}

	/**
	 * 获取对应的连接地址
	 */
	public static String getLink(String target) {
		if (!isInit) {
			init();
		}
		if(target == null || "".endsWith(target)) return "";
		target = target.replaceAll("\\.jsp", ".htm").replaceAll("\\.ftl", ".htm");
		String interContext = ModuleBindingManager.getCurrentManager()
				.getContext();
		
		if(interContext != null && !"".equals(interContext)) {
			interContext = "/" + interContext + "/";
		} else {
			interContext = "/";
		}
		
		String rootUrl = rewriteUrl(appRootUrl) + interContext;
		
		target = target.startsWith("/") ? target.substring(1) : target;
		return rootUrl + target;
	}
	
	public static String getOtherLink(String target){
		
		HttpServletRequest request = ContextHolder.getRequest();
		String appContext = request.getContextPath();
		String appRootUrl = null;
		ModuleBindingManager moduleMgr = ModuleBindingManager.getCurrentManager();
		
		String url = moduleMgr.getProperties("url");
		
		if(StringUtils.isEmpty(url)) {
			
			StringBuffer sb = new StringBuffer();
			sb.append("http://");
			sb.append(request.getServerName());
			/*if(!("80".equals(request.getServerPort()))) {
				sb.append(":");
				sb.append(request.getServerPort());
			}*/
			sb.append(appContext);
			appRootUrl = sb.toString();
		} else {
			appRootUrl = url;
		}
		
		target = target.replaceAll("\\.jsp", ".htm").replaceAll("\\.ftl", ".htm");
		
		String interContext = ModuleBindingManager.getCurrentManager()
				.getContext();

		if(interContext != null && !"".equals(interContext)) {
			interContext = "/" + interContext + "/";
		} else {
			interContext = "/";
		}
		
		String rootUrl = rewriteUrl(appRootUrl) + interContext;
		
		target = target.startsWith("/") ? target.substring(1) : target;
		return rootUrl + target;
	}
	
	/**
	 * 获取对应的连接地址，https协议
	 */
	public static String getHttpsLink(String target) {
		if (!isInit) {
			init();
		}
		target = target.replaceAll("\\.jsp", ".htm").replaceAll("\\.ftl", ".htm");
		String interContext = ModuleBindingManager.getCurrentManager()
				.getContext();

		if (target.startsWith("/")) {
			if (interContext != null && !"".equals(interContext)) {
				interContext = "/" + interContext;
			}
		} else {
			if (interContext != null && !"".equals(interContext)) {
				interContext = "/" + interContext + "/";
			} else {
				interContext = "/";
			}
		}
		return getLink(target);
	}
	
	
	public static String getCitySite(){
		HttpServletRequest request = ContextHolder.getRequest();
		String serverName = request.getServerName();
		String citySite = serverName.substring(0, serverName.indexOf("."));
		return citySite;
	}
	
	/**
	 * 获取一个url的内部访问地址
	 * @param target
	 * @return
	 */
	public static String getInnerLink(String target) {
		String viewPath = ModuleBindingManager.getCurrentManager().getViewPath();
		
		viewPath += "/screen/";
		/*
		if (!target.startsWith("/") && !viewPath.endsWith("/")) {
			viewPath = viewPath + "/";
		}*/
		String ret = viewPath + target;
		ret = ret.replaceAll("//", "/");
		return ret;
	}

	/**
	 * 获取首页
	 */
	public static String getHome() {
		if (!isInit) {
			init();
		}
		return appRootUrl;
	}
	
	/**
	 * 获取当前请求的URL
	 * @return
	 */
	public static String getCurrentUrl() {
		String uri = ContextHolder.getRequestURI();
		if(uri == null) return null;
		
		if (!isInit) {
			init();
		}
		
		int pos = uri.lastIndexOf(".");
		if(pos > -1) {
			String suffix = uri.substring(pos+1).toLowerCase();
			if(!"htm".equals(suffix)) {
				StringBuffer sb = new StringBuffer();
				sb.append(uri.substring(0, pos+1)).append("htm");
				if(suffix.startsWith("html")) {
					sb.append("html");
				} else if(suffix.startsWith("jsp")) {
					sb.append("jsp");
				} else if(suffix.startsWith("js")) {
					sb.append("js");
				} else if(suffix.startsWith("css") || suffix.startsWith("jpg") || suffix.startsWith("png") 
					|| suffix.startsWith("gif") || suffix.startsWith("ico") || suffix.startsWith("swf")) {
					sb.append(suffix.substring(0, 3));
				} else {
					sb.append("htm");
				}
				uri = sb.toString();
			}
		}
		
		String rootUrl = (uri.startsWith("http://") || uri.startsWith("https://")) ? appRootUrl : appContext;
		
		uri = uri.replaceAll(rootUrl, rewriteUrl(rootUrl));
		
		return uri;
	}
	
	/**
	 * 判断url是否是访问widget的url
	 * @param url
	 * @return
	 */
	public static boolean isWidgetUrl(String url) {
		if(url == null) return false;

		Map<String,Object> paramMap = RequestUtil.parseParameterMap(url);
		if(paramMap != null) {
			Object widgetValue = paramMap.get("isWidget");
			String isWidget = "";
			if(widgetValue != null) {
				if(widgetValue instanceof String[]) {
					String[] widgetValues = (String[]) widgetValue;
					if(widgetValues.length > 0) {
						isWidget = widgetValues[0];
					}
				} else {
					isWidget = String.valueOf(widgetValue);
				}
			}
			return "true".equalsIgnoreCase(isWidget);
		}
		
		return false;
	}
	
	/**
	 * 根据重写规则重写url
	 * 重写规则：
	 * #如 http://127.0.0.1:80/uc/index.htm?_PATH_=sn/100720 
	 * #重写后为
	 * #http://127.0.0.1:80/uc/sn/100720/htm/index.htm
	 * @param rootUrl
	 * @return
	 */
	private static String rewriteUrl(String rootUrl) {
		HttpServletRequest request = ContextHolder.getRequest();
		String frameRewrite = getFrameConf("frame.rewrite");
		rootUrl = (rootUrl == null) ? "" : rootUrl;
		rootUrl = rootUrl.endsWith("/") ? rootUrl.substring(0, rootUrl.length()-1) : rootUrl;
		StringBuffer sb = new StringBuffer(rootUrl);
		//是否开启了url重写
		if(("on".equalsIgnoreCase(frameRewrite) || "1".equalsIgnoreCase(frameRewrite))) {
			String pathParam = getFrameConf("frame.rewrite.pathmark");
			//获取重写的path
			String pathValue = request.getParameter(pathParam);
			if(pathValue != null && !"".equals(pathValue)) {
				//获取间隔符
				String rewritePath = pathValue.startsWith("/") ? pathValue.substring(1) : pathValue;
				rewritePath = rewritePath.endsWith("/") ? rewritePath.substring(0, rewritePath.length()-1) : rewritePath;
				sb.append("/").append(rewritePath);
				String spaceMark = getFrameConf("frame.rewrite.spacemark");
				spaceMark = StringUtils.isNotEmpty(spaceMark) ? spaceMark : "htm";
				//组装重写后的url的path
				sb.append("/").append(spaceMark);
			}
		}
		return sb.toString();
	}

	public static String getUrl(String url) {
		if (!isInit) {
			init();
		}
		if (url.startsWith("http://")) {
			return url;
		}

		StringBuffer resUrl = new StringBuffer(appContext);
		if(!url.startsWith("/")) {
			resUrl.append("/");
		}
		resUrl.append(url);
		if(resUrl.lastIndexOf(".") > -1) {
			//如果url是文件，则添加主题标记，处理浏览器缓存问题
			String currentTheme = ThemeBindingManager.getCurrentTheme();
			if(StringUtils.isNotEmpty(currentTheme)) {
				if(resUrl.lastIndexOf("?") > -1) {
					resUrl.append("&");
				} else {
					resUrl.append("?");
				}
				resUrl.append("t=").append(MD5Utils.md5(currentTheme));
			}
		}
		return resUrl.toString();
	}

	public static String getContentImage(String key, int width, int height) {
		String imageurl = null;
		// 返回默认图片路径
		if (key == null || "".equals(key)) {
			imageurl = getDefaultImage();
		} else {

			// 调用图片获取服务，并传递图片地址参数
			// 使用当前网站服务器的文件存储
			imageurl = getUrl(CONTENT_IMAGE_PREFIX + key);
		}
		return imageurl;
	}

	private static String getDefaultImage() {
		return getUrl("images/noimage.jpg");
	}
	
	public static String getFileUrl() {
		return fileUrl;
	}
	
	/**
	 * 根据key获取modules.properties中的值
	 */
	public static String getModuleValue(String key) {
		if (!isInit) {
			init();
		}
		return ModuleBindingManager.getCurrentManager().getProperties(key);
	}
	/**
	 * 根据key获取frame.properties中的值
	 * @param key
	 * @return
	 */
	public static String getFrameConf(String key) {
		return PropertiesUtil.getValue("frame.properties", key);
	}
}
