package org.loushang.internet.freemarker.tags;

import java.io.IOException;
import java.io.Writer;
import java.util.Map;

import org.loushang.internet.util.CSRFManager;

import com.inspur.common.utils.PropertiesUtil;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

public class CSRFTokenTag implements TemplateDirectiveModel {

	public void execute(Environment env, Map params, TemplateModel[] loopVars,
			TemplateDirectiveBody body) throws TemplateException, IOException {
		// TODO Auto-generated method stub
		Map<String, String> token = CSRFManager.createToken();
		String CRSFName = PropertiesUtil.getValue("frame.properties", "global.CRSFTokenName");
		Writer out = env.getOut();
		out.write("<input style=\"display:none;\" type=\"hidden\" name=\"");
		out.write(CRSFName);
		out.write("\" value=\"");
		out.write(token.get("key"));
		out.write("\" alt=\"");
		out.write(token.get("token"));
		out.write("\" />");
		out.flush();
	}

}
