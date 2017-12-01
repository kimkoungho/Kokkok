<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	String area_no = request.getParameter("area_no");
	String kind = "area";
	
	AreaDatabase ad = new AreaDatabase();
	RecommendDatabase rd = new RecommendDatabase();
	ImageDatabase id = new ImageDatabase();
	CourseDatabase cd = new CourseDatabase();
	CommentDatabase cmd = new CommentDatabase();
	MyItemDatabase mid = new MyItemDatabase();
	
	HashMap<String, Object> hash = ad.getAreaInfo(area_no);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	ArrayList<String> img_list = id.getImageURLList(kind, area_no);
	int recommend_cnt = rd.getRecommendCount(kind, area_no);
	int scrap_cnt = mid.getScrapCount(kind, area_no);
	boolean isRecommend = rd.isRecommend(nickName, kind, area_no);
	boolean isScrap = mid.isScrap(nickName, kind, area_no);
	
	ArrayList<HashMap<String, Object>> comment_list = cmd.getDB(kind, area_no, 1);
	ArrayList<HashMap<String, Object>> relate_course = cd.getAreaCourseInfo(area_no);
%>

<!doctype html>
<html>
<head>
	<title> 관광지 세부 정보 </title>
    <!-- 반응형 임포트 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!-- [if lt IE 9] -->
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <!-- [endif] -->
    <!-- 동수 꺼-->
    <link href="lib/jquery.bxslider.css" rel="stylesheet" />
    <link rel="stylesheet" href="dist/css/swiper.min.css">
    
    <script src="//apis.daum.net/maps/maps3.js?apikey=a7a2302448b878aba762a21dd0317d72&libraries=services"></script>
    
    <!-- 여기 있어야 실행됨 반응형 -->
    <script src="JS/jquery.js"></script>
    <script src="JS/jquery.masonry.min.js"></script>
    <script src="dist/js/swiper.min.js"></script>
    
    <link rel="stylesheet" href="CSS/SiteDetail.css">
    <script src="JS/SiteDetail.js"></script>
</head>

