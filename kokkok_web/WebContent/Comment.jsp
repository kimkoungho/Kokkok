<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String nickName=(String)session.getAttribute("userNickname");
	String kind = request.getParameter("kind");
	String item_id = request.getParameter("item_id");
	String level = request.getParameter("level");
	String parent_item_id = request.getParameter("parent_item_id");
	
	CommentDatabase cmd = new CommentDatabase();
	ImageDatabase id = new ImageDatabase();
	
	ArrayList<HashMap<String, Object>> list = null;
	HashMap<String, Object> parent_item = null;
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	if( level.equals("1") )
		list = cmd.getDB(kind, item_id, Integer.parseInt(level));
	else
	{
		list = cmd.getSubDB(kind, item_id, Integer.parseInt(level) + 1, parent_item_id);
		parent_item = cmd.getParentCommentInfo(parent_item_id);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>댓글</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
	<!-- [if lt IE 9] -->
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<!-- [endif] -->
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="CSS/Comment.css" />
	<!-- <link rel="stylesheet" href="dist/css/dialog_ui.css"> -->
	
	<script type="text/javascript" src="JS/jquery.js"></script>
	<script type="text/javascript" src="JS/Comment.js"></script>
	<!-- <script type="text/javascript" src="dist/js/jquery_dialog.js"></script> -->

</head>

<body>
	<div id="header">
		<div class="exit_btn">X</div>
		댓 글
	</div>
	
	<%
	if( level.equals("1") )	// 게시물에 대한 코멘트
	{
	 %>
	<div class="comment">
        <div class="comment_content">
        <%
		for( int i = 0; i < list.size(); i++ )
        {
		%>
            <div class="comment_item">
                <div class="user_image">
                <%
                	String member_nickname = (String) list.get(i).get("member_nickname");
             		
                	String imageURL = id.getMemberImageURL(member_nickname);
                
                	if( imageURL.contains("kakao") )
                		out.println("<img src='" + id.getMemberImageURL(member_nickname) + "' style='width:100%;'>");
                	else
                		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
                %>
                </div>
                
                <div class="user_text">
                    <span class="user_name"><%=list.get(i).get("member_nickname") %></span>
                    <span class="comment_date"><%=sdf.format(list.get(i).get("date"))%></span>
                    <div class="user_comment"><%=list.get(i).get("content") %></div>
                    <div class="comment_foot" id=<%=list.get(i).get("comment_no")%>> 
                    	<%
                    	if( nickName != null )
                    	{
	                    	if( ((String)list.get(i).get("member_nickname")).equals(nickName) )
	                    	{
                    	%>
 						<span class="foot_text_modify"> 수정 </span>
   						<span class="foot_text_delete"> 삭제 </span>
   						<span class="foot_text_reply"> 댓글달기 </span>
   						<%
	                    	}
	                    	else
	                    	{
                   		%>
                   		<span class="foot_text_reply" style="display: inline-block; width: 100%;"> 댓글달기 </span>
                   		<%
	                    	}
                    	}
                    	else
                    	{
                   		%>
                   		<span class="foot_text_reply" style="display: inline-block; width: 100%;"> 댓글달기 </span>
	                 	<%
                    	}
	                	 %>
  						<div class="sub_comment">
  							<div class="sub_list">
  							<%
  							ArrayList<HashMap<String, Object>> subList = cmd.getSubDB(kind, item_id, Integer.parseInt(level) + 1, (String)list.get(i).get("comment_no"));
  							
  							for( int j = 0; j < subList.size(); j++ )
  							{
  							%>
  								<div class="sub_comment_item">
					                <div class="sub_user_image">
					                <%
				                	member_nickname = (String) subList.get(j).get("member_nickname");
				                
					                imageURL = id.getMemberImageURL(member_nickname);
					                
				                	if( imageURL.contains("kakao") )
				                		out.println("<img src='" + id.getMemberImageURL(member_nickname) + "' style='width:100%;'>");
				                	else
				                		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
					                %>
					                </div>
					                
					                <div class="sub_user_text">
					                    <span class="sub_user_name"><%=subList.get(j).get("member_nickname") %></span>
					                    <span class="sub_comment_date"><%=sdf.format(subList.get(j).get("date"))%></span>
					                    <div class="sub_user_comment"><%=subList.get(j).get("content") %></div>
					                    <div class="sub_comment_foot" id=<%=subList.get(j).get("comment_no")%>> 
					                    	<%
					                    	if( nickName != null )
					                    	{
						                    	if( ((String)subList.get(j).get("member_nickname")).equals(nickName) )
						                    	{
					                    	%>
					 						<span class="sub_foot_text_modify"> 수정 </span>
					   						<span class="sub_foot_text_delete"> 삭제 </span>
					   						<%
						                    	}
					                    	}
					                    	%>
					  						<span class="sub_foot_text_reply"> 댓글달기 </span>
					  					</div>
			  						</div>
		  						</div>		
	  						<%
  							}
	  						%>
  							</div>
  							
  							<form action="CommentProc.jsp?type=new&kind=<%=kind%>&item_id=<%=item_id%>&level=<%=(Integer.parseInt(level) + 1)%>&parent_item_id=<%=list.get(i).get("comment_no")%>" method="post">
  								<textarea name="content" rows=2 placeholder="내용을 입력해주세요."></textarea>
							</form>
							
							<span class="reply_btn">전송</span>
  						</div>
					</div>
                </div>
            </div>
		<%
		}
		%>
        </div>
	</div>
	<%
	}
	else		// 코멘트의 코멘트
	{
	%>
	<div class="comment">
        <div class="comment_content">
            <div class="comment_item">
                <div class="user_image">
                <%
               	String member_nickname = (String) parent_item.get("member_nickname");
               
                String imageURL = id.getMemberImageURL(member_nickname);
                
            	if( imageURL.contains("kakao") )
               		out.println("<img src='" + id.getMemberImageURL(member_nickname) + "' style='width:100%;'>");
               	else
               		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
                %>
                </div>
                
                <div class="user_text">
                    <span class="user_name"><%=parent_item.get("member_nickname") %></span>
                    <span class="comment_date"><%=sdf.format(parent_item.get("date"))%></span>
                    <div class="user_comment"><%=parent_item.get("content") %></div>
                    <div class="comment_foot" id=<%=parent_item.get("comment_no")%>> 
                    	<%
                    	if( nickName != null )
                    	{
	                    	if( ((String)parent_item.get("member_nickname")).equals(nickName) )
	                    	{
                    	%>
 						<span class="foot_text_modify"> 수정 </span>
   						<span class="foot_text_delete"> 삭제 </span>
   						<%
	                    	}
                    	}
   						%>
   						
  						<div class="sub_comment">
  							<div class="sub_list">
  							<%
  							for( int i = 0; i < list.size(); i++ )
  							{
  							%>
  								<div class="sub_comment_item">
					                <div class="sub_user_image">
					               <%
					               	member_nickname = (String) list.get(i).get("member_nickname");
					               
					               imageURL = id.getMemberImageURL(member_nickname);
					                
				                	if( imageURL.contains("kakao") )
					               		out.println("<img src='" + id.getMemberImageURL(member_nickname) + "' style='width:100%;'>");
					               	else
					               		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
					                %>
					                </div>
					                
					                <div class="sub_user_text">
					                    <span class="sub_user_name"><%=list.get(i).get("member_nickname") %></span>
					                    <span class="sub_comment_date"><%=sdf.format(list.get(i).get("date"))%></span>
					                    <div class="sub_user_comment"><%=list.get(i).get("content") %></div>
					                    <div class="sub_comment_foot" id=<%=list.get(i).get("comment_no")%>> 
					                    	<%
					                    	if( nickName != null )
					                    	{
						                    	if( ((String)list.get(i).get("member_nickname")).equals(nickName) )
						                    	{
					                    	%>
					 						<span class="sub_foot_text_modify"> 수정 </span>
					   						<span class="sub_foot_text_delete"> 삭제 </span>
					   						<%
						                    	}
					                    	}
					   						%>
					  					</div>
			  						</div>
		  						</div>	
  							</div>
  							<%
							}
							%>
  						</div>
					</div>
                </div>
            </div>
		
        </div>
	</div>
	<%
	}
	%>
	
	<div id="input_content">
		<%
		if( level.equals("1") )
		{
		%>
		<form name="inputForm" action="CommentProc.jsp?type=new&kind=<%=kind%>&item_id=<%=item_id%>&level=<%=level%>" method="post">
		<%
		}
		else
		{
		%>
		<form name="inputForm" action="CommentProc.jsp?type=new&kind=<%=kind%>&item_id=<%=item_id%>&level=<%=Integer.parseInt(level) + 1%>&parent_item_id=<%=parent_item.get("comment_no")%>" method="post">
		<%
		}
		%>
			<textarea rows="1" cols="50" name="content" placeholder="댓글달기..." class="input_text" required></textarea>
			<!-- <input type="text" name="content" placeholder="댓글달기..." class="input_text" autofocus required multiple> -->
			<input type="button" value="전송" onclick="writeComment();" class="input_btn">
		</form>
	</div>

    <script>

   	 	$(window).load(function() {
   	 		
   	 		$(".user_image img").css("height", $(".user_image img").width());
   	 		$(".sub_user_image img").css("height", $(".sub_user_image img").width());
   	 		
   	 		if( <%=level.equals("1")%> )
	 			$(".sub_comment").hide();
   	 	
   	 		kind = '<%=kind%>';
   	 		item_id = '<%=item_id%>';
   			level = <%=level%>;
   			parent_item_id = '<%=parent_item_id%>';
   			
   			if( <%=nickName != null %> )
   				nickName = '<%=nickName%>';
   	 		
    		$("#header").css("height", $(window).innerWidth() * 0.1);
    		
    		var commentHeight = 0;
    		
    		for( var i = 0; i < <%=list.size()%>; i++ )
    			commentHeight += $('.comment_item').eq(i).outerHeight(true);
    		
    		$(".comment").css("top", $("#header").outerHeight(true));
    		
    		$("#input_content").css("height", $(window).innerWidth() * 0.08);
    		$("#input_content").css("top", $(window).innerHeight() - $("#input_content").outerHeight(true));
    		
    		if( <%=nickName == null%> )
   			{
    			$(".input_text").attr("placeholder", "로그인을 해주세요...");
    			$(".input_text").attr("readonly", true);
   				$(".input_btn").attr("disabled", "disabled");
   				$(".input_btn").css("background-color", "gray");
   			}
    		
    	});
   	 	
   		// resize가 최종완료되기전까지 resize 이벤트를 무시(최대화의 경우 resize가 계속발생하는 것을 방지)
		$(window).resize(function() {		
			if( this.resizeTO )
		        clearTimeout(this.resizeTO);

		    this.resizeTO = setTimeout(function() {
		        $(this).trigger('resizeEnd');
		    }, 0);
		});
		// resize가 최종완료된 후 실행되는 callback 함수
		$(window).on('resizeEnd', function() {
			$("#header").css("height", $(window).innerWidth() * 0.08);
			$(".user_image img").css("height", $(".user_image img").width());
			$(".sub_user_image img").css("height", $(".sub_user_image img").width());
    		
    		var commentHeight = 0;
    		
    		for( var i = 0; i < <%=list.size()%>; i++ )
    			commentHeight += $('.comment_item').eq(i).outerHeight(true);
    		
    		$(".comment").css("top", $("#header").outerHeight(true));
    		
    		$(this).attr('rows', 1);
    		$("#input_content").css("height", $(window).innerWidth() * 0.08);
    		$("#input_content").css("top", $(window).innerHeight() - $("#input_content").outerHeight(true));
    		
    		if( $(".input_text").is(":focus") )
    		{
    			$(this).attr('rows', 3);
    			$("#input_content").css("top", $(window).height() - $("#input_content").outerHeight(true) * 3);
    	   		$("#input_content").css("height", $(window).innerWidth() * 0.24);
    		}
		});
		
		$('.input_text').focus(function() {
			if( <%=nickName%> != null )
			{
				$(this).attr('rows', 3);
	   	 		$("#input_content").css("top", $(window).height() - $("#input_content").outerHeight(true) * 3);
	   			$("#input_content").css("height", $(window).innerWidth() * 0.24);
			}
	   	}).blur(function() {
	   	    $(this).attr('rows', 1);
	   		$("#input_content").css("height", $(window).innerWidth() * 0.08);
 			$("#input_content").css("top", $(window).innerHeight() - $("#input_content").outerHeight(true));
   	 	});
   	 	
    </script>
</body>
</html>