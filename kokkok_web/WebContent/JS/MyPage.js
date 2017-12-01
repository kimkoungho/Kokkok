$(document).ready(function () {
	
	$(".course_item").click(function() {
		var url = "CourseDetail.jsp?course_no=" + $(this).parent().attr("id");
		location.href = url;
	});
	
	$(".course_trash").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var item_id = $(this).parent().parent().attr("id");
			
			if( item_id == '괴산_0000001' )
			{
				var url = "DeleteProc.jsp?item_id=" + item_id + "&kind=course&type=mypage";
				
				location.href = url;
			}
			else
				alert('삭제 실패');
		}
		return false;
	})
	
	$(".review_trash").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var item_id = $(this).parent().parent().attr("id");
			
			if( item_id == '0000000004' )
			{
				var url = "DeleteProc.jsp?item_id=" + item_id + "&kind=review&type=mypage";
				
				location.href = url;
			}
			else
				alert('삭제 실패');
		}
		
		return false;
	})

	$(".area_content").click(function() {
		var url = "ReviewDetail.jsp?review_no=" + $(this).parent().attr("id");
		location.href = url;
	});

    $(".menu1").click(function () {
       
        $(this).css('background-color', '#2D4B71');
        $(this).css('color','white')
        $(".menu2").css('background-color', '#f0f0f0');
        $(".menu2").css('color', 'black');
        $(".my_course_wrap").show();
        $(".my_review_wrap").hide();
        $(".my_scrap_wrap").hide();
       
    });
    $(".menu2").click(function () {
      
        $(this).css('background-color', '#2D4B71');
        $(this).css('color','white')
        $(".menu1").css('color', 'black');
        $(".menu1").css('background-color', '#f0f0f0');
        $(".my_course_wrap").hide();
        $(".my_review_wrap").show();
        $(".my_scrap_wrap").hide();
      
    });
    
    $(".write_review").click(function(){
    	var type="make";
    	location.href="CourseMain.jsp?tab=3";
    });
    $(".write_review1").click(function(){
    	var type="make";
    	location.href="ReviewMake.jsp";
    });
  
});