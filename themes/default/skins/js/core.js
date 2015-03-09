$(function(){
	
	 function formToArray(form) {
		var a = [];
		if (!form) {
			return a;
		}

		var els = form.elements;
		if (!els) {
			return a;
		}

		var i,j,n,v,el,max,jmax;
		for(i=0, max=els.length; i < max; i++) {
			el = els[i];
			n = el.name;
			if (!n) {
				continue;
			}
			v = fieldValue(el, true);
			if (v && v.constructor == Array) {
				for(j=0, jmax=v.length; j < jmax; j++) {
					a.push({name: n, value: v[j]});
				}
			} else if (v !== null && typeof v != 'undefined') {
				a.push({name: n, value: v, type: el.type});
			}
		}

		return a;
	};
	function fieldValue(el,successful) {
		var n = el.name, t = el.type, tag = el.tagName.toLowerCase();
		if (successful === undefined) {
			successful = true;
		}

		if (successful && (!n || el.disabled || t == 'reset' || t == 'button' ||
			(t == 'checkbox' || t == 'radio') && !el.checked ||
			(t == 'submit' || t == 'image') && el.form ||
			tag == 'select' && el.selectedIndex == -1)) {
				return null;
		}

		if (tag == 'select') {
			var index = el.selectedIndex;
			if (index < 0) {
				return null;
			}
			var a = [], ops = el.options;
			var one = (t == 'select-one');
			var max = (one ? index+1 : ops.length);
			for(var i=(one ? index : 0); i < max; i++) {
				var op = ops[i];
				if (op.selected) {
					var v = op.value;
					if (!v) { // extra pain for IE...
						v = (op.attributes && op.attributes['value'] && !(op.attributes['value'].specified)) ? op.text : op.value;
					}
					if (one) {
						return v;
					}
					a.push(v);
				}
			}
			return a;
		}
		if(el.type=='file'){
			var fname = el.value;
			return fname.lastIndexOf('\\')>-1?fname.substring(fname.lastIndexOf('\\')+1):null;
		}
		return $(el).val();
	};
	//form-pre-serialize.beforesub  使用 jquery.form.js的时候会用到这个时间
	$('form').on('submit.beforesub form-pre-serialize.beforesub',function(){
		var t = $('input[name=__hash__]',this).attr('alt');
		if(!t)return;
		if(this.getAttribute('submiting')=='submiting'){
			return;
		}
		this.setAttribute('submiting','submiting');
		var _this = $(this)
			,a = formToArray(this)
			,sign = ''
			,b
			,action = this.action
			,gets = action.substring(action.indexOf('?')+1)
			,g
			;
		gets = gets.split('&');
		for(var j =0,jen=gets.length;j<jen;j++){
			g = gets[j];
			if(g=="")continue;
			g = g.split('=');
			a.push({
				name : g[0],
				value : g[1]
			});
		}
		a = a.sort(function(a1,a2){
			return a1.name >= a2.name? 1 : -1;
		});
		for(var i = 0 ,len=a.length;i<len;i++){
			b = a[i];
			sign += (b.name+'='+b.value+'&');
		}
		sign = toMD5Str(sign);
		sign = toMD5Str(sign+t);
		_this.append('<input style="display:none;" type="hidden" name="__hashsign__" value="'+sign+'">');
	}).on('reset.aftersub form-submit-notify.aftersub',function(){
		$('input[name=__hashsign__]',this).remove();
		this.removeAttribute('submiting');
	});
});