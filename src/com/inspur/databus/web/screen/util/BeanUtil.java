package com.inspur.databus.web.screen.util;

import com.inspur.databus.util.SpringContextHolder;

/**
 * 获取Bean工具类
 * @author zhanglch
 */
public class BeanUtil {

	/**
	 * 
	 * @param beanId
	 * @return
	 */
	public static Object getBean(String beanId){
		
		//前后台一个项目，通过Spring注入方式获取
		return SpringContextHolder.getBean(beanId);
		
		//前后台分离，通过ServiceFactory获取
		//return ServiceFactory.getService(beanId);
	}
	


	
}
