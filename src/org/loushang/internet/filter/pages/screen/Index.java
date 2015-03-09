package org.loushang.internet.filter.pages.screen;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.util.CSRFManager;
import org.loushang.internet.view.ViewHandler;

public class Index implements ViewHandler {

	public void execute(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	
	public void doAdd(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if(CSRFManager.validateCSRF(request)){
			System.out.println("====================");
			response.getWriter().write("error");
		} else{
			Enumeration<String> paramNames = request.getParameterNames();
			while(paramNames.hasMoreElements()) {
				String paramName = paramNames.nextElement();
				String[] paramValues = request.getParameterValues(paramName);
				for(String paramValue : paramValues) {
					response.getWriter().println(paramName+"-----"+paramValue);
				}
			}
			response.getWriter().write("-------------------");
		}
		
	}
	
	/**
	 * 注销session中的登录信息
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void doLogout(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}
}
