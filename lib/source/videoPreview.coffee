#Default values

VideoPreview = {
	width : 560
	height : 315
	paletes : {
		mint : {boxBG:'#cae1f9',arrowBG:'#47a3ff'}
		lime : {boxBG:'#caf7cd',arrowBG:'#47ff65'}
		cinamon : {boxBG:'#f7caca',arrowBG:'#ff4747'}
	}
	palete : 'mint'
	holderStyle : ''
}

$ZeroDragon = {
	getTag : (tag)->
		return document.getElementsByTagName(tag)
	getID : (id)->
		return document.getElementById(id)
	removeClass : (el,className)->
		if (el.classList)
		  el.classList.remove(className)
		else
		  el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')
	domReady : (cb)->
		if document.addEventListener
			document.addEventListener 'DOMContentLoaded', (->
				document.removeEventListener 'DOMContentLoaded', arguments.callee, false
				cb()
				return
			), false
		else if document.attachEvent
			document.attachEvent 'onreadystatechange', ->
				if document.readyState == 'complete'
					document.detachEvent 'onreadystatechange', arguments.callee
					cb()
				return
	getJSON : (path, callback) ->
		xmlhttp = new XMLHttpRequest
		xmlhttp.overrideMimeType 'application/json'

		xmlhttp.onreadystatechange = ->
			ready = xmlhttp.readyState == 4 and xmlhttp.status == 200
			if ready
				callback JSON.parse(xmlhttp.responseText)[0]
			return

		xmlhttp.open 'GET', path, true
		xmlhttp.send()
		return
}

(($)->
	(VideoPreview[k] = v for k, v of videoPreview) if videoPreview?
	VideoPreview.color = VideoPreview.paletes[VideoPreview.palete]
	VideoPreview.playImage = '<svg width="92" height="92" xmlns="http://www.w3.org/2000/svg"><g><title>Play</title><rect opacity="0.9" ry="24" rx="24" id="svg_1" height="87" width="87" y="2.5" x="2.5" stroke-width="5" stroke="#ffffff" fill="'+VideoPreview.color.boxBG+'"/><path id="svg_3" d="m33.84636,74.58079l8.22989,-29.31224l-8.2299,-26.57616l27.94421,27.9442l-27.94419,27.94419z" stroke-linecap="null" stroke-linejoin="null" stroke-width="0" stroke="#ffffff" fill="'+VideoPreview.color.arrowBG+'"/></g></svg>'
	VideoPreview.playImage = '<img src="'+VideoPreview.play+'"/>' if VideoPreview.play?
	VideoPreview.display = (id,url)->
		e = $.getID('overlay'+id)
		e.outerHTML = '<iframe src="'+url+'" width="'+VideoPreview.width+'" height="'+VideoPreview.height+'" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
		$.removeClass $.getID('holder'+id),'holderStyle'
		return
	style = document.createElement('style')
	style.innerHTML ='.videoHolder{
			width:'+VideoPreview.width+'px;
			height:'+VideoPreview.height+'px;
			position:relative;
			display:inline-block;
			overflow:hidden;
			box-sizing:border-box;
		}
		.videoHolder.holderStyle{
			'+VideoPreview.holderStyle+'
		}
		.videoHolder .videoIframe{
			position:absolute;
			top:0;
			left:0;
		}
		.videoHolder .videoImage{
			position:absolute;
			top:0;
			left:0;
			width:'+VideoPreview.width+'px;
			height:'+VideoPreview.height+'px;
			background-size:cover;
			display:inline-block;
		}
		.videoHolder .overlays{
			position:relative;
			height:'+VideoPreview.height+'px;
			width:100%;
		}
		.videoHolder .playbtn{
			cursor:pointer;
			position:absolute;
			top:50%;
			left:50%;
			-webkit-transform:translate(-50%,-50%);
			-moz-transform:translate(-50%,-50%);
			transform:translate(-50%,-50%);
		}
		.videoHolder .playbtn:hover{
			-webkit-opacity:0.9;
			-moz-opacity:0.9;
			opacity:0.9;
		}'
	document.head.appendChild(style)
	$.domReady ->
		forEachTag = ((cb)->
			tags = $.getTag('vp')
			tagLength = tags.length - 1
			tag = tags[0]
			url = tag.getAttribute('url')
			if url.search("=") isnt -1
				id = url.split('=').pop()
			else if url.search("youtu.be/") isnt -1
				id = url.split("youtu.be/").pop()
			else
				id = url.split('/').pop()
			output = '<div class="videoHolder holderStyle" id="holder'+k+'-'+id+'">'

			continua = (tg, data, out)->

				imgUrl = data.thumbnail_large
				videoUrl = data.videoUrl
				out += '<div style="background:url(\''+imgUrl+'\') no-repeat center center;" class="videoImage" id="overlay'+k+'-'+id+'">'
				out += '<div class="overlays"><a href="javascript:;" onClick="VideoPreview.display(\''+k+'-'+id+'\',\''+videoUrl+'\');" class="playbtn">'+VideoPreview.playImage+'</a>'
				out += '</div></div></div>'

				tg.outerHTML = out

				if tagLength is 0
					cb()
				else
					return forEachTag(cb)

			if id % 1 is 0
				#ID es de vimeo
				$.getJSON 'http://vimeo.com/api/v2/video/' + id + '.json', (data)->
					data.videoUrl = 'https://player.vimeo.com/video/'+id+'?autoplay=1'
					continua tag, data, output
			else
				#ID es de youtube
				((cb)->
					cb {
						'thumbnail_large':'http://img.youtube.com/vi/'+id+'/0.jpg'
						'videoUrl':'https://www.youtube.com/embed/'+id+'?autoplay=1'
					}
				) (data)->
					continua tag, data, output
		)
		forEachTag ->
		return

) $ZeroDragon