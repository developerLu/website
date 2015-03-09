package org.loushang.internet.response.header;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Metas {
	private Map equivMap = new HashMap();
	private Map nameMap = new HashMap();
	
	private List<Map> metaList = new ArrayList<Map>();
	public void addMeta(String type,String key,String content){
		if("name".equals(type)){
			nameMap.put(key, content);
		}else if("http-equiv".equals(type)){
			equivMap.put(key, content);
		}
	}
	public void addMeta(Map map) {
		metaList.add(map);
	}
	public void write(StringWriter writer){
		String key = null;
		Iterator equivIt = equivMap.keySet().iterator();
		while(equivIt.hasNext()){
			key = (String) equivIt.next();
			writer.write("\n\t<meta  http-equiv=\"");
			writer.write(key);
			writer.write("\" content=\"");
			writer.write((String)equivMap.get(key));
			writer.write("\"/>");
		}
		Iterator nameIt = nameMap.keySet().iterator();
		while(nameIt.hasNext()){
			key = (String) nameIt.next();
			writer.write("\n\t<meta name=\"");
			writer.write(key);
			writer.write("\" content=\"");
			writer.write((String)nameMap.get(key));
			writer.write("\"/>");
		}
		for (Map map : metaList) {
			
			if(map.size() > 0) {
				writer.write("\n\t<meta");
				
				Iterator keys = map.keySet().iterator();
				while(keys.hasNext()){
					key = (String) keys.next();
					writer.write(" ");
					writer.write(key);
					writer.write("=\"");
					writer.write((String)map.get(key));
					writer.write("\"");
				}
				
				writer.write(" />");
			}
		}
	}
}
