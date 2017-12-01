$(document).ready(function() {
	$('.menu2').on('click', function() {

		if ($(this).hasClass("on")) {
			$(this).css('background-color', '#ffffff');
			$('.main2').slideToggle();
			$(this).removeClass("on");
		} else {
			$('.main2').slideToggle();
			$(this).css('background-color', '#cccccc');
			$(this).addClass("on");
		}
	});
	
	
	$('.chk').change(function(){
		var id=$(this).attr('id');
		
		var parent=$(this).parent('.ckbox').next();
		if($(this).is(':checked')){
			parent.removeAttr("disabled");
		}else{
			parent.attr("disabled",true);
		}
	});
	
	$('.change').click(function(){
		$('.main2').slideToggle();
	});
	
	$('.search_btn').click(function(){
		var area=$('.menu2_text').val();
		var content=$('#search_content').val();
		var tag=$('#search_tag').val();
		
		var url="ReviewList.jsp?area="+area+"&content="+content+"&tag="+tag;
		location.href=url;
	});
});