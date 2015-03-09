package org.loushang.internet.util;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.loushang.internet.context.ContextHolder;
import org.loushang.internet.util.crypto.MD5Utils;

import com.inspur.common.utils.PropertiesUtil;
/**
 * token 的形式是 key - value  ，每个session 可能有N个token对 。每次form提交以后再token列表里面找是否 有值
 * 前台提交的只是key，会更安全点
 * @author lipf
 *
 */
public final class CSRFManager {

    /**
     * session里面的token 属性名
     */
    public static final  String CSRF_TOKEN_FOR_SESSION_ATTR_NAME = CSRFManager.class.getSimpleName() + ".tokenkey";

    /**
     * 创建一个token并缓存
     * @return
     */
    public static Map<String,String> createToken() {
    	//等石园memcache jar弄好了以后使用memcache 还可以设置失效时间 key可以用sessionid作为前缀
    	HttpSession session = ContextHolder.getRequest().getSession();
        synchronized (session) {
//        	cacheManager = CacheExpressControl. 应该放在memcachecache里面
        	Map<String,String> kv = new HashMap<String,String>();
        	String token = UUID.randomUUID().toString().replaceAll("-", "");
        	String key = randomString(10);
        	while(session.getAttribute(CSRF_TOKEN_FOR_SESSION_ATTR_NAME+key)!=null) {
        		key = randomString(10);
        	}
        	kv.put("key", key);
        	kv.put("token", token);
        	session.setAttribute(CSRF_TOKEN_FOR_SESSION_ATTR_NAME+key, token);
            return kv;
        }
    }
    /**
     * 获取token值，并且将其冲缓存中删除，一个token只能给一个表单用一次
     * @param request
     * @param key
     * @return
     */
    public static String getToken(HttpServletRequest request,String key){
    	HttpSession session = request.getSession();
    	String token = (String) session.getAttribute(CSRF_TOKEN_FOR_SESSION_ATTR_NAME+key);
    	session.removeAttribute(CSRF_TOKEN_FOR_SESSION_ATTR_NAME+key);
    	return token;
    }
    /**
     * 获取reuqest里面的 CRSFToken 值
     * @param request
     * @return
     */
    public static String getTokenKey(HttpServletRequest request) {
    	String CRSFName = PropertiesUtil.getValue("frame.properties", "global.CRSFTokenName");
        return request.getParameter(CRSFName);
    }
    /**
     * 验证是否有csrf攻击
     * @param request
     * @return false表示没有crsf攻击，true表示有攻击
     */
    public static boolean validateCSRF(HttpServletRequest request){
    	String tokenKey = getTokenKey(request);
		if(tokenKey!=null && !tokenKey.isEmpty()){//存在tokenkey就验证令牌
			String token = CSRFManager.getToken(request,tokenKey);
			return validateCSRF(token,request);
//			if(validateCSRF(token,request)){//验证是攻击
//				String errCode = ErrCodeUtil.ERR_CSRF;
//				String errInfo = ErrCodeUtil.getErrInfo(errCode);
//				log.error("提交数据不安全或者重复提交了，请查看csrf配置以及提交的相关数据");
//				if(RequestUtil.isAjaxQuery(request)) {
//					response.setStatus(500);
//					Map<String,Object> result = new HashMap<String,Object>();
//					result.put("errCode", errCode);
//					result.put("errInfo", errInfo);
//					response.getWriter().write(JsonUtils.convertToString(result));
//				} else {
//					request.setAttribute("errCode", errCode);
//					request.getRequestDispatcher(Function.getErrUrl()).forward(request, response);
//				}
//				return;
//			}
		} else {
			return false;
		}
    }
    private static boolean validateCSRF(String token , HttpServletRequest request){
		if(token==null || token.isEmpty()){//被攻击了
			return true;
		}
		String signName = PropertiesUtil.getValue("frame.properties", "global.CRSFSignName");
		if(signName==null || signName.isEmpty()){//没有配置signName 说明不需要验证
			return false;
		}
		String signValue = request.getParameter(signName);
		Map parameter = request.getParameterMap();
		
		StringBuilder sb = new StringBuilder();
		if (parameter != null) {
			Object[] keys = parameter.keySet().toArray();
			Arrays.sort(keys);
			String key;
			for (int i = 0 , len = keys.length ; i < len ; i++) {
				key = (String) keys[i];
				if(signName.equals(key)){
					continue;
				}
				String vs [] = request.getParameterValues(key);
				for(String v : vs){
					sb.append(key).append("=").append(v).append("&");
				}
			}
		}
//		System.out.println(token);
//		System.out.println(sb.toString());
		String reqCode = MD5Utils.md5(sb.toString());
//		System.out.println(reqCode);
		reqCode = MD5Utils.md5(reqCode+token);
//		System.out.println(reqCode);
		return !reqCode.equals(signValue);
	} 
    private static String randomString(int length) {  
        String str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";  
        Random random = new Random();  
        StringBuffer buf = new StringBuffer();  
        for (int i = 0; i < length; i++) {  
            int num = random.nextInt(62);  
            buf.append(str.charAt(num));  
        }  
        return buf.toString();  
    }  
    
    private CSRFManager() {};

}