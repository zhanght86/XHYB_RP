//初始化列表
function initTable(searchParam){
	var resType = searchParam.resType;
	var _table;//列表Id
	var	_ajax;//后台url&参数
	var _columns;//列属性
	
	if(resType!=="" && resType==='1'){//期刊
		hiddenOtherTable(resType);
		
		_table = 'journal_list';
		_ajax = {
		  	"url": _appPath+"/index/queryResList.action",
		  	"type": "POST",
		  	"data": {"searchParam": JSON.stringify(searchParam)}//额外的需提交到后台的参数
		};
		_columns = [
			{ "title": "期刊名","data":"metadataMap.magazine"},  
			{ "title": "序号","data":"id"}, 
		    { "title": "国内刊号", "data":'metadataMap.localSerialNumber'},
		    { "title": "国际刊号", "data":'metadataMap.overseasSerialNumber'},
			{ "title": "期刊年份","data":"metadataMap.magazineYear"},  
			{ "title": "当前期数","data":"metadataMap.numOfYear"},  
			{ "title": "总期数","data":"metadataMap.magazineNum"}];
	}else if(resType!=="" && resType==='2'){//文章
		hiddenOtherTable(resType);
		
		_table = 'article_list';
		_ajax = {
			"url": _appPath+"/index/queryResList.action",
		  	"type": "POST",
		  	"data": {"searchParam": JSON.stringify(searchParam)}//额外的需提交到后台的参数
		};
		_columns = [
            {"title": "序号","data":"id"}, 
			{"title": "文章标题", "data": "metadataMap.title",
				"render": function(data, type, row) {
					if(data.length>15){
						data = data.substring(0,15)+"...";
					}
                	return data;
            	}
			},
			{"title": "所属期次分类", "data": "metadataMap.wzJournalClass"},
			{"title": "关键词","data": "metadataMap.keywords",
				"render": function(data, type, row) {
					var arr = data.split(",");
					var keywords = "";
					if(arr.length>4){
						for(var i=0; i<4; i++){
							keywords += arr[i]+",";
						}
					}else{
						for(var i=0; i<arr.length; i++){
							keywords += arr[i]+",";
						}
					}
					if(keywords.length > 0){
						keywords = keywords.substring(0,keywords.length)+"..";
					}
                	return data;
            	}
			},
			{"title": "来源","data": "metadataMap.source"},
			{"title": "所属期次期号", "data": "metadataMap.articleOfJul"}];
	}else if(resType!=="" && resType==='3'){//大事记
		hiddenOtherTable(resType);
		
		_table = 'event_list';
		_ajax = {
		  	"url": _appPath+"/index/queryResList.action",
		  	"type": "POST",
		  	"data": {"searchParam": JSON.stringify(searchParam)}//额外的需提交到后台的参数
		};
		_columns = [
            {"title":"序号","data":"id","width":"10%"}, 
    		{"title":"日期","data":"metadataMap.magazineTime","width":"10%"},
    		{"title":"条目内容",
    			"data":"content",
    			"render": function(data, type, row) {
    				if(data.length>60){
    					data = data.substring(0,60)+"...";
    				}
                    return data;
                }
    		},
    		{"title":"所属期刊","data":"metadataMap.magazineNum","width":"20%"}];
	}else if(resType!=="" && resType==='5'){//网页爬虫
		hiddenOtherTable(resType);
		
		_table = 'crawl_list';
		_ajax = {
		  	"url": _appPath+"/index/queryResList.action",
		  	"type": "POST",
		  	"data": {"searchParam": JSON.stringify(searchParam)}//额外的需提交到后台的参数
		};
		_columns = [
			{ "title":'编号', "data":'sn'},
			{ "title":'标题', "data":'title',
				"render": function(data, type, row) {
    				data = "<a href=\"javascript:view('"+row.url+"')\">"+data+"</a>";
                    return data;
                }
			},
			{ "title":'来源', "data":'source',
				"render": function(data, type, row) {
					if(row.source){
						return row.source.replace(/来源：/g,"");	
					}else{
						return row.source;	
					}
				}
			},
			{ "title":'发布时间', "data":'postime'},
			{ "title":'状态', "data":'status'},
			{ "title":'采集时间', "data":'createTime'}];
	}
	//"<a href=\"javascript:view('"+row.url+"')\">"+value+"</a>"
	$.fn.dataTable.ext.errMode = "throw";//出现错误时，抛掉 默认为alert弹出
	var table = queryDataTable(_table,_ajax,_columns);//封装的查询组件
	onclickColumn(table,resType);//列表点击事件
}

