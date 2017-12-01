	
$(document).ready(function() {
	
	$(".box_site").click(function() {
		var item_id = $(this).attr("id").split("-")[1];
		var kind =$(this).attr("id").split("-")[0];
		
		var url;
		
		if( kind == 'area' )
			url = "SiteDetail.jsp?area_no=" + item_id;
		else if( kind == 'restaurant' )
			url = "RestaurantDetail.jsp?rst_no=" + item_id;
		else if( kind == 'accommodation' )
			url = "AccommodationDetail.jsp?acc_no=" + item_id;
		else if( kind == 'shopping' )
			url = "ShoppingDetail.jsp?shop_no=" + item_id;
		
		location.href = url;
	});
	
	$(".course_item").click(function() {
		var item_id = $(this).parent().attr("id").split("-")[1];
		var kind = $(this).parent().attr("id").split("-")[0];
		
		var url = "CourseDetail.jsp?course_no=" + item_id;
		
		location.href = url;
	});
	
	$(".site_trash").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var item_id = $(this).parent().parent().parent().parent().parent().attr("id").split("-")[1];
			var kind = $(this).parent().parent().parent().parent().parent().attr("id").split("-")[0];
			
			var url = "DeleteProc.jsp?item_id=" + item_id + "&kind=" + kind + "&type=myscrap";
			
			location.replace(url);
		}
		return false;
	});
	
	$(".around_trash").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var item_id = $(this).parent().parent().parent().parent().parent().attr("id").split("-")[1];
			var kind = $(this).parent().parent().parent().parent().parent().attr("id").split("-")[0];
			
			var url = "DeleteProc.jsp?item_id=" + item_id + "&kind=" + kind + "&type=myscrap";
			
			location.replace(url);
		}
		
		return false;
	});
	
	$(".course_trash").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var item_id = $(this).parent().parent().attr("id").split("-")[1];
			var kind = $(this).parent().parent().attr("id").split("-")[0];
			
			var url = "DeleteProc.jsp?item_id=" + item_id + "&kind=" + kind + "&type=myscrap";
			
			location.replace(url);
		}
		
		return false;
	});
	
	
	
	
});
	