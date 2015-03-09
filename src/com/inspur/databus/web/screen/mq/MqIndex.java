package com.inspur.databus.web.screen.mq;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.util.StringUtils;
import org.loushang.internet.view.ViewHandler;

import com.inspur.databus.web.screen.util.BeanUtil;
import com.inspur.databus.web.screen.util.RequestParamUtil;

/**
 * 首页
 * @author zhanglch
 */
public class MqIndex implements ViewHandler {

	private static Log log = LogFactory.getLog(MqIndex.class);// 日志
	public void execute(HttpServletRequest request, HttpServletResponse response) {
		try{
			//-分页参数（通过自定义的分页工具类获取分页参数）
    		Map<String, Object> param = new HashMap<String, Object>();
    		Map<String, Integer> limit = RequestParamUtil.getRequestLimit(request, 1, 10);
    		param.put("_limit", limit);
    		param.put("_order", " notice_id desc");
    		
		}catch(Exception ex){
			ex.printStackTrace();
			log.error("系统配置信息页出错！",ex);
		}
		
	}

}
