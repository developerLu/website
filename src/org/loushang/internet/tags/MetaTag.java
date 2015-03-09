package org.loushang.internet.tags;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;

import org.loushang.internet.response.header.Header;
import org.loushang.internet.util.StringUtils;

public class MetaTag extends javax.servlet.jsp.tagext.SimpleTagSupport{
	private String name;
	private String content;
	private String httpEquiv;
	private String property;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getHttpEquiv() {
		return httpEquiv;
	}
	public void setHttpEquiv(String httpEquiv) {
		this.httpEquiv = httpEquiv;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public void doTag()throws JspException,  IOException{ 
	     // ��ȡҳ���������������ַ�
	     //getJspContext().getOut().write("Hello World"); 
		 //���ƣ���������е����
		PageContext pageContext = (PageContext) this.getJspContext(); 
	 	HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		Header header =  (Header) request.getAttribute(HeadTag.HEADER_NAME);
		 if(header==null){
			 header = new Header();
			 request.setAttribute(HeadTag.HEADER_NAME, header);
		 }
		 /*
		 if(this.name!=null){
			 header.addMeta("name", this.name,content);
		 }else{
			 header.addMeta("http-equiv", this.httpEquiv, content);
		 }
		 */
		 Map<String,String> params = new LinkedHashMap<String,String>();
		 if(StringUtils.isNotEmpty(this.name)) {
			 params.put("name", this.name);
		 }
		 if(StringUtils.isNotEmpty(this.httpEquiv)) {
			 params.put("http-equiv", this.httpEquiv);
		 }
		 if(StringUtils.isNotEmpty(this.property)) {
			 params.put("property", this.property);
		 }
		 if(StringUtils.isNotEmpty(this.content)) {
			 params.put("content", this.content);
		 }
		 header.addMeta(params);
	 } 
}
