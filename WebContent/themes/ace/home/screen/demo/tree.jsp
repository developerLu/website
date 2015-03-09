<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" buffer="none"%>
<%@ taglib uri="/tags/website" prefix="website"%>
<%@ taglib uri="/tags/website-function" prefix="fn"%>
<website:script src="js/fuelux/data/fuelux.tree-sampledata.js"/>
<website:script src="js/fuelux/fuelux.tree.min.js"/>
<div class="row">
	<div class="col-sm-3">
		<div class="widget-box">
			<div class="widget-header">
				<h4 class="smaller">Popovers</h4>
			</div>
	
			<div class="widget-body">
				<div class="widget-main">
						<div id="tree1" class="tree"></div>
				</div>
			</div>
		</div>
	</div><!-- /span -->
	<div class="col-sm-9" style="display:none;">
		<div class="tabbable">
			<ul class="nav nav-tabs" id="myTab">
				<li class="active">
					<a data-toggle="tab" href="#home">
						<i class="green icon-home bigger-110"></i>
						Home
					</a>
				</li>

				<li>
					<a data-toggle="tab" href="#profile">
						Messages
						<span class="badge badge-danger">4</span>
					</a>
				</li>

				<li class="dropdown">
					<a data-toggle="dropdown" class="dropdown-toggle" href="#">
						Dropdown &nbsp;
						<i class="icon-caret-down bigger-110 width-auto"></i>
					</a>

					<ul class="dropdown-menu dropdown-info">
						<li>
							<a data-toggle="tab" href="#dropdown1">@fat</a>
						</li>

						<li>
							<a data-toggle="tab" href="#dropdown2">@mdo</a>
						</li>
					</ul>
				</li>
			</ul>

			<div class="tab-content">
				<div id="home" class="tab-pane in active">
					<p>Raw denim you probably haven't heard of them jean shorts Austin.</p>
				</div>

				<div id="profile" class="tab-pane">
					<p>Food truck fixie locavore, accusamus mcsweeney's marfa nulla single-origin coffee squid.</p>
				</div>

				<div id="dropdown1" class="tab-pane">
					<p>Etsy mixtape wayfarers, ethical wes anderson tofu before they sold out mcsweeney's organic lomo retro fanny pack lo-fi farm-to-table readymade.</p>
				</div>

				<div id="dropdown2" class="tab-pane">
					<p>Trust fund seitan letterpress, keytar raw denim keffiyeh etsy art party before they sold out master cleanse gluten-free squid scenester freegan cosby sweater. Fanny pack portland seitan DIY, art party locavore wolf cliche high life echo park Austin.</p>
				</div>
			</div>
		</div>
	</div><!-- /span -->
</div>

<script type="text/javascript">
	var $assets = "assets";//this will be used in fuelux.tree-sampledata.js

	$('#tree1').ace_tree({
		dataSource: treeDataSource ,
		multiSelect:false,
		loadingHTML:'<div class="tree-loading"><i class="icon-refresh icon-spin blue"></i></div>',
		'open-icon' : 'icon-minus',
		'close-icon' : 'icon-plus',
		'selectable' : true,
	});
	$('#tree1').on('loaded', function (evt, data) {
	});

	$('#tree1').on('opened', function (evt, data) {
	});

	$('#tree1').on('closed', function (evt, data) {
	});

	$('#tree1').on('selected', function (evt, data) {
		$('.col-sm-9').show();
		
	});

    $('tree1').on('click', function() {
    	alert(123);
    });

</script>