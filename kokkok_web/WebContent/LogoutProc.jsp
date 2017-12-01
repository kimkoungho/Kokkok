<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page errorPage="ErrorPage.jsp" %>
<%	
	session.removeAttribute("userNickname");
	String url=request.getParameter("url");
	response.sendRedirect(url);
%>