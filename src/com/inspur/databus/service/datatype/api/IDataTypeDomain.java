package com.inspur.databus.service.datatype.api;

import java.util.List;
import java.util.Map;

/**
 * 数据类型相关查询维护
 * @author luguosui
 *
 */
public interface IDataTypeDomain {

	/**
	 * 根据查询条件获取数据类型列表（列表+数目）
	 */
	public Map<String,Object> getListByParam(Map<String,Object> param);


	/**
	 * 新增数据类型
	 */
	public void add(Map<String, Object> dataType);
	
	/**
	 * 更新数据类型
	 */
	public void update(Map<String, Object> dataType);

}
