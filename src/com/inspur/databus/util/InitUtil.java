package com.inspur.databus.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 静态方法初始化对象 
 * @author zhanglch
 */
public class InitUtil {

	public static Map<String,Object> initMap(){
		return new HashMap<String,Object>();
	}
	
	public static List<Map<String, Object>> initMapList(){
		return new ArrayList<Map<String, Object>>();
	}
}

