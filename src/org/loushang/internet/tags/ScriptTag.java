package org.loushang.internet.tags;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.loushang.internet.response.header.Header;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.el.Function;

public class ScriptTag extends javax.servlet.jsp.tagext.SimpleTagSupport {
	private boolean isMerger = false;
	private String src = "";
	private String jsCode = "";
	private String ifNotation;
	private String charset;
	private String async;
	private String defer;

	public void doTag() throws JspException, IOException {
		// 获取页面输出流，并输出字符串
		// getJspContext().getOut().write("Hello World");
		// 控制，不输出其中的输出
		PageContext pageContext = (PageContext) this.getJspContext();
		HttpServletRequest request = (HttpServletRequest) pageContext
				.getRequest();
		Header header = (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if (header == null) {
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		if (StringUtils.isNotEmpty(src)) {
			if (isMerger) {
				header.addScript("merger", src);
			} else {
				//header.addScript("", src);
				Map<String, String> params = new LinkedHashMap<String, String>();
				
				String contextPath = request.getContextPath();
				if(this.src.startsWith(contextPath)) {
					// 如果已经经过getUrl方法处理
					params.put("src", this.src);
				} else {
					params.put("src", Function.getUrl(this.src));
				}
				
				if(StringUtils.isNotEmpty(ifNotation)) {
					params.put("ifNotation", this.ifNotation);
				}
				if(StringUtils.isNotEmpty(charset)) {
					params.put("charset", this.charset);
				}
				if(StringUtils.isNotEmpty(async)) {
					params.put("async", this.async);
				}
				if(StringUtils.isNotEmpty(defer)) {
					params.put("defer", this.defer);
				}
				header.addScript(params);
			}
		}
		if (!"".equals(jsCode)) {
			header.addScirptCode(jsCode);
		}
	}

	public boolean isMerger() {
		return isMerger;
	}

	public void setMerger(boolean isMerger) {
		this.isMerger = isMerger;
	}

	public String getSrc() {
		return src;
	}

	public void setSrc(String src) {
		this.src = src;
	}

	public String getJsCode() {
		return jsCode;
	}

	public void setJsCode(String jsCode) {
		this.jsCode = jsCode;
	}

	public String getIfNotation() {
		return ifNotation;
	}

	public void setIfNotation(String ifNotation) {
		this.ifNotation = ifNotation;
	}

	public String getCharset() {
		return charset;
	}

	public void setCharset(String charset) {
		this.charset = charset;
	}

	public String getAsync() {
		return async;
	}

	public void setAsync(String async) {
		this.async = async;
	}

	public String getDefer() {
		return defer;
	}

	public void setDefer(String defer) {
		this.defer = defer;
	}

}
