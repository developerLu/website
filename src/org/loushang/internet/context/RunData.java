package org.loushang.internet.context;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;

public class RunData {
	public static String ASYNC = "async";
	public static String STATIC = "static";
	
	private String requestUri = null;
	private boolean isRedirect = false;;
	private boolean isForward = false;
	private String action = null;
//	private boolean isWidget = false;
	private String viewType = STATIC;
	
	private boolean canRenderer = true;
	private String requestMethod = null;
	private String forwardUri = null;
	
	//模板文件（包含路径）
	private String templateUri = null;
	//模板文件的后缀
	private String templateSuffix = null;
	//模板文件的上下文路径（不含文件名）
	private String templateContext = null;
	
	public RunData(HttpServletRequest request,
			HttpServletResponse response, 
			ServletContext sc) {
		
		requestUri = RequestUtil.getRequestUrl(request);
		
		//form表单请求
		String tmpaction = request.getParameter("action");
		if(tmpaction != null && !"".equals(tmpaction)) {
			tmpaction = "act" + StringUtils.getInitialUpperCase(tmpaction);;
		}
		action = tmpaction;
		
		//一般的ajax异步请求
		String tmpUri = requestUri.split("[?]")[0];
		if(tmpUri.endsWith(".do")) {
			requestMethod = request.getParameter("method");
			if(requestMethod != null && !"".equals(requestMethod)) {
				requestMethod = "do" + StringUtils.getInitialUpperCase(requestMethod);
				canRenderer = false;
			}
		}
		
		//widget请求
		/*
		String widget = request.getParameter("isWidget");
		if(widget != null && "true".equals(widget)) {
			isWidget = true;
		}
		*/
		
		String view = request.getParameter("_view");
		if(view != null) {
			if(ASYNC.equals(view)) {
				viewType = ASYNC;
			}
		}
	}
	
	public String getRequestUri() {
		return requestUri;
	}
	
	public void setRequestUri(String requestUri) {
		this.requestUri = requestUri;
	}
	
	public boolean getIsRedirect() {
		return isRedirect;
	}
	
	public void setIsRedirect(boolean isRedirect) {
		this.isRedirect = isRedirect;
	}
	
	public boolean getIsForward() {
		return isForward;
	}
	
	public void setIsForward(boolean isForward) {
		this.isForward = isForward;
	}
	
	public String getAction() {
		return action;
	}
	
	public void setAction(String action) {
		this.action = action;
	}
	/*
	public boolean getIsWidget() {
		return isWidget;
	}
	
	public void setWidget(boolean isWidget) {
		this.isWidget = isWidget;
	}
	 */
	public String getViewType() {
		return viewType;
	}

	public void setViewType(String viewType) {
		this.viewType = viewType;
	}

	public boolean getIsAsync() {
		return ASYNC.equals(this.viewType);
	}

	public boolean isCanRenderer() {
		return canRenderer;
	}

	public void setCanRenderer(boolean canRenderer) {
		this.canRenderer = canRenderer;
	}

	public String getRequestMethod() {
		return requestMethod;
	}

	public void setRequestMethod(String requestMethod) {
		this.requestMethod = requestMethod;
	}

	public String getForwardUri() {
		return forwardUri;
	}

	public void setForwardUri(String forwardUri) {
		this.forwardUri = forwardUri;
	}

	public String getTemplateUri() {
		return templateUri;
	}

	public void setTemplateUri(String templateUri) {
		this.templateUri = templateUri;
	}

	public String getTemplateSuffix() {
		return templateSuffix;
	}

	public void setTemplateSuffix(String templateSuffix) {
		this.templateSuffix = templateSuffix;
	}

	public String getTemplateContext() {
		return templateContext;
	}

	public void setTemplateContext(String templateContext) {
		this.templateContext = templateContext;
	}

}
