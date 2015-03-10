/*
	[EasyJForum] (C)2007 Hongshee Soft.
	$file: post.js $
	$Date: 2007/11/30 $
*/

var seqno = 1;
var attachexts = new Array();
var attachfiles = new Array();

function deleteAttach(id) {
	deleteMediaFromEditor(id);
	$('attachbody').removeChild($('attach_' + id).parentNode.parentNode);
	if ($('attachbody').innerHTML == '') addAttach();
}

function deleteMediaFromEditor(id) {
	if(!attachexts[id]) {
		return;
	}
	var txt = '';
	if(attachexts[id] == 2) {
		if($('serverfile_' + id) && $('serverfile_' + id).value != '')
			txt = '<IMG[^>]+?src="[^>]+?' + $('serverfile_' + id).value + '"[^>]*>';
		else
			txt = '\\[img="' + id + '"\\]' + attachfiles[id] + '\\[/img\\]';
	}else if(attachexts[id] == 3){
		if($('serverfile_' + id) && $('serverfile_' + id).value != '')
			txt = '\\[media="[^"]+?' + $('serverfile_' + id).value + '"\\].+?\\[/media\\]';
		else
			txt = '\\[media="' + id + '"\\].+?\\[/media\\]';
	}
	if(txt != ''){
		if (wysiwyg)
			editdoc.body.innerHTML = editdoc.body.innerHTML.replace(new RegExp(txt,"igm"),"");
		else
			editbox.value = editbox.value.replace(new RegExp(txt,"igm"),"");
	}
}

function addAttach() {
	appendAttach(seqno);
	seqno++;
}

function appendAttach(aid) {
	var newnode = $('attachitem').firstChild.cloneNode(true);
	var tags = newnode.getElementsByTagName('input');
	for(i=0; i<tags.length; i++) {
		if(tags[i].name == 'attachfile') {
			tags[i].id = 'attach_' + aid;
			tags[i].name = 'attach_' + aid;
			tags[i].onchange = function() {insertAttach(aid);};
			tags[i].unselectable = 'on';
		}
		else if(tags[i].name == 'attachid') {
			tags[i].id = 'attachid_' + aid;
			tags[i].name = 'attachid_' + aid;
		}
		else if(tags[i].name == 'serverfile') {
			tags[i].id = 'serverfile_' + aid;
			tags[i].name = 'serverfile_' + aid;
		}
		else if(tags[i].name == 'attachcredits') {
			tags[i].id = 'attachcredits_' + aid;
			tags[i].name = 'attachcredits_' + aid;
		}
		else if(tags[i].name == 'attachtitle') {
			tags[i].id = 'attachtitle_' + aid;
			tags[i].name = 'attachtitle_' + aid;
		}
	}
	tags = newnode.getElementsByTagName('span');
	for(i=0; i<tags.length; i++) {
		if(tags[i].id == 'localfile') {
			tags[i].id = 'localfile_' + aid;
		}
	}
	$('attachbody').appendChild(newnode);
}

