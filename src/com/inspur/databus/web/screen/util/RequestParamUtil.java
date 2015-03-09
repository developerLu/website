package com.inspur.databus.web.screen.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.loushang.internet.util.StringUtils;

/**
 * 分页、请求等参数处理
 * @author zhanglch
 */
public class RequestParamUtil {
	
	public static Map<String,Object> pageMap = new HashMap<String,Object>();//这里面存了前台分页的Map

	/**
	 * 获取request对象中的分页参数，并返回一个map
	 * @request request对象
	 * @defindex 没有找到index参数时，指定的默认值
	 * @defsize 没有找到pagesize参数时，指定的默认值
	 */
	public static Map<String, Integer> getRequestLimit(HttpServletRequest request, int defindex, int defsize) {
		String indexstr = null;
		String sizestr = null;
		
		if(request != null){
			indexstr = request.getParameter("index");
			sizestr = request.getParameter("pagesize");
		}
		
		int index = defindex;
		if(StringUtils.isNotEmpty(indexstr)) {
			index = Integer.parseInt(indexstr);
		}
		int size = defsize;
		if(StringUtils.isNotEmpty(sizestr)) {
			size = Integer.parseInt(sizestr);
		}
		if(index < 1) {
			index = defindex;
		}
		if(size < 1) {
			size = defsize;
		}
		Map<String, Integer> limit = new HashMap<String, Integer>();
		limit.put("_pindex", index);
		limit.put("_pstart", (index - 1) * size);
		limit.put("_psize", size);
		
		return limit;
	}
	
	/**
	 * 前台进行分页
	 * @param list
	 * @param request
	 * @param defindex
	 * @param defsize
	 * @return
	 */
	public static List<?> getData(List<?> list,HttpServletRequest request, int defindex, int pageSize){
		
		//组装分页参数
		int size = list.size();
		Map<String, Integer> page = RequestParamUtil.getRequestLimit(request, 1, pageSize);
		request.setAttribute("count", size);
		request.setAttribute("index", page.get("_pindex"));
		request.setAttribute("pagesize", page.get("_psize"));
		
		//切割数据
		int pageEnd = (Integer)page.get("_pindex") * pageSize;
		pageEnd = (pageEnd > size) ? size : pageEnd;
		return list.subList((Integer)page.get("_pstart"),pageEnd);
	}
	
	public static void putPageData(String key,Object value){
		pageMap.put(key, value);
	}
	
	public static Object getPageData(String key){
		return pageMap.get(key);
	}
	
	public static Object removePageData(String key){
		return pageMap.remove(key);
	}
	
	/**
	 * 判断当前页面是否是编辑页面(编辑和管理员审核界面都可以进行编辑)
	 * @param request
	 * @return
	 */
	public static boolean isEdit(HttpServletRequest request){
		
		//编辑
		String edit = request.getParameter("e");
		if("1".equals(edit)){
			request.setAttribute("edit", "1");
			return true;
		}
		
		//审核
		String check = request.getParameter("c");
		if("1".equals(check)){
			request.setAttribute("edit", "1");
			return true;
		}
		return false;
	}
}
