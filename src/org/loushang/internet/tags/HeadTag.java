package org.loushang.internet.tags;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.loushang.internet.response.header.Header;

public class HeadTag extends BodyTagSupport {
	public static String HEADER_NAME = "-#header%";

	public int doStartTag() throws JspException {
		HttpServletRequest request = (HttpServletRequest) pageContext
				.getRequest();
		Header header = (Header) request.getAttribute(HEADER_NAME);
		if (header == null) {
			header = new Header();
			request.setAttribute(HEADER_NAME, header);
		}
		return EVAL_BODY_INCLUDE;
	}
}
