package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.util.HashMap;
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
import freemarker.template.TemplateScalarModel;

public class MetaTag implements TemplateDirectiveModel {
	
	private static final String PARAM_NAME = "name";
	private static final String PARAM_CONTENT = "content";
	private static final String PARAM_HTTP_EQUIV = "httpEquiv";
	private static final String PARAM_SCHEME = "scheme";

	public void execute(Environment env, Map params, TemplateModel[] loopVars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
	 	HttpServletRequest request = (HttpServletRequest) ContextHolder.getRequest();
		Header header =  (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if(header==null){
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		Map<String, String> parseParams = new HashMap<String, String>();
		if(params != null) {
			//处理参数
			//name
			TemplateModel name = (TemplateModel) params.get(PARAM_NAME);
			if(name != null && name instanceof TemplateScalarModel) {
				String nameStr = ((TemplateScalarModel) name).getAsString();
				parseParams.put("name", nameStr);
			}
			//http-equiv
			TemplateModel httpEquiv = (TemplateModel) params.get(PARAM_HTTP_EQUIV);
			if(httpEquiv != null && httpEquiv instanceof TemplateScalarModel) {
				String httpEquivStr = ((TemplateScalarModel) httpEquiv).getAsString();
				parseParams.put("http-equiv", httpEquivStr);
			}
			//content
			TemplateModel content = (TemplateModel) params.get(PARAM_CONTENT);
			if(content != null && content instanceof TemplateScalarModel) {
				String contentStr = ((TemplateScalarModel) content).getAsString();
				parseParams.put("content", contentStr);
			}
			//scheme
			TemplateModel scheme = (TemplateModel) params.get(PARAM_SCHEME);
			if(scheme != null && scheme instanceof TemplateScalarModel) {
				String schemeStr = ((TemplateScalarModel) scheme).getAsString();
				parseParams.put("scheme", schemeStr);
			}
		}
		header.addMeta(parseParams);
		if(body != null) {
			body.render(env.getOut());
		}
	}

}
