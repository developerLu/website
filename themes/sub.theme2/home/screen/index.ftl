<@website.script src="js/jquery.js" />
<@website.script src="js/jquery.form.js" />
<@website.script src="js/md5.js" />
<@website.script src="js/core.js" />

<@website.style href="css/default.css" />

<@website.widget path="widget.jsp?city=2014" />
<script type="text/javascript">
function sub2(){
	$('form').ajaxSubmit();
}
function sub3(){
	$('form')[0].reset();	
}
</script>
