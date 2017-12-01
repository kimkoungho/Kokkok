<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	nickName = "kani";
	
	RecommendDatabase rd = new RecommendDatabase();
	ReviewDatabase rvd = new ReviewDatabase();
	CourseDatabase cd = new CourseDatabase();
	ImageDatabase id = new ImageDatabase();
	CommentDatabase cmd = new CommentDatabase();
	
	ArrayList<HashMap<String, Object>> course_list = cd.getMyCourseInfo(nickName);
	ArrayList<HashMap<String, Object>> review_list = rvd.getMyReviewInfo(nickName);
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	
	<!-- 반응형 임포트 -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
	<!-- [if lt IE 9] -->
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<!-- [endif] -->
	<!-- 동수 꺼-->
	<link href="lib/jquery.bxslider.css" rel="stylesheet" />
	<link rel="stylesheet" href="CSS/MyPage.css" />
	<!-- Link Swiper's CSS -->
	<link rel="stylesheet" href="dist/css/swiper.min.css">
	
	<title> 마이페이지 </title>
	<!--여기 있어야 실행됨 반응형 -->
	<script src="JS/jquery.js"></script>
	<script src="JS/jquery.masonry.min.js"></script>
	<script src="JS/MyPage.js" type="text/javascript"></script>
	<!-- <script src="JS/jquery.longclick-min.js"></script> -->
	 
</head>

<body>
	<div class="header">
		<div class="my_pic">
			<div class="temp">&nbsp;</div>
                   <%
                String imageURL = id.getMemberImageURL(nickName);
                
            	if( imageURL.contains("kakao") )
               		out.println("<img src='" + imageURL + "'>");
               	else
               		out.println("<img src='IMAGES/user_icon.svg'>");
            	%>
            
            <div class="temp">&nbsp;</div>
		</div>
		
		<div class="logo_name">	
			<%=nickName%>
		</div>

	</div>
	<div class="nav">
		<div class="menu1">내가 만든 코스</div>
		<div class="menu2">내가 쓴 여행기</div>

	</div>
	<div class="my_contents">
		<div class="my_course_wrap">
			<div class="lnb">
				<div class="num"> 총 <%=course_list.size()%>건 </div>
				<div class="write_review">
					<img src="IMAGES/add.png" style="width: 10%;" /> 나의 코스 만들기
				</div>
			</div>

			<%
				for (int i = 0; i < course_list.size(); i++)
				{
					HashMap<String, Object> map = cd.getCourseInfo((String) course_list.get(i).get("course_no"));
							
					String[] dateRouteList = ((String) map.get("route")).split("-");
					String startPosition = null;
					String endPosition = null;
					
					for (int j = 0; j < dateRouteList.length; j++)
					{
						String[] routeList = dateRouteList[j].split(",");
						
						for (int k = 0; k < routeList.length; k++)
						{
							if (j == 0)
							{
								startPosition = routeList[0].split("_")[0];
								map.put("image", id.getImageURLList("area", routeList[0]).get(0));
							}
							if (j == dateRouteList.length - 1)
								endPosition = routeList[routeList.length - 1].split("_")[0];
						}
					}
					map.put("recommendCount", rd.getRecommendCount("course", (String) course_list.get(i).get("course_no")));
					
			%>
			<div class="cont_ele" id=<%=course_list.get(i).get("course_no")%>>
				<!-- <div class="course_delete_btn" > 삭제하기</div> -->
				<div class="course_item" style="background-image: url(<%=map.get("image")%>);">
					<div class="course_site">
						<img src="IMAGES/location2.svg" style="float: left; width: 15%; margin-top: 3%; margin-left: 4%;" />
						<%=startPosition%> ~ <%=endPosition%>
					</div>
					
					<div class="course_trash">
                  		<img src="IMAGES/trash.svg" style="float:right; width: 80%; margin-top: 3%;"/>
               		</div>

					<div class="course_name"><%=course_list.get(i).get("name")%></div>
					
					<div class="course_isBasic">
					<%
						if( ((String)map.get("isBasic")).equals("true") )
							out.println("한국 관광 공사 추천");
						else
							out.println("사용자 추천");
					%>
					</div>
				</div>
			</div>

			<%
				}
			%>
		</div>

		<div class="my_review_wrap">
			<div class="lnb">
				<div class="num">
					총 <%=review_list.size()%>건
				</div>
				<div class="write_review1">
					<img src="IMAGES/add.png" style="width: 10%;" /> 후기 작성하기
				</div>
			</div>

			<%
				for (int i = 0; i < review_list.size(); i++)
				{
					HashMap<String, Object> map = review_list.get(i);
					map.put("recommendCount", rd.getRecommendCount("review", (String) map.get("review_no")));
					map.put("commentCount", cmd.getCommentCount("review", (String) map.get("review_no")));
			%>
			<div class="box" id=<%=map.get("review_no")%>>
				<!-- <div class="review_delete_btn" > 삭제하기 </div> -->
				<div class="box_header">
					<span class="member"> 
						<%=nickName%>님의 여행기 
						<font color="#d0d0d0">
							<b>|</b>
						</font>
					</span>
					
					<span class="box_icon">
						<span class="icon_img"> <img	 src="IMAGES/like.svg" class="recommend_icon" style="width: 11%" /> </span>
						<span class="icon_text"><%=map.get("recommendCount")%></span>
						<span class="icon_img"> <img src="IMAGES/reply.svg" class="myitem_icon" style="width: 11%" /></span>
						<span class="icon_text"><%=map.get("commentCount")%></span>
					</span>
				</div>
				
				<div class="area_content" style="background-image:url('<%=map.get("default_image")%>')">
               		<img src="IMAGES/transparency4.png" width="100% /">
               			 <div class="review_trash">
                  		<img src="IMAGES/trash.svg" style="float:right; width: 80%; margin-top: 3%; "/>
               		</div>
               
               		<div class="area_item">
                  		<span class="area_item_title"><%=map.get("review_name")%></span>
                  		<span class="area_item_member"> | <%=nickName%></span>
               		</div>
            	</div>
			</div>
			<%
				}
			%>
		</div>
	</div>

	<script>
		$(document).ready( function() {
			$(".my_pic").css("height", $(window).innerWidth() / 3);
		});
	
		/* $(window).load(function() {
			$(".my_pic").css("height", $(window).innerWidth() / 3);
		}); */
		
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
			$(".my_pic").css("height", $(window).innerWidth() / 3);
		});
    
	</script>

</body>

</html>