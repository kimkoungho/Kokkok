<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String nickName=(String)session.getAttribute("userNickname");
	String kind=request.getParameter("kind");
	String item_id=request.getParameter("item_id");

	//복귀할 문서
	String url = request.getParameter("url");
	
	MyItemDatabase mtd=new MyItemDatabase();
	mtd.writeMyItem(nickName, kind, item_id);
	
	response.sendRedirect(url);
%>