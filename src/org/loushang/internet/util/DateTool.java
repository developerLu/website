package org.loushang.internet.util;

public class DateTool {

	/**
	 * 使用默认格式格式化日期，默认格式 "年-月-日"
	 * @param date
	 * @return
	 */
	public static String dateFormat(String date) {
		return dateFormat(date, "yyyy-MM-dd");
	}
	/**
	 * 格式化日期
	 * @param date
	 * @param format
	 * @return
	 */
	public static String dateFormat(String date, String format) {
		String year = "1970";
		String month = "01";
		String day = "01";
		String hour = "00";
		String minute = "00";
		String second = "00";
		
		String tdate = date.replaceAll(":", "").replaceAll("/", "").replaceAll("-", "");
		// 获取日期
		int len = tdate.length();
		if(len >= 4) year = tdate.substring(0, 4);
		if(len >= 6) month = tdate.substring(4, 6);
		if(len >= 8) day = tdate.substring(6, 8);
		if(len >= 10) hour = tdate.substring(8, 10);
		if(len >= 12) minute = tdate.substring(10, 12);
		if(len >= 14) second = tdate.substring(12, 14);
		
		// 格式化日期
		String f = format;
		f = f.replaceAll("yyyy", year);
		f = f.replaceAll("MM", month);
		f = f.replaceAll("dd", day);
		f = f.replaceAll("hh", hour);
		f = f.replaceAll("mm", minute);
		f = f.replaceAll("ss", second);
		
		return f;
	}
}
