package org.loushang.internet.bindingclass;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.el.Function;

public class ThemeBindingManager {
	private static  Log log = LogFactory.getLog(ThemeBindingManager.class);
	
	public static final String THEME_KEY_CONF = "frame.theme";
	public static final String THEME_KEY_CACHE = "__curtheme__";
	public static final String THEME_ROOT = "/themes/";
	public static final String THEME_DEFAULT = "default";
	public static final String THEME_PARAM_KEY = "_THEME_";
	
	private static final String SUB_THEME_MARK = ".";
	
	private static String currentTheme = null;
	private static String curDefaultTheme = null;
	
	public static void init() {
		HttpServletRequest request = ContextHolder.getRequest();
		HttpSession session = null;
		if(request != null) {
			session = request.getSession();
			if(session != null) {
				currentTheme = (String) session.getAttribute(THEME_KEY_CACHE);
			}
		}
		if(currentTheme == null || "".equals(currentTheme)) {
			//session缓存中没有，则从配置文件中取
			currentTheme = Function.getFrameConf(THEME_KEY_CONF);
			if(currentTheme == null && "".equals(currentTheme)) {
				currentTheme = THEME_DEFAULT;
			}
			if(session != null) {
				session.setAttribute(THEME_KEY_CACHE, currentTheme);
			}
		}
		curDefaultTheme = currentTheme;
	}
	/**
	 * 获取当前主题
	 * @return
	 */
	public static String getCurrentTheme() {
		return currentTheme;
	}
	/**
	 * 设置当前主题
	 * @param currentTheme
	 */
	public static void setCurrentTheme(String curTheme) {
		if(curTheme == null || "".equals(curTheme)) {
			currentTheme = Function.getFrameConf(THEME_KEY_CONF);
		} else {
			currentTheme = curTheme;
		}
		HttpServletRequest request = ContextHolder.getRequest();
		if(request != null) {
			HttpSession session = request.getSession();
			if(session != null) {
				session.setAttribute(THEME_KEY_CACHE, currentTheme);
			}
		}
	}
	/**
	 * 判断当前主题是否是子主题，如主题cy.qingdao sn.qingdao等是子主题（qingdao的子主题），qingdao不是子主题
	 * @return 是则返回true，否则返回false
	 */
	public static boolean isSubTheme() {
		return isSubTheme(currentTheme);
	}
	/**
	 * 判断参数指定主题是否是子主题，如主题cy.qingdao sn.qingdao等是子主题（qingdao的子主题），qingdao不是子主题
	 * @param theme 主题名称
	 * @return 是则返回true，否则返回false
	 */
	public static boolean isSubTheme(String theme) {
		if(theme == null || "".equals(theme.trim())) {
			return false;
		}
		return theme.indexOf(SUB_THEME_MARK) > 0;
	}
	/**
	 * 获取当前主题的默认主题
	 * @return
	 */
	public static String getThemeDef() {
		return getThemeDef(currentTheme);
	}
	/**
	 * 获取参数指定主题的默认主题
	 * @param theme
	 * @return
	 */
	public static String getThemeDef(String theme) {
		if(theme == null || "".equals(theme.trim())) {
			return THEME_DEFAULT;
		}
		if(isSubTheme(theme)) {
			String parentTheme= theme.substring(theme.indexOf(SUB_THEME_MARK) + 1);
			return parentTheme;
		} else {
			return THEME_DEFAULT;
		}
	}
	/**
	 * 获取当前主题上下文路径
	 * @return
	 */
	public static String getThemePath() {
		return getThemePath(false);
	}
	/**
	 * 获取当前主题下的默认主题的上下文路径
	 * @return
	 */
	public static String getThemePathDef() {
		return getThemePath(true);
	}
	/**
	 * 获取参数指定主题下的默认主题的上下文路径（常用来获取子主题形式下的父主题）
	 * @param theme 主题名称
	 * @return
	 */
	public static String getThemePathDef(String theme) {
		return getThemePath(theme, true);
	}
	/**
	 * 获取主题上下文路径
	 * @param isDefault 是否使用默认主题
	 * @return
	 */
	private static String getThemePath(boolean isDefault) {
		return getThemePath(currentTheme, isDefault);
	}
	/**
	 * 获取参数指定的主题对应的主题上下文路径
	 * @param theme
	 * @param isDefault
	 * @return
	 */
	private static String getThemePath(String theme, boolean isDefault) {
		if(theme == null || "".equals(theme.trim())) {
			return THEME_ROOT + THEME_DEFAULT;
		}
		if(isSubTheme(theme) && isDefault) {
			String parentTheme= theme.substring(theme.indexOf(SUB_THEME_MARK) + 1);
			return THEME_ROOT + parentTheme;
		} else if(isDefault) {
			return THEME_ROOT + THEME_DEFAULT;
		}
		return THEME_ROOT + theme;
	}
	/**
	 * 获取当前的默认主题（记录递归查找模板文件时的当前默认主题）
	 * @return
	 */
	public static String getCurDefaultTheme() {
		return curDefaultTheme;
	}
	/**
	 * 设置当前的默认主题
	 * @return
	 */
	public static void setCurDefaultTheme(String _curDefaultTheme) {
		curDefaultTheme = _curDefaultTheme;
	}
	/**
	 * 获取当前的默认主题的上下文路径
	 * @return
	 */
	public static String getCurDefaultThemePath() {
		return THEME_ROOT + curDefaultTheme;
	}
	/**
	 * 根据主题规则获取模板文件的上下文路径
	 * @return
	 */
	public static String getTemplateUri(String uri, String currentTheme) {
		return getTemplateUri(uri, currentTheme, uri, 0);
	}
	
