<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" buffer="none"%>

<%@ include file="/themes/default/home/screen/mq/console/comm/topmenu.jsp"%> 


	<button class="btn btn-sm btn-success" type="button" onclick="addToDB('addTopic')">新增</button>
	<button class="btn btn-sm btn-success" type="button" onclick="initAll()">全部启用</button>
	<br/>
	<br/>
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
					<th width="60px;">序号</th>
					<th width="100px;">数据类型</th>
					<th>写入队列数</th>
					<th>读取队列数</th>
					<th>读写权限</th>
					<th>是否初始化</th>
					<th>初始化时间</th>
					<th>停用时间</th>
					<th>操作</th>
			</tr>
		</thead>
	 <c:if test="${!empty dataTypelist}">
		 <c:forEach items="${dataTypelist}" var="dataType" varStatus="status">
			<tr class="item-info" >
				<td >${(index-1)*pagesize + status.count}</td> 
				<td >${ dataType.TOPIC_NAME}</td>
				<td >${ dataType.WRITE_QUEUE_NUMS}</td>
				<td >${ dataType.READ_QUEUE_NUMS}</td>
				<td >${ dataType.PERM}</td>
				<c:if test="${ dataType.IS_INIT=='1'}">
					<td >是</td>
				</c:if>
				<c:if test="${ dataType.IS_INIT=='0'}">
					<td >否</td>
				</c:if>
				<td >${ dataType.INIT_TIME}</td>
				<td >${ dataType.STOP_TIME}</td>
				<td>
						<button class="btn btn-sm btn-success" type="button" onclick="addToDB('updateTopic','${ dataType.TOPIC_CODE}')">修改</button>
						<button class="btn btn-sm btn-info" type="button"
							onclick="createTopic('${ dataType.TOPIC_CODE}')">启用</button> 
						<button class="btn btn-sm btn-danger" type="button"
							onclick="delTopic('${ dataType.TOPIC_CODE}')">停用</button>
				</td>
			</tr>
		</c:forEach>
	</c:if>
	</table>
	<!-- 分页 -->
	<c:if test="${count > pagesize}">
			<script type="text/javascript">
				$(document).ready(function() {
					$("#item_paper_box").ui_paper({
						url:"${fn:getLink('mq/console/topic/topicDBList.jsp')}",
						pagesize: ${pagesize },
						current: ${index },
						count: ${count }
					});
				});
			</script>
			<div id="item_paper_box" class="paper" style="margin: 30px auto;"></div>
	</c:if>
<script type="text/javascript">
	function initAll(method){
		var groupManage_url = "${fn:getLink('mq/console/topic/topicDBList.do')}";
		//进行请求
		$.ajax({
			url: groupManage_url + "?method=initAll",
			type:"POST",
			data:{},
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success: function(data){
				if(data=='1'){
					alert("初始化成功！");
					document.location.href="${fn:getLink('mq/console/topic/topicDBList.jsp')}";
				}else{
					alert("初始化失败！");
				}
	  		}
		});
	
	}
	function createTopic(topic){
		var groupManage_url = "${fn:getLink('mq/console/topic/topicDBList.do')}";
		//进行请求
		$.ajax({
			url: groupManage_url + "?method=createTopic",
			type:"POST",
			data:{'topic':topic},
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success: function(data){
				if(data=='1'){
					alert("启用成功！");
					document.location.href="${fn:getLink('mq/console/topic/topicDBList.jsp')}";
				}else{
					alert("启用失败！");
				}
	  		}
		});
	}
	function delTopic(topic){
		var groupManage_url = "${fn:getLink('mq/console/topic/topicDBList.do')}";
		//进行请求
		$.ajax({
			url: groupManage_url + "?method=delTopic",
			type:"POST",
			data:{'topic':topic},
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success: function(data){
				if(data=='1'){
					alert("停用成功！");
					document.location.href="${fn:getLink('mq/console/topic/topicDBList.jsp')}";
				}else{
					alert("停用失败！");
				}
	  		}
		});
		
	}
	function addToDB(m,topic){
		document.location.href="${fn:getLink('mq/console/topic/topicDBAction.jsp?m=')}"+m+"&topicCode="+topic;
	}
</script>
