package org.loushang.internet.cache;

import java.util.Iterator;

import org.dom4j.Element;
import org.loushang.internet.util.ReflectUtils;

public abstract class AbstractCacheManager implements CacheManager {

	protected String moduleName;
	protected boolean allowCache;
	

	public void setConfig(Element ele) {
		@SuppressWarnings("unchecked")
		Iterator<Element> iterator = ele.elementIterator("param");
		while(iterator.hasNext()) {
			Element param = iterator.next();
			String aname = param.attributeValue("key");
			String avalue = param.attributeValue("value");
			// 通过反射的方式设置属性
			ReflectUtils.setFieldValue(this, aname, String.class, avalue);
		}
	}
	
	public void init(String moduleName, boolean allowCache) {
		this.moduleName = moduleName;
		this.allowCache = allowCache;
	}
	
	public boolean allowCache(String key) {
		if(allowCache) {
			return CacheExpressControl.checkIsCache(moduleName, key);
		}
		return false;
	}
	
	public boolean put(String key, String value) {
		return put(key, value, null);
	}
}
