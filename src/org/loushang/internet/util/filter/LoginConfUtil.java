package org.loushang.internet.util.filter;

import com.inspur.common.utils.PropertiesUtil;


/*
 * 对应配置文件 login.properties
 */
public class LoginConfUtil{
	
//	private static Logger log = Logger.getLogger(LoginConfUtil.class);
//	private static PropertiesUtil prop = new PropertiesUtil();
//	static{
//		try {
//			prop.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("login.properties"));
//			
//			//转码处理
////			Set<Object> keyset = prop.getKeys();
////			Iterator<Object> iter = keyset.iterator();
////			while (iter.hasNext()) {
////				String key = (String) iter.next();
////				String newValue = null;
////				try {
////					//属性配置文件自身的编码
////					String propertiesFileEncode = "utf-8";
////					newValue = new String(prop.getProperty(key).getBytes("ISO-8859-1"),propertiesFileEncode);
////				} catch (UnsupportedEncodingException e) {
////					newValue = prop.getProperty(key);
////				}
////				prop.setProperty(key, newValue);
////			}
//		} catch (Exception e) {
//			log.error("读取配置文件login.properties出错！", e);
//		}
//	}
	
	/**
	 * 根据key，取得对应的value值
	 * @param String key
	 * @return String
	 */
	public static String getValue(String key){
		return PropertiesUtil.getValue("login.properties",key);
	}
} 

