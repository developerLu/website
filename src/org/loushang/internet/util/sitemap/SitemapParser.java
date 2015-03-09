package org.loushang.internet.util.sitemap;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class SitemapParser {

	private static String SITEMAP_PATH = "sitemap.xml";

	private static boolean isInit = false;

	protected static Element root;

	protected static Map<String, Element> modules = new HashMap<String, Element>();

	protected static void init() throws DocumentException {
		SAXReader reader = new SAXReader();
		InputStream is = SitemapParser.class.getClassLoader()
				.getResourceAsStream(SITEMAP_PATH);
		if (is != null) {
			Document document = reader.read(is);
			root = document.getRootElement();
		}
		isInit = true;
	}

	public static List<SitemapNode> select(String module, String url) {
		List<SitemapNode> nodes = new ArrayList<SitemapNode>();

		if (!isInit) {
			try {
				init();
			} catch (DocumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return nodes;
			}
		}

		Element ele = getModule(module);
		if (ele != null) {
			String[] items = splitUrl(url);
			SitemapNode parent = null;
			for (int i = 0; i < items.length; i++) {

				@SuppressWarnings("unchecked")
				List<Element> list = ele.selectNodes(items[i]);
				if (list.isEmpty()) {
					break;
				}
				ele = list.get(0);
				SitemapNode node = new SitemapNode().build(ele);
				if (parent != null) {
					node.setParent(parent);
					parent.setChild(node);
				}
				nodes.add(node);
				parent = node;
			}
		}
		return nodes;
	}

	private static String[] splitUrl(String url) {
		String tmpUrl = url;
		if (tmpUrl.indexOf("/screen/") > -1) {
			tmpUrl = tmpUrl.split("/screen/")[1];
		}
		if (tmpUrl.indexOf("/") == -1) {
			tmpUrl = "root/" + tmpUrl;
		}
		return tmpUrl.split("/");
	}

	private static Element getModule(String moduleName) {
		if (modules.containsKey(moduleName)) {
			return modules.get(moduleName);
		}
		@SuppressWarnings("unchecked")
		List<Element> list = root.selectNodes("//module");
		Iterator<Element> iter = list.iterator();
		while (iter.hasNext()) {
			Element ele = iter.next();
			if (moduleName.equals(ele.valueOf("@id"))) {
				modules.put(moduleName, ele);
				return ele;
			}
		}
		return null;
	}
}
