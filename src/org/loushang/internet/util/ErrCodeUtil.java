package org.loushang.internet.util;

import com.inspur.common.utils.PropertiesUtil;

public class ErrCodeUtil {
	
	public static final String ERR_CSRF = "global.ERRCSRF";
	public static final String ERR_NOSC = "global.ERRNOSC";
	public static final String ERR_NFSC = "global.ERRNFSC";
	public static final String ERR_ELLP = "global.ERRELLP";
	public static final String ERR_XSS = "global.ERR0501";
	public static final String ERR_LOGIN = "global.ERR0502";
	public static final String ERR_ILLEGAL = "global.ERR0503";
	public static final String ERR_LOGSAML = "global.ERR0504";
	
	private static final String ERR_INFO_CSRF = "非法操作，提交数据不安全或者重复提交";
	private static final String ERR_INFO_NOSC = "请求地址对应的资源文件不存在$1";
	private static final String ERR_INFO_NFSC = "内部跳转地址对应的资源文件不存在$1";
	private static final String ERR_INFO_ELLP = "内部地址跳转存在闭合的死循环$1";
	private static final String ERR_INFO_XSS = "请求路径或参数中存在非法字符";
	private static final String ERR_INFO_LOGIN = "尚未登录或登录已失效";
	private static final String ERR_INFO_ILLEGAL = "非法操作归属性资源";
	private static final String ERR_INFO_LOGSAML = "登录失败！未获取到有效的SAML数据信息";
	/*
	private static Logger log = Logger.getLogger(ErrCodeUtil.class);
	private static PropertiesUtil prop = new PropertiesUtil();
	
	static{
		try {
			prop.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("errcodes.properties"));
			
			//转码处理
			Set<Object> keyset = prop.keySet();
			Iterator<Object> iter = keyset.iterator();
			while (iter.hasNext()) {
				String key = (String) iter.next();
				String newValue = null;
				try {
					//属性配置文件自身的编码
					String propertiesFileEncode = "utf-8";
					newValue = new String(prop.getProperty(key).getBytes("ISO-8859-1"),propertiesFileEncode);
				} catch (UnsupportedEncodingException e) {
					newValue = prop.getProperty(key);
				}
				prop.setProperty(key, newValue);
			}
		} catch (Exception e) {
			log.error("读取配置文件errcodes.properties出错！", e);
		}
	}
	*/
	/**
	 * 根据key，取得对应的value值
	 * @param String key
	 * @return String
	 */
	public static String getErrInfo(String errCode){
		if(errCode == null){
			return "";
		}
		String errInfo = PropertiesUtil.getValue("frame.properties", errCode);
		if(errInfo == null || "".equals(errInfo.trim())) {
			errInfo = getDefInfoByErrCode(errCode);
		}
		return errInfo;
	}
	
	private static String getDefInfoByErrCode(String errCode) {
		if(errCode == null){
			return "";
		}
		if(errCode.equals(ERR_CSRF)) {
			return ERR_INFO_CSRF;
		} else if(errCode.equals(ERR_NOSC)) {
			return ERR_INFO_NOSC;
		} else if(errCode.equals(ERR_NFSC)) {
			return ERR_INFO_NFSC;
		} else if(errCode.equals(ERR_ELLP)) {
			return ERR_INFO_ELLP;
		} else if(errCode.equals(ERR_XSS)) {
			return ERR_INFO_XSS;
		} else if(errCode.equals(ERR_LOGIN)) {
			return ERR_INFO_LOGIN;
		} else if(errCode.equals(ERR_ILLEGAL)) {
			return ERR_INFO_ILLEGAL;
		} else if(errCode.equals(ERR_LOGSAML)) {
			return ERR_INFO_LOGSAML;
		} else {
			return "";
		}
	}
}
