package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.freemarker.FreeMarkerEngine;
import org.loushang.internet.servlet.WebDispatcherFilter;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

public class ScreenInclude implements TemplateDirectiveModel {

	public void execute(Environment env, Map params, TemplateModel[] loopVars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
		HttpServletRequest request =  ContextHolder.getRequest();
		HttpServletResponse response =  ContextHolder.getResponse();
		String url = (String) request.getAttribute(WebDispatcherFilter.SCREEN_ATTRIBUTE_NAME);
		try {
			FreeMarkerEngine.getInstance().process(url, request, response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TemplateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
