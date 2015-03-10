package com.hongshee.ejforum.data;

/**
 * <p>Title: EntityDAO.java</p>
 * <p>Description: Base class of all data access object</p>
 * <p>Copyright: Hongshee Software (c) 2007</p>
 * @author jackie du
 * @version 1.0
 */

import java.util.ArrayList;
import java.util.HashMap;
//import java.util.Map;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import com.hongshee.common.util.DBManager;
import com.hongshee.ejforum.common.AppContext;
//import com.hongshee.ejforum.util.PageUtils;

public abstract class EntityDAO 
{
    protected DBManager dbManager = DBManager.getInstance();
    SqlAdapter adapter = AppContext.getInstance().getSqlAdapter();
    String adapterName = adapter.getClass().getName();
    
    /**
     * Execute an update statement
     * @param 
     *      sql - sql statement to execute
     *      paramList - Parameter value list
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    public void execUpdateSql(String sql, ArrayList<Object> paramList) 
                                                throws SQLException
    {
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            execUpdateSql(sql, paramList, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }
    
    /**
     * Execute an update statement
     * @param 
     *      sql - sql statement to execute
     *      paramList - Parameter value list
     *      conn - DB connection
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    protected void execUpdateSql(String sql, ArrayList<Object> paramList, 
                                 Connection conn) throws SQLException
    {
        PreparedStatement pstmtUpdate = null;
        try
        {
            pstmtUpdate = conn.prepareStatement(sql);
            if (paramList != null)
            {
                for (int i=0; i<paramList.size(); i++)
                {
                    pstmtUpdate.setObject(i+1, paramList.get(i));
                }
            }
            pstmtUpdate.executeUpdate();
        }
        finally
        {
            dbManager.closePStatement(pstmtUpdate);
        }
    }

    /**
     * Execute an select statement
     * @param 
     *      sql - sql statement to execute
     *      paramList - Parameter value list
     * @return Result list - ArrayList<HashMap>
     * @throws SQLException
     * @since 1.0
     */
    public ArrayList<HashMap> execSelectSql(String sql, ArrayList<Object> paramList)
                                                                throws SQLException
    {
        Connection conn = null;
        try
        {
            conn = dbManager.getConnection();
            return execSelectSql(sql, paramList, conn);
        }
        finally
        {
            dbManager.closeConnection(conn);
        }
    }
    
    /**
     * Execute an select statement
     * @param 
     *      sql - sql statement to execute
     *      paramList - Parameter value list
     *      conn - DB connection
     * @return Result list - ArrayList<HashMap>
     * @throws SQLException
     * @since 1.0
     */
    protected ArrayList<HashMap> execSelectSql(String sql, ArrayList<Object> paramList,
                                               Connection conn) throws SQLException
    {
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(sql);
            if (paramList != null)
            {
                for (int i=0; i<paramList.size(); i++)
                {
                    pstmtQuery.setObject(i+1, paramList.get(i));
                }
            }
            rs = pstmtQuery.executeQuery();
            
            ArrayList<HashMap> result = new ArrayList<HashMap>();
            if (rs.next())
                fetchRsToList(rs, result);
            
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }

    /**
     * Execute an select count statement
     * @param 
     *      sql - sql statement to execute
     *      conn - DB connection
     * @return select count
     * @throws SQLException
     * @since 1.0
     */
    protected int execSelectCountSql(String countSql, ArrayList<Object> paramValues,
                                     Connection conn) throws SQLException
    {
        int result = 0;
        PreparedStatement pstmtQuery = null;
        ResultSet rs = null;
        try
        {
            pstmtQuery = conn.prepareStatement(countSql);
            if (paramValues != null)
            {
                for (int i=0; i<paramValues.size(); i++)
                {
                    pstmtQuery.setObject(i+1, paramValues.get(i));
                }
            }
            rs = pstmtQuery.executeQuery();
            
            if (rs.next())
                result = rs.getInt(1);
            
            return result;
        }
        finally
        {
            dbManager.closeResultSet(rs);
            dbManager.closePStatement(pstmtQuery);
        }
    }
    
    /**
     * Execute an update statement
     * @param 
     *      rs - ResultSet to be fetched data, must not be null or empty
     *      result - ArrayList<HashMap>, must not be null
     * @return none
     * @throws SQLException
     * @since 1.0
     */
    protected void fetchRsToList(ResultSet rs, ArrayList<HashMap> result) throws SQLException
    {
        ResultSetMetaData metaData = rs.getMetaData();
        String fieldName = null;
        HashMap<String, String> record = null;
        do
        {
            record = new HashMap<String, String>();
            for(int i=0; i<metaData.getColumnCount(); i++)           
            {                
                fieldName = (String)metaData.getColumnName(i+1);
                record.put(fieldName.toUpperCase(), rs.getString(i+1));
            }
            result.add(record);
        }
        while(rs.next());
    }
    
}
