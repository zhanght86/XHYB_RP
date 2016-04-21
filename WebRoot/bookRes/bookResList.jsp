<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.brainsoon.system.support.SystemConstants.ResourceStatus"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/appframe/common.jsp"%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>列表</title>
	<script type="text/javascript" src="${path}/appframe/util/accountHeight.js"></script>
	<script type="text/javascript" src="${path}/appframe/util/download.js"></script>
	<script type="text/javascript" src="${path}/bres/res_operate.js"></script>
	<script type="text/javascript">
	var resTargetId = '${resTargetId}';
	var isTarget = '${isTarget}';
	var libType = '${libType}';
	var type='${type}';
	var module='${module}';
		$(function(){
			getStatusMap();
			//定义一datagrid
			var _url='';
	   		if(isTarget=='1'&&resTargetId!=''){
	   			//根据isTarget判断是否查询main页面的复选框按钮
	   			_url = '${path}/target/queryTargetRes.action?resTargetId='+resTargetId+"&libType="+libType+"&module="+module+"&type="+type;
	   		}else{
	   			_url = '${path}/bookRes/query.action';
	   		}
	   		var _divId = 'data_div';
	   		var _pk = 'objectId';
	   		var _conditions = ['module','type','status','eduPhase','version','subject','grade','fascicule','title','creator','description','res_version','keywords','modifiedStartTime','modifiedEndTime','searchText','queryType','libType','batchNum'];
	   		var _sortName = 'modified_time';
	   		var _sortOrder = 'desc';
			var _colums = [
							{field:'commonMetaData.commonMetaDatas.title',title:'资源标题',width:fillsize(0.16),sortable:true,align:'center'},
							{field:'commonMetaData.commonMetaDatas.creator',title:'制作者',width:fillsize(0.08),sortable:true,align:'center'},
							{field:'commonMetaData.commonMetaDatas.keywords',title:'关键字',width:fillsize(0.1),sortable:true,align:'center'},
							{field:'commonMetaData.commonMetaDatas.res_version',title:'资源版本',width:fillsize(0.06),sortable:true,formatter:$resVersion,align:'center'},
							{field:'commonMetaData.commonMetaDatas.status',title:'状态',width:fillsize(0.05),sortable:true,formatter:$statusDesc,align:'center'},
							{field:'commonMetaData.commonMetaDatas.modified_time',title:'更新时间',width:fillsize(0.14),sortable:true,align:'center'},
							{field:'opt1',title:'操作',width:fillsize(0.27),align:'center',formatter:$operate,align:'center'}];
			accountHeight();
	   		$grid = $.datagrid(_divId,_url,_pk,_colums,_conditions,_sortName,_sortOrder);
		});
		/***版本号***/
		$resVersion = function(value,rec){
			return "V"+value+".0";
		}
		/***操作列***/
		$operate = function(value,rec){
			var optArray = new Array();
			var status = rec.commonMetaData.commonMetaDatas.status;
			<c:if test="${param.libType == 2 }">
			<sec:authorize url='/bookRes/detail/2.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:detail('"+rec.objectId+"')\" ><i class=\"fa fa-sign-out\"></i> 详细</a>");
			</sec:authorize>
			if(status==<%=ResourceStatus.STATUS0 %>||status==<%=ResourceStatus.STATUS5 %>){
			<sec:authorize url='/bookRes/updateRes/2.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:upd('"+rec.objectId+"')\" ><i class=\"fa fa-edit\"></i> 修改</a>");
			</sec:authorize>
			}
			// 草稿、下线、已驳回
			if(status==<%=ResourceStatus.STATUS0 %>||status==<%=ResourceStatus.STATUS4 %>||status==<%=ResourceStatus.STATUS5 %>){
				<sec:authorize url='/bookRes/deleteRes/2.action'>
				optArray.push("<a class=\"btn hover-blue\" href=\"javascript:enforceDelete('"+rec.objectId+"')\" ><i class=\"fa fa-trash-o\"></i> 删除</a>");
				</sec:authorize>
			}
			if('${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS1 %>||'${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS2%>||'${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS3%>||'${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS6%>)
			{
				optArray.push("<a class=\"btn hover-blue\" href=\"javascript:enforceDelete('"+rec.objectId+"')\" ><i class=\"fa fa-trash-o\"></i> 强制删除</a>");
			}
			<sec:authorize url='/bookRes/read/2.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:readRes('"+rec.objectId+"')\" ><i class=\"fa fa-eye\"></i> 预览</a>");
			optArray.push("<sec:authorize url='/bres/doTarget/1.action'><a class=\"btn hover-red\" href=\"javascript:clickTarget('"+rec.objectId+"')\" ><i class=\"fa fa-tag\"></i> 标签</a></sec:authorize>");
			</sec:authorize>
			<sec:authorize url='/bookRes/deleteRes/2.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:doDown('"+rec.objectId+"')\" ><i class=\"fa fa-download\"></i> 下载</a>");
			</sec:authorize>
			// 草稿，驳回状态
			if(status==<%=ResourceStatus.STATUS0 %>||status==<%=ResourceStatus.STATUS5 %>){
				<sec:authorize url='/bookRes/doApply/2.action'>
				optArray.push("<a class=\"btn hover-red\" href=\"javascript:doApply('"+rec.objectId+"','2')\" ><i class=\"fa fa-mail-reply-all\"></i>上报</a>");
				</sec:authorize>
			}
			// 待审核
			if(status==<%=ResourceStatus.STATUS1 %>||status==<%=ResourceStatus.STATUS2%>||status==<%=ResourceStatus.STATUS6%>){
				<sec:authorize url='/bookRes/checkOne/2.action'>
				optArray.push("<a class=\"btn hover-red\" href=\"javascript:gotoCheck('"+rec.objectId+"',${param.libType})\" ><i class=\"fa fa-sign-out\"></i>审核</a>");
				</sec:authorize>
			}
			// 审核已经通过
			if(status==<%=ResourceStatus.STATUS3 %>){
				<sec:authorize url='/bookRes/offlineRes/2.action'>
				optArray.push("<a class=\"btn hover-red\" href=\"javascript:offlineRes('"+rec.objectId+"')\" ><i class=\"fa  fa-level-down\"></i>下线</a>");
				</sec:authorize>
			}
// 			<sec:authorize url="/bres/toChange/2.action">
// 			optArray.push("<a class=\"btn hover-red\" href=\"javascript:change('"+rec.objectId+"')\" ><i class=\"fa fa-download\"></i> 转换</a>");
// 			</sec:authorize>
			</c:if>
			<c:if test="${param.libType == 1 }">
			<sec:authorize url='/bookRes/detail/1.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:detail('"+rec.objectId+"')\" ><i class=\"fa fa-sign-out\"></i> 详细</a>");
			</sec:authorize>
			<sec:authorize url='/bookRes/updateRes/1.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:upd('"+rec.objectId+"')\" ><i class=\"fa fa-edit\"></i> 修改</a>");
			</sec:authorize>
			// 草稿、下线、已驳回
			if(status==<%=ResourceStatus.STATUS0 %>||status==<%=ResourceStatus.STATUS4 %>||status==<%=ResourceStatus.STATUS5 %>){
				<sec:authorize url='/bookRes/deleteRes/1.action'>
				optArray.push("<a class=\"btn hover-blue\" href=\"javascript:enforceDelete('"+rec.objectId+"')\" ><i class=\"fa fa-trash-o\"></i> 删除</a>");
				</sec:authorize>
			}
			if('${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS1 %>||'${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS2%>||'${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS3%>||'${enforceDelete}'==1 && status==<%=ResourceStatus.STATUS6%>)
			{
				optArray.push("<a class=\"btn hover-blue\" href=\"javascript:enforceDelete('"+rec.objectId+"')\" ><i class=\"fa fa-trash-o\"></i> 强制删除</a>");
			}
			<sec:authorize url='/bookRes/read/1.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:readRes('"+rec.objectId+"')\" ><i class=\"fa fa-eye\"></i> 预览</a>");
			optArray.push("<sec:authorize url='/bres/doTarget/1.action'><a class=\"btn hover-red\" href=\"javascript:clickTarget('"+rec.objectId+"')\" ><i class=\"fa fa-tag\"></i> 标签</a></sec:authorize>");
			</sec:authorize>
			<sec:authorize url='/bookRes/download/1.action'>
			optArray.push("<a class=\"btn hover-red\" href=\"javascript:doDown('"+rec.objectId+"')\" ><i class=\"fa fa-download\"></i> 下载</a>");
			</sec:authorize>
			// 草稿，驳回状态
			if(status==<%=ResourceStatus.STATUS0 %>||status==<%=ResourceStatus.STATUS5 %>){
				<sec:authorize url='/bookRes/doApply/1.action'>
				optArray.push("<a class=\"btn hover-red\" href=\"javascript:doApply('"+rec.objectId+"','1')\" ><i class=\"fa fa-mail-reply-all\"></i>上报</a>");
				</sec:authorize>
			}
			// 待审核
			if(status==<%=ResourceStatus.STATUS1 %>||status==<%=ResourceStatus.STATUS2%>||status==<%=ResourceStatus.STATUS6%>){
				<sec:authorize url='/bookRes/checkOne/1.action'>
				optArray.push("<a class=\"btn hover-red\" href=\"javascript:gotoCheck('"+rec.objectId+"',${param.libType})\" ><i class=\"fa fa-sign-out\"></i>审核</a>");
				</sec:authorize>
			}
			// 审核已经通过
			if(status==<%=ResourceStatus.STATUS3 %>){
				<sec:authorize url='/bookRes/offlineRes/1.action'>
				optArray.push("<a class=\"btn hover-red\" href=\"javascript:offlineRes('"+rec.objectId+"')\" ><i class=\"fa  fa-level-down\"></i>下线</a>");
				</sec:authorize>
			}
// 			<sec:authorize url="/bres/toChange/2.action">
// 			optArray.push("<a class=\"btn hover-red\" href=\"javascript:change('"+rec.objectId+"')\" ><i class=\"fa fa-download\"></i> 转换</a>");
// 			</sec:authorize>
			</c:if>
			return createOpt(optArray);
		};
		
		function readRes(objectId){
			readFileOnline("",objectId,"tszy");
		}
		/***添加***/
		function add(){
			upd('-1');
		}
		
		/***修改***/
		function upd(objectId){
			var libType=$('#libType').val();
			window.location.replace("${path}/bookRes/edit.action?module=${param.module}&type=${param.type}&objectId="+objectId+'&libType='+libType);
		}
		/***转换***/
		function change(objectId){
			window.location.href = "${path}/bookRes/toChange.action?libType=${param.libType}&objectId="+objectId;
		}
		/***删除***/
		function del() {
			var codes = getChecked('data_div','objectId').join(',');
			if (codes == '') {
			    $.alert('请选择要删除的数据！');
			} else {
				var canDel = true;
				var rows = $('#data_div').datagrid('getChecked');
			 	for ( var i = 0; i < rows.length; i++) {
			 		var status = eval('rows[i]' + '.' + 'commonMetaData.commonMetaDatas.status');
			 		if(status != '0' && status != '5'){
			 			$.alert('状态为非草稿或者非驳回的资源不允许删除！');
			 			canDel = false;
			 			break;
			 		}
			 	}
			 	if(canDel){
			 		enforceDelete(codes);
			 	}
			};
		}
		//强制删除
		function enforceDelete(ids){
			$.confirm('确定要删除所选数据吗？', function(){
				$.ajax({
					url:'enforceDelete/${param.libType}.action?ids=' + ids,
				    type: 'post',
				    datatype: 'text',
				    success: function (returnValue) {
				    	data = eval('('+returnValue+')');
				    	if(data.status==1){
				    		$.alert("删除成功!");
				    		query();
				    	}else{
				    		$.alert("该资源已发布不能删除!");
				    	}
				    }
				});
			});
		}
		//标签点击事件
		function clickTarget(obj){
			var codes = getChecked('data_div','objectId').join(',');
			 var ids=document.getElementsByName("objectId");
			 var resIds = '';
			    for(var i=0;i<ids.length;i++){
			         if(ids[i].checked){
			        	 resIds+=(ids[i].value+",");
			       }
			    }
			if(obj!=null){
			$.post('${path}/target/selectTarget.action?resId='+obj+'&libType='+$('#libType').val()+'&module='+$('#module').val()+'&type='+$('#type').val(),function(data){
				data = eval('('+data+')');
				if(data.status == 1){
					confirmRepeat(data,obj);
				}else{
					 $.alert('您还没有创建标签！');
					    return;
				}
			});
		}else if(codes == ''){
		    $.alert('请选择要添加标签的资源！');
		    return;
		}else {
			    $('#resId').val(resIds);
			$.post('${path}/target/selectTarget.action?resId='+resIds+'&libType='+$('#libType').val()+'&module='+$('#module').val()+'&type='+$('#type').val(),function(data){
				data = eval('('+data+')');
				if(data.status == 1){
					confirmRepeat(data,resIds);
				}else{
					 $.alert('您还没有创建标签！');
					    return;
				}
			});
			
		}
			
		}
		function confirmRepeat(data,resIds){
			
			$('#selectResId').val(resIds);
			var msg = '<table border="1" cellpadding="0" width="300px" cellspacing="0" >';
			msg += data.target;
			msg += '</table>';
			$.simpleDialog({
				title:'添加标签', 
				content:'<font color=\"red\">已选标签</font><br>'+ msg,
				button:[{name:'添加',callback:function(){
							var canSelectTargetIds ='';
							top.$('input:checkbox[name="canSelectTarget"]:checked').each(function(){
						    	 canSelectTargetIds+=$(this).val()+",";
						    	 
						     });
							canSelectTargetIds = canSelectTargetIds.substring(0,canSelectTargetIds.length-1);
							//alert(canSelectTargetIds);
							var hasSelectTargetIds ='';
							top.$('input:checkbox[name="hasSelectTarget"]:checked').each(function(){
								hasSelectTargetIds+=$(this).val()+",";
							     });
							
							hasSelectTargetIds = hasSelectTargetIds.substring(0,hasSelectTargetIds.length-1);
							//alert(hasSelectTargetIds+"111");
							if(canSelectTargetIds.length>0 || hasSelectTargetIds.length>0){
								saveForm(canSelectTargetIds,hasSelectTargetIds);
							}else{
								$.alert('请选择要添加的标签');
								return false;
							}
							
						}},
				        {name:'取消',callback:function(){}}
				]
			});
			
		}
		function saveForm(canSelectTargetIds,hasSelectTargetIds){
			//alert(canSelectTargetIds);
			//alert(hasSelectTargetIds+"nnnn");
			saveResWaiting = $.waitPanel('正在保存资源...',false);
			//alert($('#selectResId').val());
			$('#coreData').ajaxSubmit({
				url: '${path}/target/saveTarget.action?canSelectTargetIds='+canSelectTargetIds+'&selectResId='+$('#selectResId').val()+'&hasSelectTargetIds='+hasSelectTargetIds+'&libType='+$('#libType').val()+'&resIds='+$('#resId').val()+'&module='+$('#module').val()+'&type='+$('#type').val(),//表单的action
 				method: 'post',//方式
 				success:(function(response){
 					saveResWaiting.close();
					if(response == ''){
						parent.queryForm();
 					}else{
						$.showTips(response,5,'');
 					}
 					
           		})
 			});
		}
// 		function deleteRecord(ids){
// 			$.confirm('确定要删除所选数据吗？', function(){
// 				$.ajax({
// 					url:'${path}/collectRes/delRes.action?ids=' + ids,
// 				    type: 'post',
// 				    datatype: 'text',
// 				    success: function (returnValue) {
// 				    	query();
// 				    }
// 				});
// 			});
// 		}
		function query(){
			$grid.query();
		}
		/***查看***/
		function detail(objectId){
			window.location.href = "${path}/bookRes/detail.action?objectId="+objectId;
		}
		function importRes(){
			$.openWindow("${path}/bookRes/import/bookResImport.jsp?libType=${param.libType}&module=${param.module}&type=${param.type}",'批量导入',600,350);
		}
		//下载资源
		function batchDown(){
			var codes = getChecked('data_div','objectId').join(',');
			if (codes == '') {
			    $.alert('请选择要下载的资源！');
			} else {
				doDown(codes);
			}
		}
		function doDown(codes){
			down4Encrypt('${path}/bookRes/downloadBookRes/${param.libType}.action?ids='+codes);
		}
		function batchOneCheck(){
			var codes = getChecked('data_div','objectId').join(',');
			if (codes == '') {
			    $.alert('请选择要批量一审的资源！');
			} else {
				var canApply = true;
			 	var rows = $('#data_div').datagrid('getChecked');
			 	for ( var i = 0; i < rows.length; i++) {
			 		var status = eval('rows[i]' + '.' + 'commonMetaData.commonMetaDatas.status');
			 		if(status == '1' || status == '2'){
			 		}else{
			 			$.alert('状态为非待审核或者非待一审的资源不允许一审！');
			 			canApply = false;
			 			break;
			 		}
			 	}
			 	if(canApply){
			 		$("#versionText").modal('show');
			 	}
			}
		}
		function batchSecCheck(){
			var codes = getChecked('data_div','objectId').join(',');
			if (codes == '') {
			    $.alert('请选择要批量二审的资源！');
			} else {
				var canApply = true;
			 	var rows = $('#data_div').datagrid('getChecked');
			 	for ( var i = 0; i < rows.length; i++) {
			 		var status = eval('rows[i]' + '.' + 'commonMetaData.commonMetaDatas.status');
			 		if(status == '6'){
			 		}else{
			 			$.alert('状态为非待二审的资源不允许二审！');
			 			canApply = false;
			 			break;
			 		}
			 	}
			 	if(canApply){
			 		$("#versionText").modal('show');
			 	}
			}
		}
		function batchDoApply(){
			var codes = getChecked('data_div','objectId').join(',');
			if (codes == '') {
			    $.alert('请选择要批量上报的资源！');
			} else {
				var canApply = true;
			 	var rows = $('#data_div').datagrid('getChecked');
			 	for ( var i = 0; i < rows.length; i++) {
			 		var status = eval('rows[i]' + '.' + 'commonMetaData.commonMetaDatas.status');
			 		if(status == '0'||status == '5'){
			 		}else{
			 			$.alert('状态为非草稿的资源不允许上报！');
			 			canApply = false;
			 			break;
			 		}
			 	}
			 	if(canApply){
			 		var libType=$('#libType').val();
		 			doApply(codes,libType);
			 	}
			}
		}
		function lookBatchResult(){
			window.location.href = '${path}/bres/import/list.jsp?libType=${param.libType}&module=${param.module}&type=${param.type}';
		}
	</script>
</head>
<body>

	<div id="fakeFrame" class="container-fluid by-frame-wrap " style="height: 100%;">
	<form action="#" id="coreData" class="form-horizontal" method="post">
      					<input type="hidden" id="selectResId"  name="selectResId" value=""/>
					<input type="hidden" id="resId" name="resId" value=""/>
					<input type="hidden" id="typeTarget" name="typeTarget" value="${param.pMenuId}"/>
					<input type="hidden" id="module" name="module" value="${param.module }" />
					<input type="hidden" id="type" name="type" value="${param.type }" />
					<input type="hidden" id="status" name="status" value="${param.status }" />
					<input type="hidden" id="eduPhase" name="eduPhase" value="${param.eduPhase }" />
					<input type="hidden" id="version" name="version" value="${param.version }" />
					<input type="hidden" id="subject" name="subject" value="${param.subject }" />
					<input type="hidden" id="grade" name="grade" value="${param.grade }" />
					<input type="hidden" id="fascicule" name="fascicule" value="${param.fascicule }" />
					<input type="hidden" id="unit" name="unit" value="${param.unit }" />
					<input type="hidden" id="batchNum" name="batchNum" value="${param.batchNum }" />
					<input type="hidden" id="title" name="title" value="${param.title }" />
					<input type="hidden" id="creator" name="creator" value="${param.creator }" />
					<input type="hidden" id="description" name="description" value="${param.description }" />
					<input type="hidden" id="keywords" name="keywords" value="${param.keywords }" />
					<input type="hidden" id="modifiedStartTime" name="modifiedStartTime" value="${param.modifiedStartTime }" />
					<input type="hidden" id="modifiedEndTime" name="modifiedEndTime" value="${param.modifiedEndTime }" />
					
					<input type="hidden" id="searchText" name="searchText" value="${param.searchText }" />
					
					<input type="hidden" id="libType" name="libType" value="${param.libType }" />
					<input type="hidden" id="queryType" name="queryType" value="${param.queryType }" />
					</form>
				
					
		<div class="panel panel-default" style="height: 100%;">
			<div class="panel-heading" id="div_head_t">
				<ol class="breadcrumb">
					<li><a href="javascript:;">资源管理</a>
					</li>
					<li class="active">图书资源</li>
					<li class="active">资源列表</li>
				</ol>
			</div>
			<div class="panel-body height_remain" id="999">
				<div style="margin: 0px 10px 10px 0px;">
				<c:if test="${param.libType ==2 }">
					<sec:authorize url='/bookRes/add/2.action'>
					<input type="button" value="添加" class="btn btn-primary" onclick="add()"/>  
					</sec:authorize>
					<sec:authorize url='/bookRes/import/2.action'>
					<input type="button" value="批量导入" class="btn btn-primary" onclick="importRes()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/importResult/2.action'>
					<input type="button" value="批量导入日志" class="btn btn-primary" onclick="lookBatchResult()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/deleteRes/2.action'>
					<input type="button" value="批量删除" class="btn btn-primary" onclick="del()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/download/2.action'>
					<input type="button" value="批量下载" class="btn btn-primary" onclick="batchDown()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/doApply/2.action'>
						<input type="button" value="批量上报" class="btn btn-primary" onclick="batchDoApply()"/>
					</sec:authorize>
					<sec:authorize url='/bres/doTarget/1.action'>
						<input type="button" value="批量标签" class="btn btn-primary" onclick="clickTarget()"/>
						</sec:authorize>
					<sec:authorize url='/bookRes/checkOne/2.action'>
						<input type="button" value="批量一审" class="btn btn-primary" onclick="batchOneCheck()"/>
					</sec:authorize>
					</c:if>
					<c:if test="${param.libType ==1 }">
					<sec:authorize url='/bookRes/add/1.action'>
					<input type="button" value="添加" class="btn btn-primary" onclick="add()"/>  
					</sec:authorize>
					<sec:authorize url='/bookRes/import/1.action'>
					<input type="button" value="批量导入" class="btn btn-primary" onclick="importRes()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/importResult/1.action'>
					<input type="button" value="批量导入日志" class="btn btn-primary" onclick="lookBatchResult()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/deleteRes/1.action'>
					<input type="button" value="批量删除" class="btn btn-primary" onclick="del()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/download/1.action'>
					<input type="button" value="批量下载" class="btn btn-primary" onclick="batchDown()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/doApply/1.action'>
						<input type="button" value="批量上报" class="btn btn-primary" onclick="batchDoApply()"/>
					</sec:authorize>
					<sec:authorize url='/bres/doTarget/1.action'>
						<input type="button" value="批量标签" class="btn btn-primary" onclick="clickTarget()"/>
					</sec:authorize>
					<sec:authorize url='/bookRes/checkOne/1.action'>
						<input type="button" value="批量一审" class="btn btn-primary" onclick="batchOneCheck()"/>
					</sec:authorize>
						<sec:authorize url='/bookRes/checkSec/1.action'>
						<input type="button" value="批量二审" class="btn btn-primary" onclick="batchSecCheck()"/>
						</sec:authorize>
					</c:if>
				</div>
				<div id="data_div" class="data_div height_remain" style="width: 100%;"></div>
				<%@ include file="/bres/resCheck.jsp" %>
			</div>
		</div>
	</div>
</body>
</html>