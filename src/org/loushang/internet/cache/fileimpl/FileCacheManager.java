package org.loushang.internet.cache.fileimpl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Set;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Element;
import org.loushang.internet.cache.AbstractCacheManager;
import org.loushang.internet.cache.CacheManager;
import org.loushang.internet.cache.redisimpl.RedisCacheManager;
import org.loushang.internet.util.StringUtils;

public class FileCacheManager extends AbstractCacheManager implements CacheManager {
	private static Log log = LogFactory.getLog(FileCacheManager.class);
	
	protected String filePath;
	
	private Base64 encrypt;
	
	public void init(String moduleName, boolean allowCache) {
		super.init(moduleName, allowCache);
		
		try {
			log.debug("FileCacheManager init start");
			filePath = FileCacheManager.class.getClassLoader().getResource("/").toURI().getPath()
				+ String.format("cache/%s/", this.moduleName);
			log.debug("FileCacheManager init end");
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			filePath = FileCacheManager.class.getClassLoader().getResource("/").getPath()
				+ String.format("cache/%s/", this.moduleName);
		}
		encrypt = new Base64();
	}
	
	public boolean put(String key, String value, Integer expireTime) {
		if(key == null || "".equals(key)) {
			return false;
		}
		String[] paths = getFilePath(key);
		File path = new File(paths[0]);
		if(!path.exists())
			path.mkdirs();
		
		FileWriter fw = null;
		try {
			File file = new File(paths[0], paths[1]);
			fw = new FileWriter(file, false);
			fw.write(value);
			fw.flush();
			return true;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.debug(e.getStackTrace());
		} finally {
			if(fw != null ) {
				try {
					fw.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					log.debug(e.getStackTrace());
				}
			}
		}
		return false;
	}

	public String get(String key) {
		String[] paths = getFilePath(key);
		File file = new File(paths[0], paths[1]);
		if(!file.exists())
			return null;
		
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
			StringBuffer sb = new StringBuffer();
			char buff[] = new char[1024];
			int len;
			while((len = br.read(buff))>0) {
				sb.append(buff,0,len);
			}
			return sb.toString();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.debug(e.getStackTrace());
		} finally {
			if(br != null ) {
				try {
					br.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					log.debug(e.getStackTrace());
				}
			}
		}
		return null;
	}

	public void delete(String key) {
		String[] paths = getFilePath(key);
		File file = new File(paths[0], paths[1]);
		if(file.exists())
			file.delete();
	}
	
	public void deleteAll() {
		File path = new File(filePath);
		if(path.exists()) {
			path.delete();
		}
	}

	public Set<String> search(String key) {
		// TODO Auto-generated method stub
		return null;
	}
	
	protected String[] getFilePath(String key) {
		String[] keys = getKeys(key);
		String path;
		String file;
		if(keys.length > 1) {
			path = encodeKey(keys[0]);
			file = encodeKey(keys[1]) + ".cache";
		} else {
			path = encodeKey(keys[0]);
			file = path + ".cache";
		}
		return new String[] {filePath + path, file};
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
	
	protected String encodeKey(String key) {
		//return MD5Utils.hashed(key);
		//return encrypt.encodeToString(key.getBytes());
		return key.replaceAll("/", "-");
	}
	protected String decodeKey(String key) throws IOException {
		return new String(encrypt.decode(key));
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
}
