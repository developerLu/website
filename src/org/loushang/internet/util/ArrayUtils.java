package org.loushang.internet.util;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

public class ArrayUtils {
	
	/**
	 * 拼接数组
	 * @param target
	 * @param source
	 * @param cls
	 * @return
	 */
	public static <T> T[] concat(T[] target, T[] source, Class<T> cls) {
		if(target == null && source == null) return null;
		List<T> list = new ArrayList<T>();
		if(target != null) {
			for(T item : target) {
				list.add(item);
			}
		}
		if(source != null) {
			for(T item : source) {
				list.add(item);
			}
		}
		T[] inst = (T[]) Array.newInstance(cls, list.size());
		return list.toArray(inst);
	}
	
	/**
	 * 去除数组中重复的元素
	 * @param target
	 * @return
	 */
	public static <T> T[] distinct(T[] target, Class<T> cls) {
		if(target == null) return null;
		List<T> result = new ArrayList<T>();
		for(T item : target) {
			if(item != null && !result.contains(item)) {
				result.add(item);
			}
		}
		T[] inst = (T[]) Array.newInstance(cls, result.size());
		return result.toArray(inst);
	}
	
}
