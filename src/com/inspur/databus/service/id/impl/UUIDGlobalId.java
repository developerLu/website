package com.inspur.databus.service.id.impl;

import java.util.UUID;

import com.inspur.databus.service.BaseDomain;
import com.inspur.databus.service.id.api.IGlobalId;

/**
 * 随机ID生成器
 * @author zhanglch
 */
public class UUIDGlobalId extends BaseDomain implements IGlobalId{
	public  String getGlobalIncrementId(){
		UUID uuid = UUID.randomUUID();
		return uuid.toString();
	}

}