//列表点击事件
function onclickColumn(table,resType){
	//点击打开Tab页
	$('.display tbody').on( 'click', 'tr', function (event) {
		//选中样式
		if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        }else {
            table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
		//打开tab页面
		if(resType==="5"){
			console.info(table.row( this ).data().url);
		}else{
			openTabs(table.row( this ).data().objectId,resType,table.row( this ).data().metadataMap.title);
		}
	} );

}

//查询列表时 隐藏其他列表
function hiddenOtherTable(resType){
	if(resType!=="" && resType==='1'){
		$('#journal_list_wrapper').show();
		$('#article_list_wrapper').hide();
		$('#event_list_wrapper').hide();
		$('#crawl_list_wrapper').hide();
	}else if(resType!=="" && resType==='2'){
		$('#journal_list_wrapper').hide();
		$('#article_list_wrapper').show();
		$('#event_list_wrapper').hide();
		$('#crawl_list_wrapper').hide();
	}else if(resType!=="" && resType==='3'){
		$('#journal_list_wrapper').hide();
		$('#article_list_wrapper').hide();
		$('#event_list_wrapper').show();
		$('#crawl_list_wrapper').hide();
	}else if(resType!=="" && resType==='5'){
		$('#journal_list_wrapper').hide();
		$('#article_list_wrapper').hide();
		$('#event_list_wrapper').hide();
		$('#crawl_list_wrapper').show();
	}
}

function view(url){
	layer.open({
        type: 2,
        title: '结果页',
        fix: false,
        shadeClose: true,
        maxmin: true,
        area: ['1000px', '600px'],
        content: url
    });
}

/**
 * 封装查询组件
 * @param _table
 * @param _ajax
 * @param _columns
 * @returns
 */
function queryDataTable(_table,_ajax,_columns) {
	var data_table_object;
	if(_table == null || _table == "" || typeof(_table) == 'undefined'){
		_table = "table_list";
	}
	data_table_object = $("#"+_table).DataTable({
		"language" : {
			"processing" : "正在加载中......",
			"lengthMenu" : "每页 _MENU_ 条",
			"zeroRecords" : "对不起，查询不到相关数据！",
			"emptyTable" : "没数据存在！",
			"info" : "当前显示<font color='green'> _START_ </font>到<font color='green'> _END_ </font>条，共<font color='red'> _TOTAL_ </font>条记录",
			"infoEmpty":"当前显示<font color='red'>0</font>到<font color='red'> 0</font>条，共<font color='red'> 0</font>条记录",
			"infoFiltered" : "数据表中共为 _MAX_ 条记录",
			"search" : "搜索",
			"paginate" : {
				"first" : "首页",
				"previous" : "上一页",
				"next" : "下一页",
				"last" : "末页"
			}
		},
		"pagingType" : "simple_numbers",//分页按钮种类显示选项 numbers simple simple_numbers(默认) full full_numbers
		"destroy": true,//允许重新实例化Datatables
		"processing": true,//显示加载信息
		"serverSide" : true,//开启服务器模式
		"ordering" : false,// 是否使用排序
		//"scrollX":"100%",
		"ajax": _ajax,
		"columns": _columns
		//"initComplete" : initComplete
	});

	return data_table_object;
}



(function($) {
	$.fn.formJSON = function() {
		var serializeObj = {};
		var array = this.serializeArray();
		var str = this.serialize();
		$(array).each(
				function() {
					if (serializeObj[this.name]) {
						if ($.isArray(serializeObj[this.name])) {
							serializeObj[this.name].push(this.value);
						} else {
							serializeObj[this.name] = [
									serializeObj[this.name], this.value ];
						}
					} else {
						serializeObj[this.name] = this.value;
					}
				});
		return serializeObj;
	};
})(jQuery);
function isEmpty(str) {
	return (str == null || $.trim(str).length == 0);
}

