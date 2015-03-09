package org.loushang.internet.cache;

import java.util.List;
import java.util.Set;

import org.dom4j.Element;

public interface CacheManager {
	void setConfig(Element ele);
	
	void init(String moduleName, boolean allowCache);
	
	boolean allowCache(String key);
	
	/**
	 * 把key/value数据放入到缓存中
	 * @param key
	 * @param value
	 * @param expireTime 失效时间，如果打算使用系统配置的时间，请传值null
	 * @return
	 */
	boolean put(String key, String value, Integer expireTime);
	boolean put(String key, String value);
	
	String get(String key);
	
	void delete(String key);
	
	void deleteAll();
	
	Set<String> search(String key);
}
