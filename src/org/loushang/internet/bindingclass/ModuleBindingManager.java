package org.loushang.internet.bindingclass;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.cache.CacheExpressControl;
import org.loushang.internet.cache.CacheManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.el.Function;
import org.loushang.internet.util.sitemap.SitemapParser;

import com.inspur.common.utils.PropertiesUtil;

public class ModuleBindingManager {
	private static  Log log = LogFactory.getLog(ModuleBindingManager.class);
	private static Map<String,ModuleBindingManager> instances = new  HashMap<String,ModuleBindingManager>();
	private static ModuleBindingManager DEFAULTMANGER=null;
	private static String CONTEXTNAME = "_module_manger_";
	private static String VIEWPATH = "viewPath";
	private static String PACKAGE = "package";
	private static String CONTEXTPATH = "context";
	private static String MODULENAME = "moduleName";
	private static String ALLOWCACHE = "allowCache";
	private static String RESOURCEURL = "resource";
	private static String moduleFile = "modules.properties";
	
	private static String frameTemplate = null;
	
	private Map<String,Class<?>> storeMap = new HashMap<String,Class<?>>();
	private Map<String, String> prop = new HashMap<String, String>();
	private ServletContext servletContext = null;
	private CacheManager cacheManager = null;
	/*
	public ModuleBindingManager(String context,String viewPath,String packageName){
		this.context = context;
		this.viewPath = viewPath;
		this.packageName = packageName;
	}
	*/
	public static void init(){
		PropertiesUtil props = loadProperties();
		if (props != null) {
			Iterator<Object> it = props.getKeys().iterator();
			while (it.hasNext()) {
				String key = (String) it.next();
				//对于zookeeper使用的属性app.conf进行处理
				if("app.conf".equals(key)){
					continue;
				}
				
				String[] keys = key.split("\\.");
				if (keys.length >= 2) {
					ModuleBindingManager moduleMgr = instances.get(keys[0]);
					if (moduleMgr == null) {
						moduleMgr = new ModuleBindingManager();
						moduleMgr.setProp(MODULENAME, keys[0]);
						instances.put(keys[0], moduleMgr);
					}
					String value = props.getProperty(key);
					moduleMgr.setProp(keys[1], value);
					//知道类路径以后进行初始化
					if(keys[1].equals(PACKAGE)){
						moduleMgr.initScan();
					} else if(keys[1].equals(ALLOWCACHE)) {
						moduleMgr.initCacheManager();
					}else if(keys[1].equals(CONTEXTPATH)){
						if(value!=null&&(value.equals("")||value.equals("/"))){
							DEFAULTMANGER = moduleMgr;
						}
					}
					
				}
			}
		}
	}
	private static PropertiesUtil loadProperties() {
		InputStream in = ModuleBindingManager.class.getClassLoader().getResourceAsStream(moduleFile);
		if (in == null) {
			in = Thread.currentThread().getContextClassLoader().getResourceAsStream(moduleFile);
			if (in == null) {
				return null;
			}
		}	
		try {
			PropertiesUtil p = new PropertiesUtil();
			p.load(in);
			return p;
		} catch (IOException e) {
			log.error("", e);
		}
		return null;
	}
	public static ModuleBindingManager getManagerByModuleId(String id){
		ModuleBindingManager temp = instances.get(id);
		return temp;
	}
	public static ModuleBindingManager getManagerByWidgetPath(String path, ServletContext sc){
		ModuleBindingManager ret = null;
		if(path==null) return DEFAULTMANGER;
		path = ThemeBindingManager.stripThemePath(path);
		Iterator<String> it = instances.keySet().iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			ModuleBindingManager temp = instances.get(key);
			String viewPath = ThemeBindingManager.stripThemePath(temp.getViewPath());
			if(path.startsWith(viewPath)){
				ret= temp;
				break;	
			}
			
		}
		if(ret == null) ret = DEFAULTMANGER;
		return ret;
	}
	public static ModuleBindingManager getManagerByUri(String uri,ServletContext sc){
		ModuleBindingManager ret=null;
		String u= uri;
		if(u.startsWith("/")){
			 u=  uri.substring(1);
		}
		int index = u.indexOf("/");
		if(index>=0){
			u = u.substring(0,index);
		}else{
			u="";
		}
		Iterator<String> it = instances.keySet().iterator();
		while (it.hasNext()) {
			String key = (String) it.next();
			ModuleBindingManager temp = instances.get(key);
			String context =temp.getContext(); 
			if(context.equals(u)){
				ret= temp;
				break;	
			}
			
		}
		if(ret==null)ret = DEFAULTMANGER;
		return ret;
	}
	public static ModuleBindingManager getCurrentManager(String uri,ServletContext sc){
		ModuleBindingManager ret= getManagerByUri(uri,sc);
		ContextHolder.setContextParameter(CONTEXTNAME, ret);
		ret.servletContext = sc;
		return ret;
	}
	public static ModuleBindingManager getCurrentManager(){
		return (ModuleBindingManager) ContextHolder.get(CONTEXTNAME);
	}
	
	public void initScan(){
		ClassPathScanHandler handler = new ClassPathScanHandler();  
		storeMap = handler.getPackageAllClasses(this.prop.get(PACKAGE), true);
	}
	public void initCacheManager() {
		cacheManager = CacheExpressControl.getCacheManager(getModuleName());
		cacheManager.init(getModuleName(), getAllowCache());
	}
	
	/**
	 * 执行url对应类的方法
	 * @param uri
	 * @param method
	 */
	private void executeMethod(String uri, String method) {
		if(method == null || "".equals(method)) {
			return;
		}
		Class<?> cls = storeMap.get(getClassKey(uri));
		//log.error("ceshi+++++++：：：：：：url:"+url+"    class"+cls+"    viewpath:"+this.getViewPath()+"    classkey:"+getClassKey(url));
		if(cls!=null){
			try {
				Object obj=cls.newInstance();		
				Method invokeMethod = null;
				try {
					// 获取带有request和response参数的方法
					invokeMethod = cls.getMethod(method, HttpServletRequest.class, HttpServletResponse.class);
					invokeMethod.invoke(obj, ContextHolder.getRequest(), ContextHolder.getResponse());
				} catch(NoSuchMethodException e) {
					// 如果带有request和response参数的方法为空，则获取不带参数的方法
					invokeMethod = cls.getMethod(method);
					invokeMethod.invoke(obj);
				}
			} catch (Throwable e) {
				NoClassDefFoundError dd;
				Throwable t = e;
				if(e.getCause()!=null)t = e.getCause();
				if(e.getCause()!=null)t = e.getCause();			
				throw new RuntimeException(t);
			}
		}
	}
	
	public void executeAction(String uri) {
		uri = preClassPath(uri, "screen/");
		executeMethod(uri, ContextHolder.getRunData().getAction());
	}
	
	public void executeDoMethod(String uri) {
		uri = preClassPath(uri, "screen/");
		executeMethod(uri, ContextHolder.getRunData().getRequestMethod());
	}
	
	public void executeScreen(String uri) {
		// 20130527 去掉框架内的站点地图，该功能不常用
		//parseSitemap(url);
		if(getIsScreen(uri)) {
			int pos = uri.lastIndexOf("/screen/");
			if(pos > -1) {
				uri = uri.substring(pos+1);
			}
		} else {
			uri = preClassPath(uri, "screen/");
		}
		executeMethod(uri, "execute");
	}

	public void executeWidget(String uri){
		if(getIsWidget(uri)) {
			int pos = uri.lastIndexOf("/widget/");
			if(pos > -1) {
				uri = uri.substring(pos+1);
			}
		} else {
			uri = preClassPath(uri, "widget/");
		}
		executeMethod(uri, "execute");
	}

	public void executeLayout(String uri){
		if(getIsLayout(uri)) {
			int pos = uri.lastIndexOf("/layout/");
			if(pos > -1) {
				uri = uri.substring(pos+1);
			}
		} else {
			uri = preClassPath(uri, "layout/", "default");
		}
		executeMethod(uri, "execute");
	}
	
	private String preClassPath(String uri, String pre) {
		return preClassPath(uri, pre, null);
	}
	
	private String preClassPath(String uri, String pre, String def) {
		if(def == null || "".equals(def)) {
			def = "index";
		}
		//去掉虚假的内部context
		String interContext = this.getContext();
		if(interContext != null && !interContext.equals("")){
			uri = uri.substring(interContext.length() + 1);
		}
		if(uri.equals("") || uri.endsWith("/")){
			uri += def + ".htm";
		}
		// 进行组装
		StringBuffer sb = new StringBuffer();
		sb.append(pre);
		sb.append((uri.startsWith("/") ? uri.substring(1) : uri));
		
		return sb.toString();
	}
	
	/**
	 * 获取对应的screen的真实的地址。
	 */
	public String getScreenPath(String uri) {
		return replaceToPath(uri, "screen/");
	}
	
	/**
	 * 获取对应的widget的真实的地址。
	 */
	public String getWidgetPath(String uri) {
		return replaceToPath(uri, "widget/");
	}
	
	/**
	 * 将请求uri替换为真实的上下文路径
	 * 
	 * @param uri
	 * 			请求的uri路径
	 * @param tag
	 * 			模板文件的标记，layout、screen、widget
	 * @return String
	 */
	private String replaceToPath(String uri, String tag) {
		String viewPath = this.getViewPath();
		//对url进行处理，去掉虚假的内部context
		String interContext = this.getContext();
		if(interContext!=null&&!interContext.equals("")){
			uri = uri.substring(interContext.length()+1);
		}
		//默认页面
		if(uri.equals("")||uri.endsWith("/")){
			uri += "index.htm";
		}
		//如果uri为空或者uri不是有效的文件路径，则返回null
		if(uri.lastIndexOf(".") == -1 || (uri.lastIndexOf(".") + 1) == uri.length()) {
			return null;
		}
		//进行组装
		StringBuffer sb = new StringBuffer();
		sb.append(viewPath);
		sb.append(tag);
		sb.append((uri.startsWith("/") ? uri.substring(1) : uri));
		uri = sb.toString();
		//根据主题规则获取模板文件
		String path = null;
		String[] suffixArr = getTemplateSx();
		String currentTheme = ThemeBindingManager.getCurrentTheme();
		int i = 0;
		do {
			sb = new StringBuffer(uri);
			//替换后缀
			int len = sb.lastIndexOf(".");
			if (len > 0) {
				sb = sb.delete(len, sb.length());
				sb.append(suffixArr[i]);
			}
			i++;
			path = ThemeBindingManager.getTemplateUri(sb.toString(), currentTheme);
		} while (path == null && i < suffixArr.length);
		return path;
	}
	
	/**
	 * 获取模板所有允许的后缀名
	 * @return
	 */
	public static String[] getTemplateSx() {
		if(frameTemplate == null) {
			frameTemplate = Function.getFrameConf("frame.template");
		}
		String[] suffixArr = {".jsp"};
		if(StringUtils.isEmpty(frameTemplate)) {
			frameTemplate = "";
			return suffixArr;
		}
		suffixArr = frameTemplate.split(",");
		for(int i = 0; i < suffixArr.length; i++) {
			String suffix = suffixArr[i];
			if(!suffix.startsWith(".")) {
				suffixArr[i] = "." + suffix;
			}
		}
		return suffixArr;
	}
	
	/**
	 * 获取相应的布局文件的上下文路径
	 */
	public String getLayoutPath(String uri, String suffix) {
		return this.getLayoutPath(uri, suffix, null, 0);
	}
	
	private String getLayoutPath(String uri, String suffix, String currentTheme, int level) {
		//模板文件的位置
		String layoutPath = null;
		
		//获取主题相关信息
		if(currentTheme == null || "".equals(currentTheme.trim())) {
			currentTheme = ThemeBindingManager.getCurrentTheme();
		}
		String curThemePath = ThemeBindingManager.THEME_ROOT + currentTheme;
		String curThemePathDef = ThemeBindingManager.getCurDefaultThemePath();
		
		if(uri.indexOf(curThemePath) > -1 || uri.indexOf(curThemePathDef) > -1) {
			//根据screen上下文路径获取layout路径
			if(level < 1 && uri.indexOf(curThemePathDef) > -1) {
				//首先找当前主题下的模板页面
				uri = uri.replaceAll(curThemePathDef, curThemePath);
			}
			// 根据screenUrl的，来获取模板所在的位置
			layoutPath = uri.replace("/screen/", "/layout/");
		} else {
			//如果uri中未包含主题路径，则添加上主题路径
			layoutPath = curThemePath + "/layout/";
			if(uri.startsWith("/")) {
				uri = uri.substring(1);
			}
			//对uri进行处理，去掉虚假的内部context
			String interContext = this.getContext();
			if(interContext!=null&&!interContext.equals("")){
				uri = uri.substring(interContext.length()+1);
			}
			if(uri.equals("") || uri.endsWith("/")){
				uri += "default" + (suffix.startsWith(".") ? suffix : "." + suffix);
			}
			layoutPath += uri;
		}
		
		// 和screen重名的模板
		if (ContextHolder.isFileExist(layoutPath, suffix)) {
			return layoutPath;
		} else {
			// 寻找默认的模板
			String layoutUri = layoutPath;
			do {
				layoutUri = layoutUri.substring(0, layoutUri.lastIndexOf("/"));
				layoutPath = layoutUri + "/default" + suffix;
				if(ContextHolder.isFileExist(layoutPath,suffix)) {
					return layoutPath;
				}
			} while(!layoutUri.endsWith("/layout"));
			// 未找到模板页面
			if(level > 100 || curThemePath.equals(ThemeBindingManager.THEME_ROOT + ThemeBindingManager.THEME_DEFAULT)) {
				// 如果已递归调用100层【或】当前查找主题已经是最上层的默认主题
				return null;
			} else if(uri.indexOf(curThemePath) > -1) {
				// 在默认主题下找
				curThemePathDef = ThemeBindingManager.getThemePathDef(currentTheme);
				uri = uri.replaceAll(curThemePath, curThemePathDef);
				return getLayoutPath(uri, suffix, ThemeBindingManager.getThemeDef(currentTheme), level + 1);
			}
			return null;
		}
	}
	
	/**
	 * 解析用户当前位置
	 * @param url
	 */
	public void parseSitemap(String url) {
		ContextHolder.getRequest().setAttribute(
				"sitemap", SitemapParser.select(getModuleName(), url));
	}
	
	/**
	 * 获取缓存管理对象
	 * @return
	 */
	public CacheManager getCacheManager() {
		if(cacheManager == null) {
			initCacheManager();
		}
		return cacheManager;
	}
	
	private String getClassKey(String path) {
		String keySx = path;
		keySx = keySx.substring(0, keySx.lastIndexOf("."));
		keySx = keySx.replaceAll("/", ".");
		keySx = keySx.toLowerCase();
		//加上主题前缀
		String curTheme = ThemeBindingManager.getCurrentTheme();
		boolean isDefaultTheme = false;
		StringBuffer key = null;
		do {
			key = new StringBuffer();
			isDefaultTheme = ThemeBindingManager.THEME_DEFAULT.equals(curTheme);
			if(isDefaultTheme) {
				//如果是默认主题，则不添加主题前缀
				key.append(keySx);
			} else {
				StringBuffer keyPx = new StringBuffer();
				if(ThemeBindingManager.isSubTheme(curTheme)) {
					//当前主题是子主题
					keyPx = keyPx.append(curTheme.replaceAll("\\.", "_"));
				} else {
					keyPx.append(curTheme);
				}
				if(key.length() > 0) {
					key.delete(0, key.length());
				}
				key.append(keyPx).append(".").append(keySx);
			}
			curTheme = ThemeBindingManager.getThemeDef(curTheme);
		} while (storeMap.get(key.toString()) == null && !isDefaultTheme);
		return key.toString();
	}
	
	public static Boolean getIsScreen(String path) {
		return path != null && (path.indexOf("/screen/") > -1);
	}
	
	public String stripScreenPath(String path) {
		String uri = null;
		if(getIsScreen(path)) {
			int pos = path.indexOf("/screen/") + 8;
			uri = path.substring(pos);
			//加上模块内部的context
			String interContext = this.getContext();
			if(interContext != null && !interContext.equals("")){
				uri = interContext + "/" + uri;
			}
		}
		return uri;
	}

	public static Boolean getIsWidget(String path) {
		return path != null && (path.indexOf("/widget/") > -1);
	}

	public String stripWidgetPath(String path) {
		String uri = null;
		if(getIsWidget(path)) {
			int pos = path.indexOf("/widget/") + 8;
			uri = path.substring(pos);
			//加上模块内部的context
			String interContext = this.getContext();
			if(interContext != null && !interContext.equals("")){
				uri = interContext + "/" + uri;
			}
		}
		return uri;
	}

	public static Boolean getIsLayout(String path) {
		return path != null && (path.indexOf("/layout/") > -1);
	}

	public String stripLayoutPath(String path) {
		String uri = null;
		if(getIsLayout(path)) {
			int pos = path.indexOf("/layout/") + 8;
			uri = path.substring(pos);
			//加上模块内部的context
			String interContext = this.getContext();
			if(interContext != null && !interContext.equals("")){
				uri = interContext + "/" + uri;
			}
		}
		return uri;
	}

	public void setProp(String key,String value){
		this.prop.put(key, value);
	}
	public String getModuleName() {
		return this.prop.get(MODULENAME);
	}
	/**
	 * 获取当前主题下访问页面的上下文路径
	 * @return
	 */
	public String getViewPath(){
		String viewPath = this.prop.get(VIEWPATH);
		if(viewPath == null) viewPath = "";
		if(!viewPath.startsWith("/")) {
			viewPath = "/" + viewPath;
		}
		if(!viewPath.endsWith("/")) {
			viewPath = viewPath + "/";
		}
		return ThemeBindingManager.getThemePath() + viewPath;
	}
	public String getContext(){
		return this.prop.get(CONTEXTPATH);
	}
	/**
	 * 获取当前主题下资源文件的上下文路径
	 * @return
	 */
	public String getResourceUrl() {
		String resourceUrl = this.prop.get(RESOURCEURL);
		if(resourceUrl == null || resourceUrl.isEmpty()) {
			resourceUrl = "/skins";
		}
		if(!resourceUrl.startsWith("/")) {
			resourceUrl = "/" + resourceUrl;
		}
		if(!resourceUrl.endsWith("/")) {
			resourceUrl = resourceUrl + "/";
		}
		return ThemeBindingManager.getThemePath() + resourceUrl;
	}
	
	public String getProperties(String name) {
		return this.prop.get(name);
	}
	
	/**
	 * 是否允许缓存
	 * @return
	 */
	public boolean getAllowCache() {
		return "true".equals(this.prop.get(ALLOWCACHE));
	}
	
}
