package org.loushang.internet.util;

import java.io.IOException;
import org.codehaus.jackson.map.ObjectMapper;

public class JsonUtils {

	/**
	 * 把对象转换成Json格式，支持JavaBean、Map、List
	 * @param obj
	 * @return
	 * @throws IOException
	 */
	public static String convertToString(Object obj) throws IOException {
		
		if(obj == null) return null;
		
		//通过jackson转换为json值
		ObjectMapper om = new ObjectMapper();
		return om.writeValueAsString(obj);
	}
	
	/**
	 * 把Json字符串读取成对象格式
	 * @param <T>
	 * @param str
	 * @param cla
	 * @return
	 * @throws IOException
	 */
	public static <T> T readToObject(String str, Class<T> cla) throws IOException{
		
		if(str == null) return null;
		
		ObjectMapper om = new ObjectMapper();
		return om.readValue(str, cla);
	}
}
