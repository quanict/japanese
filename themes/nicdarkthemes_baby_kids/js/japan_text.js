/**
 *
 */

jQuery(document).ready(function() {
	var audio = new Audio();

	jQuery('.mp3').click(function(){
		audio.src = jQuery(this).attr('src')
		audio.play();
	});

	jQuery('.listen').click(function(){
		
		if( jQuery(this).attr('code').length > 0 ){
			$code = jQuery(this).attr('code');
		} else {
			$code = jQuery(this).parent('.character').find('.r').attr('code');	
		}
		
		audio.src = '//'+window.location.hostname+'/sound/syllabary/'+$code+'.mp3';
		console.log(audio.src);
		audio.play();
	});

	jQuery('.write').click(function(){
		$code = jQuery(this).parent('.character').find('.r').attr('code');
		window.location.href = '//'+window.location.hostname+'/syllabary/draw/'+$code;
	});

	

	var $draw = jQuery('.japandraw');
	if( $draw.length > 0 ){
		jQuery( ".writing" ).each(function( index ) {
			var code = jQuery(this).attr('code');
			var romaji = jQuery(this).attr('romaji');
			var dmak_id = jQuery(this).attr('id');
			var group = jQuery(this).attr('group');
			jQuery.ajax({ 
			    type: 'GET', 
			    url: '/api/character/', 
			    data: { 'romaji': romaji ,'type':group}, 
			    dataType: 'json',
			    success: function (data) {
			    	if( data.hasOwnProperty('character') && data.hasOwnProperty('type') ){
			    		drawjp(data.character,data.code,data.type,dmak_id);
			    	}
			    }
			});
			
			
	  
		});
		
	}
});

drawjp = function(char,code,group,dmak_id ){
	var audio = new Audio();
	audio.src = '//'+window.location.hostname+'/sound/syllabary/'+code+'.mp3';
	audio.play();

	var dmak = new Dmak(char, {'element': dmak_id, "uri": '//'+window.location.hostname+'/svg/'+group+'/'});
	var $draw = jQuery('.japandraw');
	$draw.find('a.play').click(function(){
		dmak.render();
	});
	$draw.find('a.stop').click(function(){
		dmak.pause();
	});

	$draw.find('a.pre').click(function(){
		dmak.eraseLastStrokes();
	});
	$draw.find('a.next').click(function(){
		dmak.renderNextStrokes();
	});

}
