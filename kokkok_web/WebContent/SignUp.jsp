<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="ErrorPage.jsp" %>	
	
<%
	//String url=request.getParameter("url");
	String pID=request.getParameter("pID");
	String profile=request.getParameter("profile");
	
	//System.out.println(url+"…"+pID+"…."+profile);
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta charset="UTF-8">

	<link rel="stylesheet" href="CSS/SignUp.css" />
	<script type="text/javascript" src="JS/jquery.js"></script>
	
	<title></title>
</head>
<body>
	<div id="background" style="background-image: url('IMAGES/name_background.jpg');">
		<img src="IMAGES/name_background_opacity.png" width="100%" height="100%" />
		<div class="login">
			<div class="login_title">닉네임 설정</div>
			<div class="login_notice">
				사용할 닉네임을 설정해주세요.<br /> <span class="sub_notice">(10자 이내 제한)</span>
			</div>
			<input type="text" class="login_input" placeholder="닉네임을 작성해주세요" maxlength="10"/>
			<div class="set_button">설정</div>
			<!--  <div class="cancel_button">취소</div> -->
		</div>
	</div>
	
	<script>
		$('.set_button').click(function(){
			//alert($('.input').children('div').children('.nick_input').val());
			var nickName=$('.login_input').val();
			
			//alert(nickname);
			if(nickName.trim()=='' || nickName==null){
				alert('값을 입력하세요.');
			}else{
				var url="SignUpProc.jsp?pID="+'<%=pID%>'+"&profile="+'<%=profile%>'+"&nickName="+nickName;
				
				//alert(url);
				//window.android.setNickname(nickname);
				
				location.href=url;
			}
		});
	</script>
</body>
</html>