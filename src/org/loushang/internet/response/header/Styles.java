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

public class Styles {
	private Set single = new LinkedHashSet();
	private Set group = new LinkedHashSet();
	
	//private List<Map> styleList = new ArrayList<Map>();
	private Map<String, Map> styleList = new LinkedHashMap<String, Map>();
	
	public void addStyle(String type,String href){
		if("merger".equals(type)){
			group.add(href);
		}else{
			single.add(href);
		}
	}
	public void addStyle(Map map) {
		//styleList.add(map);
		Object href = map.get("href");
		if(href != null) {
			styleList.put(href.toString(), map);
		}
	}
	
	public void write(StringWriter writer,String version){	
		String key = null;
		Iterator it = single.iterator();
		while (it.hasNext()){
			key = (String) it.next();
			writer.write("\n\t<link type=\"text/css\" rel=\"stylesheet\" href=\"");
			//��Ĭ��ֱ����������ڿ�����������
			writer.write(Function.getUrl(key));
			if(version!=null){
				writer.write("?v=");
				writer.write(version);
			}
			writer.write("\"/>");
		}
		StringBuffer temp=new StringBuffer();
		it = group.iterator();
		while (it.hasNext()){
			key = (String) it.next();
			temp.append(key);
			temp.append(",");
		}
		if(temp.length()>3){
			temp.deleteCharAt(temp.length()-1);
			writer.write("\n\t<link type=\"text/css\" rel=\"stylesheet\" href=\"");
			//������һ��ͳһ��url��
			writer.write(temp.toString());
			if(version!=null){
				writer.write("?v=");
				writer.write(version);
			}
			writer.write("\"/>");
		}
		
		for (String skey : styleList.keySet()) {
			Map map = styleList.get(skey);
			
			if(map.size() > 0) {

				Object ifNotation = map.get("ifNotation");
				if(ifNotation != null) {
					map.remove("ifNotation");
					writer.write("\n\t<!--[if ");
					writer.write(ifNotation.toString());
					writer.write("]>");
				}
				
				writer.write("\n\t<link ");
				
				Iterator keys = map.keySet().iterator();
				while(keys.hasNext()){
					key = (String) keys.next();
					writer.write(" ");
					writer.write(key);
					writer.write("=\"");
					writer.write((String)map.get(key));
					if("href".equals(key) && version != null) {
						writer.write("?v=");
						writer.write(version);
					}
					writer.write("\"");
				}
				
				writer.write(" />");
				
				if(ifNotation != null) {
					writer.write("\n\t<![endif]-->");
				}
			}
		}
	}
}
