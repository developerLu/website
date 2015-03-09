package com.inspur.databus.web.widget;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Footer
 * @author zhanglch
 */
public class Footer {
	
	private static Log log = LogFactory.getLog(Footer.class);// 日志

	public void execute(HttpServletRequest request, HttpServletResponse response){
		try{
			//数据量
			request.setAttribute("data_num", 0);
			
			//用户数
			Map<String,Object> param1 = new HashMap<String,Object>();
			param1.put("if_use", "1");
		}catch(Exception ex){
			ex.printStackTrace();
			log.error("Footer出错！",ex);
		}
	}
}
