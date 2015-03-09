package org.loushang.internet.util.crypto;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;

/**
 * MD5Utils �� ����MD5ɢ���㷨�Ĺ�����
 * 
 * @author yuhai mail to: yuhai@inspur.com
 */

public class MD5Utils {

	/**
	 * ���� hashed ��ԭ�Ľ���MD5ɢ��
	 * 
	 * @param plainText
	 *            ԭ��
	 * @return String ɢ�еĽ��
	 */
	public static String hashed(String plainText) {

		byte[] temp = (plainText+"{1#2$3%4(5)6@7!poeeww$3%4(5)djjkkldss}").getBytes();
		//byte[] temp = (plainText).getBytes();
		MessageDigest md;
		// ���ؽ��
		StringBuffer buffer = new StringBuffer();
		try {
			// ����MD5ɢ��
			md = MessageDigest.getInstance("md5");
			md.update(temp);
			temp = md.digest();

			// ��ɢ�еĽ��ת��ΪHex�ַ�
			int i = 0;
			for (int offset = 0; offset < temp.length; offset++) {
				i = temp[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buffer.append("0");
				buffer.append(Integer.toHexString(i));
			}
		} catch (GeneralSecurityException e) {
			e.printStackTrace();
		}

		// ����
		return buffer.toString();
	}
	/**
	 * md5
	 * @return
	 */
	public static String md5(String plainText){
		if(plainText == null)
			plainText = "";
		byte[] temp = plainText.getBytes();
		MessageDigest md;
		// 返回结果
		StringBuffer buffer = new StringBuffer();
		try {
			// 进行MD5散列
			md = MessageDigest.getInstance("md5");
			md.update(temp);
			temp = md.digest();
			// 将散列的结果转换为Hex字符串
			int i = 0;
			for (int offset = 0; offset < temp.length; offset++) {
				i = temp[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buffer.append("0");
				buffer.append(Integer.toHexString(i));
			}
		} catch (GeneralSecurityException e) {
			e.printStackTrace();
		}
		// 返回
		return buffer.toString();
	}
	/**
	 * ���� main �Ը�����в���
	 */
	public static void main(String[] args) {
		System.out.println(MD5Utils.hashed("1"));
	}
}
