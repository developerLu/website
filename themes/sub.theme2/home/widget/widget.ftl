<@website.style href="${fn.getUrl('css/default.css')}"/>

<h1>
	<#if (param.city)?has_content>
	City ID: ${param.city}
	<#else>
	City
	</#if>
</h1>
<@website.widget path="widget2.ftl" />