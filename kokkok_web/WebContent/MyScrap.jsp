<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	
	AreaDatabase ad = new AreaDatabase();
	CourseDatabase cd = new CourseDatabase();
	RecommendDatabase rd = new RecommendDatabase();
	ImageDatabase id = new ImageDatabase();
	CommentDatabase cmd = new CommentDatabase();
	MyItemDatabase mid = new MyItemDatabase();

	ArrayList<HashMap<String, Object>> course_list = mid.getMyCourse("course", nickName);
	ArrayList<HashMap<String, Object>> area_list = mid.getMyArea("area", nickName);
	ArrayList<HashMap<String, Object>> shop_list = mid.getMyShopping("shopping", nickName);
	ArrayList<HashMap<String, Object>> acc_list = mid.getMyAccommodation("accommodation", nickName);
	ArrayList<HashMap<String, Object>> rst_list = mid.getMyRestaurant("restaurant", nickName);
	
	ArrayList<HashMap<String, Object>> around_list = new ArrayList<HashMap<String, Object>> ();
	
	for( int i = 0; i < area_list.size(); i++ )
	{
		area_list.get(i).put("image", id.getImageURLList("area", (String)area_list.get(i).get("area_no")).get(0));
		area_list.get(i).put("recommendCount", rd.getRecommendCount("area", (String)area_list.get(i).get("area_no")));
		area_list.get(i).put("scrapCount", mid.getScrapCount("area", (String)area_list.get(i).get("area_no")));
	}
	
	for( int i = 0; i < shop_list.size(); i++ )
	{
		shop_list.get(i).put("kind", "shopping");
		shop_list.get(i).put("image", id.getImageURLList("shopping", (String)shop_list.get(i).get("shop_no")).get(0));
		shop_list.get(i).put("recommendCount", rd.getRecommendCount("shopping", (String)shop_list.get(i).get("shop_no")));
		shop_list.get(i).put("scrapCount", mid.getScrapCount("shopping", (String)shop_list.get(i).get("shop_no")));
		
		
		around_list.add(shop_list.get(i));
	}
	
	for( int i = 0; i < acc_list.size(); i++ )
	{
		acc_list.get(i).put("kind", "accommodation");
		acc_list.get(i).put("image", id.getImageURLList("accommodation", (String)acc_list.get(i).get("acc_no")).get(0));
		acc_list.get(i).put("recommendCount", rd.getRecommendCount("accommodation", (String)acc_list.get(i).get("acc_no")));
		acc_list.get(i).put("scrapCount", mid.getScrapCount("accommodation", (String)acc_list.get(i).get("acc_no")));
		
		around_list.add(acc_list.get(i));
	}
	
	for( int i = 0; i < rst_list.size(); i++ )
	{
		rst_list.get(i).put("kind", "restaurant");
		rst_list.get(i).put("image", id.getImageURLList("restaurant", (String)rst_list.get(i).get("rst_no")).get(0));
		rst_list.get(i).put("recommendCount", rd.getRecommendCount("restaurant", (String)rst_list.get(i).get("rst_no")));
		rst_list.get(i).put("scrapCount", mid.getScrapCount("restaurant", (String)rst_list.get(i).get("rst_no")));
		
		around_list.add(rst_list.get(i));
	}
	
	
%>

<!doctype html>

<html>
<head>
	<meta charset="utf-8">
	<title>나의 스크랩 정보</title>
	
	<script src="dist/js/swiper.min.js"></script>
	<script src="JS/jquery.js"></script>
	<script src="JS/MyScrap.js"></script>
	
	<link rel="stylesheet" href="dist/css/swiper.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="CSS/MyScrap.css">
</head>

