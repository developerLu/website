package com.inspur.databus.service.dic.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.inspur.databus.service.BaseDomain;
import com.inspur.databus.service.dic.api.IDicDomain;

/**
 * 字典解析服务类
 * @author luguosui
 *
 */
public class DicDomain  extends BaseDomain implements IDicDomain{

	private static Log log = LogFactory.getLog(DicDomain.class);//日志

	Map<String, Map<String, String>> dicMap = new HashMap<String, Map<String, String>>();
	/**
	 * 根据查询条件获取列表
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getList(String table,String code,String value){
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT ").append(code).append(" AS CODE ,").append(value).append(" AS VALUE ").append(" FROM ").append(table);
		try{
			return dealNullValue((List<Map<String,Object>>)sqlMapClient.queryForList("dic.exeSQL",sql.toString()));
		}catch(Exception ex){
			log.error("DicDomain.getList()出错！",ex);
			ex.printStackTrace();
			return com.inspur.databus.util.InitUtil.initMapList();
		}
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getList(String sql){
		try{
			return dealNullValue((List<Map<String,Object>>)sqlMapClient.queryForList("dic.exeSQL",sql));
		}catch(Exception ex){
			log.error("DicDomain.getList()出错！",ex);
			ex.printStackTrace();
			return com.inspur.databus.util.InitUtil.initMapList();
		}
	}
	
	public Map<String, List<Map<String,Object>>> getAllDic() {
		Map<String, List<Map<String,Object>>> returnMap =  new HashMap<String, List<Map<String,Object>>>();
		Set<String> keySet = dicMap.keySet();
		for (String table : keySet) {
			List<Map<String,Object>> list = getList(table,dicMap.get (table).get("code"), (dicMap.get(table)).get("value"));
			returnMap.put(table.toUpperCase(), list);
		}
		return returnMap;
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
	public Map<String, Map<String, String>> getDicMap() {
		return dicMap;
	}
	public void setDicMap(Map<String, Map<String, String>> dicMap) {
		this.dicMap = dicMap;
	}
}
