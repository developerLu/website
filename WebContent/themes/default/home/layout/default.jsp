<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" buffer="none" %>
<%@ taglib uri="/tags/website" prefix="website" %>
<%@ taglib uri="/tags/website-function" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
<website:html>
	<!-- 通用样式和组件 -->
	<website:widget path="components.jsp"/>
	
	<body class="skin-blue" style="height:100px;">
		<!-- 顶部菜单,header -->
		<website:widget path="header.jsp"/>
		
		
		<div class="wrapper row-offcanvas row-offcanvas-left">
			<website:widget path="left.jsp"/>
		</div>
		
	</body>
</website:html>