<body>

	<div id="header">
		<div class="menu">스크랩한 명소</div>
		<div class="menu">스크랩한 장소</div>
		<div class="menu">스크랩한 코스</div>
	</div>
	
	<div id="nav">
		<div class="lnb">
			총 <%=area_list.size()%> 건
		</div>
	</div>

	<div class="swiper-container" id="all_package">
      <!-- Add Pagination -->
      <div class="swiper-pagination"></div>

      <div class="swiper-wrapper">
         <div class="swiper-slide" id="area_package">
			<div id="container_around">
				  <%
			      for(int i=0; i<area_list.size(); i++)
			      {
			      %>
					<div class="box_site" id='<%="area-" + area_list.get(i).get("area_no")%>'>
						<div class="site_title">
							<div class="site_name">&nbsp;<%=area_list.get(i).get("name")%></div>
							<div class="arrow">
								<img src="IMAGES/next.svg"/>
							</div>
						</div>
						
						<div class="content">
                     <div class="site_img">
                        <img src='<%=area_list.get(i).get("image") %>' class="site_image_back">
                     </div>
            
                     <div class="site_content">
                        <div class="site_address">
                           <img src="IMAGES/location.svg" class="location_img" />
                           <div class="site_info"> <%=area_list.get(i).get("address")%><br></div>
                        </div>
                        
                        <div class="site_like">
                           <div class="like"> 
                              <img src="IMAGES/scrap.svg"> 
                              <div class="like_cont"><%=area_list.get(i).get("scrapCount")%></div>
                           </div>
                           <div class="like"> 
                              <img src="IMAGES/like.svg"/> 
                              <div class="like_cont"><%=area_list.get(i).get("recommendCount")%></div>
                           </div>
                           <div class="delete">
                              <img class="around_trash" src="IMAGES/trash.svg"/>
                            </div>
                        </div>
                     </div>
                  </div>
					</div>
					<%
			      }
			      %>
				</div>
			</div>
			
			<div class="swiper-slide" id="around_package">
				<div id="container_around">
				  <%
			      for(int i=0; i<around_list.size(); i++)
			      {
			    	  HashMap<String, Object> tempMap = around_list.get(i);
			    	  String filter = null;
			    	  String kind = null;
			    	  
			    	  if( ((String)tempMap.get("kind")).equals("restaurant") )
			    	  {
			    		  filter = "rst_no";
			    		  kind = "restaurant";
			    	  }
			    	  else if( ((String)tempMap.get("kind")).equals("accommodation") )
			    	  {
			    		  filter = "acc_no";
			    		  kind = "accommodation";
			    	  }
			    	  else if( ((String)tempMap.get("kind")).equals("shopping") )
			    	  {
			    		  filter = "shop_no";
			    		  kind = "shopping";
			    	  }
			      %>
					<div class="box_site" id='<%=kind + "-" + around_list.get(i).get(filter)%>'>
						<div class="site_title">
							<div class="site_name">&nbsp;<%=around_list.get(i).get("name")%></div>
							<div class="arrow">
								<img src="IMAGES/next.svg"/>
							</div>
						</div>
						
						<div class="content">
                     <div class="site_img">
                        <img src='<%=around_list.get(i).get("image") %>' class="site_image_back">
                     </div>
            
                     <div class="site_content">
                        <div class="site_address">
                           <img src="IMAGES/location.svg" class="location_img" />
                           <div class="site_info"> <%=around_list.get(i).get("address")%><br></div>
                        </div>
                        
                        <div class="site_like">
                           <div class="like"> 
                              <img src="IMAGES/scrap.svg"> 
                              <div class="like_cont"><%=around_list.get(i).get("scrapCount")%></div>
                           </div>
                           <div class="like"> 
                              <img src="IMAGES/like.svg"/> 
                              <div class="like_cont"><%=around_list.get(i).get("recommendCount")%></div>
                           </div>
                           <div class="delete">
                              <img class="around_trash" src="IMAGES/trash.svg"/>
                            </div>
                        </div>
                     </div>
                  </div>
					</div>
					<%
			      }
			      %>
				</div>
			</div>
			
			<div class="swiper-slide">
				<div class="course_container">
				<%
					for(int i=0; i<course_list.size(); i++)
					{
						String[] dateRouteList = ((String) course_list.get(i).get("route")).split("-");
						String startPosition = null;
						String endPosition = null;
						String imageUrl="";
						
						String isBasic="사용자 추천";
						if(course_list.get(i).get("isBasic").equals("false"))
							isBasic="한국 관광 공사 추천";
						
						for (int j = 0; j < dateRouteList.length; j++)
						{
							String[] routeList = dateRouteList[j].split(",");
							
							for (int k = 0; k < routeList.length; k++)
							{
								if (j == 0){
									startPosition = routeList[0].split("_")[0];
									imageUrl=(String)id.getImageURLList("area", routeList[0]).get(0);
								}
								if (j == dateRouteList.length - 1)
									endPosition = routeList[routeList.length - 1].split("_")[0];
							}
						}
						
				%>
					<div class="cont_ele" id=<%="course-" + course_list.get(i).get("course_no")%>>
                  		<div class="course_item" style="background-image:url('<%=imageUrl%>')">
                     		<div class="course_site">
                        		<img src="IMAGES/location2.svg" style="float: left; width: 15%; margin-top: 3%; margin-left: 4%;" />
                        		<%=startPosition%>~<%=endPosition%>
                     		</div>
                     
                     		<div class="course_trash">
                        		<img src="IMAGES/trash.svg" style="float:right; width: 100%;"/>
                     		</div>
                     
                     		<div class="course_name"><%=course_list.get(i).get("name")%></div>
                    		<div class="course_isBasic"><%=isBasic %></div>
                  		</div>
              		 </div>
				<%
					}
				%>
				</div>
			</div>
		</div>
	</div>

	<script>

		$(window).load(function(){  
		
			$('#header').css("height", $(window).innerWidth() * 0.1);
			$('#nav').css("height", $(window).innerWidth() * 0.1);
			$('.box_site').css("height", $(window).innerWidth() * 0.4);
			$('#container_site').css("height", $('.box_site').outerHeight(true) * <%=area_list.size()%>);
			$("#container_package").css("height", $("#container_site").outerHeight(true));
			
			$('#container_around').css("height", $('.box_site').outerHeight(true) * <%=around_list.size()%>);
			$("#around_package").css("height", $("#container_around").outerHeight(true));
			
			$('#nav').css("left", 0);
			$("#nav").css("top", $("#header").outerHeight(true)); 
			
			$("#all_package").css("left", "0");
			$("#all_package").css("top", $("#header").outerHeight(true) + $("#nav").outerHeight(true));
			
			$(".menu").eq(0).click();
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
			
			$('#header').css("height", $(window).innerWidth() * 0.1);
			$('#nav').css("height", $(window).innerWidth() * 0.1);
			$('.box_site').css("height", $(window).innerWidth() * 0.4);
			$('#container_site').css("height", $('.box_site').outerHeight(true) * <%=area_list.size()%>);
			$("#container_package").css("height", $("#container_site").outerHeight(true));
			
			$('#container_around').css("height", $('.box_site').outerHeight(true) * <%=around_list.size()%>);
			$("#around_package").css("height", $("#container_around").outerHeight(true));
			
			$('#nav').css("left", 0);
			$("#nav").css("top", $("#header").outerHeight(true)); 
			
			$("#all_package").css("left", "0");
			$("#all_package").css("top", $("#header").outerHeight(true) + $("#nav").outerHeight(true));

		});
	
		$('.menu').click(function() {
			
		  	var index = $(this).index();
		  	
		  		if( index == 0 )
		  			$(".lnb").text("총 <%=area_list.size()%> 건");
		  		else if( index == 1 )
		  			$(".lnb").text("총 <%=around_list.size()%> 건");
		  		else if( index == 2 )
		  			$(".lnb").text("총 <%=course_list.size()%> 건");
		  	
		   		$(".menu").css("background-color", "#f0f0f0");
		   		$(".menu").css("border-bottom", "1px solid #cccccc");
		   		$(".menu").css("color", "black");
		  	 	$(this).css("background-color", "#2D4B71");
		  	 	$(this).css("color", "white");
		  	 	
		  	 	main_swiper.slideTo(index);
			
		});

	      var main_swiper = new Swiper('.swiper-container', {
	    	  
	 
	         onSlideChangeStart : function(evt)
	         {
	        	
	        	 
	        	$(".menu").css("background-color", "#f0f0f0");
	 	   		$(".menu").css("border-bottom", "1px solid #cccccc");
	 	   		$(".menu").css("color", "black");
	            $(".menu").eq(evt.activeIndex).css("color", "white");
	            $(".menu").eq(evt.activeIndex).css("background-color", "#2D4B71");
	         },
	         onSlideChangeEnd : function(evt)
	         {
	        	 var index = evt.activeIndex;
	        	 
	        	 if( index == 0 )
			  			$(".lnb").text("총 <%=area_list.size()%> 건");
			  		else if( index == 1 )
			  			$(".lnb").text("총 <%=around_list.size()%> 건");
			  		else if( index == 2 )
			  			$(".lnb").text("총 <%=course_list.size()%> 건");
	         }
	      /* pagination : '.swiper-pagination',
	      paginationClickable : true,
	      paginationType : 'progress' */

	      });
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

	</script>
	
</body>
</html>