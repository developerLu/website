package org.loushang.internet.response.header;

import java.io.StringWriter;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;



public class Header {
	private String title=null;
	private String namespace=null;
	private String manifest=null;
	private Metas metas = new Metas(); 
	private Scripts scripts = new Scripts();
	private Styles styles = new Styles();

	public void setTitle(String title) {
		this.title = title;
	}
	public void setNamespace(String namespace) {
		this.namespace = namespace;
	}
	public void addScript(String group,String src){
		this.scripts.addScript(group, src);
	}
	public void addScript(Map map) {
		this.scripts.addScript(map);
	}
	public void addScirptCode(String code){
		this.scripts.addScriptCode(code);
	}
	public void setManifest(String manifest) {
		this.manifest = manifest;
	}
	public void addStyle(String type,String href){
		this.styles.addStyle(type, href);
	}
	public void addStyle(Map map){
		this.styles.addStyle(map);
	}
	public void addMeta(String type,String key,String content){
		this.metas.addMeta(type, key, content);
	}
	public void addMeta(Map map) {
		this.metas.addMeta(map);
	}
	public void write(StringWriter writer,HttpServletRequest request){
		
		writer.write("<!DOCTYPE html>");
		writer.write("\n<html");
		if(manifest !=null)writer.write(" manifest=\""+manifest+"\"");
		if(namespace != null) writer.write(" "+namespace);	
		writer.write(">\n<head>");
		writer.write("\n\t<title>");
		writer.write(title);
		writer.write("</title>");
		this.metas.write(writer);
		//获取cookie的操作
		Cookie[] cookies = request.getCookies();
		String version = null;
		if(cookies!=null)
		for(Cookie cookie : cookies){
				if(cookie.getName().equals("xsm_file_version")){
					version = cookie.getValue();
					break;
				}
		}
		this.styles.write(writer,version);
		this.scripts.write(writer,version);
		writer.write("\n</head>");
	}
	
	
}
