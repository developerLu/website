package org.loushang.internet.tags;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.loushang.internet.response.header.Header;

public class HtmlTag extends  BodyTagSupport {
//	System.out.println("gaochuanji");
	
	// html��ǵ�����ռ�
	private String namespace = null;
	private String manifest =null;
	
	@Override
	public int doEndTag() throws JspException {
		try {
			this.pageContext.getOut().println("</html>");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}
	public int doStartTag() throws JspException{
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		Header header =  (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if(header==null){
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		header.setNamespace(namespace);
		header.setManifest(manifest);
		return EVAL_BODY_INCLUDE;
	}
	public String getNamespace() {
		return namespace;
	}
	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}
	public String getManifest() {
		return manifest;
	}
	public void setManifest(String manifest) {
		this.manifest = manifest;
	}
	
}
