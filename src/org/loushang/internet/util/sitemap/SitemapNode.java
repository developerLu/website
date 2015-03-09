package org.loushang.internet.util.sitemap;

import java.util.List;

import org.dom4j.Element;

public class SitemapNode {

	private String tagName;
	private String id;
	private String context;
	private String name;
	private String path;
	private String page;
	
	private SitemapNode parent;
	private List<SitemapNode> children;
	private SitemapNode child;
	
	public SitemapNode build(Element ele) {
		this.tagName = ele.getName();
		this.id = ele.attributeValue("id");
		this.context = ele.attributeValue("context");
		this.name = ele.attributeValue("name");
		page = ele.attributeValue("page"); 
		return this;
	}
	
	public String getTagName() {
		return tagName;
	}
	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getContext() {
		return context;
	}
	public void setContext(String context) {
		this.context = context;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public SitemapNode getParent() {
		return parent;
	}
	public void setParent(SitemapNode parent) {
		this.parent = parent;
	}
	public List<SitemapNode> getChildren() {
		return children;
	}
	public void setChildren(List<SitemapNode> children) {
		this.children = children;
	}
	public SitemapNode getChild() {
		return child;
	}
	public void setChild(SitemapNode child) {
		this.child = child;
	}

	public String getPath() {
		if(path == null) {
			String tag = "root".equals(this.tagName) ? "" : this.tagName + "/";
			if(this.parent != null) {
				path = this.parent.getPath() + tag;
			} else {
				path = tag;
			}
		}
		if(page!=null&&!"".equals(page)){
			path +=  page;
		}
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
}
