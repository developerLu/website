package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.io.Writer;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.response.header.Header;
import org.loushang.internet.tags.HeadTag;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateScalarModel;

public class HtmlTag implements TemplateDirectiveModel {
	
	private static final String PARAM_MANIFEST = "manifest";
	private static final String PARAM_NAMESPACE = "xmlns";
	private static final String PARAM_NSFIX = "nsfix";

	public void execute(Environment env, Map params, TemplateModel[] loopvars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
		Writer out = env.getOut();
		HttpServletRequest request = (HttpServletRequest) ContextHolder.getRequest();
		Header header =  (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if(header==null){
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		if(params != null) {
			//处理参数
			TemplateModel manifest = (TemplateModel) params.get(PARAM_MANIFEST);
			if(manifest != null && manifest instanceof TemplateScalarModel) {
				//manifest
				String manifestStr = ((TemplateScalarModel) manifest).getAsString();
				header.setManifest(manifestStr);
			}
			
			TemplateModel namespace = (TemplateModel) params.get(PARAM_NAMESPACE);
			if(namespace != null && namespace instanceof TemplateScalarModel) {
				//namespace
				String namespaceKey = PARAM_NAMESPACE;
				TemplateModel nsfix = (TemplateModel) params.get(PARAM_NSFIX);
				if(nsfix != null && nsfix instanceof TemplateScalarModel) {
					String nsfixStr = ((TemplateScalarModel) nsfix).getAsString();
					if(StringUtils.isNotEmpty(nsfixStr))
						namespaceKey += ":" + nsfixStr;
				}
				String namespaceStr = ((TemplateScalarModel) namespace).getAsString();
				header.setNamespace(namespaceKey + "=\"" + namespaceStr + "\"");
			}
		}
		if(body != null) {
			body.render(env.getOut());
		}
		out.write("</html>");
		out.flush();
	}

}
