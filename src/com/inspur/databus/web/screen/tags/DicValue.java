package com.inspur.databus.web.screen.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.inspur.databus.web.screen.util.DicUtil;

public class DicValue extends TagSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public String table;
	public String code;
	
	
	public int doStartTag() throws JspException {  
        return EVAL_BODY_INCLUDE;  
    }  
	public int doEndTag() throws JspException { 
		JspWriter out = this.pageContext.getOut();
		try {
			out.write(DicUtil.getDicValue(table, code));
		} catch (IOException e) {
			e.printStackTrace();
		}
        return EVAL_PAGE;  
    } 
	
	

	public String getTable() {
		return table;
	}
	public void setTable(String table) {
		this.table = table;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
}
