package org.loushang.internet.tags;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.loushang.internet.bindingclass.ModuleBindingManager;
import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.cache.CacheManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.freemarker.FreeMarkerEngine;
import org.loushang.internet.request.RequestWrapper;
import org.loushang.internet.response.BufferedResponseImpl;
import org.loushang.internet.servlet.WebDispatcherFilter;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.el.Function;

import freemarker.template.TemplateException;

public class WidgetTag extends TagSupport {
	
	private String path;
	private String lazy;
	private String module;
	
	@Override
	public int doEndTag() throws JspException {
		ModuleBindingManager moduleMgr =null;
		if(module!=null&&!module.equals("")){
			moduleMgr = ModuleBindingManager.getManagerByModuleId(module);
		}else{
			moduleMgr= ModuleBindingManager.getCurrentManager();
		}
		String viewPath = moduleMgr.getViewPath();
		
		if("true".equals(lazy)) {
			try {
				// 添加isWidget参数
				path = RequestUtil.addWidgeParam(path);
				this.pageContext.getOut().write(getLazyTag(Function.getLink(path)));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return EVAL_PAGE;
		}
		path = "widget/" + path;
		
		String widgetPath = ThemeBindingManager.getTemplateUri(viewPath + path, ThemeBindingManager.getCurrentTheme());
		
		boolean iscache = false;
		CacheManager cache = null;
		if(moduleMgr.getAllowCache()) {
			cache = moduleMgr.getCacheManager();
			iscache = cache.allowCache(path);
		}
		String content = null;
		if(iscache) {
			// 从缓存中获取内容
			content = cache.get(path);
		}
		
		if(content != null) {
			try {
				this.pageContext.getOut().write(getCacheTag(path));
				this.pageContext.getOut().write(content);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			try {
				BufferedResponseImpl response = (BufferedResponseImpl) ContextHolder.getResponse();
				RequestWrapper request = (RequestWrapper) ContextHolder.getRequest();
				String suffix = StringUtils.getFileSuffix(widgetPath);
				String start = null;
				if(iscache) {
					this.pageContext.getOut().flush();
					start = response.getBufferPosition();
				}
				if(WebDispatcherFilter.FREEMARKER_SUFFIX.equals(suffix)) {
					Map<String, Object> paramMap = RequestUtil.parseParameterMap(widgetPath);
					//将url中的参数设置在request中
					request.setAllParameters(paramMap);
					int paramIndex = widgetPath.lastIndexOf("?");
					if(paramIndex > -1) {
						widgetPath = widgetPath.substring(0, paramIndex);
					}
					//执行后台处理类
					moduleMgr.executeWidget(widgetPath);
					//初始化Freemarker引擎
					if(!FreeMarkerEngine.inited) 
						FreeMarkerEngine.initConfig(ContextHolder.getServletContext(), "/");
					//渲染模板
					FreeMarkerEngine.getInstance().process(widgetPath ,request, response);
					//清空request中设置的参数
					request.removeParameterMap(paramMap);
				} else {
					// 添加isWidget参数
					widgetPath = RequestUtil.addWidgeParam(widgetPath);
					//include Widget
					this.pageContext.include(widgetPath);
				}
				if(iscache) {
					this.pageContext.getOut().flush();
					content = response.readBuffer(start);
					if(content != null) {
						cache.put(path, content);
					}
				}
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (TemplateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return EVAL_PAGE;
	}
	
	protected String getLazyTag(String path) {
		StringBuffer sb = new StringBuffer();
		String id = StringUtils.getRandomString(6);
		sb.append("\n<div id=\"");
		sb.append(id);
		sb.append("\">\n<script type=\"text/javascript\">\n<!--\n");
		sb.append("$(document).ready(function() {\n");
		sb.append("$(\"#");
		sb.append(id);
		sb.append("\").ui_htmlloader({url:\"");
		sb.append(path);
		sb.append("\"});\n");
		sb.append("});\n//-->\n</script>\n</div>\n");
		return sb.toString();
	}
	
	protected String getCacheTag(String path) {
		StringBuffer sb = new StringBuffer();
		sb.append("\n<!-- ").append(path).append(" -->\n");
		return sb.toString();
	}
	
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getLazy() {
		return lazy;
	}
	public void setLazy(String lazy) {
		this.lazy = lazy;
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}
	
}





