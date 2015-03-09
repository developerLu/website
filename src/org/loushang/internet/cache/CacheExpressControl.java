package org.loushang.internet.cache;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.loushang.internet.cache.fileimpl.FileCacheManager;
import org.loushang.internet.util.sitemap.SitemapParser;

public class CacheExpressControl {
	protected static String CACHEFILE = "cache.xml";
	protected static Map<String, RegexpPath> cachePaths = new HashMap<String, RegexpPath>();
	protected static Map<String, List<RegexpPath>> regs = new HashMap<String, List<RegexpPath>>();
	protected static Map<String, CacheManager> cacheManagers = new HashMap<String, CacheManager>();

	protected static boolean isInit = false;

	/**
	 * 初始化缓存配置
	 * 
	 * @throws DocumentException
	 */
	protected static void init() throws DocumentException {

		// 读取缓存配置
		SAXReader reader = new SAXReader();
		InputStream is = SitemapParser.class.getClassLoader()
				.getResourceAsStream(CACHEFILE);

		if (is != null) {
			Document document = reader.read(is);

			Element root = document.getRootElement();

			// 获取模块列表
			@SuppressWarnings("unchecked")
			List<Element> list = root.selectNodes("//module");
			Iterator<Element> iter = list.iterator();
			while (iter.hasNext()) {
				Element ele = iter.next();
				String moduleName = ele.attributeValue("id");
				regs.put(moduleName, fillRegexp(ele, false, -1));
				cacheManagers.put(moduleName, fillCacheManager(ele));
			}
		}
		isInit = true;
	}

	/**
	 * 将缓存的xml配置转换为列表对象
	 * 
	 * @param ele
	 * @param allowCache
	 * @return
	 */
	private static List<RegexpPath> fillRegexp(Element ele, boolean allowCache,
			int expireTime) {
		if (ele == null)
			return null;

		List<RegexpPath> plist = new ArrayList<RegexpPath>();

		@SuppressWarnings("unchecked")
		Iterator<Element> paths = ele.elementIterator("path");
		while (paths.hasNext()) {
			Element item = paths.next();

			RegexpPath rp = new RegexpPath();
			rp.setSubPath("true".equals(item.attributeValue("subPath")));
			rp.setRegexp(replaceMatch(item.attributeValue("regexp"),
					rp.isSubPath()));

			String allow = item.attributeValue("allowCache");
			boolean state = false;
			// 如果设置allowCache属性，则按照该属性的值，否则为上级的allowCache取反
			if ("true".equals(allow)) {
				state = true;
			} else if ("false".equals(allow)) {
				state = false;
			} else {
				state = !allowCache;
			}
			rp.setAllowCache(state);

			// 设置失效时间属性
			String expire = item.attributeValue("expireTime");
			if (expire == null || "".equals(expire)) {
				rp.setExpireTime(expireTime);
			} else {
				rp.setExpireTime(Integer.parseInt(expire));
			}

			@SuppressWarnings("unchecked")
			// 查找是否有例外情况
			List<Element> list = item.selectNodes("exceptional");
			Element exc = null;
			if (list.size() > 0) {
				exc = list.get(0);
			}
			rp.setExcep(fillRegexp(exc, state, rp.getExpireTime()));

			@SuppressWarnings("unchecked")
			// 查找是否有单独配置的子项
			List<Element> list2 = item.selectNodes("children");
			Element exc2 = null;
			if (list2.size() > 0) {
				exc2 = list2.get(0);
			}
			rp.setChildren(fillRegexp(exc2, !state, rp.getExpireTime()));

			plist.add(rp);
		}

		return plist;
	}

	/**
	 * 根据配置设置缓存对象
	 * 
	 * @param ele
	 * @return
	 */
	private static CacheManager fillCacheManager(Element ele) {
		if (ele == null)
			return null;
		List<Element> list = ele.selectNodes("manager");
		if (list.size() > 0) {
			Element man = list.get(0);
			String className = man.attributeValue("class");
			try {
				Class<?> cacheClass = (Class<?>) CacheExpressControl.class
						.forName(className);
				CacheManager cm = (CacheManager) cacheClass.newInstance();

				cm.setConfig(man);
				return cm;

			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * 获取指定模块的缓存处理类
	 * 
	 * @param moduleName
	 * @return
	 */
	public static CacheManager getCacheManager(String moduleName) {

		// 是否已初始化
		if (!isInit) {
			try {
				init();
			} catch (DocumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return new FileCacheManager();
			}
		}

		CacheManager cm = cacheManagers.get(moduleName);
		if (cm == null) {
			cm = new FileCacheManager();
		}
		return cm;
	}

	/**
	 * 获取某个路径对应的匹配配置
	 * 
	 * @param moduleName
	 * @param path
	 * @return 返回值不为空，isAllowCache方法返回是否缓存，getExpireTime方法返回失效时间
	 */
	public static RegexpPath getCacheConfig(String moduleName, String path) {
		// 去掉url后面的参数
		String path2 = path.split("[?]")[0];

		String key = moduleName + "|" + path2;
		// 直接从内存缓存中获取
		if (cachePaths.containsKey(key)) {
			return cachePaths.get(key);
		}

		RegexpPath tmp = new RegexpPath();

		// 是否已初始化
		if (!isInit) {
			try {
				init();
			} catch (DocumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return tmp;
			}
		}

		// 通过匹配检测是否缓存
		List<RegexpPath> plist = regs.get(moduleName);
		if (plist != null) {
			for (RegexpPath rp : plist) {
				tmp = rp.checkIsMatch(path2);
				if (tmp != null)
					break;
			}
		}
		// 路径是否缓存加入到内存中保存
		cachePaths.put(key, tmp);
		return tmp;
	}

	/**
	 * 检测某个路径是否缓存
	 * 
	 * @param moduleName
	 *            路径对应的模块名
	 * @param path
	 *            路径url
	 * @return
	 */
	public static boolean checkIsCache(String moduleName, String path) {
		RegexpPath rp = getCacheConfig(moduleName, path);
		if (rp != null) {
			return rp.isAllowCache();
		}
		return false;
	}

	/**
	 * 转换设置的值为规则正则表达式，*替换为所有字符
	 * 
	 * @param regexp
	 * @param subPath
	 * @return
	 */
	private static String replaceMatch(String regexp, boolean subPath) {
		String reg = regexp;
		reg = reg.replaceAll("[.]", "\\\\.");
		if (subPath) {
			reg = reg.replaceAll("[*]", "[\\\\w\\\\./\\\\\\\\]*");
		} else {
			reg = reg.replaceAll("[*]", "[\\\\w\\\\.]*");
		}
		if (reg.endsWith("*")) {
			reg = reg + "$";
		}
		return reg;
	}
}
