<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String item_id = request.getParameter("item_id");
	double latitude = 0;
	double longitude = 0;
	double distance = Double.parseDouble(request.getParameter("distance"));
	String type = request.getParameter("type");	
	String passList = request.getParameter("passList");
	
	AroundDatabase ard = new AroundDatabase();
	String data = null;
	
	if( type == null )
	{
		latitude = Double.parseDouble(request.getParameter("latitude"));
		longitude = Double.parseDouble(request.getParameter("longitude"));
		data = ard.getAround(item_id, latitude, longitude, distance);
	}
	else if( type.equals("course") )
		data = ard.getCourseAround(passList, distance);

	out.print(data);
%>