	private static String getTemplateUri(String uri, String currentTheme, String uriOrg, int level) {
		if(uri == null || "".equals(uri.trim())) {
			return "";
		}
		String uriNoParams = uri;
		//解析参数
		int paramsPos = uri.lastIndexOf("?");
		String params = "";
		if(paramsPos > -1) {
			params = uri.substring(paramsPos);
			uriNoParams = uri.substring(0, paramsPos);
		}
		//解析后缀名
		int suffixPos = uriNoParams.lastIndexOf(".");
		String suffix = null;
		if(suffixPos > -1) {
			suffix = uriNoParams.substring(suffixPos);
		}
		
		if(ContextHolder.isFileExist(uri, suffix)) {
			//递归出口: 当前主题下存在模板文件
			setCurDefaultTheme(currentTheme);
			return uri;
		} else if(level > 100 || THEME_DEFAULT.equals(currentTheme)) {
			//递归出口: 如果递归超过100层【或】当前主题已经是最上层的默认主题
			if(ContextHolder.isFileExist(uri, suffix)) {
				setCurDefaultTheme(currentTheme);
				return uri;
			} else {
				setCurDefaultTheme(getCurrentTheme());
				log.debug("不存在" + uriOrg + "的资源");
				return null;
			}
		} else {
			//如果当前主题下不存在模板文件，则在默认主题下找
			String themePath = THEME_ROOT + currentTheme, themeDef = getThemeDef(currentTheme);
			String themePathDef = THEME_ROOT + themeDef;
			String uriDef = uri.replaceAll(themePath, themePathDef);
			return getTemplateUri(uriDef, themeDef, uriOrg, level + 1);
		}
	}
	/**
	 * 获取运行时设置主题的参数名
	 * @return
	 */
	public static String getThemeParamKey() {
		String paramKey = Function.getFrameConf("frame.theme.paramKey");
		if(StringUtils.isEmpty(paramKey)) {
			paramKey = THEME_PARAM_KEY;
		}
		return paramKey;
	}
	/**
	 * 去除路径参数中的主题上下文
	 * @param path
	 * @return
	 */
	public static String stripThemePath(String path) {
		if(path == null) return null;
		String curThemePath = getThemePath();
		if(path.indexOf(curThemePath) > -1) {
			path = path.replaceAll(curThemePath, "");
		} else {
			String curThemePathDef = getCurDefaultThemePath();
			if(path.indexOf(curThemePathDef) > -1) {
				path = path.replaceAll(curThemePathDef, "");
			}
		}
		if(path.startsWith("/")) {
			path = path.substring(1);
		}
		return path;
	}
}
