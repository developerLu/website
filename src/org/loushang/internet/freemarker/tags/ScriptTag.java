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

public class ScriptTag implements TemplateDirectiveModel {
	
	private static final String PARAM_SRC = "src";
	private static final String PARAM_CHARSET = "charset";
	private static final String PARAM_DEFER = "defer";

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
			//src
			TemplateModel src = (TemplateModel) params.get(PARAM_SRC);
			if(src != null && src instanceof TemplateScalarModel) {
				String srcStr = ((TemplateScalarModel) src).getAsString();
				String contextPath = request.getContextPath();
				if(srcStr.startsWith(contextPath)) {
					// 如果已经经过getUrl方法处理
					parseParams.put("src", srcStr);
				} else {
					parseParams.put("src", Function.getUrl(srcStr));
				}
			}
			//charset
			TemplateModel charset = (TemplateModel) params.get(PARAM_CHARSET);
			if(charset != null && charset instanceof TemplateScalarModel) {
				String charsetStr = ((TemplateScalarModel) charset).getAsString();
				parseParams.put("charset", charsetStr);
			}
			//defer
			TemplateModel defer = (TemplateModel) params.get(PARAM_DEFER);
			if(defer != null && defer instanceof TemplateScalarModel) {
				String deferStr = ((TemplateScalarModel) defer).getAsString();
				parseParams.put("defer", deferStr);
			}
			header.addScript(parseParams);
		}
	}

}
