<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" buffer="none"%>

<%@ include file="/themes/default/home/screen/mq/console/comm/topmenu.jsp"%> 
<div class="container theme-showcase" role="main">
	<div id="updateReturnDiv" class="alert alert-success" style=" display:none">
		
	</div>
	<!--changed part begin-->
	
	<table class="table table-bordered table-hover">
		<tbody>
			<form  id="topicForm"    onsubmit="javascript:return false;">
				<tr>
					<th>数据类型代码:</th>
					<td><input class="form-inline span2" type="text" name="topicCode"
						value='${dataType.TOPIC_CODE }' /> <font color="red">*</font> &nbsp;&nbsp;<span>数据类型</span></td>
				</tr>
				<tr>
					<th>数据类型名称:</th>
					<td><input class="form-inline span2" type="text" name="topicName"
						value='${dataType.TOPIC_NAME }' /> <font color="red">*</font> &nbsp;&nbsp;<span>数据类型</span></td>
				</tr>
				<tr>
					<th>写入队列数:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.WRITE_QUEUE_NUMS }'
						name="writeQueueNums" /> &nbsp;&nbsp;<span>设置写入队列数</span></td>
				</tr>
				<tr>
					<th>读取队列数:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.READ_QUEUE_NUMS }'
						name="readQueueNums" /> &nbsp;&nbsp;<span>设置读取队列数</span></td>
				</tr>
				<tr>
					<th>权限:</th>
					<td><input class="form-inline span2" type="text" name="perm"  value='${dataType.PERM }'/>
						&nbsp;&nbsp;<span>设置主题的读写权限(W|R|WR)</span></td>
				</tr>
				
				<tr style = "display:none;">
					<th>集群名:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.CLUSTER_NAME }'
						name="clusterName" /> &nbsp;&nbsp;<span>为哪个集群创建主题</span></td>
				</tr>
				<tr style = "display:none;">
					<th>tags:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.TAGS }'
						name="tags" /> &nbsp;&nbsp;<span></span></td>
				</tr>
				<tr style = "display:none;">
					<th>是否初始化:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.IS_INIT }'
						name="isInit" /> &nbsp;&nbsp;<span></span></td>
				</tr>
				<tr style = "display:none;">
					<th>主键列:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.KEY_COLUMN }'
						name="keyColumn" /> &nbsp;&nbsp;<span></span></td>
				</tr>
				<tr style = "display:none;">
					<th>初始化时间:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.INIT_TIME }'
						name="initTime" /> &nbsp;&nbsp;<span></span></td>
				</tr>
				<tr style = "display:none;">
					<th>停用时间:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.STOP_TIME }'
						name="stoptime" /> &nbsp;&nbsp;<span></span></td>
				</tr>
				<tr style = "display:none;">
					<th>更新时间:</th>
					<td><input class="form-inline span2" type="text" value='${dataType.UPDATE_TIME }'
						name="updateTime" /> &nbsp;&nbsp;<span></span></td>
				</tr>
				<tr>
					<td colspan="2">
						<center>
								<button class="btn btn-success" onclick="save('${method}')">提交</button>
						</center>
					</td>
				</tr>
			</form>
		</tbody>
	</table>
	<script type="text/javascript">
	function save(method){
		var data = $("#topicForm").serialize();
		var str = ""; 
		var groupManage_url = "${fn:getLink('mq/console/topic/topicDBAction.do')}";
		//进行请求
		$.ajax({
			url: groupManage_url + "?method="+method,
			type:"POST",
			data:data,
			contentType:"application/x-www-form-urlencoded; charset=UTF-8",
			success: function(data){
				if(data=="1"){
					$("#updateReturnDiv").html("<strong>更新并启用成功!</strong>");	
				}else{
					$("#updateReturnDiv").html("<strong>"+data+"</strong>");	
				}
				$("#updateReturnDiv").show();
	  		}
		});
	
	}
</script>
	<!-- properties-->

</div>
