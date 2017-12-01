<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String nickName=(String)session.getAttribute("userNickname");
	String course_no = request.getParameter("course_no");
	String kind = "course";	
	
	AreaDatabase ad = new AreaDatabase();
	CourseDatabase cd = new CourseDatabase();
	RecommendDatabase rd = new RecommendDatabase();
	ImageDatabase id = new ImageDatabase();
	CommentDatabase cmd=new CommentDatabase();
	MyItemDatabase mid = new MyItemDatabase();

	HashMap<String, Object> map = cd.getCourseInfo(course_no);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	ArrayList<HashMap<String, Object>> comment_list=cmd.getDB(kind, course_no, 1);
	
	String []dateRouteList = ((String)map.get("route")).split("-");
	String startPosition = null;
	String endPosition = null;
	
	boolean isRecommend = rd.isRecommend(nickName, kind, course_no);
	boolean isScrap = mid.isScrap(nickName, kind, course_no);
	
	for( int i = 0; i < dateRouteList.length; i++ )
	{
		String []routeList = dateRouteList[i].split(",");
		
		for( int j = 0; j < routeList.length; j++ )
		{
			if( i == 0 )
				startPosition = routeList[0].split("_")[0];
			if( i == dateRouteList.length - 1 )
				endPosition = routeList[routeList.length - 1].split("_")[0];
		}
	}
	
	map.put("recommendCount", rd.getRecommendCount(kind, course_no));
	map.put("scrapCount", mid.getScrapCount(kind, course_no));
%>

<!doctype html>

<html>
<head>
	<meta charset="utf-8">
	<title>코스 정보보기</title>
	<!-- 반응형 임포트 -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
	<!-- [if lt IE 9] -->
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<!-- [endif] -->
	
	
	<script src="https://apis.skplanetx.com/tmap/js?version=1&format=xml&appKey=e10a67d6-add9-31f0-a944-933fcb536922"></script>
	
	<script src="JS/jquery.js"></script>
	<script src="JS/jquery.masonry.min.js"></script>
	<script type="text/javascript" src="JS/CourseDetail.js"></script>
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="CSS/CourseDetail.css">
</head>

