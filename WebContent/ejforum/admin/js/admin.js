/*
	[EasyJForum] (C)2007 Hongshee Soft.
	$file: admin.js $
	$Date: 2007-11-07 $
*/

function toBreakWord(txt, size)
{
	var tmpStr = txt;
	var result = "";
	while(tmpStr.length > size)
	{
		result = result + tmpStr.substr(0, size) + "<br>";
		tmpStr = tmpStr.substr(size, tmpStr.length);
	}
	result = result + tmpStr;
	document.write(result);
}    

function zoomtextarea(objname, zoom) {
	zoomsize = zoom ? 10 : -10;
	obj = $(objname);
	if (obj.rows < 50 || zoomsize < 0)
	{
		if (obj.rows + zoomsize > 0) {
			obj.rows += zoomsize;
		}
	}
}

function redirect(url) {
	window.location.replace(url);
}

function collapse_change(menucount, imagepath) {
	if($('menu_' + menucount).style.display == 'none') {
		$('menu_' + menucount).style.display = '';
		$('menuimg_' + menucount).src = imagepath + '/menu_reduce.gif';
	} else {
		$('menu_' + menucount).style.display = 'none';
		$('menuimg_' + menucount).src = imagepath + '/menu_add.gif';
	}
}