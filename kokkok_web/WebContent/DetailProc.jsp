<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String nickName=(String)session.getAttribute("userNickname");
	String ref = request.getParameter("ref");
	String type = request.getParameter("type");
	String kind = request.getParameter("kind");
	String item_id = request.getParameter("item_id");
	
	RecommendDatabase rd = new RecommendDatabase();
	MyItemDatabase mid = new MyItemDatabase();
	
	if( type.equals("recommend") )
		rd.insertRecommend(nickName, kind, item_id);
	else if( type.equals("scrap") )
		mid.writeMyItem(nickName, kind, item_id);
%>

<script>
	var temp_item_id;
	
	if( <%=ref.equals("SiteDetail")%> )
		temp_item_id = 'area_no';
	else if( <%=ref.equals("RestaurantDetail")%> )
		temp_item_id = 'rst_no';
	else if( <%=ref.equals("AccommodationDetail")%> )
		temp_item_id = 'acc_no';
	else if( <%=ref.equals("ShoppingDetail")%> )
		temp_item_id = 'shop_no';
	else if( <%=ref.equals("CourseDetail")%> )
		temp_item_id = 'course_no';
	else if( <%=ref.equals("ReviewDetail")%> )
		temp_item_id = 'review_no';
		
	javascript:location.replace('<%=ref%>.jsp?kind=<%=kind%>&' + temp_item_id + '=<%=item_id%>');
</script>
