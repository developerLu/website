package com.inspur.databus.service;

import org.springframework.orm.ibatis.SqlMapClientTemplate;


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
}
