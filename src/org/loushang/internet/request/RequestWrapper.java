package org.loushang.internet.request;

import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.util.ArrayUtils;

public class RequestWrapper extends HttpServletRequestWrapper {

	private static Log log = LogFactory.getLog(RequestWrapper.class);
	
	private String path;
	
	private String fromEncode;
	private String encode;
	
	private boolean isInclude = false;
	
	private HttpServletRequest request;
	
	private Map<String, String[]> parameterMap;

	public RequestWrapper(HttpServletRequest request) {
		super(request);
		this.request = request;
		this.parameterMap = new HashMap<String, String[]>();
	}

	public void setPath(String path) {
		this.path = path;
	}

	public void setEncoding(String f, String e) {
		fromEncode = f;
		encode = e;
	}
	
	public void setParameter(String name, Object value) {
		if(value != null) {
			if(value instanceof String[]) {
				this.parameterMap.put(name, (String[]) value);
			} else if(value instanceof String) {
				this.parameterMap.put(name, new String[]{(String) value});
			} else {
				this.parameterMap.put(name, new String[]{String.valueOf(value)});
			}
		}
	}
	
	public void setAllParameters(Map<String, Object> paramsMap) {
		if(paramsMap != null) {
			for(Map.Entry<String, Object> entry : paramsMap.entrySet()) {
				this.setParameter(entry.getKey(), entry.getValue());
			}
		}
	}
	
	public String getParameter(String name)
	{
		String value = null;
		
		String[] valueArr = this.parameterMap.get(name);
		if(null != valueArr) {
			value = valueArr[0];
		}
		
		if(null == value) {
			value = getRequest().getParameter(name);
		}
		
		if (null != value && "GET".equals(request.getMethod())) {
			if(fromEncode != null && encode != null) {
				try
				{
					// tomcat默认以ISO8859-1处理GET传来的参数。把tomcat上的值用ISO8859-1获取字节流，再转换成UTF-8字符串
					value = new String(value.getBytes(fromEncode), encode);
				}
				catch (UnsupportedEncodingException e)
				{
					log.error("转换utf-8失败："+e);
				}
			}
		}
		return value;
	}
	
	public String[] getParameterValues(String name)
	{
		String[] values = this.parameterMap.get(name);
		
		if(null == values) {
			values = getRequest().getParameterValues(name);
		}
		
		return values;
	}
	
	public Enumeration getParameterNames() {
		Hashtable<Integer, Object> resultNames = new Hashtable<Integer, Object>();
		int index = 0;
		
		Enumeration paramNames = getRequest().getParameterNames();
		if(paramNames != null) {
			while(paramNames.hasMoreElements()) {
				resultNames.put(index, paramNames.nextElement());
				index++;
			}
		}
		
		Set<String> paramSet = this.parameterMap.keySet();
		if(paramSet != null) {
			for(Iterator<String> it = paramSet.iterator(); it.hasNext();) {
				String value = it.next();
				if(value != null && !resultNames.containsValue(value)) {
					resultNames.put(index, value);
					index++;
				}
			}
		}
		
		return resultNames.elements();
	}
	
	public Map getParameterMap() {
		Map paramMap = new HashMap(getRequest().getParameterMap());
		
		if(paramMap == null) {
			paramMap = new HashMap();
		}
		
		Set<String> paramKeys = paramMap.keySet();
		for(String paramKey : paramKeys) {
			Object paramValue = paramMap.get(paramKey);
			if(paramValue instanceof String[]) {
				String[] paramValues = (String[]) paramValue;
				paramValues = ArrayUtils.distinct(paramValues, String.class);
				if(paramValues.length == 1) {
					paramMap.put(paramKey, paramValues[0]);
				} else {
					paramMap.put(paramKey, paramValues);
				}
			}
		}
		
		for(Map.Entry<String, String[]> entry : this.parameterMap.entrySet()) {
			String[] value = entry.getValue();
			if(value != null) {
				if(value.length > 1) {
					paramMap.put(entry.getKey(), entry.getValue());
				} else {
					paramMap.put(entry.getKey(), value[0]);
				}
			} else {
				paramMap.put(entry.getKey(), null);
			}
			
		}
		
		return paramMap;
	}
	
	public void removeParameter(String name) {
		this.parameterMap.remove(name);
	}
	
	public void removeParameterMap(Map<String, Object> paramMap) {
		if(paramMap != null) {
			Set<String> paramKeySet = paramMap.keySet();
			if(paramKeySet != null) {
				for(Iterator<String> it = paramKeySet.iterator(); it.hasNext();) {
					this.parameterMap.remove(it.next());
				}
			}
		}
	}

	public void emptyParameterMap() {
		Set<String> paramKeySet = this.parameterMap.keySet();
		if(paramKeySet != null) {
			for(Iterator<String> it = paramKeySet.iterator(); it.hasNext();) {
				this.parameterMap.remove(it.next());
			}
		}
	}
	
	public boolean isInclude() {
		return isInclude;
	}

	public void setInclude(boolean isInclude) {
		this.isInclude = isInclude;
	}
	
}
