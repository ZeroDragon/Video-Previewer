$(document).ready(function(){
	/* CONFIGURACION */

	//tamaño del player a desplegar (width,height)
	var player = new Array(650,350);

	//icono opcional sobre el preview (top,left,url,link)
	//si no especificas url, no se crea el icono ni el link, si no especificas link, no se crea el link
	var icon = new Array(230,535,"img/icon.png","http://www.zerothedragon.com");
	
	//boton de play para el preview (top,left,url)
	var play = new Array(107,265,"img/play.png");

	/* 	TERMINA CONFIGURACION */
	$('body').append('<style>.elplay{cursor: pointer;}.elplay:hover{opacity:0.4;filter:alpha(opacity=40);}.video img{background: 0 !important;border: 0 !important;padding: 0 !important;border-radius: 0 !important;-moz-border-radius: 0 !important;-webkit-border-radius: 0 !important;}</style>');	
	$(".video").each(function(){
		urrl = $(this).attr("elvideo").match("[\\?&]v=([^&#]*)");
		url = "http://img.youtube.com/vi/"+urrl[1]+"/0.jpg";
		$(this).attr('style','border: 0px solid black; width:'+player[0]+'px; height:'+player[1]+'px; position:relative; overflow:hidden;');
		$(this).append('<img src="'+url+'" width="'+player[0]+'" height="'+player[1]+'" border="0" style="position:absolute; top:0px; left:0px;" />');
		$(this).append(icono(icon));
		$(this).append('<div class="elplay" id="'+urrl[1]+'" style="position:absolute; top:'+play[0]+'px; left:'+play[1]+'px;"><img src="'+play[2]+'" border="0" /></div>');
	});
	$(".elplay").click(function(){
		id = $(this).attr('id');
		embed = "<iframe style='z-index:500; position:absolute; top:0px; left:0px;' width='"+player[0]+"' height='"+player[1]+"' src='http://www.youtube.com/embed/"+id+"?rel=0&autoplay=1' frameborder='0' allowfullscreen></iframe>";
		$(this).parent().html(embed);
	});
});
function icono(icon){
	if(icon){
		link = '<img id="icono" src="'+icon[2]+'" border="0" />';
		link = (icon[3] !='') ? '<a href="'+icon[3]+'" target="_blank">'+link+'</a>' : link;
		return '<div style="position:absolute; top:'+icon[0]+'px; left:'+icon[1]+'px;">'+link+'</div>';
	}
}