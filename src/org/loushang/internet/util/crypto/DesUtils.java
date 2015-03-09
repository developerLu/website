package org.loushang.internet.util.crypto;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

/**
 * DesUtils 类 这是Des加密解密算法的工具类
 * 
 * @author yuhai mail to: yuhai@inspur.com
 */

public class DesUtils {

	/** 加密解密中使用的key */
	static String key = "00000000";
	/**
	 * 方法 desCrypto 对原文进行加密
	 * 
	 * @param datasource
	 *            原文
	 * @return byte[] 加密后的密文
	 */
	public static byte[] desCrypto(byte[] datasource) {
		try {
			SecureRandom random = new SecureRandom();
			DESKeySpec desKey = new DESKeySpec(key.getBytes());
			// 创建一个密匙工厂，然后用它把DESKeySpec转换成
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey securekey = keyFactory.generateSecret(desKey);
			// Cipher对象实际完成加密操作
			Cipher cipher = Cipher.getInstance("DES");
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.ENCRYPT_MODE, securekey, random);
			// 现在，获取数据并加密
			// 正式执行加密操作
			return cipher.doFinal(datasource);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 方法 decrypt 对密文进行加密
	 * 
	 * @param src
	 *            密文
	 * @return byte[] 解密后的原文
	 */
	private static byte[] decrypt(byte[] src) {

		try {
			// DES算法要求有一个可信任的随机数源
			SecureRandom random = new SecureRandom();
			// 创建一个DESKeySpec对象
			DESKeySpec desKey = new DESKeySpec(key.getBytes());
			// 创建一个密匙工厂
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			// 将DESKeySpec对象转换成SecretKey对象
			SecretKey securekey = keyFactory.generateSecret(desKey);
			// Cipher对象实际完成解密操作
			Cipher cipher = Cipher.getInstance("DES");
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.DECRYPT_MODE, securekey, random);
			// 真正开始解密操作
			return cipher.doFinal(src);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 方法 main 对该类进行测试
	 */
	public static void main(String[] args) {
		// 待加密内容
		String str = "asd";
		byte[] result = DesUtils.desCrypto(str.getBytes());
		System.out.println(new String(result));
		// 直接将如上内容解密
		byte[] decryResult = DesUtils.decrypt(result);
		System.out.println("解密后内容为：" + new String(decryResult));
	}
}
