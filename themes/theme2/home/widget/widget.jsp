<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" buffer="none" %>
<%@ taglib uri="/tags/website" prefix="website" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="/tags/website-function" prefix="fn" %>

<website:style href="${fn:getUrl('css/default.css')}"/>

<c:if test="${empty param.city}">
<h1>表单</h1>
</c:if>
<c:if test="${!empty param.city}">
<h1>表单 ID: ${param.city}</h1>
</c:if>

<website:widget path="widget2.jsp"/>