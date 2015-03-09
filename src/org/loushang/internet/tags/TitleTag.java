package org.loushang.internet.tags;

import java.io.IOException;
import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.JspFragment;

import org.loushang.internet.response.header.Header;

public class TitleTag  extends javax.servlet.jsp.tagext.SimpleTagSupport{
	 public void doTag()throws JspException,  IOException{ 
	     // 获取页面输出流，并输出字符串
	     //getJspContext().getOut().write("Hello World"); 
		 //控制，不输出其中的输出
	 	PageContext pageContext = (PageContext) this.getJspContext(); 
	 	HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		Header header =  (Header) request.getAttribute(HeadTag.HEADER_NAME);
		 if(header==null){
			 header = new Header();
			 request.setAttribute(HeadTag.HEADER_NAME, header);
		 }
		 JspFragment body=getJspBody();
		 StringWriter sw = new StringWriter();
		 body.invoke(sw);
		 header.setTitle(sw.toString());
			 
	 } 
}