<body>

	<div id="header">
		<div id="title">
			<span class="title_text">
	        	<%=((String)hash.get("area_no")).substring(0,2)%> > 
	        	<%=hash.get("name")%>
	        </span>
        
	        <span id="state_bar">
				<span class="state_icon">
					<img src="IMAGES/scrap.svg" class="icon_image">
					<span class="icon_text" > <%=scrap_cnt%> </span>
				</span>
				
				<span class="state_icon">
					<img src="IMAGES/like.svg" class="icon_image">
					<span class="icon_text" > <%=recommend_cnt%> </span>
				</span>
			</span>
    	</div>
    
	    <div class="swiper-container main">
	        <div class="swiper-wrapper">
	        <%
	        for( int i = 0; i < img_list.size(); i++ )
	        {
	        %>
	            <div class="swiper-slide">
	            	<img src="IMAGES/transparency3.png" class="area_img" style="background-image:url('<%=img_list.get(i) %>');">
	            </div>
		    <%
	        }
		    %>        
		
	        </div>
	        <!-- Add Pagination -->
	        <div class="swiper-pagination" id="main_pagi"></div>
	    </div>
    
	    <div class="area_text">
	        <div class="area_name"> <%=hash.get("name") %> </div>
	        <div class="area_info1">
	        	<div class="area_info_title">
	        		<b> 정보 </b>
	       		</div>
	       	
		        <div class="area_info_content">
		        	<span class="info_dept"> 분류 </span>
		            <span class="info_insert">명소 > 
		            <%
	           			String group = (String)hash.get("kind");
		            	
		            	if( group.equals("tourism") )
		            		out.println("관광");
		            	else if( group.equals("leisure") )
		            		out.println("레저 스포츠");
		            	else
		            		out.println("문화 시설");
					 %>
		            </span>
		        </div>
		        
		        <div class="area_info_content">
		            <span class="info_dept"> 주소 </span>
		            <span class="info_insert"> <%=hash.get("address")%> </span>
		        </div>
		        
		        <div class="area_info_content">
		            <span class="info_dept"> 전화번호 </span>
		            <span class="info_insert"> <%=hash.get("phone")%> </span>
		        </div>
		        
		        <div class="area_info_content">
		            <span class="info_dept"> 이용시간 </span>
		            <span class="info_insert"><%=hash.get("time")%></span>
		        </div>
	    	</div>
        
	        <div id="icon_bar">
	    		<div class="icon">
	   	    		<img src="IMAGES/like.svg" class="icon_image2"/>
	   	    		<div> 추천해요! </div>
	    		</div>
	  	    		
	    		<div class="icon">
	    			<img src="IMAGES/scrap.svg" class="icon_image2"/>
	   				<div> 스크랩 </div>
				</div>
	  				
	       		<div class="icon">
	       			<img src="IMAGES/reply.svg" class="icon_image2"/>
	       			<div> 의견나누기 </div>
	      		</div>
	      			
	       		<div class="icon">
	       			<img src="IMAGES/surrounding.svg" class="icon_image2"/>
	      			<div> 주변정보 </div>
	  			</div>
	   		</div>
    	</div>
   	</div>

	<div class="area_info">
		<div class="area_info_title">
			<b> 장소 설명 </b>
		</div>
		
		<span class="info_insert"> <%=((String)hash.get("intro")).replaceAll("\n", "<BR>")%> </span>
    </div>
    
    <div id="area_map">
        <div class="header">
            <span class="title"> 위치 </span>
            <span class="more_content" id="map_big"> 크게 보기 > </span>
        </div>
        
        <div id="dt_map"></div>
    </div>
    
    <div class="comment">
        <div class="header">
            <span class="title"> 의견 </span>
            <span class="more_content" id="comment_show"> 더보기 > </span>
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
	               		out.println("<img src='" + imageURL + "' style='width:100%;'>");
	               	else
	               		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
	            	%>
                </div>
                
                <div class="user_text">
                    <span class="user_name"> <%=comment_list.get(i).get("member_nickname") %> </span>
                    <span class="comment_date"> <%=sdf.format(comment_list.get(i).get("date"))%> </span>
                    <div class="user_comment"> <%=comment_list.get(i).get("content") %> </div>
                </div>
            </div>
		<%
			if( i == comment_list.size() - 2 ) break;
		}
		%>
        </div>
	</div>	
    
    <div class="relative_course">
        <div class="title_site"> 이 명소가 포함된 코스 &nbsp;&nbsp;&nbsp;&nbsp;<%=relate_course.size()%>건</div>
        <div class="swiper-container course">
            <div class="swiper-wrapper">
            <%
          	/* if(relate_course!=null)
          	{ */
          		for(int i=0; i<relate_course.size(); i++)
	            {
	            	String[] dateRouteList = ((String)relate_course.get(i).get("route")).split(",");
	        		String farea = dateRouteList[0];
	        		String larea = dateRouteList[dateRouteList.length-1];
	        		
	        		String ImageUrl = id.getImageURLList(kind, farea).get(0);
	
	        		farea = farea.substring(0, 2);
					larea = larea.substring(0, 2); 
					
            %>
            	<div class="swiper-slide" onclick="moveCourseDetail('<%=relate_course.get(i).get("course_no")%>')">
					<img src="IMAGES/transparency4.png" class="course_image" style="background-image:url('<%=ImageUrl%>')" />
                    <div class="course_item">
                    	<div class="course_site">
                        <!--  <img src="IMAGES/location.svg" class="locaion_icon"/> --> 
                        	<div class="location_text"><%=farea %> - <%=larea %> </div>
                        </div>
                        
                        <div class="course_name"><%= relate_course.get(i).get("name")%></div>
                        <div class="course_isBasic"> 
                        <% 
                        	if( Boolean.parseBoolean((String)(relate_course.get(i).get("isBasic"))) )
                        		out.println("추천코스");
                        	else
                        		out.println("사용자추천");
                        %>
                         </div>
                    </div>
                </div>
            <%
            	}
          	//}
            %>
            </div>
            <!-- Add Pagination -->
            <%
            if( relate_course.size() > 0 )
            {
            %>
            <div class="swiper-pagination" id="course_pagi"></div>
            <%
            }
            %>
        </div>
    </div>
    
    <iframe src="Comment.jsp?kind=area&item_id=<%=area_no%>&level=1" id="dynamic" style="display:none" name="dynamic"></iframe>
   	
    <script>
    	
    	$(window).load(function() {
    		$(".user_image img").css("height", $(".user_image img").width());
    		$("#dt_map").css("height", $(window).width() * 0.5);
    		drawMap('<%=hash.get("name")%>', <%=hash.get("latitude")%>, <%=hash.get("longitude")%>);
    		
    		ref = "SiteDetail";
			item_id = '<%=area_no%>';
			kind = '<%=kind%>';
			isRecommend = '<%=isRecommend%>';
			isScrap = '<%=isScrap%>';
			
			if( <%=nickName != null%> )
				nickName = '<%=nickName%>';
    	});
    	
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
			$(".user_image img").css("height", $(".user_image img").width());
			$("#dt_map").css("height", $(window).width() * 0.5);
		});
    
    
        var swiper = new Swiper('.main', {
            pagination: '#main_pagi',
            paginationClickable: true
        });
        var course_swiper = new Swiper('.course', {
            pagination: '#course_pagi',
            paginationClickable: true
        });
    </script>
    
</body>
</html>