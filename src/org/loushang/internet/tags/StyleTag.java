package org.loushang.internet.tags;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.response.header.Header;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.util.el.Function;

public class StyleTag extends javax.servlet.jsp.tagext.SimpleTagSupport {
	private String href;
	private String type = "text/css";
	private String rel = "stylesheet";
	private boolean isMerger = false;
	private String ifNotation;
	private String media;

	public boolean isMerger() {
		return isMerger;
	}

	public void setMerger(boolean isMerger) {
		this.isMerger = isMerger;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getRel() {
		return rel;
	}

	public void setRel(String rel) {
		this.rel = rel;
	}

	public String getHref() {
		return href;
	}

	public void setHref(String href) {
		this.href = href;
	}

	public String getIfNotation() {
		return ifNotation;
	}

	public void setIfNotation(String ifNotation) {
		this.ifNotation = ifNotation;
	}

	public String getMedia() {
		return media;
	}

	public void setMedia(String media) {
		this.media = media;
	}

	public void doTag() throws JspException, IOException {
		// ��ȡҳ���������������ַ�
		// getJspContext().getOut().write("Hello World");
		// ���ƣ���������е����
		PageContext pageContext = (PageContext) this.getJspContext();
		HttpServletRequest request = (HttpServletRequest) pageContext
				.getRequest();
		Header header = (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if (header == null) {
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		if (isMerger) {
			header.addStyle("merger", href);
		} else {
			// header.addStyle("", href);
			Map<String, String> params = new LinkedHashMap<String, String>();

			if (StringUtils.isNotEmpty(href)) {
				String contextPath = request.getContextPath();
				if(this.href.startsWith(contextPath)) {
					// 如果已经经过getUrl方法处理
					params.put("href", this.href);
				} else {
					params.put("href", Function.getUrl(this.href));
				}
			}
			if (StringUtils.isNotEmpty(ifNotation)) {
				params.put("ifNotation", this.ifNotation);
			}
			if (StringUtils.isNotEmpty(media)) {
				params.put("media", this.media);
			}
			if (StringUtils.isNotEmpty(type)) {
				params.put("type", this.type);
			}
			if (StringUtils.isNotEmpty(rel)) {
				params.put("rel", this.rel);
			}
			header.addStyle(params);
		}
	}
}
