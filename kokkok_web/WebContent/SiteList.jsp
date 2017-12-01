<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	String localArr[] = {"전체", "괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시", "충주시"};

	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	String currentPage = request.getParameter("page");
	String local = request.getParameter("local");
	String type =request.getParameter("type");
	
	if( type == null )
		type = "site";
	
	int currentLocal = 0;
	
	if( local == null )
		local = "전체";
	
	for( int i = 0; i < localArr.length; i++ )
	{
		if( local.equals(localArr[i]) )
		{
			currentLocal = i;
			break;
		}
	}
	
	
	
   	int pageCnt = 1;
	int totalPage = 0;
	int totalPageSet = 0;
	int currentPageSet = 0;

	if( currentPage != null )
		pageCnt = Integer.parseInt(currentPage);
	
	if( local.equals("전체") ) 
		local = "";
	
	AreaDatabase ad = new AreaDatabase();
	RecommendDatabase rd = new RecommendDatabase();
	ImageDatabase id = new ImageDatabase();
	MyItemDatabase mid = new MyItemDatabase();
	
	totalPage = ad.getTotalPage(local);
	
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
	
	ArrayList<HashMap<String, Object>> list = ad.getPage(local, pageCnt);
	
	for( int i = 0; i < list.size(); i++ )
	{
		list.get(i).put("scrapCount", mid.getScrapCount("area", (String)list.get(i).get("area_no")));
		list.get(i).put("recommendCount", rd.getRecommendCount("area", (String)list.get(i).get("area_no")));
		list.get(i).put("image", id.getImageURLList("area", (String)list.get(i).get("area_no")));
	}
%>

<!doctype html>

<html>
<head>
	<meta charset="utf-8">
	<title>관광지 정보 보기</title>
	
	<script src="JS/jquery.js"></script>
	<script src="JS/SiteList.js"></script>
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="CSS/SiteList.css">
</head>

