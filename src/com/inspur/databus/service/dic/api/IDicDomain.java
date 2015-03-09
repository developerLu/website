package com.inspur.databus.service.dic.api;

import java.util.List;
import java.util.Map;

/**
 * 字典接口
 * @author luguosui
 *
 */
public interface IDicDomain {

	/**
	 * 根据查询条件获取列表
	 */
	public List<Map<String,Object>> getList(String table,String code,String value);
	/**
	 * 根据查询条件获取列表
	 */
	public List<Map<String,Object>> getList(String sql);
	/**
	 * 加载所有的字典
	 * @return
	 */
	public Map<String, List<Map<String,Object>>> getAllDic() ;
}
