<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	String kind = request.getParameter("kind");
	String item_id = request.getParameter("item_id");
	String routeDate = request.getParameter("routeDate");

	
	AroundDatabase ard = new AroundDatabase();
	AreaDatabase ad = new AreaDatabase();
	RestaurantDatabase rtd = new RestaurantDatabase();
	AccommodationDatabase acd = new AccommodationDatabase();
	ShoppingDatabase sd = new ShoppingDatabase();
	CourseDatabase cd = new CourseDatabase();
	
	HashMap<String, Object> map = null;
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>> ();
		
	if( kind.equals("area") )
		map = ad.getAreaInfo(item_id);
	else if( kind.equals("restaurant") )
		map = rtd.getRestaurantInfo(item_id);
	else if( kind.equals("accommodation") )
		map = acd.getAccommodationInfo(item_id);
	else if( kind.equals("shopping") )
		map = sd.getShoppingInfo(item_id);
	else if( kind.equals("course") )
		map = cd.getCourseInfo(item_id);
	else
	{
		map = new HashMap<String, Object> ();
		map.put("latitude", null);
		map.put("longitude", null);
		map.put("name", null);
	}
		
	if( nickName != null )
	{
		ArrayList<HashMap<String, Object>> tempList1 = cd.getMyCourseInfo(nickName);
		
		for( int i = 0; i < tempList1.size(); i++ )
		{
			HashMap<String, Object> tempMap = tempList1.get(i);
			
			String []routeList = ((String)tempMap.get("route")).split("-");
			ArrayList<ArrayList<HashMap<String, Object>>> tempList2 = new ArrayList<ArrayList<HashMap<String, Object>>> ();
			HashMap<String, Object> myCourseMap = new HashMap<String, Object> ();
			
			for( int j = 0; j < routeList.length; j++ )
			{
				String []dateRouteList = routeList[j].split(",");
				ArrayList<HashMap<String, Object>> tempList3 = new ArrayList<HashMap<String, Object>> ();
				
				for( int k = 0; k < dateRouteList.length; k++ )
					tempList3.add(ad.getAreaInfo(dateRouteList[k]));
				
				tempList2.add(tempList3);
			}
			myCourseMap.put("course_no", tempMap.get("course_no"));
			myCourseMap.put("name", tempMap.get("name"));
			myCourseMap.put("routeList", tempList2);
			
			list.add(myCourseMap);
		}
	}

%>

<!doctype html>
<html>

<head>
	<meta charset="utf-8">
	<title>주변 정보 보기</title>

	<script src="https://apis.skplanetx.com/tmap/js?version=1&format=xml&appKey=e10a67d6-add9-31f0-a944-933fcb536922"></script>
	<script src="//apis.daum.net/maps/maps3.js?apikey=a7a2302448b878aba762a21dd0317d72&libraries=services"></script>
	<script src="JS/jquery.js"></script>
	<script src="JS/jquery.masonry.min.js"></script>
	<script src="dist/js/swiper.min.js"></script>
	<script src="JS/Around.js"></script>
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="dist/css/swiper.min.css">
	<link rel="stylesheet" href="CSS/Around.css">
</head>