<body>
	<div id="header">
		<div class="gnb">
			<div class="section">
				<span class="area_name"> 전체</span> 
				<span class="area_name"> 괴산군</span>
				<span class="area_name"> 단양군</span> 
				<span class="area_name"> 보은군</span>
				<span class="area_name"> 영동군</span> 
				<span class="area_name"> 옥천군</span>
				<span class="area_name"> 음성군</span> 
				<span class="area_name"> 제천시</span>
				<span class="area_name"> 증평군</span> 
				<span class="area_name"> 진천군</span>
				<span class="area_name"> 청주시</span> 
				<span class="area_name"> 충주시</span>
			</div>
		</div>
	</div>

	<div id="container_site">
	<%
      for(int i=0; i<list.size(); i++)
      {
      %>
		<div class="box_site" id='<%=list.get(i).get("area_no")%>'>
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

	<div id="nav" style="background-color: white;">
		<%
		if( currentPageSet > 1 )
		{
			int beforePageSetLastPage = 5 * (currentPageSet - 1);
			String retUrl = "SiteList.jsp?type=" + type + "&local=" + local +"&page=" + beforePageSetLastPage;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back_more.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_back_more.svg' width=30px height=30px>");

		
		if( pageCnt > 1 )
		{
			int beforePage = pageCnt - 1;
			String retUrl = "SiteList.jsp?type=" + type + "&local=" + local +"&page=" + beforePage;
			
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
	            String retUrl = "SiteList.jsp?type=" + type + "&local=" + local +"&page=" + i;
	            out.println("&nbsp;");
	            out.println("<a href=" + retUrl + " style='color:#888888'>" + i + "</a>");
	            out.println("&nbsp;");
	         }
		}
		   
		if( totalPage > pageCnt )
		{
			int nextPage = pageCnt + 1;
			String retUrl = "SiteList.jsp?type=" + type + "&local=" + local +"&page=" + nextPage;
			
			String click="javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_next.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next.svg' width=30px height=30px>");
		
		if( totalPageSet > currentPageSet )
		{
			int nextPageSet = 5 * currentPageSet + 1;
			String retUrl = "SiteList.jsp?type=" + type + "&local=" + local +"&page=" + nextPageSet;
			
			String click = "javascript:location.href='" + retUrl;	
			 out.println("<IMG SRC='IMAGES/move_next_more.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next_more.svg' width=30px height=30px>");
		
	%>
	</div>

	<div id="latitude" style="display: none;"></div> <!-- 후기에서 경위도 값과 지역이름을 가져오기 위한 div -->
	<div id="longitude" style="display: none;"></div> <!-- 후기에서 경위도 값과 지역이름을 가져오기 위한 div -->
	<div id="areaName" style="display: none;"></div> <!-- 후기에서 경위도 값과 지역이름을 가져오기 위한 div -->

	<script>

		$(window).load(function(){  
			
			$('.area_name').eq(<%=currentLocal%>).css("color", "#5970AD");
			$('.area_name').eq(<%=currentLocal%>).css("border-bottom", "2px solid #5970AD");
			
			$('.area_name').eq(<%=currentLocal%>).css("color", "#5970AD");
			$('.area_name').eq(<%=currentLocal%>).css("border-bottom", "2px solid #5970AD");
			
			$('#header').css("height", $(window).innerWidth() * 0.12);
			$('.box_site').css("height", $(window).innerWidth() * 0.4);
			$('#container_site').css("height", $('.box_site').outerHeight(true) * <%=list.size()%>);
			$('#nav').css("height", $(window).innerWidth() * 0.1);
			
			$("#container_site").css("left", "0");
			$("#container_site").css("top", $("#header").outerHeight(true));
			
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
			
			$('#header').css("height", $(window).innerWidth() * 0.12);
			$('.box_site').css("height", $(window).innerWidth() * 0.4);
			$('#container_site').css("height", $('.box_site').outerHeight(true) * <%=list.size()%>);
			$('#nav').css("height", $(window).innerWidth() * 0.1);
			
			
			$("#container_site").css("left", "0");
			$("#container_site").css("top", $("#header").outerHeight(true));
			
			$("#nav").css("top", $("#container_site").outerHeight(true) + $("#header").outerHeight(true));
		});
		
		
		$('.area_name').click(function() {
			var index = $(this).index();
			var url = "SiteList.jsp?local=";
			
			switch( index )
			{
				case 0: break;
				case 1: url = url + "괴산군"; break;
				case 2: url = url + "단양군"; break;
				case 3: url = url + "보은군"; break;
				case 4: url = url + "영동군"; break;
				case 5: url = url + "옥천군"; break;
				case 6: url = url + "음성군"; break;
				case 7: url = url + "제천시"; break;
				case 8: url = url + "증평군"; break;
				case 9: url = url + "진천군"; break;
				case 10: url = url + "청주시"; break;
				case 11: url = url + "충주시"; break;
			}
			url += "&type=" + '<%=type%>' + "&page=1";
			location.href = url;
		});
		
		
		
		$('.box_site').click(function() {	
			if( <%=type.equals("review")%> ) // 후기에서 옴
			{				
				var temp = "<div class='site_title'>" + 
									"<b>" + $(this).find('.site_title').find('.site_name').text() + "</b>" +
									/* "<span class='arrow'>" +
										"<img src='IMAGES/next.svg' width='80%' />" +
									"</span>" + */
								  "</div>" +

			"<div class='site_img'>" +
				"<img src='" + $(this).find('.content').find('.site_img').find('.site_image_back').attr('src') + "' class='site_image_back'>" +
			"</div>" +

			"<div class='site_content'>" +
				"<img src='IMAGES/location.svg' class='location_img' />" +
				"<div class='site_info'>" +
					$(this).find('.site_content').find('.site_address').find('.site_info').text() + "<br>" +
				"</div>" +

				"<div class='site_like'>" +
					"<span class='like'>" + 
						"<img src='IMAGES/scrap.svg' style='width: 40%;'>" + 
						"<span class='like_cont'>" + $(this).find('.site_like').find('.like').eq(0).find('.like_cont').text() + "</span>" +
					 "</span>" +
					 
					 "<span class='like'>" +
					 	"<img src='IMAGES/like.svg' style='width: 40%;'>" +
						"<span class='like_cont'>" + $(this).find('.site_like').find('.like').eq(1).find('.like_cont').text() + "</span>" +
					"</span>" +
				"</div>" +
			"</div>";
				
				var text="<div class=\"canvas\"><img src='IMAGES/circle.svg' width='100%'/>  </div>";
				text += "<div class=\"box_site\" id=\""+this.id+"\">";
				text += temp + "</div><div class=\"site_line\"><img src='IMAGES/line.svg' width='100%'/> </div>";
				
				parent.addAreaBox(text, this.id);
				
				parent.$('#dynamic').toggle();
			}
			else if( <%=type.equals("around2")%> )	// 주변정보에서 옴
			{
				<%
				for( int i = 0; i < list.size(); i++ )
				{
				%>
				if( this.id == '<%=list.get(i).get("area_no")%>' )
				{
					$("#latitude").append('<%=list.get(i).get("latitude")%>');
					$("#longitude").append('<%=list.get(i).get("longitude")%>');
					$("#areaName").append('<%=list.get(i).get("name")%>');
				}
				<%
				}
				%>
				parent.selectedArea(this.id, $("#latitude").text(), $("#longitude").text(), $("#areaName").text());
				$("#latitude").empty();
				$("#longitude").empty();
				$("#areaName").empty();
			
				parent.$('#dynamic').toggle();
			}
			else	// site_detail 이동
				location.href = "SiteDetail.jsp?kind=area&area_no=" + $(this).attr("id");
		});
				
	</script>
	
</body>
</html>