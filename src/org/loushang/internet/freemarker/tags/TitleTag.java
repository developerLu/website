package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.response.header.Header;
import org.loushang.internet.tags.HeadTag;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

public class TitleTag implements TemplateDirectiveModel {

	public void execute(Environment env, Map params, TemplateModel[] loopVars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
		HttpServletRequest request = (HttpServletRequest) ContextHolder.getRequest();
		Header header =  (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if(header==null){
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		if(body != null) {
			StringWriter sw = new StringWriter();
			body.render(sw);
			header.setTitle(sw.toString());
			sw.flush(); sw.close();
		}
	}

}
