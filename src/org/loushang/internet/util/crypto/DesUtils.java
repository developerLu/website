package org.loushang.internet.util.crypto;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

/**
 * DesUtils �� ����Des���ܽ����㷨�Ĺ�����
 * 
 * @author yuhai mail to: yuhai@inspur.com
 */

public class DesUtils {

	/** ���ܽ�����ʹ�õ�key */
	static String key = "00000000";
	/**
	 * ���� desCrypto ��ԭ�Ľ��м���
	 * 
	 * @param datasource
	 *            ԭ��
	 * @return byte[] ���ܺ������
	 */
	public static byte[] desCrypto(byte[] datasource) {
		try {
			SecureRandom random = new SecureRandom();
			DESKeySpec desKey = new DESKeySpec(key.getBytes());
			// ����һ���ܳ׹�����Ȼ��������DESKeySpecת����
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey securekey = keyFactory.generateSecret(desKey);
			// Cipher����ʵ����ɼ��ܲ���
			Cipher cipher = Cipher.getInstance("DES");
			// ���ܳ׳�ʼ��Cipher����
			cipher.init(Cipher.ENCRYPT_MODE, securekey, random);
			// ���ڣ���ȡ���ݲ�����
			// ��ʽִ�м��ܲ���
			return cipher.doFinal(datasource);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * ���� decrypt �����Ľ��м���
	 * 
	 * @param src
	 *            ����
	 * @return byte[] ���ܺ��ԭ��
	 */
	private static byte[] decrypt(byte[] src) {

		try {
			// DES�㷨Ҫ����һ�������ε������Դ
			SecureRandom random = new SecureRandom();
			// ����һ��DESKeySpec����
			DESKeySpec desKey = new DESKeySpec(key.getBytes());
			// ����һ���ܳ׹���
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			// ��DESKeySpec����ת����SecretKey����
			SecretKey securekey = keyFactory.generateSecret(desKey);
			// Cipher����ʵ����ɽ��ܲ���
			Cipher cipher = Cipher.getInstance("DES");
			// ���ܳ׳�ʼ��Cipher����
			cipher.init(Cipher.DECRYPT_MODE, securekey, random);
			// ������ʼ���ܲ���
			return cipher.doFinal(src);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * ���� main �Ը�����в���
	 */
	public static void main(String[] args) {
		// ����������
		String str = "asd";
		byte[] result = DesUtils.desCrypto(str.getBytes());
		System.out.println(new String(result));
		// ֱ�ӽ��������ݽ���
		byte[] decryResult = DesUtils.decrypt(result);
		System.out.println("���ܺ�����Ϊ��" + new String(decryResult));
	}
}
