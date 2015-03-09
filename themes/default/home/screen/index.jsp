<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" buffer="none" %>
<%@ taglib uri="/tags/website" prefix="website" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="/tags/website-function" prefix="fn" %>

	<website:script src="js/jquery.js"/>
	<website:script src="js/jquery.form.js"/>
	<website:script src="js/md5.js"/>
	<website:script src="js/core.js"/>
	<website:widget path="widget.ftl?city=21001"/>
	<form action="${fn:getLink('filter/index.do?method=add') }" method="post">
		<input type="text" name="a" value="">
		<input type="text" name="b" value="">
		<input type="text" name="c" value="">
		<input type="text" name="d" value="">
		<website:CSRFToken/>
		<input type="submit" value="提交">
		<input type="button" value="异步提交" onclick="sub2()">
		<input type="button" value="重置" onclick="sub3()">
	</form>
	<website:widget path="widget.jsp"/>
	<script type="text/javascript">
	function sub2(){
		$('form').ajaxSubmit();
	}
	function sub3(){
		$('form')[0].reset();	
	}
	</script>