function query_dataTable(options) {
	var data_table_object;
	// options参数说明 function 有complete 查询完成后会调用的事件
	// load 替换现有在加载函数 调用自己的加载函数来加载datatable数据 调用load函数会传递 这个4个参数url, queryParam,
	// callback, oSettings
	// success 在表格数据成功加载后需要调用的function 会传递json数据 即后台返回的数据包
	// table对象中 data-options 设置每个对象即一列 里面的参数包括 Class title visible width out
	// render 四个属性 Class自定义样式 title标题 visible是否显示列 width 自定义每列宽度 默认平均分配宽度
	// out 自定义此列输出内容 返回字符串 会传递2个参数 当前值 跟当前行的所有列对象数据
	// render 跟out函数用法差不多 此函数覆盖原来的输出列函数 自定义列输出 三个参数 当前行数据 当前列数据 oSettings对象
	// hidden_title 是否隐藏表头 默认显示
	// selected 是否显示选择列
	// selectType 单选或多选 默认多选
	// selectCall 选择框change时的触发事件调用函数 传递当前选中的内容json数组格式
	// 可以调selectedAll()函数获取当前选中的内容json数组
	var url = options.url ? options.url : "自定义默认url";
	var table = options.table;// 显示列表数据 table
	var query = options.query ? options.query : "#queryParam";// 查询条件包裹元素id
	var table_class = $(table).attr("class"); // 是否自定义样式
	var hidden_title = options.hidden_title ? options.hidden_title : null;// 是否隐藏表头
	var complete = function() {// 加载完成调用事件
		if (options.complete)
			options.complete();
	}
	var columns = [];
	if (isEmpty(table_class)) {
		$(table).removeClass("table table-striped table-hover table-bordered");
		$(table).addClass("table table-striped table-hover table-bordered");
	}
	var data_options = $(table).attr("data-column");// 表头的自定义列属性
	var bSort = options.sort ? options.sort : false;// 自定义表格否排序 true false
	data_options = JSON.parse(data_options);
	var selectedType = options.selectType ? options.selectType : "checkbox";// 选择类型单选或多选
	// checkbox
	// radio
	var dis = (selectedType == "radio") ? "disabled" : "";
	if (options.selected) {// 是否显示复选框默认不显示
		columns.push({
			"mDataProp" : "",
			"sTitle" : "<input title='全选/反选' type='" + selectedType + "'" + dis
					+ "name='bootstarp_data_table_checkbox'>",
			"sClass" : "left selected",
			"bVisible" : true,
			"sWidth" : "2%",
			"bSortable" : false,
			"fnRender" : function() {
				return "<input title='选择' type='" + selectedType
						+ "' name='bootstarp_data_table_checkbox'>";
			}
		});
	}
	var displayLen = data_options.length;// 获取显示列数量
	$.each(data_options, function() {
		var visible = this["visible"];
		if (visible)
			displayLen--;
	});
	$.each(data_options, function(index, td) {// 初始化列数据
		var sClass = td.Class ? td.Class : "center";// 居中
		var sTitle = td.title ? td.title : "";// 标题
		var bVisible = td["visible"] ? false : true;// 是否隐藏
		var sWidth = td.width ? td.width : (100 / displayLen) + "%";// 不设置宽度默认
		var bSortable = td.sort ? td.sort : bSort;// 自定义列是否排序 true false
		// 平均分配
		var column = {
			"mDataProp" : td.name,
			"sTitle" : sTitle,
			"sClass" : sClass,
			"bVisible" : bVisible,
			"sWidth" : sWidth,
			"bSortable" : bSortable
		};
		if (td.out) {
			column["fnRender"] = function(row, key) {// 编辑列需要执行的自定义函数输出内容
				// 此函数会接收两个参数 （第一个是此列的值
				// 第二个是当前行所有内容）
				return td.out(key, row.aData);// key 为当前列数据
				// row.aData为当前行数据
			}
		}
		if (td.render) {// 覆盖原有的编辑列自定义输出内容函数 此函数有三个参数 oSettings 对象
			// row对象 col列对象
			column["fnRender"] = td.render;
		}
		columns.push(column);
	});
	function success(json) {
		// to code
	}
	var successFunc = options.success ? options.success : success;
	// 3个参数的名字可以随便命名,但必须是3个参数,少一个都不行
	function datatable_callback(url, queryParam, callback, oSettings) {
		queryParam = $(query).formJSON();// 查询条件
		queryParam["PAGE_INFO.currentPage"] = oSettings._iDisplayStart;// 当前页
		$.ajax({
			type : 'POST',
			dataType : 'json',
			cache : false,
			url : url,// 这个就是请求地址对应sAjaxSource
			data : queryParam, // 这个是把datatable的一些基本数据传给后台,比如起始位置,每页显示的行数
			success : function(json) {
				json["sEcho"] = oSettings._sEcho | oSettings.iDraw;
				if (options.success)
					options.success(json);
				callback(json);// 把返回的数据传给这个方法就可以了,datatable会自动绑定数据的
			},
			error : function(e) {
				// alert("对不起数据加载失败！");
			}
		});
	}
	var data_table_load = options.load ? options.load : datatable_callback;
	data_table_object = $(table).dataTable({
		"bFilter" : false,// 去掉搜索框
		"bAutoWidth" : false, // 自适应宽度
		"sPaginationType" : "bootstrap",
		"bLengthChange" : false,
		"bDestroy" : true,
		"bProcessing" : false,
		"sAjaxSource" : url,
		"fnServerData" : data_table_load, // 获取数据的处理函数
		"bServerSide" : false,// 是否每次请求新数据
		"bSort" : bSort,// 是否使用排序
		"aoColumns" : columns,
		"fnInitComplete" : complete,
		"oLanguage" : {
			"sProcessing" : "数据获取中...",
			"sLengthMenu" : "_MENU_ 记录/页",
			"sZeroRecords" : "没有匹配的记录",
			"sInfo" : "显示第 _START_ 至 _END_ 条记录，共 _TOTAL_ 条",
			"sInfoEmpty" : "显示第 0 至 0 条记录，共 0条",
			"sInfoFiltered" : "(由 _MAX_ 条记录过滤)",
			"sInfoPostFix" : "",
			"oPaginate" : {
				"sFirst" : "首页",
				"sPrevious" : "上页",
				"sNext" : "下页",
				"sLast" : "末页"
			}
		}
	});
	if (options.selected) {// 显示选择框
		$('tbody', $(table))
				.on(
						'click',
						'td',
						function() {
							if ($(this)
									.find(
											":input[name='bootstarp_data_table_checkbox']").length < 1) {
								var box = $(this)
										.parent()
										.find(
												":input[name='bootstarp_data_table_checkbox']");
								box.prop("checked", !box.is(":checked"));
							}
							if (options.selectCall) {// 选择框点击时触发selectCall函数
								var selecteds = data_table_object.selectedAll();
								options.selectCall(selecteds);
							}
						});
		$('thead', $(table)).find(
				":input[name='bootstarp_data_table_checkbox']").on(
				"click",
				function() {
					$('tbody', $(table)).find(
							":input[name='bootstarp_data_table_checkbox']")
							.prop("checked", $(this).is(":checked"));
					if (options.selectCall) {// 选择框点击时触发selectCall函数
						var selecteds = data_table_object.selectedAll();
						options.selectCall(selecteds);
					}
				});
		// 获取datatable选中行的所有数据
		data_table_object.selectedAll = function() {
			var selected = [];
			$.each(this.fnGetNodes(), function() {
				var rows = this;
				var checked = $(this).find(
						":input[name='bootstarp_data_table_checkbox']").is(
						":checked");
				if (checked)
					selected.push(data_table_object.fnGetData(rows));
			});
			return selected;
		};
	}
	$(table).prev().hide();
	if (hidden_title) {
		$(table).find("tr:eq(0)").hide();
	}
	return data_table_object;
}