<body>

	<div id="container">
	
		<div id="title"> 
			<span class="course_name"><%=map.get("name")%></span>
			<span class="course_group"> | 
			<%
			if( ((String)map.get("isBasic")).equals("true") )
				out.println("추천 코스");
			else
				out.println("사용자 추천");
			%> 
			</span>
		</div>
		
		<div class="line_style1"></div>
			
		<div id="state_bar">
			<span class="state_icon">
				<img src="IMAGES/scrap.svg" class="icon_image" />
				 <span class="icon_text"><%=map.get("scrapCount")%></span>
			</span>
			<span class="state_icon">
				<img src="IMAGES/like.svg" class="icon_image" />
				<span class="icon_text"><%=map.get("recommendCount")%> </span>
			</span>
		</div>
		
		<div id="description">
			<div class="description_title">방문지역 </div>
			<div class="description_text"> <%=startPosition%> ~ <%=endPosition%> </div>
			<div class="description_title">여행일정</div>
			<div class="description_text"> <%=dateRouteList.length%> 일 </div>
		</div>

		<div class="line_style2"></div>
	
		<div id="icon_bar">
    	    <div class="icon"><img src="IMAGES/like.svg" class="icon_image2"/><div>추천해요!</div></div>
   	    	<div class="icon"><img src="IMAGES/scrap.svg" class="icon_image2"/><div>스크랩</div></div>
        	<div class="icon"><img src="IMAGES/reply.svg" class="icon_image2"/><div>의견나누기</div></div>
        	<div class="icon"><img src="IMAGES/surrounding.svg" class="icon_image2"/><div>주변정보</div></div>
 	   </div>

		<div class="select">
			<div class="select_title">일차 선택</div>
			<select id="select">
		<%
		for( int i = 1; i <= dateRouteList.length; i++ )
		{
		%>
				<option value="<%=i%>"> <%=i%>일차 보기
		<%
		}
		%>
			</select>
		</div>
		
	 </div>
	 
	 
		<div id="course">
			<!-- select(comboBox)의 value(일차)에 따라 동적으로 그려짐 -->
		</div>
		
		<div id="mapView">
			<!-- 경로 탐색이 모두 끝난후 동적으로 그려짐 -->
		</div>
		
   		<div class="comment">
        <div class="comment_header">
            <span class="comment_title">의견</span>
            <span class="more_content" id="comment_show">더보기 ></span>
        </div>
        <div class="comment_content">
        <%
        for( int i = comment_list.size() - 1; i >= 0; i-- )
        {
		%>
            <div class="comment_item">
                <div class="user_image">
                    <%
	               	String member_nickname = (String) comment_list.get(i).get("member_nickname");
	               
	                String imageURL = id.getMemberImageURL(member_nickname);
	                
	            	if( imageURL.contains("kakao") )
	               		out.println("<img src='" + id.getMemberImageURL(member_nickname) + "' style='width:100%;'>");
	               	else
	               		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
	            	%>
                </div>
                
                <div class="user_text">
                    <span class="user_name"><%=comment_list.get(i).get("member_nickname") %></span>
                    <span class="comment_date"><%=sdf.format(comment_list.get(i).get("date"))%></span>
                    <div class="user_comment"><%=comment_list.get(i).get("content") %></div>
                </div>
            </div>
		<%
			if( i == comment_list.size() - 2 ) break;
		}
		%>
        </div>
		</div>
		
	<iframe src="Comment.jsp?kind=course&item_id=<%=course_no%>&level=1" id="dynamic" style="display:none" name="dynamic"></iframe>
	
	<script>

		
		// select(comboBox)의 내용이 바뀌었을시 실행(일차 변경)
		$('#select').change(function() {
			currentIndex = this.value - 1;
			routeDate = this.value;
			viewCourse();
		});
		
		$(window).load(function() {
			$(".user_image img").css("height", $(".user_image img").width());
			ref = "CourseDetail";
			item_id = '<%=course_no%>';
			kind = '<%=kind%>';
			isRecommend = '<%=isRecommend%>';
			isScrap = '<%=isScrap%>';
			
			if( <%=nickName != null%> )
				nickName = '<%=nickName%>';
				
			init();
			viewCourse();
			$('.icon_image').css("height",window.innerWidth*0.05);
			$('.icon_text').css("height",window.innerWidth*0.05);

		});
		
		// resize가 최종완료되기전까지 resize 이벤트를 무시(최대화의 경우 resize가 계속발생하는 것을 방지)
		$(window).resize(function() {		
			if( this.resizeTO )
		        clearTimeout(this.resizeTO);
		      
		    this.resizeTO = setTimeout(function() {
		        $(this).trigger('resizeEnd');
		    }, 0);
		    
		    $('.icon_image').css("height",window.innerWidth*0.05);
			$('.icon_text').css("height",window.innerWidth*0.05);
		});
		// resize가 최종완료된 후 실행되는 callback 함수
		$(window).on('resizeEnd', function() {
			$(".user_image img").css("height", $(".user_image img").width());
			viewCourse();
			$('.icon_image').css("height",window.innerWidth*0.05);
			$('.icon_text').css("height",window.innerWidth*0.05);
		});
		
		function init()
		{
			var count = -1;	// 일차에 관계없이 전체 경로를 각 배열에 집어넣기 위한 인덱스
			<%
			for( int i = 0; i < dateRouteList.length; i++ )
			{
				String []routeList = dateRouteList[i].split(",");	
				for( int j = 0; j < routeList.length; j++ )
				{
			%>
			dateNo[++count] = <%=i%>;					// 일차
			areaNo[count] = '<%=routeList[j]%>';		/* 관광지 번호 */
			areaName[count] = '<%=ad.getAreaInfo(routeList[j]).get("name")%>';
			areaLatitude[count] = '<%=ad.getAreaInfo(routeList[j]).get("latitude")%>';
			areaLongitude[count] = '<%=ad.getAreaInfo(routeList[j]).get("longitude")%>';
			areaImage[count] = '<%=id.getImageURLList("area", routeList[j]).get(0)%>';		
			recommendCount[count] = <%=rd.getRecommendCount("area", (String)ad.getAreaInfo(routeList[j]).get("area_no"))%>;
			<%
				}
			}
			%>
			
			routeInfoInit();
		}
	</script>
	
</body>
</html>