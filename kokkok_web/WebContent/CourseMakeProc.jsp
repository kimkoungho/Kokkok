<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	CourseDatabase cd = new CourseDatabase();
	
	String nickName=(String)session.getAttribute("userNickname");
	String course_no;
	String course_route = request.getParameter("course_route");
	String course_name = request.getParameter("course_name");

	String isBasic="false";
	
	// System.out.println(course_route+".."+course_name+".."+nickname);
	out.println(course_route);
	course_no=course_route.split(",")[0];
	course_no=course_no.substring(0,2)+"_";
	
	int cnt=cd.getCourseCount(course_no);
	
	for( int i = 0; i < 7 - (cnt / 10 + 1); i++ )
		course_no += '0';
	
	course_no += cnt;
	// System.out.println(course_no);
	
	cd.insertCourse(course_no, course_name, course_route, isBasic, nickName);
	
	try
	{
		Thread.sleep(1000);
	}
	catch(Exception e)
	{
		
	}
	response.sendRedirect("CourseDetail.jsp?course_no="+course_no);
%>