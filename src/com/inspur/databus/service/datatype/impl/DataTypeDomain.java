package com.inspur.databus.service.datatype.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.util.StringUtils;

import com.inspur.databus.service.BaseDomain;
import com.inspur.databus.service.datatype.api.IDataTypeDomain;

/**
 * 数据类型相关查询维护
 * @author luguosui
 *
 */
public class DataTypeDomain extends BaseDomain implements IDataTypeDomain{

	private static Log log = LogFactory.getLog(DataTypeDomain.class);//日志


	/**
	 * 新增数据类型
	 */
	public void add(Map<String, Object> dataType){
		if(!StringUtils.isNotEmptyMap(dataType)) return;
		try{
			sqlMapClient.insert("dataType.add",dealNullValue(dataType));
		}catch(Exception ex){
			log.error("addDataType()出错！",ex);
			ex.printStackTrace();
			System.out.println(ex);
		}
	}
	/**
	 * 更新数据类型
	 */
	public void update(Map<String, Object> dataType){
		try{
			sqlMapClient.update("dataType.update", dealNullValue(dataType));
		}catch(Exception ex){
			ex.printStackTrace();
			log.error("DataTypeDomain.update()出错！",ex);
		}
	}
	@Override
	public Map<String, Object> getListByParam(Map<String, Object> param) {
		if(!StringUtils.isNotEmptyMap(param))return null;
		try{
			System.out.println(getList(param)==null?0:getList(param).size());
			param.put("data", getList(param));
			param.put("count", getCount(param));
			return param;
		}catch(Exception ex){
			System.out.println("异常："+ex);
			log.error("DataTypeDomain.getListByParam",ex);
			ex.printStackTrace();
			return com.inspur.databus.util.InitUtil.initMap();
		}
	}

	/**
	 * 根据查询条件获取数据类型数目
	 */
	public int getCount(Map<String, Object> param) {
		try{
			Map map=(Map) sqlMapClient.queryForObject("dataType.getCount",param);
			return Integer.parseInt(map.get("COUNT").toString()) ;
		}catch(Exception ex){
			log.error("DataTypeDomain.getCount()出错！",ex);
			ex.printStackTrace();
			return 0;
		}
	}

	/**
	 * 根据查询条件获取数据类型列表
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getList(Map<String,Object> param){
		try{
			return dealNullValue((List<Map<String,Object>>)sqlMapClient.queryForList("dataType.getList",param));
		}catch(Exception ex){
			log.error("DataTypeDomain.getList()出错！",ex);
			ex.printStackTrace();
			return com.inspur.databus.util.InitUtil.initMapList();
		}
	}

	/**
	 * null值处理
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> dealNullValue(List<Map<String,Object>> list) {
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		for (Map<String, Object> map : list) {
			returnList.add(dealNullValue(map));
		}
		return returnList;
	}
	
	/**
	 * null值处理
	 * @param map
	 * @return
	 */
	private Map<String,Object> dealNullValue(Map<String,Object> map) {
		Set<String> keSet = map.keySet();
		for (Iterator it = keSet.iterator(); it.hasNext();) {
            String key = (String) it.next();
            if (map.get(key)==null) {
				map.put(key, "");
			}
        }
		return map;
	}
}
