<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	String item_id = request.getParameter("item_id");
	String routeDate = request.getParameter("routeDate");
	String type = request.getParameter("type");
	String currentPage = request.getParameter("page");
	String latitude = request.getParameter("latitude");
	String longitude = request.getParameter("longitude");

	int pageCnt = 1;
	int totalPage = 0;
	int totalPageSet = 0;
	int currentPageSet = 0;
	
	if( currentPage != null )
		pageCnt = Integer.parseInt(currentPage);
	
	AroundDatabase ard = new AroundDatabase();
	AreaDatabase ad = new AreaDatabase();
	RestaurantDatabase rst = new RestaurantDatabase();
	AccommodationDatabase acd = new AccommodationDatabase();
	ShoppingDatabase sd = new ShoppingDatabase();
	CourseDatabase cd = new CourseDatabase();
	
	RecommendDatabase rd = new RecommendDatabase();
	ImageDatabase id = new ImageDatabase();
	MyItemDatabase mid = new MyItemDatabase();
	
	String passList = "";
	
	if( type == null || type.equals("null") )
		totalPage = ard.getTotalPage(item_id, Double.parseDouble(latitude), Double.parseDouble(longitude), 4);
	else
	{
		String []routeList = ((String)cd.getCourseInfo(item_id).get("route")).split("-");
		String []dateRouteList = routeList[Integer.parseInt(routeDate) - 1].split(",");
		
		for( int i = 0; i < dateRouteList.length; i++ )
		{
			HashMap<String, Object> tempMap = ad.getAreaInfo(dateRouteList[i]);
			passList += tempMap.get("latitude") + "," + tempMap.get("longitude") + "-";
		}
		totalPage = ard.getTotalPage2(passList, 4);
	}
	
	if( totalPage % 10 == 0 )
		totalPage /= 10;
	else
		totalPage = totalPage / 10 + 1;
	
	if( totalPage % 5 == 0 )
		totalPageSet = totalPage / 5;
	else
		totalPageSet = totalPage / 5 + 1;
	
	if( pageCnt % 5 == 0 )
		currentPageSet = pageCnt / 5;
	else
		currentPageSet = pageCnt / 5 + 1;

	ArrayList<HashMap<String, Object>> list = null;
	
	if( type == null || type.equals("null") )
		list = ard.getPage(item_id, Double.parseDouble(latitude), Double.parseDouble(longitude), 4, pageCnt);
	else
		list = ard.getPage2(passList, 4, pageCnt);
	
	for( int i = 0; i < list.size(); i++ )
	{
		list.get(i).put("scrapCount", mid.getScrapCount((String)list.get(i).get("kind"), (String)list.get(i).get("item_id")));
		list.get(i).put("recommendCount", rd.getRecommendCount((String)list.get(i).get("kind"), (String)list.get(i).get("item_id")));
		list.get(i).put("image", id.getImageURLList((String)list.get(i).get("kind"), (String)list.get(i).get("item_id")));
	}
%>

<!doctype html>

<html>
<head>
	<meta charset="utf-8">
	<title>관광지 정보 보기</title>
	<!-- 반응형 임포트 -->
	<!-- <meta name="viewport" content="width=device-width, initial-scale=1.0"> -->
	<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
	<!-- [if lt IE 9] -->
	<!-- <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script> -->
	<!-- [endif] -->
	
	<script src="JS/jquery.js"></script>
	<!-- <script src="JS/jquery.masonry.min.js"></script> -->
	<!-- Swiper JS -->
	<!-- <script src="dist/JS/swiper.min.js"></script> -->
	<script src="JS/SiteList.js"></script>
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<!-- <link rel="stylesheet" href="dist/CSS/swiper.min.css"> -->
	<link rel="stylesheet" href="CSS/SiteList.css">
</head>

