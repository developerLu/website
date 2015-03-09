<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" buffer="none" %>
<%@ taglib uri="/tags/website" prefix="website" %>
<%@ taglib uri="/tags/website-function" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<website:html>
	<!-- 通用样式和组件 -->
	<website:widget path="components.jsp"/>
	
	<body>
		<website:widget path="header.jsp"/>
		
		<div class="main-container" id="main-container">
			<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
			</script>
	
			<div class="main-container-inner">
				<a class="menu-toggler" id="menu-toggler" href="#">
					<span class="menu-text"></span>
				</a>
				<website:widget path="left.jsp"/>
				<div class="main-content">
					<website:widget path="navigation.jsp"/>
					
					<div class="page-content">
						<website:widget path="page-header.jsp"/>
						<div class="row">
							<div class="col-xs-12">
							<!-- 显示内容 -->
							<website:screenHolder/>
							</div>
						</div>
					</div><!-- /.page-content -->
					
				</div><!-- /.main-content -->
				
				<website:widget path="setting.jsp"/>
			</div><!-- /.main-container-inner -->
			<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="icon-double-angle-up icon-only bigger-110"></i>
			</a>
		</div><!-- /.main-container -->
	</body>
</website:html>