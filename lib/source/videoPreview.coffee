$ZeroDragon = $.noConflict()
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

(($)->
	$ ->
		(VideoPreview[k] = v for k, v of videoPreview) if videoPreview
		VideoPreview.color = VideoPreview.paletes[VideoPreview.palete]
		VideoPreview.playImage = '<svg width="92" height="92" xmlns="http://www.w3.org/2000/svg"><g><title>Play</title><rect opacity="0.9" ry="24" rx="24" id="svg_1" height="87" width="87" y="2.5" x="2.5" stroke-width="5" stroke="#ffffff" fill="'+VideoPreview.color.boxBG+'"/><path id="svg_3" d="m33.84636,74.58079l8.22989,-29.31224l-8.2299,-26.57616l27.94421,27.9442l-27.94419,27.94419z" stroke-linecap="null" stroke-linejoin="null" stroke-width="0" stroke="#ffffff" fill="'+VideoPreview.color.arrowBG+'"/></g></svg>'
		VideoPreview.playImage = '<img src="'+VideoPreview.play+'"/>' if VideoPreview.play?
		VideoPreview.display = (id,url)->
			$('#overlay'+id).replaceWith '<iframe src="'+url+'" width="'+VideoPreview.width+'" height="'+VideoPreview.height+'" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
			$('#holder'+id).removeClass 'holderStyle'
			return

		$('head').append('<style>
			.videoHolder{
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
			}

		</style>')
		$(document).ready ->
			$('vp').each (k,e)->				#Extraemos el ID
				url = $(e).attr('url').replace(/\/$/,'')
				if url.search("=") isnt -1
					id = url.split('=').pop()
				else if url.search("youtu.be/") isnt -1
					id = url.split("youtu.be/").pop()
				else
					id = url.split('/').pop()
				output = '<div class="videoHolder holderStyle" id="holder'+k+'-'+id+'">'

				if id % 1 is 0
					#ID es de vimeo
					videoUrl = 'https://player.vimeo.com/video/'+id+'?autoplay=1'
					imgUrlPromise = $.when($.getJSON('http://vimeo.com/api/v2/video/' + id + '.json?callback=?'))

				else
					#ID es de youtube
					videoUrl = 'https://www.youtube.com/embed/'+id+'?autoplay=1'
					imgUrlPromise = $.when([{'thumbnail_large':'http://img.youtube.com/vi/'+id+'/0.jpg'}])

				imgUrlPromise.then (data)->
					imgUrl = data[0].thumbnail_large
					output += '<div style="background:url(\''+imgUrl+'\') no-repeat center center;" class="videoImage" id="overlay'+k+'-'+id+'">'
					output += '<div class="overlays"><a href="javascript:;" onClick="VideoPreview.display(\''+k+'-'+id+'\',\''+videoUrl+'\');" class="playbtn">'+VideoPreview.playImage+'</a>'
					output += '</div></div></div>'
					$(e).replaceWith output
) $ZeroDragon