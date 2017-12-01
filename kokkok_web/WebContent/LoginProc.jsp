<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.*" %>
<%@ page import="com.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
 	/* String url=request.getParameter("url");
	url=url.substring(url.lastIndexOf("/")+1); */
	
 	String pID=request.getParameter("pID");
 	String profile=request.getParameter("profile");
	
 	MemberDatabase md=new MemberDatabase();
 	ImageDatabase id=new ImageDatabase();
 	
 	String nickName="";
 	
 	if(md.isID(pID)){//로그인
 		nickName=(String)(md.getMemberInfo(pID)).get("nickname");
 		String imgUrl=id.getImageURLList("member", nickName).get(0);
 		//프로필 변경됨
 		if(imgUrl.equals(profile)==false)
 			id.updateImage("member", nickName, profile);
 		
 		
 		/* JSONObject jObject=new JSONObject();//전송할 파일
 	 	//JSONArray jArr=new JSONArray();
 	 	
 	 	jObject.put("msg", "succed");
 	 	jObject.put("member_nickname", nickname);
 	 	System.out.println(jObject.toJSONString());
 	 	out.println(jObject.toJSONString()); */
 	 	
 	 	System.out.println(nickName);
 	 	String userInfo=pID+"_"+profile+"_"+nickName;
%>
 	 	<script>
 	 		window.Android.setUserInfo('<%=userInfo%>');
 	 	</script>
 <%
 	 	//세션 변수 저장
 	 	
 	 	session.setAttribute("userNickname", nickName);
 	 	
 	 	
 	 	//response.sendRedirect(url);
 	}else{//처음 로그인
 		//System.out.println("처음….");
 		/* JSONObject jObject=new JSONObject();//전송할 파일
 	 	//JSONArray jArr=new JSONArray();
 	 	
 	 	jObject.put("msg", "fail");
 	 	jObject.put("member_nickname", "");
 	 	out.println(jObject.toJSONString());
 	 	System.out.println(jObject.toJSONString()); */
 	 	
 	 	response.sendRedirect("SignUp.jsp?pID="+pID+"&profile="+profile);
 	}
%>