function insertAttach(id) {
	var path = $('attach_' + id).value;
	if(path == '') return;

	if ($('attachbody').childNodes.length > maxAttachNum) 
	{
		alert(msgs['too_many_attach']);
		$('attachbody').removeChild($('attach_' + id).parentNode.parentNode);
		addAttach();
		return;
	}

	var localfile = path.replace(/\\/g, '/');
	localfile = localfile.substr(localfile.lastIndexOf('/') + 1);
	var p = localfile.lastIndexOf('.');
	var ext = p == -1 ? '' : localfile.substr(p+1).toLowerCase();

	var re = new RegExp("," + ext + ",", "ig");
	extensions = extensions.replace(/\s/g, '');
	if(extensions != '' && (re.exec("," + extensions + ",") == null || ext == '')) {
		alert(msgs['attach_ext_invalid']);
		$('attachbody').removeChild($('attach_' + id).parentNode.parentNode);
		addAttach();
		return;
	}

	attachexts[id] = 
		isInArray(ext, ['gif', 'jpg', 'png', 'bmp', 'jpeg']) ? 2 : (isInArray(ext, ['swf', 'mp3', 'wma', 'wmv']) ? 3 : 1);
	attachfiles[id] = localfile;
	
	$('attach_' + id).style.display = 'none';
	
	var htmlStr = '[&nbsp;<a href="#" onclick="deleteAttach(' + id + ')">' + msgs['attach_deletelink'] + '</a>&nbsp;]';
	if ((allowimg && attachexts[id] == 2) || (allowmedia && attachexts[id] == 3))
	{
		htmlStr = htmlStr + ' [&nbsp;<a href="#" onclick="insertMediaToEditor('
				+ id + ');return false;">' + msgs['attach_insert'] + '</a>&nbsp;]';
		insertMediaToEditor(id);
	}
	htmlStr = htmlStr + ' <span class="smalltxt">[' + id + ']</span> ' + localfile;
	$('localfile_' + id).innerHTML = htmlStr;
	
	addAttach();
}

function showAttach(id, attachid, serverfile, localfile, credits, title) {
	appendAttach(id);
	seqno = id + 1;
	
	var p = localfile.lastIndexOf('.');
	var ext = p == -1 ? '' : localfile.substr(p+1).toLowerCase();

	attachexts[id] = 
		isInArray(ext, ['gif', 'jpg', 'png', 'bmp', 'jpeg']) ? 2 : (isInArray(ext, ['swf', 'mp3', 'wma', 'wmv']) ? 3 : 1);
	attachfiles[id] = localfile;

	$('attach_' + id).disabled = true;
	$('attach_' + id).style.display = 'none';
	
	var htmlStr = '[&nbsp;<a href="#" onclick="deleteAttach(' + id + ')">' + msgs['attach_deletelink'] + '</a>&nbsp;]';
	if ((allowimg && attachexts[id] == 2) || (allowmedia && attachexts[id] == 3))
		htmlStr = htmlStr + ' [&nbsp;<a href="#" onclick="insertMediaToEditor('
				+ id + ');return false;">' + msgs['attach_insert'] + '</a>&nbsp;]';
	htmlStr = htmlStr + ' <span class="smalltxt">[' + id + ']</span> ' + localfile;
	$('localfile_' + id).innerHTML = htmlStr;
	$('attachid_' + id).value = attachid;
	$('serverfile_' + id).value = serverfile;
	$('attachcredits_' + id).value = credits;
	$('attachtitle_' + id).value = title;
}

function insertMediaToEditor(id) {
	if (!wysiwyg) return;
	if(!attachexts[id]) {
		return;
	}
	if(attachexts[id] == 2) {
		insertHTML('[img="' + id + '"]' + attachfiles[id] + '[/img]');	
	} else if(attachexts[id] == 3) {
		insertHTML('[media="' + id + '"]' + attachfiles[id] + ',400,300[/media]');
	}
}

function checkInt(field) {
	if(field && parseInt(field.value)) {
		field.value = Math.abs(parseInt(field.value));
	} else {
		field.value = 0;
	}
}

function checkPost(theform) {
	var subject = trim(theform.subject.value);
	if($('postbtn').name != 'post_reply' && subject == "") {
		alert(msgs['post_subject_empty']);
		theform.subject.focus();
		return;
	}
	if($('postbtn').name == 'post_reward') {
		if ($('reward').value == 0)	{
			alert(msgs['post_reward_zero']);
			theform.reward.focus();
			return;
		}
	}
	var content = getContent();
	content = trim(content);
	var tmpStr = trim(content.replace(/&nbsp;|<[^>]*>/ig,''));
	if(tmpStr == "") {
		alert(msgs['post_content_empty']);
		return;
	}
	if(maxTitleLength != 0 && uc_strlen(subject) > maxTitleLength) {
		alert(msgs['post_subject_toolong']);
		theform.subject.focus();
		return;
	}
	if(maxPostLength != 0 && uc_strlen(content) > maxPostLength - 200) {
		alert(msgs['post_content_toolong'] + '\n\n' + msgs['post_curlength'] + ': ' + uc_strlen(content) + ' ' + msgs['bytes']);
		return;
	}
	if (trim($('verifycode').value) == '')
	{
		warning($('checkverifycode'), msgs['post_vcode_empty']);
		theform.verifycode.focus();
		return;
	}
	if (!checkverifycode())
	{
		theform.verifycode.focus();
		return;
	}
	wysiwyg = 0;
	theform.action = performUrl + '&verifycode=' + $('verifycode').value;
	theform.subject.value = subject;
	theform.content.value = content;
	theform.submit();
	$('postmsg').innerHTML = msgs['posting'];
}

