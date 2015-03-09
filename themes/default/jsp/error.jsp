<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" buffer="none" %>
<%@ page import="java.util.List" %>
<%@ page import="org.loushang.internet.util.ErrCodeUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

	request.setAttribute("homeUrl", basePath);
	String errMsg = "";
	Exception e = (Exception) request.getAttribute("jframe.exception");
	if(e != null) {
		errMsg = e.getMessage();
	} else {
		String errCode = (String) request.getAttribute("errCode");
		errMsg = ErrCodeUtil.getErrInfo(errCode);
		List<String> errReplacements = (List<String>) request.getAttribute("errReplacements");
		if(errMsg != null && errReplacements != null && errReplacements.size() > 0) {
			String errReplacement = "";
			for(int i = 0; i < errReplacements.size(); i++) {
				errReplacement = errReplacements.get(i);
				errMsg = errMsg.replaceAll("\\$"+(i+1), errReplacement);
			}
		}
	}
	if(errMsg == null || errMsg.isEmpty()) {
		errMsg = "未知错误";
	}
	request.setAttribute("errMsg", errMsg);
	
	String themeMark = (String) request.getAttribute("themeMark");
	String cssPath = "css/errbase.css";
	if(themeMark != null && !themeMark.isEmpty()) {
		cssPath = cssPath + "?t=" + themeMark;
	}
	request.setAttribute("cssPath", cssPath);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<base href="<%=basePath%>"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>出错了！</title>
	<link href="${cssPath}" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="Prompt">
		<div class="Prompt_top"></div>
		<div class="Prompt_body">
			<h2 class="title">提示信息</h2>
			<div class="cont">
				<span class="Prompt_x"></span>
				<div class="Prompt_txt">
					<h2 class="error">${errMsg}</h2>
              		<p>
              			系统将在 <span id="num-counter" class="numc">8</span> 秒后自动跳转至首页，如果不想等待，直接点击 <a href="${homeUrl}">这里</a> 跳转<br>
          				或者 <a href="javascript:void(0);" onclick="stopJump(this)">停止</a> 自动跳转
          			</p>
				</div>
			</div>
    	</div>
    	<div class="Prompt_btm"></div>
	</div>
	<script type="text/javascript">
	var stopped = false;
	var numCounter = document.getElementById("num-counter");
	var counter = parseInt(numCounter.innerHTML);
	function jump(){
		if(stopped) return;
		numCounter.innerHTML = counter;
		counter --;
		if(counter < 0) {
			window.location.href = '${homeUrl}';
		} else {
			setTimeout(jump, 1000);
		}
	}
	function stopJump(aObj) {
		if(!stopped) {
			stopped = true;
			aObj.innerHTML = "继续";
		} else {
			stopped = false;
			aObj.innerHTML = "停止";
			jump();
		}
		
	}
	jump();
	</script>
</body>
</html>