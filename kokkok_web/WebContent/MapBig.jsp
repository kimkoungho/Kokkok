<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*" %>
<%@ page errorPage="ErrorPage.jsp" %>
<%
	request.setCharacterEncoding("utf-8");

	String kind = request.getParameter("kind");
	String item_id = request.getParameter("item_id");
	String routeURLs = request.getParameter("routeURL");
	String latitude = request.getParameter("latitude");
	String longitude = request.getParameter("longitude");
	String routeDate = request.getParameter("routeDate");
	String type = request.getParameter("type");
	String []routeURL = null;
	
	AroundDatabase ard = new AroundDatabase();
	AreaDatabase ad = new AreaDatabase();
	RestaurantDatabase rtd = new RestaurantDatabase();
	AccommodationDatabase acd = new AccommodationDatabase();
	ShoppingDatabase sd = new ShoppingDatabase();
	CourseDatabase cd  = new CourseDatabase();
	
	ArrayList<HashMap<String, Object>> list = null; // list = new ArrayList<HashMap<String, Object>> ();
	HashMap<String, Object> map = null;
	
	String centerLon = null;
	String centerLat = null;
	String url = null;
	String route = null;
	
	if( kind.equals("course") )
	{
		routeURL = routeURLs.split("-");
		
		url = "https://apis.skplanetx.com/tmap/routes?version=1&format=xml&";
		
		centerLon = routeURL[0].split("=")[1];
		centerLat = routeURL[1].split("=")[1];
		
		for( int i = 0; i < routeURL.length; i++ )
			url += routeURL[i] + "&";

		url += "appKey=e10a67d6-add9-31f0-a944-933fcb536922";
	}
	else if( kind.contains("around") )
	{
		if( kind.contains("current") )
		{
			map = new HashMap<String, Object> ();
			map.put("name", "현재 위치");
			map.put("latitude", Double.parseDouble(latitude));
			map.put("longitude", Double.parseDouble(longitude));
		}
		else if( kind.contains("course") )
		{
			map = cd.getCourseInfo(item_id);
		}
		else
		{
			if( kind.contains("area") )
				map = ad.getAreaInfo(item_id);
			else if( kind.contains("restaurant") )
				map = rtd.getRestaurantInfo(item_id);
			else if( kind.contains("accommodation") )
				map = acd.getAccommodationInfo(item_id);
			else if( kind.contains("shopping") )
				map = sd.getShoppingInfo(item_id);
		}
	}
	else
	{
		if( kind.equals("area") )
			map = ad.getAreaInfo(item_id);
		else if( kind.equals("restaurant") )
			map = rtd.getRestaurantInfo(item_id);
		else if( kind.equals("accommodation") )
			map = acd.getAccommodationInfo(item_id);
		else if( kind.equals("shopping") )
			map = sd.getShoppingInfo(item_id);
	}
%>

<!doctype html>

<html>
<head>
	<meta charset="utf-8">
	<title>지도 크게보기</title>

	<script src="//apis.daum.net/maps/maps3.js?apikey=a7a2302448b878aba762a21dd0317d72&libraries=services"></script>
	<script src="https://apis.skplanetx.com/tmap/js?version=1&format=xml&appKey=e10a67d6-add9-31f0-a944-933fcb536922"></script>
	
	<script src="JS/jquery.js"></script>
	<script src="JS/MapBig.js"></script>
	<!-- <script src="JS/site_detail.js"></script>
	<script src="JS/course_detail2.js"></script> -->
</head>

<body>
	<div id="dt_map" style="width: 100%;"></div>
	
	<script>
		$(window).load(function() {
			
			$('#dt_map').css('height', window.innerHeight);
			
			kind = '<%=kind%>';
			type = '<%=type%>';
			
			<%
			if( kind.equals("course") )
			{
			%>
			map = new Tmap.Map({div: 'dt_map',
				width: "100%",
				height: window.innerHeight + 'px',
				transitionEffect: "resize",
		        animation: true
		    });
			
			var centerLon = <%=centerLon%>;
			var centerLat = <%=centerLat%>;
			var routeURL = '<%=url%>';
			
			var routeFormat = new Tmap.Format.KML({extractStyles:true, extractAttributes:true});
			
			var prtcl = new Tmap.Protocol.HTTP({
                url: routeURL,
                format:routeFormat
            });

			var routeLayer = new Tmap.Layer.Vector("route", {protocol:prtcl, strategies:[new Tmap.Strategy.Fixed()]});
			routeLayer.events.register("featuresadded", routeLayer, onDrawnFeatures);
			map.addLayer(routeLayer);
			
			map.setCenter(new Tmap.LonLat(centerLon, centerLat), 10);

			<%
			}
			else if( kind.contains("around") )
			{
				if( kind.contains("current") )
				{
			%>
					centerLatitude = <%=map.get("latitude")%>;
					centerLongitude = <%=map.get("longitude")%>;
					drawMap('<%=map.get("name")%>', <%=map.get("latitude")%>, <%=map.get("longitude")%>);
					getAroundInfo(<%=map.get("latitude")%>, <%=map.get("longitude")%>);
			<%
				}
				else if( kind.contains("course") )
				{
			%>
			areaLatitude = new Array();
			areaLongitude = new Array();
			areaNames = new Array();
			areaNo = new Array();
			areaCount = 0;
			<%
					String []routeList = ((String)map.get("route")).split("-");
					String []dateRouteList = routeList[Integer.parseInt(routeDate) - 1].split(",");
					
					for( int i = 0; i < dateRouteList.length; i++ )
					{
						HashMap<String, Object> tempMap = ad.getAreaInfo(dateRouteList[i]);
			%>
						areaLatitude[areaCount] = <%=tempMap.get("latitude")%>;
						areaLongitude[areaCount] = <%=tempMap.get("longitude")%>;
						areaNames[areaCount] = '<%=tempMap.get("name")%>';
						areaNo[areaCount++] = '<%=tempMap.get("area_no")%>';
			<%
					}
			%>
					initRouteMap();
					getAroundInfo(0, 0);
			<%
				}
				else
				{
			%>
					centerLatitude = <%=map.get("latitude")%>;
					centerLongitude = <%=map.get("longitude")%>;
					drawMap('<%=map.get("name")%>', <%=map.get("latitude")%>, <%=map.get("longitude")%>);
					getAroundInfo(<%=map.get("latitude")%>, <%=map.get("longitude")%>);
			<%
				}
			}
			else
			{
			%>
			centerLatitude = <%=map.get("latitude")%>;
			centerLongitude = <%=map.get("longitude")%>;
			drawMap('<%=map.get("name")%>', <%=map.get("latitude")%>, <%=map.get("longitude")%>);
			getAroundInfo(<%=map.get("latitude")%>, <%=map.get("longitude")%>);
			<%
			}
			%>
		});
		$(window).resize(function() {
			$('#dt_map').css('height', window.innerHeight);
		});
	</script>
	
</body>
</html>