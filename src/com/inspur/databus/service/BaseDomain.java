package com.inspur.databus.service;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import com.inspur.databus.service.id.api.IGlobalId;
import com.inspur.databus.util.SpringContextHolder;

/**
 * 基础Domain，默认注入SqlMapClientTemplate和实现获取自增ID
 * @author zhanglch
 */
public class BaseDomain{

	public SqlMapClientTemplate sqlMapClient;

	public SqlMapClientTemplate getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClientTemplate sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	public String getGlobalIncrementId(){
		IGlobalId globalId = SpringContextHolder.getBean("GlobalId");
		return globalId.getGlobalIncrementId();
	}
	
}
