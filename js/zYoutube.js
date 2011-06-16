$(document).ready(function(){
	/* CONFIGURACION */

	//tamaño del player a desplegar (width,height)
	var player = new Array(650,350);

	//icono opcional sobre el preview (top,left,url,link)
	//si no especificas url, no se crea el icono ni el link, si no especificas link, no se crea el link
	var icon = new Array(230,535,"img/icon.png","http://www.zerothedragon.com");

	//icono alternativo opcional que se pone en el mouseover del play (top,left,url)
	//si no especificas url, no se crea la funcion
	var iconalt =new Array(179,454,"img/iconalt.png");
	
	//boton de play para el preview (top,left,url)
	var play = new Array(107,265,"img/play.png");

	/* 	TERMINA CONFIGURACION */
	$('body').append('<style>.elplay{cursor: pointer;}.elplay:hover{opacity:0.4;filter:alpha(opacity=40);}.video img{background: 0 !important;border: 0 !important;padding: 0 !important;border-radius: 0 !important;-moz-border-radius: 0 !important;-webkit-border-radius: 0 !important;}</style>');	
	$(".video").each(function(){
		url="";
		esvimeo = $(this).attr("elvideo").search(/vimeo/i);
		$(this).attr('style','border: 0px solid black; width:'+player[0]+'px; height:'+player[1]+'px; position:relative; overflow:hidden;');
		$(this).append('<img width="'+player[0]+'" height="'+player[1]+'" border="0" style="position:absolute; top:0px; left:0px;" />');
		if (esvimeo == -1){
			urrl = $(this).attr("elvideo").match("[\\?&]v=([^&#]*)");
			url = "http://img.youtube.com/vi/"+urrl[1]+"/0.jpg";
			$(this).append('<div class="elplay" id="'+urrl[1]+'" tipo="youtube" style="position:absolute; top:'+play[0]+'px; left:'+play[1]+'px;"><img src="'+play[2]+'" border="0" /></div>');
			$(this).find('img:first').attr('src',url);
		}else{
			id = ($(this).attr("elvideo").split("/")).pop();
			that = $(this);
			$.getJSON("js/json.php?id="+id,function(data){
				url = data[0].thumbnail_large;
				$(that).find('img:first').attr('src',url);
			});
			$(this).append('<div class="elplay" id="'+id+'" tipo="vimeo" style="position:absolute; top:'+play[0]+'px; left:'+play[1]+'px;"><img src="'+play[2]+'" border="0" /></div>');
		}
		$(this).append(icono(icon));
	});
	
	$(".elplay").click(function(){
		id = $(this).attr('id');
		if($(this).attr('tipo')=='vimeo'){
			embed = "<iframe style='position:absolute; top:0px; left:0px;' src='http://player.vimeo.com/video/"+id+"?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1' width='"+player[0]+"' height='"+player[1]+"' frameborder='0'></iframe>";
		}else{
			embed = "<iframe style='position:absolute; top:0px; left:0px;' width='"+player[0]+"' height='"+player[1]+"' src='http://www.youtube.com/embed/"+id+"?rel=0&autoplay=1' frameborder='0' allowfullscreen></iframe>";
		}
		$(this).parent().html(embed);
	});

	// Aqui esta la parte donde cambia el icono por uno alternativo cuando el mouseover en el play
	$(".elplay").hover(
		function(){
			if(iconalt[2]!=''){
				$(this).parent().find('#icono').attr('src',iconalt[2]);
				$(this).parent().find('#icono2').attr('style','position: absolute; top:'+iconalt[0]+'px; left:'+iconalt[1]+'px;');
			}
		},
		function(){
			if(iconalt[2]!=''){
				$(this).parent().find('#icono').attr('src',icon[2]);
				$(this).parent().find('#icono2').attr('style','position: absolute; top:'+icon[0]+'px; left:'+icon[1]+'px;');
			}
		}
	);
	//termina el hover especial

});
function icono(icon){
	if(icon){
		link = '<img id="icono" src="'+icon[2]+'" border="0" />';
		link = (icon[3] !='') ? '<a href="'+icon[3]+'" target="_blank">'+link+'</a>' : link;
		return '<div id="icono2" style="position:absolute; top:'+icon[0]+'px; left:'+icon[1]+'px;">'+link+'</div>';
	}
}