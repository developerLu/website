package com.inspur.databus.service.id.impl;



import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.inspur.databus.service.BaseDomain;
import com.inspur.databus.service.id.api.IGlobalId;

/**
 * 数据库自增ID生成器
 * @author zhanglch
 */
public class DbGlobalId extends BaseDomain implements IGlobalId{
	private static Log log = LogFactory.getLog(DbGlobalId.class);
	
	public  String getGlobalIncrementId(){
		String ret = null;
		DataSource ds = this.getSqlMapClient().getDataSource();
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			con  = ds.getConnection();
			con.setAutoCommit(false);
		    stmt = con.createStatement();
		    stmt.executeUpdate("update db_global_id set id=id+1");
		    rs = stmt.executeQuery("select id from db_global_id");
		    rs.next();
		    ret =  rs.getBigDecimal("id").toString();
		    
		} catch (SQLException e) {
			try {
				if(con!=null){
					con.rollback();
				}
			} catch (SQLException e1) {
				log.error(e1);
			}
			log.error(e);
		}finally{
			if(rs!=null){
				try {
					rs.close();
				} catch (SQLException e) {
					log.error(e);
				}
			}
			if(stmt!=null){
				try {
					stmt.close();
				} catch (SQLException e) {
					log.error(e);
				}
			}
			if(con!=null){ 
				try {
					con.commit();con.close();
				} catch (SQLException e) {
					log.error(e);
				}
			}
		}
		return ret;
	}
}
