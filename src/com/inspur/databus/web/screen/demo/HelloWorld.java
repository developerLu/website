package com.inspur.databus.web.screen.demo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;



public class HelloWorld {
	private static Log log = LogFactory.getLog(HelloWorld.class);// 日志
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		System.out.println("Demo");
	}
	
}
