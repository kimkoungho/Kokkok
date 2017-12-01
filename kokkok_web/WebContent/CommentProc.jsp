<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String nickName=(String)session.getAttribute("userNickname");
	String type = request.getParameter("type");
	String comment_no = request.getParameter("comment_no");
	String kind = request.getParameter("kind");
	String item_id = request.getParameter("item_id");
	String level = request.getParameter("level");
	String content = request.getParameter("content");
	String parent_item_id = null;
	
	CommentDatabase cmd = new CommentDatabase();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
	Date today = new Date();
	
	if( !type.equals("delete") )
	{
		content = content.replaceAll("\r\n", "<br>");
		content = content.replaceAll("\n", "<br>");
	}
	
	if( type.equals("new") )
	{
		if( !level.equals("1") )
			parent_item_id = request.getParameter("parent_item_id");
		
		cmd.insertCommentInfo(nickName, kind, item_id, Integer.parseInt(level), parent_item_id, sdf.format(today), content);
	}
	else if( type.equals("modify") )
		cmd.updateCommentInfo(comment_no, content);
	else if( type.equals("delete") )
		cmd.deleteCommentInfo(comment_no);
	
	int temp = Integer.parseInt(level);
	
	if( temp > 1 )
		level = Integer.toString(temp - 1);
%>

<script>
	javascript:location.replace('Comment.jsp?kind=<%=kind%>&item_id=<%=item_id%>&level=<%=level%>&parent_item_id=<%=parent_item_id%>');
</script>
