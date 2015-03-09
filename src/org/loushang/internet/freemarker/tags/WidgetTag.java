package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;

import org.loushang.internet.bindingclass.ModuleBindingManager;
import org.loushang.internet.bindingclass.ThemeBindingManager;
import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.freemarker.FreeMarkerEngine;
import org.loushang.internet.request.RequestWrapper;
import org.loushang.internet.response.BufferedResponseImpl;
import org.loushang.internet.servlet.WebDispatcherFilter;
import org.loushang.internet.util.RequestUtil;
import org.loushang.internet.util.StringUtils;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateScalarModel;

public class WidgetTag implements TemplateDirectiveModel {
	
	private static final String PARAM_PATH = "path";

	public void execute(Environment env, Map params, TemplateModel[] loopVars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
		if(params != null) {
			TemplateModel pathParam = (TemplateModel) params.get(PARAM_PATH);
			String path = "";
			if(pathParam != null && pathParam instanceof TemplateScalarModel) {
				path = ((TemplateScalarModel) pathParam).getAsString();
			}
			if(StringUtils.isNotEmpty(path)) {
				ModuleBindingManager moduleMgr = ModuleBindingManager.getCurrentManager();
				String viewPath = moduleMgr.getViewPath();
				path = "widget/" + path;

				String widgetPath = ThemeBindingManager.getTemplateUri(viewPath + path, ThemeBindingManager.getCurrentTheme());
				if(widgetPath == null) return;
				try {
					HttpServletResponse hres = ContextHolder.getResponse();
					BufferedResponseImpl response = (BufferedResponseImpl) hres;
					RequestWrapper request =  (RequestWrapper) ContextHolder.getRequest();
					String suffix = StringUtils.getFileSuffix(widgetPath);
					if(WebDispatcherFilter.JSP_SUFFIX.equals(suffix)) {
						//添加isWidget参数
						widgetPath = RequestUtil.addWidgeParam(widgetPath);
						//include Widget
						request.getRequestDispatcher(widgetPath).include(request, response);
						//--requestDispatcher原生的include方法会改变当前的response对象，
						//--此处在加载完widget后重新设置当前的上下文的response对象
						ContextHolder.setContextParameter(ContextHolder.KEY_RESPONSE, hres);
					} else {
						Map<String, Object> paramMap = RequestUtil.parseParameterMap(widgetPath);
						//将url中的参数设置在request中
						request.setAllParameters(paramMap);
						int paramIndex = widgetPath.lastIndexOf("?");
						if(paramIndex > -1) {
							widgetPath = widgetPath.substring(0, paramIndex);
						}
						//执行后台处理类
						moduleMgr.executeWidget(widgetPath);
						//渲染模板
						FreeMarkerEngine.getInstance().process(widgetPath ,request, response);
						//清空request中设置的参数
						request.removeParameterMap(paramMap);
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (TemplateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ServletException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

}