<body>
	<div id="wrap">
		<div class="nav">
			<div class="menu1"> 현재 위치로 찾기 </div>
			<div class="menu2"> 주변 정보 설정 </div>
		</div>
		
		<div id="header" style="display: none;">
			<div class="ckbox">
				<input type="checkbox" id="checkMC">
				<label for="checkMC" class="contC"> &nbsp;&nbsp; 나의 코스 정보로 찾기 </label>
			</div>
		
			<select name="MC_select" class="selectBox" disabled>
				<option value="default" selected="selected"> 만든 코스가 없습니다. </option>
			</select>

			<select name="MC_day" class="selectBox" disabled>
				<option value="default" selected="selected"> 일정이 없습니다. </option>
			</select>
			
			<div class="ckbox">
				<input type="checkbox" id="checkTI">
				<label for="checkTI" class="contC"> &nbsp;&nbsp; 명소 주변 찾기 </label>
				
				<div class="area_selectBtn">
					<input type="button" value="명소 불러오기"  disabled="disabled" onclick="selectArea()">
				</div>
				
				<div class="area_content"></div>
			</div>

			<input type="button" value="찾   기" class="searchBtn" onclick="searchAroundInfo();">
		</div>
	</div>
	
	<div class="wrap_location">
		<div class="set_location" style="border-bottom:1px solid #e0e0e0">
			<img src="IMAGES/marker.svg">
			<span class="location_info"> 위치 정보 </span>
			<span class="location_info2"> 첫 로드시 현재 위치 값 뿌려주기 / 허용안하면 빈칸 </span>
		</div>
		
		<div class="set_location">
			<img src="IMAGES/target.svg">
			<span class="location_info"> 설정된 주변 위치 </span>
			<span class="location_info2"> 현재 위치 </span> 
		</div>
	</div>
	
	<div class="weather">
		<div class="weather_title"> 날씨 정보  </div>
		<div class="weather_info_sub"> ( ! ) 현재 날짜 기준으로 3일 간의 데이터만 제공됩니다. </div>
	
		<div class="swiper-container foot">
			<div class="swiper-wrapper all">
				<div class="swiper-slide box">
					<div class="weather_location">
						<img src="IMAGES/location.svg"> 
						<div class="weather_area"></div>
					</div>
					
					<%
					for( int i = 0; i < 3; i++ )
					{
					%>
					
					<div class="weather_cont">
						<div class="foot_head">
							<div class="date"></div>
							<div class="weather_info">
								<div class="foot_like">
									<img src="IMAGES/bx_loader.gif">
								</div>
							
								<div class="weather_detail">
									<div class="detail_info"></div>
									<div class="detail_info"></div>
									<div class="detail_info"></div>							
								</div>
							</div>
						</div>
					</div>
					
					<%
					}
					%>
					
				</div>
			</div>
			
			<div class="swiper-pagination pagi"></div>
		</div>
	</div>
	
	<div class="footer">
		<div class="tab_menu">
			<div class="tab">
				<div class="tab_title"><b> 명소 </b></div>
			</div>
			
			<div class="tab">
				<div class="tab_title"><b> 음식점 </b></div>
			</div>
			
			<div class="tab">
				<div class="tab_title"><b> 숙박 </b></div>
			</div>
			
			<div class="tab">
				<div class="tab_title"><b> 쇼핑 </b></div>
			</div>
			
			<div class="tab">
				<div class="tab_title"><b> WIFI </b></div>
			</div>
		</div>
		
		<div class="tab_content">
			<div class="map" id="dt_map"></div>
			<div class="map_plus">
				<input type="button" class="map_big" value="+ 지도 크게 보기" onclick="showMapBig()">
				<input type="button" class="content_more" value="내용 자세히 보기  >" onclick="goAroundList()"> 
			</div>
		</div>
	</div>
	
	<iframe src="SiteList.jsp?type=around2&page=1" id="dynamic" style="display:none" name="dynamic"></iframe>
	
	<script>
	
		function showMapBig()
		{
			var tempType;
			
			if( searchType != 'default' )
				tempType = "around_" + searchType;
			else
				tempType = "around_" + loadType;
			
			if( tempType.includes("default") )
				tempType = "around_current";
			
			var url;
			
			if( tempType.includes("course") )
				url = "MapBig.jsp?kind=" + tempType + "&item_id=" + item_id + "&routeDate=" + routeDate + "&type=" + kind;
			else if( tempType.includes("current") )
				url = "MapBig.jsp?kind=" + tempType + "&latitude=" + areaLatitude + "&longitude=" + areaLongitude + "&type=" + kind;
			else
				url = "MapBig.jsp?kind=" + tempType + "&item_id=" + item_id + "&type=" + kind;
			
			location.href = url;
		}
		
		function goAroundList()
		{
			var url;
			
			if( searchType != 'course' )
			{
				if( loadType != 'course' )
					url = "AroundList.jsp?item_id=" + item_id + "&latitude=" + areaLatitude + "&longitude=" + areaLongitude + "&page=1";
				else
					url = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&type=course&page=1";
			}
			else
				url = "AroundList.jsp?item_id=" + item_id + "&routeDate=" + routeDate + "&type=course&page=1";
			
			location.href = url;
		}
	
		function setComboBox()
		{
			var str = "<option value='default' selected='selected'> 나의 코스를 선택하세요 </option>";
			
			<%
			for( int i = 0; i < list.size(); i++ )
			{
			%>
			
			str += "<option id='<%=list.get(i).get("course_no")%>' value='<%=(i + 1)%>'> " + '<%=list.get(i).get("name")%>' + " </option>";
			<%
			}
			%>
			
			$(".selectBox").eq(0).empty();
			$(".selectBox").eq(0).append(str);
		}
		
		$(".selectBox").eq(0).change(function() {
			
			if( this.value != "default" )
			{
				<%
				for( int i = 0; i < list.size(); i++ )
				{
				%>
				if( this.value - 1 == <%=i%> )
				{
					var str = "<option value='default' selected='selected'> 일정을 선택하세요. </option>";
					<%
					HashMap<String, Object> tempMap = list.get(i);
					ArrayList<ArrayList<HashMap<String, Object>>> tempList = (ArrayList<ArrayList<HashMap<String, Object>>>)tempMap.get("routeList");
				
					for( int j = 0; j < tempList.size(); j++ )
					{
					%>
						str += "<option value='<%=(j + 1)%>'> " +  '<%=(j + 1)%> 일차' + " </option>"; 
					<%
					}
					%>
					$(".selectBox").eq(1).empty();
					$(".selectBox").eq(1).append(str);
				}
				<%
				}
				%>
			}
			else
				$(".selectBox").eq(1).find(".option").eq(0).attr("selected", "selected");
		});
		
		function searchAroundInfo()
		{
			if( $("#checkMC").is(":checked") == false && $("#checkTI").is(":checked") == false )
				alert("찾을 정보를 선택하세요.");
			else
			{
				if( $("#checkMC").is(":checked") == true )
				{
					if( $(".selectBox option:selected").eq(0).val() == "default" || $(".selectBox option:selected").eq(1).val() == "default" )
						alert('코스 내용을 확인하세요.');
					else
					{
						item_id = $(".selectBox option:selected").eq(0).attr("id");
						routeDate = $(".selectBox option:selected").eq(1).val();
						
						$(".menu1").css('background-color', '#f0f0f0');
						$(".menu1").css('color', '#999999');
			            $(".menu2").css('background-color', '#2D4B71');
			            $(".menu2").css('color', '#ffffff');
						var str = "<img src='IMAGES/target.svg'><span class='location_info'> 설정된 주변 위치 </span> <span class='location_info2'> 나의 코스 > ";
						
						str += $(".selectBox option:selected").eq(0).text();
						str += "</span>"
						$(".set_location").eq(1).empty();
						$(".set_location").eq(1).append(str);
						
						$('#header').slideToggle();
						
						searchType = 'course';
						searchCourse();
						$(".tab_title").eq(0).trigger('click');
					}
				}
				else
				{
					if( $(".area_content").text() == "" )
						alert("지역을 선택하세요.");
					else
					{
						item_id = tempAreaNo;
						
						$(".menu1").css('background-color', '#f0f0f0');
						$(".menu1").css('color', '#999999');
			            $(".menu2").css('background-color', '#2D4B71');
			            $(".menu2").css('color', '#ffffff');
			            
						var str = "<img src='IMAGES/target.svg'><span class='location_info'> 설정된 주변 위치 </span> <span class='location_info2'>";
						
						str += $(".area_content").eq(0).text();
						str += "</span>"
						$(".set_location").eq(1).empty();
						$(".set_location").eq(1).append(str);
						
						$('#header').slideToggle();
						
						areaLatitude = tempLatitude;
						areaLongitude = tempLongitude;
						areaNames = tempAreaName;
						
						searchType = 'area';
						
						$(".tab_title").eq(0).trigger('click');
						
						// drawMap(areaNames);
						
						weatherData = new Array();
						
						requestCount = 1;
						currentRequestCount = 0;
						drawWeather(1);
						getWeatherInfo(areaLatitude, areaLongitude);
						
						getAroundInfo(areaLatitude, areaLongitude);
						
						str = "<img src='IMAGES/location.svg'>";
						str += "<div class='weather_area'>" + $(".area_content").eq(0).text() + "</div>";
						
						$(".weather_location").eq(0).empty();
						$(".weather_location").eq(0).append(str);
						
					}
				}
			}
		}		
	
		$(window).load(function() {
			
			$('.footer').css('height', $(window).innerWidth() * 1.0);
			
			loadType = '<%=kind%>';
			item_id = '<%=item_id%>';
			routeDate = <%=routeDate%>;
			
			if( <%=nickName != null%> )
				nickName = '<%=nickName%>';
	
			var tempLatitude;
			var tempLongitude;
			var tempName;
			
			if( <%=nickName != null %> )
				setComboBox();
			
			if( <%=!kind.equals("default") && !kind.equals("course")%> )
			{
				tempLatitude = <%=map.get("latitude")%>;
				tempLongitude = <%=map.get("longitude")%>;
				tempName = '<%=map.get("name")%>';
			}
			
			if( loadType == "default" )
			{
				areaNames = "현재 위치";
				getCurrentLocation();	// 현재gps위치 좌표로 가져옴
			}
			else if( loadType == "area" )
			{
				areaLatitude = tempLatitude;
				areaLongitude = tempLongitude;
				
				areaNames = tempName;
				
				drawMap(tempName);
				weatherData = new Array();
				getWeatherInfo(areaLatitude, areaLongitude);
				
				getAroundInfo(areaLatitude, areaLongitude);
			}
			else if( loadType == "restaurant" )
			{
				areaLatitude = tempLatitude;
				areaLongitude = tempLongitude;
				
				areaNames = tempName;
				
				drawMap(tempName);
				weatherData = new Array();
				getWeatherInfo(areaLatitude, areaLongitude);
				
				getAroundInfo(areaLatitude, areaLongitude);
			}
			else if( loadType == "accommodation" )
			{
				areaLatitude = tempLatitude;
				areaLongitude = tempLongitude;
				
				areaNames = tempName;
				
				drawMap(tempName);
				weatherData = new Array();
				getWeatherInfo(areaLatitude, areaLongitude);
				
				getAroundInfo(areaLatitude, areaLongitude);
			}
			else if( loadType == "shopping" )
			{
				areaLatitude = tempLatitude;
				areaLongitude = tempLongitude;
				
				areaNames = tempName;
				
				drawMap(tempName);
				weatherData = new Array();
				getWeatherInfo(areaLatitude, areaLongitude);
				
				getAroundInfo(areaLatitude, areaLongitude);
			}
			else if( loadType == "course" )
			{
				searchCourse();
				searchType = 'course';
				initRouteMap();
				getAroundInfo(0, 0);
				
				weatherData = new Array();
				
			}
			
			/* $('.select_status1').eq(0).css('visibility', 'visible'); */
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
			$('.footer').css('height', $(window).innerWidth() * 1.0);
		});
		
	    var foot_swiper = new Swiper('.foot', {
	        pagination: '.swiper-pagination', 
	        paginationClickable: true ,
	        spaceBetween: 30,
	        grabCursor: true
	    });
	    
	    function searchCourse()
	    {
	    	areaLatitude = new Array();
			areaLongitude = new Array();
			areaNames = new Array();
			areaNo = new Array();
			areaCount = 0;
			
			if( searchType != 'course' )
			{
				<%
				if( kind.equals("course") )
				{
					String []dateRouteList = ((String)map.get("route")).split("-")[Integer.parseInt(routeDate) - 1].split(",");
					
				%>
			drawWeather(<%=dateRouteList.length%>);
			requestCount = <%=dateRouteList.length%>;
			currentRequestCount = 0;
			searchType = "course";
				<%
					for( int i = 0; i < dateRouteList.length; i++ )
					{
						HashMap<String, Object >tempMap = ad.getAreaInfo(dateRouteList[i]);	
				%>
				$(".weather_area").eq(<%=i%>).append('<%=tempMap.get("name")%>');
				getWeatherInfo(<%=tempMap.get("latitude")%>, <%=tempMap.get("longitude")%>);
				
				areaLatitude[areaCount] = <%=tempMap.get("latitude")%>;
				areaLongitude[areaCount] = <%=tempMap.get("longitude")%>;
				areaNames[areaCount] = '<%=tempMap.get("name")%>';
				areaNo[areaCount++] = '<%=tempMap.get("area_no")%>';
				<%
					}
				}
				%>
			}
			else
			{
				<%
				for( int i = 0; i < list.size(); i++ )
				{
				%>
				
				if( $(".selectBox option:selected").eq(0).val() == <%=(i + 1)%> )
				{
					<%
					ArrayList<ArrayList<HashMap<String, Object>>> tempList3 = (ArrayList<ArrayList<HashMap<String, Object>>>)list.get(i).get("routeList");
				
					for( int j = 0; j < tempList3.size(); j++ )
					{
					%>
					
					if( $(".selectBox option:selected").eq(1).val() == <%=(j + 1)%> )
					{
						<%
						ArrayList<HashMap<String, Object>> tempList2 = tempList3.get(j);
						%>
						drawWeather(<%=tempList2.size()%>);
						requestCount = <%=tempList2.size()%>;
						currentRequestCount = 0;
						searchType = "course";
						<%
						for( int k = 0; k < tempList2.size(); k++ )
						{
						%>
							$(".weather_area").eq(<%=k%>).append('<%=tempList2.get(k).get("name")%>');
							getWeatherInfo(<%=tempList2.get(k).get("latitude")%>, <%=tempList2.get(k).get("longitude")%>);
							
							areaNo[areaCount] = '<%=tempList2.get(k).get("area_no")%>';
							areaNames[areaCount] = '<%=tempList2.get(k).get("name")%>';
							areaLatitude[areaCount] = <%=tempList2.get(k).get("latitude")%>;
							areaLongitude[areaCount++] = <%=tempList2.get(k).get("longitude")%>;
						<%
							}
						%>
					}
					<%
					}
					%>
				}
				<%
				}
				%>
			}
			drawMap("");
	    }
	</script>
</body>

</html>