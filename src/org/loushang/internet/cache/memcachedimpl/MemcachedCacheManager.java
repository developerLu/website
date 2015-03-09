package org.loushang.internet.cache.memcachedimpl;

import java.util.Arrays;
import java.util.Date;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.cache.AbstractCacheManager;
import org.loushang.internet.cache.CacheExpressControl;
import org.loushang.internet.cache.CacheManager;
import org.loushang.internet.cache.RegexpPath;
import org.loushang.internet.util.StringUtils;

import com.danga.MemCached.MemCachedClient;
import com.danga.MemCached.SockIOPool;

public class MemcachedCacheManager extends AbstractCacheManager implements
		CacheManager {
	private static Log log = LogFactory.getLog(MemcachedCacheManager.class);

	protected String[] servers = { "localhost:10000" };

	protected MemCachedClient memCachedClient;

	public void init(String moduleName, boolean allowCache) {
		super.init(moduleName, allowCache);
		
		SockIOPool pool = SockIOPool.getInstance();
		pool.setServers(servers);
		pool.setFailover(true);
		pool.setInitConn(10);
		pool.setMinConn(5);
		pool.setMaxConn(250);
		pool.setMaintSleep(30);
		pool.setNagle(false);
		pool.setSocketTO(3000);
		pool.setAliveCheck(true);
		pool.initialize();

		memCachedClient = new MemCachedClient();
	}

	public boolean put(String key, String value, Integer expireTime) {
		if (key == null || "".equals(key)) {
			return false;
		}
		
		if(expireTime == null) {
			String[] keys = getKeys(key);
			RegexpPath rp = CacheExpressControl.getCacheConfig(moduleName, keys[0]);
			if(rp != null) {
				return memCachedClient.set(key, value, new Date(System.currentTimeMillis() + rp.getExpireTime()));
			} else {
				return memCachedClient.set(key, value);
			}
		} else {
			return memCachedClient.set(key, value, new Date(System.currentTimeMillis() + expireTime));
		}
	}

	public String get(String key) {
		if (key == null || "".equals(key)) {
			return null;
		}
		Object value = memCachedClient.get(key);
		if(value != null) return value.toString();
		return null;
	}

	public void delete(String key) {
		if (key == null || "".equals(key)) {
			return;
		}
		memCachedClient.delete(key);
	}

	public void deleteAll() {
		memCachedClient.flushAll();
	}

	public Set<String> search(String key) {
		return null;
	}

	public String getServers() {
		if(servers == null) return null;
		//String str = servers.toString();
		String str = Arrays.toString(servers);
		if(str.startsWith("[")) str = str.substring(1);
		if(str.endsWith("]")) str = str.substring(0, str.length() - 2);
		return str;
	}

	public void setServers(String str) {
		if(str != null) {
			servers = str.split(",");
		} else {
			servers = null;
		}
	}
	
	protected String[] getKeys(String key) {
		String[] keys = splitKey(key);
		if(keys.length <= 1 || StringUtils.isEmpty(keys[0] ) ||  StringUtils.isEmpty(keys[1] ) ) {
			keys = new String[] {key, "default"};
		}
		return keys;
	}
	
	protected String[] splitKey(String key) {
		return key.split("[?]");
	}
	
}

