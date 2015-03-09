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
/**
 * 
 * @author luguosui
 *
 */
public class TopicDBList {

	private static Log log = LogFactory.getLog(TopicDBList.class);// 日志
	IDataTypeDomain dataTypeDomain =(IDataTypeDomain) BeanUtil.getBean("dataTypeDomain");


    /**
     * 初始化
     * @param req
     * @param res
     */
    public void execute(HttpServletRequest req, HttpServletResponse res) {
		System.out.println("TopicDBList");
		//-分页参数（通过自定义的分页工具类获取分页参数）
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Integer> limit = RequestParamUtil.getRequestLimit(req, 1, 10);
		param.put("_limit", limit);
		param.put("_ORDER", " topic_name desc");
		//-获取结果
		Map<String,Object> map = dataTypeDomain.getListByParam(param);
		req.setAttribute("count", map.get("count"));
		req.setAttribute("dataTypelist", map.get("data"));
		req.setAttribute("index", limit.get("_pindex"));
		req.setAttribute("pagesize", limit.get("_psize"));
	}
    /**
     * 启用所有topic
     * @param req
     * @param res
     * @throws IOException
     */
    public void  doInitAll(HttpServletRequest req, HttpServletResponse res) throws IOException {
    	System.out.println("doInitAll");
		//-获取结果
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Integer> limit = RequestParamUtil.getRequestLimit(req, 1, 10);
		param.put("_limit", limit);//无分页
		param.put("IS_INIT", "0");
		param.put("_ORDER", " topic_name desc");
		//-获取结果
		Map<String,Object> map = dataTypeDomain.getListByParam(param);
		List<Map<String, Object>> dataTypeList =  (List<Map<String, Object>>) map.get("data");
		
		try {
			for (int i = 0; i < dataTypeList.size(); i++) {
				Map dataTpyeMap=dataTypeList.get(i);
	            System.out.println(dataTpyeMap.get("TOPIC_CODE")+"--creating....");
	            dataTpyeMap.put("IS_INIT", "1");
	            dataTpyeMap.put("CLISTER_NAME","111");
	            dataTpyeMap.put("UPDATE_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
	            dataTpyeMap.put("INIT_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
	            dataTpyeMap.put("TAGS","");
	            dataTpyeMap.put("STOP_TIME","");
	            dataTpyeMap.put("BROKER_ADDR","");
	            dataTypeDomain.update(dataTpyeMap);
	            System.out.println(dataTpyeMap.get("TOPIC_CODE")+"--created!");
			}
		} catch (Throwable e) {
	        res.getWriter().write("0");
			e.printStackTrace();
		} 
        res.getWriter().write("1");
    }
    /**
     * 启用指定topic
     * @param req
     * @param res
     * @throws IOException
     */
    public void doCreateTopic(HttpServletRequest req, HttpServletResponse res) throws IOException {
    	System.out.println("doInitAll");
		//-获取结果
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Integer> limit = RequestParamUtil.getRequestLimit(req, 1, 10);
		String topic = req.getParameter("topic");
//		param.put("_limit", limit);//无分页
		param.put("TOPIC_CODE", topic);
		param.put("_ORDER", " topic_name desc");
		//-获取结果
		Map<String,Object> map = dataTypeDomain.getListByParam(param);
		List<Map<String, Object>> dataTypeList =  (List<Map<String, Object>>) map.get("data");
		
		try {
			for (int i = 0; i < dataTypeList.size(); i++) {
				Map dataTpyeMap=dataTypeList.get(i);
	            System.out.println(dataTpyeMap.get("TOPIC_CODE")+"--creating....");
	            dataTpyeMap.put("IS_INIT", "1");
	            dataTpyeMap.put("CLISTER_NAME","update");
	            dataTpyeMap.put("UPDATE_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
	            dataTpyeMap.put("INIT_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
	            dataTpyeMap.put("TAGS","");
	            dataTpyeMap.put("STOP_TIME","");
	            dataTpyeMap.put("BROKER_ADDR","");
	            dataTypeDomain.update(dataTpyeMap);
	            System.out.println(dataTpyeMap.get("TOPIC_CODE")+"--created!");
			}
		} catch (Throwable e) {
	        res.getWriter().write("0");
			e.printStackTrace();
		} 
        res.getWriter().write("1");
	}
    /**
     * 停用指定topic
     * @param req
     * @param res
     * @throws IOException
     */
    public void doDelTopic(HttpServletRequest req, HttpServletResponse res) throws IOException {
    	System.out.println("doDelTopic");
		//-获取结果
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Integer> limit = RequestParamUtil.getRequestLimit(req, 1, 10);
		String topic = req.getParameter("topic");
//		param.put("_limit", limit);//无分页
		param.put("TOPIC_CODE", topic);
		param.put("_ORDER", " topic_name desc");
		//-获取结果
		Map<String,Object> map = dataTypeDomain.getListByParam(param);
		List<Map<String, Object>> dataTypeList =  (List<Map<String, Object>>) map.get("data");
		
		try {
			for (int i = 0; i < dataTypeList.size(); i++) {
				Map dataTpyeMap=dataTypeList.get(i);
	            System.out.println(dataTpyeMap.get("TOPIC_CODE")+"--stoping....");
	            dataTpyeMap.put("IS_INIT", "0");
	            dataTpyeMap.put("UPDATE_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
	            dataTpyeMap.put("STOP_TIME", new SimpleDateFormat("yyyyMMdd hh:mm:ss").format(new Date()));
	            dataTypeDomain.update(dataTpyeMap);
	            System.out.println(dataTpyeMap.get("TOPIC_CODE")+"--stoped!");
			}
		} catch (Throwable e) {
	        res.getWriter().write("0");
			e.printStackTrace();
		} 
        res.getWriter().write("1");
		
	}
}
