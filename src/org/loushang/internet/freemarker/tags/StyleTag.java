package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.response.header.Header;
import org.loushang.internet.tags.HeadTag;
import org.loushang.internet.util.el.Function;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateScalarModel;

public class StyleTag implements TemplateDirectiveModel {

	private static final String PARAM_HREF = "href";
	private static final String PARAM_REL = "rel";
	private static final String PARAM_TYPE = "type";
	private static final String PARAM_MEDIA = "media";

	public void execute(Environment env, Map params, TemplateModel[] loopVars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
		HttpServletRequest request =  ContextHolder.getRequest();
		Header header = (Header) request.getAttribute(HeadTag.HEADER_NAME);
		if (header == null) {
			header = new Header();
			request.setAttribute(HeadTag.HEADER_NAME, header);
		}
		if(params != null) {
			Map<String, String> parseParams = new LinkedHashMap<String, String>();
			//href
			TemplateModel href = (TemplateModel) params.get(PARAM_HREF);
			if(href != null && href instanceof TemplateScalarModel) {
				String hrefStr = ((TemplateScalarModel) href).getAsString();
				String contextPath = request.getContextPath();
				if(hrefStr.startsWith(contextPath)) {
					// 如果已经经过getUrl方法处理
					parseParams.put("href", hrefStr);
				} else {
					parseParams.put("href", Function.getUrl(hrefStr));
				}
			}
			//rel
			TemplateModel rel = (TemplateModel) params.get(PARAM_REL);
			if(rel != null && rel instanceof TemplateScalarModel) {
				String relStr = ((TemplateScalarModel) rel).getAsString();
				parseParams.put("rel", relStr);
			} else {
				parseParams.put("rel", "stylesheet");
			}
			//type
			TemplateModel type = (TemplateModel) params.get(PARAM_TYPE);
			if(type != null && type instanceof TemplateScalarModel) {
				String typeStr = ((TemplateScalarModel) type).getAsString();
				parseParams.put("type", typeStr);
			} else {
				parseParams.put("type", "text/css");
			}
			//media
			TemplateModel media = (TemplateModel) params.get(PARAM_MEDIA);
			if(media != null && media instanceof TemplateScalarModel) {
				String mediaStr = ((TemplateScalarModel) media).getAsString();
				parseParams.put("media", mediaStr);
			}
			header.addStyle(parseParams);
		}
	}

}
