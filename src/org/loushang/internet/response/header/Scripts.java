package org.loushang.internet.response.header;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.util.el.Function;

public class Scripts {
	private Set<String> single = new LinkedHashSet<String>();
	private Set<String> group = new LinkedHashSet<String>();
	/**
	 * ��������ȫ��JS����
	 */
	private List<String> jscodeList = new ArrayList<String>();
	
	//private List<Map> scriptList = new ArrayList<Map>();
	private Map<String, Map> scriptList = new LinkedHashMap<String, Map>();

	public void addScript(String type, String src) {
		if ("merger".equals(type)) {
			group.add(src);
		} else {
			single.add(src);
		}
	}
	public void addScriptCode(String code){
		this.jscodeList.add(code);
	}
	public void addScript(Map map) {
		//scriptList.add(map);
		Object src = map.get("src");
		if(src != null) {
			scriptList.put(src.toString(), map);
		}
	}
	public void write(StringWriter writer,String version) {
		String key = null;
		if (jscodeList.size() > 0) {
			writer.write("\n\t<script type=\"text/javascript\">");
			for (int i = 0; i < jscodeList.size(); i++) {
				writer.write((String) jscodeList.get(i));
			}
			writer.write("</script>");
		}
		Iterator it = single.iterator();
		while (it.hasNext()){
			key = (String) it.next();
			writer.write("\n\t<script  src=\"");
			// ��Ĭ��ֱ����������ڿ�����������
			writer.write(Function.getUrl(key));
			if(version!=null){
				writer.write("?v=");
				writer.write(version);
			}
			writer.write("\" type=\"text/javascript\"></script>");
		}
		StringBuffer temp = new StringBuffer();
		it = group.iterator();
		while (it.hasNext()){
			key = (String) it.next();
			temp.append(key);
			temp.append(",");
		}
		if (temp.length() > 3) {
			temp.deleteCharAt(temp.length() - 1);
			writer.write("\n\t<script type=\"text/javascript\" src=\"");
			// ������һ��ͳһ��url��
			writer.write(temp.toString());
			if(version!=null){
				writer.write("?v=");
				writer.write(version);
			}
			writer.write("\"></script>");
		}
		
		for (String skey : scriptList.keySet()) {
			
			Map map = scriptList.get(skey);
			
			if(map.size() > 0) {
				
				Object ifNotation = map.get("ifNotation");
				if(ifNotation != null) {
					map.remove("ifNotation");
					writer.write("\n\t<!--[if ");
					writer.write(ifNotation.toString());
					writer.write("]>");
				}
				
				writer.write("\n\t<script type=\"text/javascript\"");
				
				Iterator keys = map.keySet().iterator();
				while(keys.hasNext()){
					key = (String) keys.next();
					writer.write(" ");
					writer.write(key);
					writer.write("=\"");
					writer.write((String)map.get(key));
					if("src".equals(key) && version!=null) {
						writer.write("?v=");
						writer.write(version);
					}
					writer.write("\"");
				}
				
				writer.write("></script>");
				
				if(ifNotation != null) {
					writer.write("\n\t<![endif]-->");
				}
			}
		}
	}
}
