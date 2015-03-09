package org.loushang.internet.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 终端检测，用来检测客户端所处的环境
 * @author zhanglixian
 *
 */
public class TerminalTesting {

	private static Log log = LogFactory.getLog(TerminalTesting.class);
	private static Map<String, TerminalTesting> instances = new  HashMap<String, TerminalTesting>();
	
	private static String IDENTIFIER = "identifier";
	private static String MODULEPATH = "module";
	private static String configFile = "terminal.properties";
	
	private Map<String, String> prop = new HashMap<String, String>();
	private String[] identifiers;
	
	protected HttpServletRequest request;
	
	protected String userAgent;
	
	public static void init(){
		Properties props = loadProperties();
		if (props != null) {
			Iterator it = props.keySet().iterator();
			while (it.hasNext()) {
				String key = (String) it.next();
				String[] keys = key.split("\\.");
				if (keys.length >= 2) {
					TerminalTesting testing = instances.get(keys[0]);
					if (testing == null) {
						testing = new TerminalTesting();
						instances.put(keys[0], testing);
					}
					testing.setProp(keys[1], props.getProperty(key));
				}
			}
		}
	}
	
	private static Properties loadProperties() {
		InputStream in = TerminalTesting.class.getClassLoader().getResourceAsStream(configFile);
		if (in == null) {
			in = Thread.currentThread().getContextClassLoader().getResourceAsStream(configFile);
			if (in == null) {
				return null;
			}
		}	
		try {
			Properties p = new Properties();
			p.load(in);
			return p;
		} catch (IOException e) {
			log.error("", e);
		}
		return null;
	}
	
	/**
	 * 获取用户使用不同终端访问所属的module
	 * @param request
	 * @return
	 */
	public static String getTerminalModule(HttpServletRequest request) {
		String userAgent = request.getHeader("user-agent");
		Iterator<String> it = instances.keySet().iterator();
		while(it.hasNext()) {
			String key = (String) it.next();
			TerminalTesting test = instances.get(key);
			if(test.checkIncludeIdentifier(userAgent)) {
				return test.getModule();
			}
		}
		return "";
	}
	
	
	/**
	 * 检查客户端信息是否包含指定的标识
	 * @param str
	 * @return
	 */
	public boolean checkIncludeIdentifier(String str) {
		return checkIncludeStr(str, identifiers);
	}
	
	/**
	 * 检查字符串是否包含数组中的字符串之一，不区分大小写
	 * @param str1
	 * @param strs
	 * @return
	 */
	protected boolean checkIncludeStr(String str1, String[] strs) {
		if(strs == null || strs.length == 0) {
			return false;
		}
		if(str1 == null || "".equals(str1)) {
			return false;
		}
		
		String str1Lower = str1.toLowerCase();
		for(int i=0; i < strs.length; i++) {
			String tempstr = strs[i];
			if(tempstr == null || "".equals(tempstr)) {
				continue;
			}
			tempstr = tempstr.toLowerCase();
			
			String[] idens = tempstr.split(" ");
			boolean b = true;
			for(int j=0; j < idens.length; j++) {
				String iden = idens[j].trim();
				if(str1Lower.indexOf(iden) == -1) {
					b = false;
					break;
				}
			}
			if(b) {
				return b;
			}
		}
		return false;
	}
	
	public void setProp(String key,String value){
		this.prop.put(key, value);
		if(IDENTIFIER.equals(key)) {
			String[] tempStr = value.split(",");
			for(int i=0; i < tempStr.length; i++) {
				tempStr[i] = tempStr[i].trim();
			}
			identifiers = tempStr;
		}
	}
	
	public String getModule() {
		return this.prop.get(MODULEPATH);
	}
	public String getIdentifier() {
		return this.prop.get(IDENTIFIER);
	}
}
