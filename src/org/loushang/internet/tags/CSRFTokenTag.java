package org.loushang.internet.tags;

import java.io.IOException;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import org.loushang.internet.util.CSRFManager;

import com.inspur.common.utils.PropertiesUtil;

public class CSRFTokenTag extends javax.servlet.jsp.tagext.SimpleTagSupport {
	public void doTag() throws JspException, IOException {
		// getJspContext().getOut().write("Hello World");
		PageContext pageContext = (PageContext) this.getJspContext();
//		HttpServletRequest request = (HttpServletRequest) pageContext
//				.getRequest();
		JspWriter jw = pageContext.getOut();
		Map<String, String> token = CSRFManager.createToken();
		String CRSFName = PropertiesUtil.getValue("frame.properties", "global.CRSFTokenName");
		jw.write("<input style=\"display:none;\" type=\"hidden\" name=\"");
		jw.write(CRSFName);
		jw.write("\" value=\"");
		jw.write(token.get("key"));
		jw.write("\" alt=\"");
		jw.write(token.get("token"));
		jw.write("\" />");
	}
}
