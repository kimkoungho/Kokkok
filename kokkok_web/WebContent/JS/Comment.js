var kind;
var item_id;
var nickName = null;
var level;
var parent_item_id;

function writeComment()
{
	var text = $(".input_text").val();
	
	if( text.trim() != '' )
		$(".input_text").parent().submit();
	else
		alert('내용을 입력하세요.');
}

$(document).ready(function() {
	
	$(".exit_btn").click(function() {
		parent.closeComment();
	});
	
	$(".foot_text_modify").click(function() {
		
		var temp =  $(this).parent().siblings(".user_comment");
		var tempContent = temp.find("form").find("textarea").text();
			
		if( tempContent == '' )
			tempContent = temp.html();
		
		if( temp.html().includes("cancel_btn") )
		{
			if( temp.find("form").find(".tempText").val().trim() == '' )
				alert('내용을 입력하세요.');
			else
			{
				temp.find("form").submit();
				alert('댓글을 수정하였습니다.');
			}
		}
		else
		{
			var comment_no = $(this).parent().attr("id");
			
			temp.empty();
			var str = "";
			
			var url = "CommentProc.jsp?type=modify&comment_no=" + comment_no + "&kind=" + kind + "&item_id=" + item_id + "&level=" + level;
			
			tempContent = tempContent.split("<br>").join("\r\n");
			
			str += "<form action=" + url + " method='post'>";
			str += "<textarea rows=3 class='tempText' placeholder='내용을 입력하세요.' name='content' style='width: 100%;'>" + tempContent + "</textarea>" +
						"<span style='float: right' class='cancel_btn'>취소</span>";
			str += "</form>"
			
			temp.append(str);
			
			$('.cancel_btn').click(function() {
				temp.empty();
				tempContent = tempContent.split("\r\n").join("<br>");
				temp.append(tempContent);
			});
		}
	});
	
	$(".foot_text_delete").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var comment_no = $(this).parent().attr("id");
			var url = "CommentProc.jsp?type=delete&comment_no=" + comment_no + "&kind=" + kind + "&item_id=" + item_id + "&level=" + level;
			location.replace(url);
			alert('삭제되었습니다.');
		}
	});
	
	$(".foot_text_reply").click(function() {
		$(this).siblings(".sub_comment").find("form").find("textarea").val("");
		$(this).siblings(".sub_comment").slideToggle();
		
		if( nickName == null )
		{
			$(this).siblings(".sub_comment").find("form").find("textarea").attr("placeholder", "로그인을 해주세요.");
			$(this).siblings(".sub_comment").find("form").find("textarea").attr("disabled", "disabled");
			$(this).siblings(".sub_comment").find("form").find("textarea").css("background-color", "gray");
		}
	});
	
	$(".reply_btn").click(function() {
		var temp = $(this).siblings("form").find("textarea");
		
		if( !temp.is(":disabled") )
		{
			if( temp.val().trim() != "" )
			{
				$(this).siblings("form").submit();
			}
			else
				alert("내용을 입력해주세요.");
		}
	});
	
	$(".sub_foot_text_modify").click(function() {
		
		var temp =  $(this).parent().siblings(".sub_user_comment");
		var tempContent = temp.find("form").find("textarea").text();
			
		if( tempContent == '' )
			tempContent = temp.html();
		
		if( temp.html().includes("cancel_btn") )
		{
			if( temp.find("form").find(".tempText").val().trim() == '' )
				alert('내용을 입력하세요.');
			else
			{
				temp.find("form").submit();
				alert('댓글을 수정하였습니다.');
			}
		}
		else
		{
			var comment_no = $(this).parent().attr("id");
			
			temp.empty();
			var str = "";
			
			var url = "CommentProc.jsp?type=modify&comment_no=" + comment_no + "&kind=" + kind + "&item_id=" + item_id + "&level=" + level;
			
			tempContent = tempContent.split("<br>").join("\r\n");
			
			str += "<form action=" + url + " method='post'>";
			str += "<textarea rows=3 class='tempText' placeholder='내용을 입력하세요.' name='content' style='width: 100%;'>" + tempContent + "</textarea>" +
						"<span style='float: right' class='cancel_btn'>취소</span>";
			str += "</form>"
			
			temp.append(str);
			
			$('.cancel_btn').click(function() {
				temp.empty();
				tempContent = tempContent.split("\r\n").join("<br>");
				temp.append(tempContent);
			});
		}
	});
	
	$(".sub_foot_text_delete").click(function() {
		if( confirm("삭제하시겠습니까?") == true )
		{
			var comment_no = $(this).parent().attr("id");
			var url = "CommentProc.jsp?type=delete&comment_no=" + comment_no + "&kind=" + kind + "&item_id=" + item_id + "&level=" + level;
			location.replace(url);
			alert('삭제되었습니다.');
		}
	});
	
	$(".sub_foot_text_reply").click(function() {
		
		var parent_item_id = $(this).parent().attr("id");
		
		var url = "Comment.jsp?kind=" + kind + "&item_id=" + item_id +"&level=" + (level + 1) + "&parent_item_id=" + parent_item_id;
		
		location.href = url;
	});
	
	$(".sub_reply_btn").click(function() {
		var temp = $(this).siblings("form").find("textarea");
	
		if( temp.val().trim() != "" )
		{
			$(this).siblings("form").submit();
		}
		else
			alert("내용을 입력해주세요.");
	});
	
});