package com.inspur.databus.web.screen.mq.console.topic;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


import com.inspur.databus.service.datatype.api.IDataTypeDomain;
import com.inspur.databus.web.screen.util.BeanUtil;
import com.inspur.databus.web.screen.util.RequestParamUtil;

public class TopicDBAction{
	private static Log log = LogFactory.getLog(TopicDBAction.class);// 日志



	IDataTypeDomain dataTypeDomain =(IDataTypeDomain) BeanUtil.getBean("dataTypeDomain");

    
    
    public void execute(HttpServletRequest req, HttpServletResponse res) {
		System.out.println("TopicDBAction.execute");
		String m = req.getParameter("m");
		String topicCode = req.getParameter("topicCode");
        try {
			req.setAttribute("method", m);
			if ("updateTopic".equals(m)) {
				//-获取结果
				Map<String, Object> param = new HashMap<String, Object>();
				Map<String, Integer> limit = RequestParamUtil.getRequestLimit(req, 1, 10);
				param.put("_limit", limit);//无分页
				param.put("TOPIC_CODE", topicCode);
				param.put("_ORDER", " topic_name desc");
				//-获取结果
				Map<String,Object> map = dataTypeDomain.getListByParam(param);
				List<Map<String, Object>> dataTypeList =  (List<Map<String, Object>>) map.get("data");
				if (dataTypeList.size()>0) {
					req.setAttribute("dataType", dataTypeList.get(0));
				}
			}
        }
        catch (Throwable t) {
			t.printStackTrace();
        }
		
	}
    
    public void doAddTopic(HttpServletRequest req, HttpServletResponse res) throws IOException {
		System.out.println("TopicDBAction.doAddTopic");
    	String topicCode = req.getParameter("topicCode");
		String topicName = req.getParameter("topicName");
		String readQueueNums = req.getParameter("readQueueNums");
		String writeQueueNums = req.getParameter("writeQueueNums");
		String perm = req.getParameter("perm");
		String brokerAddr = req.getParameter("brokerAddr");
		String clusterName = req.getParameter("clusterName");
		String tags = req.getParameter("tags");
		String isInit = req.getParameter("isInit");
		String keyColumn = req.getParameter("keyColumn");
		String initTime = req.getParameter("initTime");
		String stopTime = req.getParameter("stopTime");
		String updateTime = req.getParameter("updateTime");
		Map<String, Object> dataType = new HashMap<String, Object>();
		dataType.put("TOPIC_CODE", topicCode);
		dataType.put("TOPIC_NAME", topicName);
		dataType.put("READ_QUEUE_NUMS", readQueueNums);
		dataType.put("WRITE_QUEUE_NUMS", writeQueueNums);
		dataType.put("PERM", perm);
		dataType.put("BROKER_ADDR", brokerAddr);
		dataType.put("CLISTER_NAME", clusterName);
		dataType.put("TAGS", tags);
		dataType.put("IS_INIT", "1");
		dataType.put("KEY_COLUMN", keyColumn);
		dataType.put("INIT_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
		dataType.put("STOP_TIME", stopTime);
		dataType.put("UPDATE_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
        String msg = "";
        try {
    		dataTypeDomain.add(dataType);
            msg="1";
        }
        catch (Throwable t) {
            msg = t.getMessage();
			t.printStackTrace();
        }
        res.getWriter().write(msg);
	}
    

    public void doUpdateTopic(HttpServletRequest req, HttpServletResponse res) throws IOException {
		System.out.println("TopicDBAction.doUpdateTopic");
		String topicCode = req.getParameter("topicCode");
		String topicName = req.getParameter("topicName");
		String readQueueNums = req.getParameter("readQueueNums");
		String writeQueueNums = req.getParameter("writeQueueNums");
		String perm = req.getParameter("perm");
		String brokerAddr = req.getParameter("brokerAddr");
		String clusterName = req.getParameter("clusterName");
		String tags = req.getParameter("tags");
		String isInit = req.getParameter("isInit");
		String keyColumn = req.getParameter("keyColumn");
		String initTime = req.getParameter("initTime");
		String stopTime = req.getParameter("stopTime");
		String updateTime = req.getParameter("updateTime");
		Map<String, Object> dataType = new HashMap<String, Object>();
		dataType.put("TOPIC_CODE", topicCode);
		dataType.put("TOPIC_NAME", topicName);
		dataType.put("READ_QUEUE_NUMS", readQueueNums);
		dataType.put("WRITE_QUEUE_NUMS", writeQueueNums);
		dataType.put("PERM", perm);
		dataType.put("BROKER_ADDR", brokerAddr);
		dataType.put("CLISTER_NAME", clusterName!=null?clusterName:"");
		dataType.put("TAGS", tags);
		dataType.put("IS_INIT", "1");
		dataType.put("KEY_COLUMN", keyColumn);
		dataType.put("INIT_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
		dataType.put("STOP_TIME", stopTime);
		dataType.put("UPDATE_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
        String msg = "";
        try {
    		dataTypeDomain.update(dataType);
            msg="1";
        }
        catch (Throwable t) {
            msg = t.getMessage();
			t.printStackTrace();
        }
        res.getWriter().write(msg);
	}
    
    public void doDeleteTopic(HttpServletRequest req, HttpServletResponse res) throws IOException {
		System.out.println("TopicDBAction.doDeleteTopic");
	}

}
