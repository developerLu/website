package org.loushang.internet.util;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.util.regex.PathNameWildcardCompiler;

/**
 * 用来匹配和过滤<code>request.getRequestURI()</code>。
 * 
 */
public class RequestURIFilter {
    private final String[] uris;
    private final Pattern[] patterns;

    public RequestURIFilter(String uris) {
    	if(uris==null||uris.equals("")){
    		uris="";
    	}
        List<String> names =  new LinkedList<String>();
        List<Pattern> patterns = new LinkedList<Pattern>();

        for (String uri : uris.split(",")) {
            uri =uri.trim();

            if (uri != null&&!uri.equals("")) {
                names.add(uri);
                patterns.add(PathNameWildcardCompiler.compilePathName(uri,0x4000));
            }
        }

        if (!patterns.isEmpty()) {
            this.uris = names.toArray(new String[names.size()]);
            this.patterns = patterns.toArray(new Pattern[patterns.size()]);
        } else {
            this.uris = new String[]{};
            this.patterns = null;
        }
    }

    public boolean matches(HttpServletRequest request) {
        if (patterns != null) {
            String requestURI = request.getRequestURI();

            for (Pattern pattern : patterns) {
                if (pattern.matcher(requestURI).find()) {
                    return true;
                }
            }
        }

        return false;
    }
    public boolean matches(String requestURI) {
    	if (patterns != null) {
    		
    		for (Pattern pattern : patterns) {
    			if (pattern.matcher(requestURI).find()) {
    				return true;
    			}
    		}
    	}
    	
    	return false;
    }
}
