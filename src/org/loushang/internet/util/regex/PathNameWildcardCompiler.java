

package org.loushang.internet.util.regex;


import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

/**
 * ����ཫһ����ͨ�����ļ�·��, �����������ʽ. ��ʽ��������:
 * <ul>
 * <li>�Ϸ���<em>�ļ����ַ�</em>����: ��ĸ/����/�»���/С���/�̺���;</li>
 * <li>�Ϸ���<em>·���ָ���</em>Ϊб��"/";</li>
 * <li>"��"���0������<em>�ļ����ַ�</em>;</li>
 * <li>"��"���1��<em>�ļ����ַ�</em>;</li>
 * <li>"����"���0������<em>�ļ����ַ�</em>��<em>·���ָ���</em>;</li>
 * <li>�����������3��"��";</li>
 * <li>�����������2��<em>·���ָ���</em>;</li>
 * <li>"����"��ǰ��ֻ����<em>·���ָ���</em>.</li>
 * </ul>
 * <p>
 * ת�����������ʽ, ��ÿһ��ͨ�����<em>���ñ���</em>, ����Ϊ<code>$1</code>, <code>$2</code>, ...
 * </p>

 */
public class PathNameWildcardCompiler {
    /** ǿ��ʹ�þ��·�� */
    public static final int FORCE_ABSOLUTE_PATH = 0x1000;

    /** ǿ��ʹ�����·�� */
    public static final int FORCE_RELATIVE_PATH = 0x2000;

    /** ��ͷƥ�� */
    public static final int FORCE_MATCH_PREFIX = 0x4000;

    // ˽�г���
    private static final char ESCAPE_CHAR = '\\';
    private static final char SLASH = '/';
    private static final char UNDERSCORE = '_';
    private static final char DASH = '-';
    private static final char DOT = '.';
    private static final char STAR = '*';
    private static final char QUESTION = '?';
    private static final String REGEX_MATCH_PREFIX = "^";
    private static final String REGEX_WORD_BOUNDARY = "\\b";
    private static final String REGEX_SLASH = "\\/";
    private static final String REGEX_SLASH_NO_DUP = "\\/(?!\\/)";
    private static final String REGEX_FILE_NAME_CHAR = "[\\w\\-\\.]";
    private static final String REGEX_FILE_NAME_SINGLE_CHAR = "(" + REGEX_FILE_NAME_CHAR + ")";
    private static final String REGEX_FILE_NAME = "(" + REGEX_FILE_NAME_CHAR + "*)";
    private static final String REGEX_FILE_PATH = "(" + REGEX_FILE_NAME_CHAR + "+(?:" + REGEX_SLASH_NO_DUP
            + REGEX_FILE_NAME_CHAR + "*)*(?=" + REGEX_SLASH + "|$)|)" + REGEX_SLASH + "?";

    // ��һ��token��״̬
    private static final int LAST_TOKEN_START = 0;
    private static final int LAST_TOKEN_SLASH = 1;
    private static final int LAST_TOKEN_FILE_NAME = 2;
    private static final int LAST_TOKEN_STAR = 3;
    private static final int LAST_TOKEN_DOUBLE_STAR = 4;
    private static final int LAST_TOKEN_QUESTION = 5;

    private PathNameWildcardCompiler() {
    }

    /**
     * ����ͨ����·�����ʽ, �����������ʽ.
     */
    public static Pattern compilePathName(String pattern) throws PatternSyntaxException {
        return compilePathName(pattern, 0);
    }

    /**
     * ����ͨ����·�����ʽ, �����������ʽ.
     */
    public static Pattern compilePathName(String pattern, int options) throws PatternSyntaxException {
        return Pattern.compile(pathNameToRegex(pattern, options), options);
    }

    /**
     * ȡ����ض���ֵ��
     * <p>
     * ��ν��ض���ֵ������ȥ�ָ����ͨ����Ժ�ʣ�µ��ַ�ȡ�
     * ��ض���ֵ��������ƥ�����������磺/a/b/c��ƥ��/a��ƥ��/*������Ȼǰ��Ϊ����ء���ƥ�䡣
     * </p>
     */
    public static int getPathNameRelevancy(String pattern) {
        pattern = normalizePathName(pattern);

        if (pattern == null) {
            return 0;
        }

        int relevant = 0;

        for (int i = 0; i < pattern.length(); i++) {
            switch (pattern.charAt(i)) {
                case SLASH:
                case STAR:
                case QUESTION:
                    continue;

                default:
                    relevant++;
            }
        }

        return relevant;
    }

