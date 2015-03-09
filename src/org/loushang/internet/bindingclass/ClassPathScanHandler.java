package org.loushang.internet.bindingclass;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.net.JarURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

/**
 * 扫描指定包（包括jar）下的class文件 <br>
 * <a href="http://sjsky.iteye.com">http://sjsky.iteye.com</a>
 * @author michael
 */
public class ClassPathScanHandler {

    /**
     * logger
     */
    private static final Logger logger = Logger
            .getLogger(ClassPathScanHandler.class);

    /**
     * 是否排除内部类 true->是 false->否
     */
    private boolean excludeInner = true;
    /**
     * 过滤规则适用情况 true—>搜索符合规则的 false->排除符合规则的
     */
    private boolean checkInOrEx = true;

    /**
     * 过滤规则列表 如果是null或者空，即全部符合不过滤
     */
    private List<String> classFilters = null;
    
    private String rootPackage=null;
    /**
     * 无参构造器，默认是排除内部类、并搜索符合规则
     */
    public ClassPathScanHandler() {
    }

    /**
     * excludeInner:是否排除内部类 true->是 false->否<br>
     * checkInOrEx：过滤规则适用情况 true—>搜索符合规则的 false->排除符合规则的<br>
     * classFilters：自定义过滤规则，如果是null或者空，即全部符合不过滤
     * @param excludeInner
     * @param checkInOrEx
     * @param classFilters
     */
    public ClassPathScanHandler(Boolean excludeInner, Boolean checkInOrEx,
            List<String> classFilters) {
        this.excludeInner = excludeInner;
        this.checkInOrEx = checkInOrEx;
        this.classFilters = classFilters;

    }

    /**
     * 扫描包
     * @param basePackage 基础包
     * @param recursive 是否递归搜索子包
     * @return Set
     */
    public Map<String,Class<?>> getPackageAllClasses(String basePackage,
            boolean recursive) {
    	rootPackage = basePackage;
    	Map<String,Class<?>> classes = new HashMap<String,Class<?>>();
        String packageName = basePackage;
        if (packageName.endsWith(".")) {
            packageName = packageName
                    .substring(0, packageName.lastIndexOf('.'));
        }
        String package2Path = packageName.replace('.', '/');

        Enumeration<URL> dirs;
        try {
            dirs = Thread.currentThread().getContextClassLoader().getResources(
                    package2Path);
            while (dirs.hasMoreElements()) {
                URL url = dirs.nextElement();
                String protocol = url.getProtocol();
                if ("file".equals(protocol)) {
                    logger.info("扫描file类型的class文件....");
                    String filePath = URLDecoder.decode(url.getFile(), "UTF-8");
                    doScanPackageClassesByFile(classes, packageName, filePath,
                            recursive);
                } else if ("jar".equals(protocol)) {
                    logger.info("扫描jar文件中的类....");
                    doScanPackageClassesByJar(packageName, url, recursive,
                            classes);
                }
            }
        } catch (IOException e) {
            logger.error("IOException error:", e);
        }

        return classes;
    }

    /**
     * 以jar的方式扫描包下的所有Class文件<br>
     * @param basePackage eg：michael.utils.
     * @param url
     * @param recursive
     * @param classes
     */
    private void doScanPackageClassesByJar(String basePackage, URL url,
            final boolean recursive, Map<String,Class<?>> classes) {
        String packageName = basePackage;
        String package2Path = packageName.replace('.', '/');
        JarFile jar;
        try {
            jar = ((JarURLConnection) url.openConnection()).getJarFile();
            Enumeration<JarEntry> entries = jar.entries();
            while (entries.hasMoreElements()) {
                JarEntry entry = entries.nextElement();
                String name = entry.getName();
                if (!name.startsWith(package2Path) || entry.isDirectory()) {
                    continue;
                }

                // 判断是否递归搜索子包
                if (!recursive
                        && name.lastIndexOf('/') != package2Path.length()) {
                    continue;
                }
                // 判断是否过滤 inner class
                if (this.excludeInner && name.indexOf('$') != -1) {
                    logger.info("exclude inner class with name:" + name);
                    continue;
                }
                String classSimpleName = name
                        .substring(name.lastIndexOf('/') + 1);
                // 判定是否符合过滤条件
                if (this.filterClassName(classSimpleName)) {
                    String className = name.replace('/', '.');
                    className = className.substring(0, className.length() - 6);
                    try {
                    	String key = className.substring(rootPackage.length()+1,className.length()).toLowerCase();
                        classes.put(key,Thread.currentThread().getContextClassLoader().loadClass(className) );
                    } catch (ClassNotFoundException e) {
                        logger.error("Class.forName error:", e);
                    }
                }
            }
        } catch (IOException e) {
            logger.error("IOException error:", e);
        }
    }

