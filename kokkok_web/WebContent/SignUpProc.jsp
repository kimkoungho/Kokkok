<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Database.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	//String url=request.getParameter("url");
	String pID=request.getParameter("pID");
	String profile=request.getParameter("profile");
	String nickName=request.getParameter("nickName");
	
	System.out.println(pID+"....."+profile+"....."+nickName);
	
	MemberDatabase md=new MemberDatabase();
	ImageDatabase id=new ImageDatabase();
	
	if(md.getMemeber(nickName)>0){//닉네임 중복
%>
		<script>
			alert('닉네임이 중복됨니다.');
			history.back();
		</script>
<%
	}else{
	
	md.insertMember(pID, nickName);
	id.insertImage("member",nickName, profile);
	
// JSONObject jObject=new JSONObject();//전송할 파일
	 	//JSONArray jArr=new JSONArray();
	 	
	/* jObject.put("msg", "succed");
	jObject.put("member_nickname", nickname);
	System.out.println(jObject.toJSONString());
	out.println(jObject.toJSONString()); */
	
	 //세션 변수 저장

 	session.setAttribute("userNickname", nickName);
 	
	
 	String userInfo=pID+"_"+profile+"_"+nickName;
%>
 	<script>
		window.Android.setUserInfo('<%=userInfo%>');
	</script>
<%
 	
	}
 	//out.println(jObject);
	//response.sendRedirect(url);
%>