<body>
	<div id="container_site">
	<%
      for(int i=0; i<list.size(); i++)
      {
      %>
		<div class="box_site" id='<%=list.get(i).get("kind")%>_<%=list.get(i).get("item_id")%>'>
			<div class="site_title">
				<div class="site_name">&nbsp;<%=list.get(i).get("name")%></div>
				<div class="arrow">
					<img src="IMAGES/next.svg"/>
				</div>
			</div>
			
			<div class="content">
				<div class="site_img">
					<img src='<%=((ArrayList<String>)list.get(i).get("image")).get(0) %>' class="site_image_back">
				</div>
	
				<div class="site_content">
					<div class="site_address">
						<img src="IMAGES/location.svg" class="location_img" />
						<div class="site_info"> <%=list.get(i).get("address")%><br></div>
					</div>
					
					<div class="site_like">
						<div class="like"> 
							<img src="IMAGES/scrap.svg"> 
							<div class="like_cont"><%=list.get(i).get("scrapCount")%></div>
						</div>
						 
						<div class="like"> 
							<img src="IMAGES/like.svg"> 
							<div class="like_cont"><%=list.get(i).get("recommendCount")%></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%
      }
      %>
	</div>
	
	<div id="nav">
		<%
		if( currentPageSet > 1 )
		{
			int beforePageSetLastPage = 5 * (currentPageSet - 1);
			
			String retUrl = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&latitude=" + latitude + "&longitude=" + longitude + "&type=" + type + "&page=" + beforePageSetLastPage;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back_more.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_back_more.svg' width=30px height=30px>");
		
		if( pageCnt > 1 )
		{
			int beforePage = pageCnt - 1;

			String retUrl = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&latitude=" + latitude + "&longitude=" + longitude + "&type=" + type + "&page=" + beforePage;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");

		}
		else
			out.println("<IMG SRC='IMAGES/move_back.svg' width=30px height=30px>");
		
		int firstPage = 5 * (currentPageSet - 1);
		int lastPage = 5 * currentPageSet ;
		
		if( currentPageSet == totalPageSet )
			lastPage = totalPage;
		
		for( int i = firstPage + 1; i <= lastPage; i++ )
		{
			if( pageCnt == i )
			{
				out.println("&nbsp;");
				out.println("<B style='color: #2b5686'>" + i + "</B>");
	            out.println("&nbsp;");
			}
			else
			{
				String retUrl = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&latitude=" + latitude + "&longitude=" + longitude + "&type=" + type + "&page=" + i;
				out.println("&nbsp;");
				out.println("<a href=" + retUrl + " style='color:#888888'>" + i + "</a>");
	            out.println("&nbsp;");
			}
		}		
		if( totalPage > pageCnt )
		{
			int nextPage = pageCnt + 1;
			
			String retUrl = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&latitude=" + latitude + "&longitude=" + longitude + "&type=" + type + "&page=" + nextPage;
			
			String click="javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_next.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next.svg' width=30px height=30px>");
		
		if( totalPageSet > currentPageSet )
		{
			int nextPageSet = 5 * currentPageSet + 1;

			String retUrl = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&latitude=" + latitude + "&longitude=" + longitude + "&type=" + type + "&page=" + nextPageSet;
			
			String click = "javascript:location.href='" + retUrl;	
			 out.println("<IMG SRC='IMAGES/move_next_more.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next_more.svg' width=30px height=30px>");
		

	%>
	</div>

	<script>

		$(window).load(function(){  
			
			$('.box_site').css("height", $(window).innerWidth() * 0.4);
			$('#container_site').css("height", $('.box_site').outerHeight(true) * <%=list.size()%>);
			$('#nav').css("height", $(window).innerWidth() * 0.1);
			
			$("#container_site").css("left", "0");
			$("#container_site").css("top", $("#header").outerHeight(true));
			
			$('#nav').css("left", 0);
			$("#nav").css("top", $("#container_site").outerHeight(true) + $("#header").outerHeight(true));
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
			
			$('.box_site').css("height", $(window).innerWidth() * 0.4);
			$('#container_site').css("height", $('.box_site').outerHeight(true) * <%=list.size()%>);
			$('#nav').css("height", $(window).innerWidth() * 0.1);
			
			
			$("#container_site").css("left", "0");
			$("#container_site").css("top", $("#header").outerHeight(true));
			
			$('#nav').css("left", 0);
			$("#nav").css("top", $("#container_site").outerHeight(true) + $("#header").outerHeight(true));
		});
		
		
		$('.box_site').click(function() {	
			
			var url;
			var id = $(this).attr("id").toString();
			var item_id = id.substring(id.length - 10);
			
			if( id.includes("area") )
				url = "SiteDetail.jsp?area_no=" + item_id + "&kind=area";
			else if( id.includes("restaurant") )
				url = "RestaurantDetail.jsp?rst_no=" + item_id + "&kind=restaurant";
			else if( id.includes("accommodation") )
				url = "AccommodationDetail.jsp?acc_no=" + item_id + "&kind=accommodation";
			else if( id.includes("shopping") )
				url = "ShoppingDetail.jsp?shop_no=" + item_id + "&kind=shopping";
			
			location.href = url;
		});
				
	</script>
	
</body>
</html>