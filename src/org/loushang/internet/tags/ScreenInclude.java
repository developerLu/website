package org.loushang.internet.tags;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.loushang.internet.servlet.WebDispatcherFilter;

public class ScreenInclude extends TagSupport {
	// System.out.println("gaochuanji");
	
	public int doEndTag() throws JspException {
		String screenPath = (String) this.pageContext.getRequest().getAttribute(WebDispatcherFilter.SCREEN_ATTRIBUTE_NAME);
		// include
		try {
			this.pageContext.include(screenPath);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}

}
