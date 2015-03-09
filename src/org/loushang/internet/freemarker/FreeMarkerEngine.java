package org.loushang.internet.freemarker;

import java.io.IOException;
import java.io.Writer;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.loushang.internet.freemarker.tags.CSRFTokenTag;
import org.loushang.internet.freemarker.tags.HeadTag;
import org.loushang.internet.freemarker.tags.HtmlTag;
import org.loushang.internet.freemarker.tags.MetaTag;
import org.loushang.internet.freemarker.tags.ScreenInclude;
import org.loushang.internet.freemarker.tags.ScriptTag;
import org.loushang.internet.freemarker.tags.StyleTag;
import org.loushang.internet.freemarker.tags.TitleTag;
import org.loushang.internet.freemarker.tags.WidgetTag;
import org.loushang.internet.util.el.Function;

import freemarker.ext.beans.BeansWrapper;
import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateHashModel;
import freemarker.template.TemplateModelException;

public class FreeMarkerEngine {
	private Configuration cfg = new Configuration();
	private static FreeMarkerEngine instance = null;
	private static TemplateHashModel FunctionStatics;
	private static Map<String,TemplateHashModel> CustomTags;
	private static TemplateDirectiveModel htmlTag;
	private static TemplateDirectiveModel headTag;
	private static TemplateDirectiveModel titleTag;
	private static TemplateDirectiveModel metaTag;
	private static TemplateDirectiveModel scriptTag;
	private static TemplateDirectiveModel styleTag;
	private static TemplateDirectiveModel screenHolderTag;
	private static TemplateDirectiveModel widgetTag;
	private static TemplateDirectiveModel CSRFTokenTag;
	
	public static boolean inited = false;
	
	public static FreeMarkerEngine getInstance(){
		if(instance==null){
			instance = new FreeMarkerEngine();
		}
		return instance;
		
	}
	public static void initConfig(ServletContext servletContext,String templateDir ){
		FreeMarkerEngine instance = getInstance();
		Configuration config = instance.cfg;
		config.setLocale(Locale.CHINA);
        config.setDefaultEncoding("utf-8");
        config.setEncoding(Locale.CHINA, "utf-8");  
        config.setClassicCompatible(true); //空值处理
        config.setNumberFormat("#"); //数字格式使用默认设置
        config.setWhitespaceStripping(true); //去除ftl标签周围的空白
        config.setServletContextForTemplateLoading(servletContext, templateDir);
        config.setObjectWrapper(new DefaultObjectWrapper()); 
		BeansWrapper wrapper = BeansWrapper.getDefaultInstance(); TemplateHashModel staticModels = wrapper.getStaticModels();
		try {
			FunctionStatics = (TemplateHashModel) staticModels.get("org.loushang.internet.util.el.Function");
			CustomTags = initCustomTags(staticModels);
			htmlTag = new HtmlTag();
			headTag = new HeadTag();
			titleTag = new TitleTag();
			metaTag = new MetaTag();
			scriptTag = new ScriptTag();
			styleTag = new StyleTag();
			screenHolderTag = new ScreenInclude();
			widgetTag = new WidgetTag();
			CSRFTokenTag = new CSRFTokenTag();
			inited = true;
		} catch (TemplateModelException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 添加自定义标签
	 * @param staticModels
	 * @return
	 * @throws TemplateModelException
	 */
	public static Map<String,TemplateHashModel> initCustomTags(TemplateHashModel staticModels) throws TemplateModelException {
		if(staticModels == null) return null;
		String cTagsStr = Function.getFrameConf("frame.ftltags");
		if(cTagsStr == null || "".equals(cTagsStr.trim())) {
			return null;
		}
		Map<String,TemplateHashModel> customTags = null;
		String[] ctags = cTagsStr.split(";");
		for(String ctag : ctags) {
			String[] ctagArr = ctag.split(":");
			if(ctagArr.length == 2) {
				String prefix = ctagArr[0];
				String _package = ctagArr[1];
				if(customTags == null) {
					customTags = new HashMap<String,TemplateHashModel>();
				}
				TemplateHashModel staticsFn = (TemplateHashModel) staticModels.get(_package);
				customTags.put(prefix, staticsFn);
			}
		}
		return customTags;
	}
	public void process(String template,HttpServletRequest request,HttpServletResponse response) throws IOException, TemplateException{
			/* 获取或创建模板*/
			Template temp = cfg.getTemplate(template);
			/* 获取数据模型 */
			Map<String,Object> root = processData(request);
			/* 将模板和数据模型合并 */
			Writer out = response.getWriter();
			temp.process(root, out);
			out.flush();
	}
	public void process(String template, HttpServletRequest request, Writer writer) throws IOException, TemplateException{
		/* 获取或创建模板*/
		Template temp = cfg.getTemplate(template);
		/* 获取数据模型 */
		Map<String,Object> root = processData(request);
		/* 将模板和数据模型合并 */
		temp.process(root, writer);
		writer.flush();
	}
	private Map<String,Object> processData(HttpServletRequest request) {
		/* 创建数据模型 */
		Map<String,Object> dataMap = new HashMap<String,Object>();
		//root.put("user", "Big Joe");
		dataMap.put("param",request.getParameterMap());
		
		if(CustomTags != null) {
			dataMap.putAll(CustomTags);
		}
		dataMap.put("fn", FunctionStatics);
		
		Map<String,TemplateDirectiveModel> ftlTags = new HashMap<String,TemplateDirectiveModel>();
		ftlTags.put("html", htmlTag);
		ftlTags.put("head", headTag);
		ftlTags.put("title", titleTag);
		ftlTags.put("meta", metaTag);
		ftlTags.put("script", scriptTag);
		ftlTags.put("style", styleTag);
		ftlTags.put("screenHolder", screenHolderTag);
		ftlTags.put("widget", widgetTag);
		ftlTags.put("CSRFToken", CSRFTokenTag);
		dataMap.put("website", ftlTags);

		//处理request内容
		Enumeration requestAttrs = request.getAttributeNames();
		Map<String,Object> requestMap = new HashMap<String,Object>();
        while(requestAttrs.hasMoreElements()){
        	String key = requestAttrs.nextElement().toString();
        	requestMap.put(key,request.getAttribute(key));
        	dataMap.put(key,request.getAttribute(key));
        }
        dataMap.put("requestScope", requestMap);
        
        //处理session内容
        HttpSession session = request.getSession();
        Enumeration sessionAttrs = session.getAttributeNames();
        Map<String,Object> sessionMap = new HashMap<String,Object>();
        while(sessionAttrs.hasMoreElements()){
        	String key = sessionAttrs.nextElement().toString();
        	sessionMap.put(key,session.getAttribute(key));
        	if(dataMap.get(key) == null) {
        		dataMap.put(key,session.getAttribute(key));
        	}
        }
        dataMap.put("sessionScope", sessionMap);
        return dataMap;
	}
}