    /**
     * ����ͨ����·�����ʽ, ת����������ʽ.
     */
    public static String pathNameToRegex(String pattern, int options) throws PatternSyntaxException {
        pattern = normalizePathName(pattern);

        int lastToken = LAST_TOKEN_START;
        StringBuilder buf = new StringBuilder(pattern.length() * 2);

        boolean forceMatchPrefix = (options & FORCE_MATCH_PREFIX) != 0;
        boolean forceAbsolutePath = (options & FORCE_ABSOLUTE_PATH) != 0;
        boolean forceRelativePath = (options & FORCE_RELATIVE_PATH) != 0;

        // ����һ���ַ�Ϊslash, �������Ҫ��forceMatchPrefix, ���ͷƥ��
		if (forceMatchPrefix
				&& !(pattern.startsWith("*") || pattern.startsWith("/") || pattern
						.startsWith("?")) || pattern.length() > 0
				&& pattern.charAt(0) == SLASH) {
			buf.append(REGEX_MATCH_PREFIX);
		}

        // ���������/����""
        if (pattern.length() == 1 && pattern.charAt(0) == SLASH) {
            pattern = "";
        }

        for (int i = 0; i < pattern.length(); i++) {
            char ch = pattern.charAt(i);

            if (forceAbsolutePath && lastToken == LAST_TOKEN_START && ch != SLASH) {
                throw new PatternSyntaxException("Syntax Error", pattern, i);
            }

            switch (ch) {
                case SLASH:
                    // slash���治����slash, slash����λ�����ַ�(���ָ����force relative path�Ļ�)
                    if (lastToken == LAST_TOKEN_SLASH) {
                        throw new PatternSyntaxException("Syntax Error", pattern, i);
                    } else if (forceRelativePath && lastToken == LAST_TOKEN_START) {
                        throw new PatternSyntaxException("Syntax Error", pattern, i);
                    }

                    // ��Ϊ**�Ѿ�������slash, ���Բ���Ҫ�����ƥ��slash
                    if (lastToken != LAST_TOKEN_DOUBLE_STAR) {
                        buf.append(REGEX_SLASH_NO_DUP);
                    }

                    lastToken = LAST_TOKEN_SLASH;
                    break;

                case STAR:
                    int j = i + 1;

                    if (j < pattern.length() && pattern.charAt(j) == STAR) {
                        i = j;

                        // **ǰ��ֻ����slash
                        if (lastToken != LAST_TOKEN_START && lastToken != LAST_TOKEN_SLASH) {
                            throw new PatternSyntaxException("Syntax Error", pattern, i);
                        }

                        lastToken = LAST_TOKEN_DOUBLE_STAR;
                        buf.append(REGEX_FILE_PATH);
                    } else {
                        // *ǰ�治����*��**
                        if (lastToken == LAST_TOKEN_STAR || lastToken == LAST_TOKEN_DOUBLE_STAR) {
                            throw new PatternSyntaxException("Syntax Error", pattern, i);
                        }

                        lastToken = LAST_TOKEN_STAR;
                        buf.append(REGEX_FILE_NAME);
                    }

                    break;

                case QUESTION:
                    lastToken = LAST_TOKEN_QUESTION;
                    buf.append(REGEX_FILE_NAME_SINGLE_CHAR);
                    break;

                default:
                    // **��ֻ����slash
                    if (lastToken == LAST_TOKEN_DOUBLE_STAR) {
                        throw new PatternSyntaxException("Syntax Error", pattern, i);
                    }

                    if (Character.isLetterOrDigit(ch) || ch == UNDERSCORE || ch == DASH) {
                        // ����word�߽�, ��������ƥ��
                        if (lastToken == LAST_TOKEN_START && !(forceMatchPrefix && i==0)) {
                            buf.append(REGEX_WORD_BOUNDARY).append(ch); // ǰ�߽�
                        } else if (i + 1 == pattern.length()) {
                            buf.append(ch).append(REGEX_WORD_BOUNDARY); // ��߽�
                        } else {
                            buf.append(ch);
                        }
                    } else if (ch == DOT) {
                        buf.append(ESCAPE_CHAR).append(DOT);
                    } else {
                        throw new PatternSyntaxException("Syntax Error", pattern, i);
                    }

                    lastToken = LAST_TOKEN_FILE_NAME;
            }
        }

        return buf.toString();
    }

    /**
     * �������
     * <ul>
     * <li>��ȥ���˿հ�</li>
     * <li>��"\\"ת����"//"</li>
     * <li>���ظ���"/"ת���ɵ�����"/"</li>
     * </ul>
     */
    public static String normalizePathName(String name) {
        if (name == null) {
            return null;
        }

        return name.trim().replaceAll("[/\\\\]+", "/");
    }
}