function loadData() 
{
	var formdata = getSessionData('data');
	if(isInArray(trim(formdata), ['', 'null', 'false', null, false]))
		return;

	var elems = formdata.split(/\x0B\x0B/);
	var obj, elem, elvalue;
	for(var i=0; i < elems.length; i++) 
	{
		elem = trim(elems[i]).split(/\x0B/);
		obj = $('postform').elements[elem[0]];
		if(typeof(obj) == 'undefined') continue;
		elvalue = typeof(elem[3])!='undefined' ? elem[3] : '';

		if(elem[1] == 'INPUT') {
			if(elem[2] == 'text') {
				obj.value = elvalue;
			} else if(elem[2] == 'checkbox' && elvalue == obj.value) {
				obj.checked = true;
			}
		} else if(elem[1] == 'TEXTAREA') {
			if(elem[0] == 'content') {
				if(typeof wysiwyg == 'undefined' || wysiwyg) {
					editdoc.body.innerHTML = elvalue;
				} else {
					textobj.value = elvalue;
				}
			} else {
				obj.value = elvalue;
			}
		}
	}
}

function saveData()
{
	var formdata = '';
	var elvalue;
	for(var i = 0; i < $('postform').elements.length; i++) {
		var el = $('postform').elements[i];
		if(el.name != '' && el.name != 'verifycode' && (el.tagName == 'TEXTAREA' || el.tagName == 'INPUT' 
			&& (el.type == 'text' || el.type == 'checkbox')) && el.name.substr(0, 6) != 'attach') 
		{
			if (el.name == 'content')
				elvalue = wysiwyg ? editdoc.body.innerHTML : textobj.value;
			else
				elvalue = el.value;
			elvalue = trim(elvalue);
			
			if(el.type == 'checkbox' && !el.checked)
				continue;
			formdata += el.name + String.fromCharCode(11) + el.tagName 
					 			+ String.fromCharCode(11) + el.type 
								+ String.fromCharCode(11) + elvalue + String.fromCharCode(11, 11);
		}
	}
	setSessionData('data', formdata);
}

function setSessionData(name, value)
{
	if(is_ie) {
		try {
			var xmlDoc = textobj.XMLDocument;
			var root = xmlDoc.firstChild;
			var node;
			if(root.childNodes.length > 0)
				node = root.firstChild;
			else
			{
				node = xmlDoc.createNode(1, 'POST', '');
				xmlDoc.documentElement.appendChild(node);
			}
			node.setAttribute(name, value);
			textobj.save('EasyJForum');
		} catch(e) {}
	} else if(window.sessionStorage) {
		try {
			sessionStorage.setItem('EasyJForum_' + name, escape(value));
		} catch(e) {}
	}
}

function getSessionData(name) {
	var value = '';
	if(is_ie) {
		try {
			textobj.load('EasyJForum');
			var oXMLDoc = textobj.XMLDocument;
			var nodes = oXMLDoc.documentElement.childNodes;
			value = nodes.item(nodes.length-1).getAttribute(name);
		} catch(e) {}
	} else if(window.sessionStorage) {
		try {
			value = unescape(sessionStorage.getItem('EasyJForum_' + name));
		} catch(e) {}
	}
	if (value == null)	return '';
	else return value.toString();
}