    /**
     * 以文件的方式扫描包下的所有Class文件
     * 
     * @param packageName
     * @param packagePath
     * @param recursive
     * @param classes
     */
    private void doScanPackageClassesByFile(Map<String,Class<?>> classes,
            String packageName, String packagePath, boolean recursive) {
        File dir = new File(packagePath);
        if (!dir.exists() || !dir.isDirectory()) {
            return;
        }
        final boolean fileRecursive = recursive;
        File[] dirfiles = dir.listFiles(new FileFilter() {
            // 自定义文件过滤规则
            public boolean accept(File file) {
                if (file.isDirectory()) {
                    return fileRecursive;
                }
                String filename = file.getName();
                if (excludeInner && filename.indexOf('$') != -1) {
                    logger.info("exclude inner class with name:" + filename);
                    return false;
                }
                return filterClassName(filename);
            }
        });
        for (File file : dirfiles) {
            if (file.isDirectory()) {
                doScanPackageClassesByFile(classes, packageName + "."
                        + file.getName(), file.getAbsolutePath(), recursive);
            } else {
                String className = file.getName().substring(0,
                        file.getName().length() - 6);
                try {
                	className = packageName + '.' + className;
                	String key = className.substring(rootPackage.length()+1,className.length()).toLowerCase();
                    classes.put(key,Thread.currentThread().getContextClassLoader().loadClass(className) );
                } catch (Throwable e) {
                    logger.error("IOException error:", e);
                }
            }
        }
    }

    /**
     * 根据过滤规则判断类名
     * @param className
     * @return
     */
    private boolean filterClassName(String className) {
        if (!className.endsWith(".class")) {
            return false;
        }
        if (null == this.classFilters || this.classFilters.isEmpty()) {
            return true;
        }
        String tmpName = className.substring(0, className.length() - 6);
        boolean flag = false;
        for (String str : classFilters) {
            String tmpreg = "^" + str.replace("*", ".*") + "$";
            Pattern p = Pattern.compile(tmpreg);
            if (p.matcher(tmpName).find()) {
                flag = true;
                break;
            }
        }
        return (checkInOrEx && flag) || (!checkInOrEx && !flag);
    }

    /**
     * @return the excludeInner
     */
    public boolean isExcludeInner() {
        return excludeInner;
    }

    /**
     * @return the checkInOrEx
     */
    public boolean isCheckInOrEx() {
        return checkInOrEx;
    }

    /**
     * @return the classFilters
     */
    public List<String> getClassFilters() {
        return classFilters;
    }

    /**
     * @param pExcludeInner the excludeInner to set
     */
    public void setExcludeInner(boolean pExcludeInner) {
        excludeInner = pExcludeInner;
    }

    /**
     * @param pCheckInOrEx the checkInOrEx to set
     */
    public void setCheckInOrEx(boolean pCheckInOrEx) {
        checkInOrEx = pCheckInOrEx;
    }

    /**
     * @param pClassFilters the classFilters to set
     */
    public void setClassFilters(List<String> pClassFilters) {
        classFilters = pClassFilters;
    }

    /**
     * @param args
     */
    public static void main(String[] args) {

        // 自定义过滤规则
        List<String> classFilters = new ArrayList<String>();
        classFilters.add("File*");

        // 创建一个扫描处理器，排除内部类 扫描符合条件的类
        ClassPathScanHandler handler = new ClassPathScanHandler(true, true,
                classFilters);

//        System.out
//                .println("开始递归扫描jar文件的包：org.apache.commons.io 下符合自定义过滤规则的类...");
//        Map<String,Class<?>> calssList = handler.getPackageAllClasses(
//                "org.apache.commons.io", true);
//        for (Class<?> cla : calssList.) {
//            System.out.println(cla.getName());
//        }
//        System.out.println("开始递归扫描file文件的包：michael.hessian 下符合自定义过滤规则的类...");
//        classFilters.clear();
//        classFilters.add("Hessian*");
//        calssList = handler.getPackageAllClasses("michael.hessian", true);
//        for (Class<?> cla : calssList) {
//            System.out.println(cla.getName());
//        }
    }
}
