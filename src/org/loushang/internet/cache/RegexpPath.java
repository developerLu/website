package org.loushang.internet.cache;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexpPath {
	private String regexp;
	private boolean allowCache = false;
	private boolean subPath;
	private int expireTime;
	private Pattern pattern;
	
	private List<RegexpPath> children;
	private List<RegexpPath> excep;
	
	public RegexpPath checkIsMatch(String path) {
		Matcher matcher = pattern.matcher(path);
		if(matcher.find()) {
			RegexpPath tmp = null;
			if(children != null) {
				for (RegexpPath rp : children) {
					tmp = rp.checkIsMatch(path);
					if(tmp != null) break;
				}
			}
			if(excep != null && tmp == null) {
				for (RegexpPath rp : excep) {
					tmp = rp.checkIsMatch(path);
					if(tmp != null) break;
				}
			}
			if(tmp == null) tmp = this;
			return tmp;
		} else {
			return null;
		}
	}

	public String getRegexp() {
		return regexp;
	}

	public void setRegexp(String regexp) {
		this.regexp = regexp;
		pattern = Pattern.compile(this.regexp);
	}


	public List<RegexpPath> getExcep() {
		return excep;
	}

	public boolean isAllowCache() {
		return allowCache;
	}

	public void setAllowCache(boolean allowCache) {
		this.allowCache = allowCache;
	}

	public boolean isSubPath() {
		return subPath;
	}

	public void setSubPath(boolean subPath) {
		this.subPath = subPath;
	}

	public void setExcep(List<RegexpPath> excep) {
		this.excep = excep;
	}

	public int getExpireTime() {
		return expireTime;
	}

	public void setExpireTime(int expireTime) {
		this.expireTime = expireTime;
	}

	public Pattern getPattern() {
		return pattern;
	}

	public void setPattern(Pattern pattern) {
		this.pattern = pattern;
	}

	public List<RegexpPath> getChildren() {
		return children;
	}

	public void setChildren(List<RegexpPath> children) {
		this.children = children;
	}
}
