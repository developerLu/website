package com.inspur.databus.web.screen.util;

import java.util.List;
import java.util.Map;


import com.inspur.databus.service.dic.api.IDicDomain;

public class DicUtil {


	static Map<String, List<Map<String,Object>>> returnMap;
	
	static{
		returnMap =( (IDicDomain)BeanUtil.getBean("dicDomain")).getAllDic();
	}
	/**
	 * 获取字典对应值
	 * @param table
	 * @return
	 */
	public static List<Map<String,Object>> getDic(String table) {
		return returnMap.get(table);
	}
	/**
	 * 
	 * @param table
	 * @param code
	 * @return
	 */
	public static String getDicValue(String table,String code) {
		String returnValue = code;
		if (table!=null&&code!=null) {
			List<Map<String,Object>> list = getDic(table);
			for (Map<String, Object> map : list) {
				if (code.equals(map.get("CODE"))) {
					returnValue =  (String) map.get("VALUE");
					break;
				}
			}
		}
		return returnValue;
	}
}
