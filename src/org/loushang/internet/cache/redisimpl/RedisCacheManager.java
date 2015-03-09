package org.loushang.internet.cache.redisimpl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.cache.AbstractCacheManager;
import org.loushang.internet.cache.CacheExpressControl;
import org.loushang.internet.cache.CacheManager;
import org.loushang.internet.cache.RegexpPath;
import org.loushang.internet.util.StringUtils;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RedisCacheManager extends AbstractCacheManager implements CacheManager {
	private static Log log = LogFactory.getLog(RedisCacheManager.class);
	
	protected String host = "localhost";
	protected int port = 6379;
	protected JedisPool pool;
	
	public void init(String moduleName, boolean allowCache) {
		super.init(moduleName, allowCache);
		
		pool = new JedisPool(host, port);
	}
	
	public boolean put(String key, String value, Integer expireTime) {
		if(key == null || "".equals(key)) {
			return false;
		}
		
		try {
			Jedis jedis = pool.getResource();
			if(jedis.isConnected()) {
				String[] keys = getKeys(key);
				jedis.hset(keys[0], keys[1], value);
				//jedis.set(key, value);
				if(expireTime == null) {
					// ���ù���ʱ��
					RegexpPath rp = CacheExpressControl.getCacheConfig(moduleName, keys[0]);
					if(rp != null) {
						jedis.expire(keys[0], rp.getExpireTime());
					}
				} else {
					jedis.expire(keys[0], expireTime);
				}
			}
			pool.returnResource(jedis);
		} catch(Exception e) {
			e.printStackTrace();
			log.debug(e.getStackTrace());
		}
		
		return false;
	}

	public String get(String key) {
		if(key == null || "".equals(key)) {
			return null;
		}
		String value = null;
		try {
			Jedis jedis = pool.getResource();
			if(jedis.isConnected()) {
				String[] keys = getKeys(key);
				value = jedis.hget(keys[0], keys[1]);
				//jedis.get(key);
			}
			pool.returnResource(jedis);
		} catch(Exception e) {
			e.printStackTrace();
			log.debug(e.getStackTrace());
		}
		
		return value;
	}

	public void delete(String key) {
		if(key == null || "".equals(key)) {
			return;
		}
		try {
			Jedis jedis = pool.getResource();
			if(jedis.isConnected()) {
				String[] keys = getKeys(key);
				jedis.hdel(keys[0], keys[1]);
			}
			pool.returnResource(jedis);
		} catch(Exception e) {
			e.printStackTrace();
			log.debug(e.getStackTrace());
		}
	}
	
	public void deleteAll() {
		try {
			Jedis jedis = pool.getResource();
			if(jedis.isConnected()) {
				jedis.flushAll();
			}
			pool.returnResource(jedis);
		} catch(Exception e) {
			e.printStackTrace();
			log.debug(e.getStackTrace());
		}
	}

	public Set<String> search(String key) {
		Set<String> list = new HashSet<String>();
		if(key == null || "".equals(key)) {
			return list;
		}
		try {
			Jedis jedis = pool.getResource();
			if(jedis.isConnected()) {
				String[] keys = getKeys(key);
				if("default".equals(keys[1])) {
					list = jedis.keys(keys[0]);
				} else {
					if(jedis.hexists(keys[0], keys[1])) {
						list.add(key);
					}
				}
			}
			pool.returnResource(jedis);
		} catch(Exception e) {
			e.printStackTrace();
			log.debug(e.getStackTrace());
		}
		
		return list;
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

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}
	public void setPort(String port) {
		this.port = Integer.parseInt(port);
	}
}
