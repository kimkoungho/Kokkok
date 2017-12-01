var map;
var markerLayer;
var requestCount;
var currentRequestCount = 0;
var weatherData;
var searchType = 'default';
var nickName = null;

var areaLatitude;
var areaLongitude;
var areaNames;
var areaNo;

var centerLatitude;
var centerLongitude;

var localData;
var loadType;

var tempLatitude;
var tempLongitude;
var tempAreaName;
var tempAreaNo;

var kind = 'area';
var routeDate;
var item_id;


function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            alert("User denied the request for Geolocation.");
            break;
        case error.POSITION_UNAVAILABLE:
            alert("Location information is unavailable.");
            break;
        case error.TIMEOUT:
            alert("The request to get user location timed out.");
            break;
        case error.UNKNOWN_ERROR:
            alert("An unknown error occurred.");
            break;
    }
}

function success(position)
{
	var currentLocationLatitude  = position.coords.latitude;
	var currentLocationLongitude = position.coords.longitude;
	
	areaLatitude = currentLocationLatitude;
	areaLongitude = currentLocationLongitude;
	
	alert(areaLatitude+'');
	
	kind = 'area';
	$(".tab_title").eq(0).trigger('click');
	// drawMap('현재 위치');

	
	weatherData = new Array();
	getWeatherInfo(currentLocationLatitude, currentLocationLongitude);
	
	getAroundInfo(currentLocationLatitude, currentLocationLongitude);
}

function error()
{
	alert('사용자의 위치를 찾을 수 없습니다.');
}
function getCurrentLocation()
{
//	if( !navigator.geolocation )
//	{
//		alert('사용자의 브라우저는 지오로케이션을 지원하지 않습니다.');
//	    return;
//    }
//	else
//	{
//		navigator.geolocation.getCurrentPosition(success, showError);
//	}
	
	window.Android.requestGPS();
	
}
function androidCall(lati, longi){
	
	var currentLocationLatitude  = Number(lati);
	var currentLocationLongitude = Number(longi);
	
	areaLatitude = currentLocationLatitude;
	areaLongitude = currentLocationLongitude;
	
	// alert(currentLocationLatitude+".."+currentLocationLongitude);
	// alert('바꿧어요..');
	kind = 'area';
	$(".tab_title").eq(0).trigger('click');
	
	weatherData = new Array();
	getWeatherInfo(currentLocationLatitude, currentLocationLongitude);
	getAroundInfo(currentLocationLatitude, currentLocationLongitude);
}

function markMap(areaName, latitude, longitude)
{
	if( searchType == "course" )
	{
		var size = new Tmap.Size(24, 35);
		var offset = new Tmap.Pixel(-(size.w/2), -size.h);
		
		var iconHtml = new Tmap.IconHtml('<img src="https://developers.skplanetx.com/upload/tmap/marker/pin_b_m_a.png"/>' , size, offset);
		
		var marker = new Tmap.Marker(transformLocation(latitude, longitude), iconHtml); 
		
		markerLayer.addMarker(marker);
	}
	else
	{
		var coords = new daum.maps.LatLng(latitude, longitude);
	
		// 결과값으로 받은 위치를 마커로 표시합니다
		var marker = new daum.maps.Marker({
			map : map,
			position : coords
		});
		
		// 인포윈도우로 장소에 대한 설명을 표시합니다
		var infowindow = new daum.maps.InfoWindow({
			content : '<div style="width:150px;text-align:center;padding:6px 0;">'
					+ areaName + '</div>'
		});
	
		infowindow.open(map, marker);
	
		// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
//		map.setCenter(coords);
	}
}

function drawMap(areaName)
{	
	if( searchType == 'course' )
	{
		initRouteMap();
		getAroundInfo(0, 0);
	}
	else
	{
		$("#dt_map").remove();
		$(".tab_content").prepend("<div class='map' id='dt_map'></div>");
		
		var mapContainer = document.getElementById('dt_map');
		var mapOption = {
			center : new daum.maps.LatLng(areaLatitude, areaLongitude), // 지도의 중심좌표
			level : 7
			// 	지도의 확대 레벨
		};
		
		// 지도를 생성합니다
		map = new daum.maps.Map(mapContainer, mapOption);
		
		centerLatitude = areaLatitude;
		centerLongitude = areaLongitude;
		
		markMap(areaName, areaLatitude, areaLongitude);
	}
}

function getDate(gap)
{
//	  var week = new Array('일', '월', '화', '수', '목', '금', '토');
	  var today = new Date();
	  var today2 = new Date(today.valueOf() + gap * (24*60*60*1000));
//	  var year = today2.getFullYear();
	  var month = today2.getMonth() + 1;
	  var day = today2.getDate();
//	  var dayName = week[today2.getDay()];
	  
	  return (month + "월 " + day + "일");
}
function getTime()
{
	var now = new Date();
	var hour = now.getHours();
	
	return hour;
}

function getWeatherInfo(latitude, longitude)
{	
	var urlStr = "http://apis.skplanetx.com/weather/forecast/3days?version=1&lat=" + latitude + "&lon=" + longitude + "&appKey=5e7282f7-2847-3675-9545-c546b7bc5ff1";
//	var urlStr = "http://apis.skplanetx.com/weather/forecast/3days?version=1&lat=" + latitude + "&lon=" + longitude + "&appKey=e10a67d6-add9-31f0-a944-933fcb536922";
//	var urlStr = "http://apis.skplanetx.com/weather/forecast/3days?version=1&lat=" + latitude + "&lon=" + longitude + "&appKey=883b4e13-4bbb-3a73-9d52-f6e9e80ff91e" // dong-su-lee
	
	ajaxManager.addReq({
		type: "get"
		,queue: true
		,async: false
		,dataType: "json"
		,url: urlStr
		,success: function(json) {
			weatherData[currentRequestCount] = json;
			currentRequestCount++;
			
			if( requestCount == currentRequestCount )
			{
				for( var i = 0; i < requestCount; i++ )
				{					
					var icon1 = weatherData[i].weather.forecast3days[0].fcst3hour.sky.code4hour;
					var icon2 = weatherData[i].weather.forecast3days[0].fcst3hour.sky.code28hour;
					var icon3 = weatherData[i].weather.forecast3days[0].fcst3hour.sky.code52hour;
					
					var weather1 = weatherData[i].weather.forecast3days[0].fcst3hour.sky.name4hour;
					var weather2 = weatherData[i].weather.forecast3days[0].fcst3hour.sky.name28hour;
					var weather3 = weatherData[i].weather.forecast3days[0].fcst3hour.sky.name52hour;
					
					var rain1 = weatherData[i].weather.forecast3days[0].fcst3hour.precipitation.prob4hour;
					var rain2 = weatherData[i].weather.forecast3days[0].fcst3hour.precipitation.prob28hour;
					var rain3 = weatherData[i].weather.forecast3days[0].fcst3hour.precipitation.prob52hour;
					
					var max1 = weatherData[i].weather.forecast3days[0].fcstdaily.temperature.tmax1day;
					var max2 = weatherData[i].weather.forecast3days[0].fcstdaily.temperature.tmax2day;
					var max3 = weatherData[i].weather.forecast3days[0].fcstdaily.temperature.tmax3day;
					
					var min1 = weatherData[i].weather.forecast3days[0].fcstdaily.temperature.tmin1day;
					var min2 = weatherData[i].weather.forecast3days[0].fcstdaily.temperature.tmin2day;
					var min3 = weatherData[i].weather.forecast3days[0].fcstdaily.temperature.tmin3day;
					
					if( rain1 == "" ) 	
						rain1 = "-";
					else
						rain1 = Math.round(rain1) + "%";
					
					if( rain2 == "" ) 	
						rain2 = "-";
					else
						rain2 = Math.round(rain2) + "%";
					
					if( rain3 == "" ) 	
						rain3 = "-";
					else
						rain3 = Math.round(rain3) + "%";
				
					if( max1 == "" ) 
						max1 = "-";
					else
						max1 = Math.round(max1) + "℃";
					
					if( max2 == "" ) 
						max2 = "-";
					else
						max2 = Math.round(max2) + "℃";
					
					if( max3 == "" ) 
						max3 = "-";
					else
						max3 = Math.round(max3) + "℃";
				
					if( min1 == "" ) 
						min1 = "-";
					else
						min1 = Math.round(min1) + "℃";
					
					if( min2 == "" ) 
						min2 = "-";
					else
						min2 = Math.round(min2) + "℃";
					
					if( min3 == "" ) 
						min3 = "-";
					else
						min3 = Math.round(min3) + "℃";
					
					var now = getTime();
					
					if( searchType == "current" || searchType == "default" )
					{
						var city = weatherData[i].weather.forecast3days[0].grid.city;
						var county = weatherData[i].weather.forecast3days[0].grid.county;
						var village = weatherData[i].weather.forecast3days[0].grid.village;
						
						var str = "<img src='IMAGES/location.svg'>";
						str += "<div class='weather_area'>" + city + " " + county + " " + village + "</div>";
						
						$(".weather_location").eq(0).empty();
						$(".weather_location").eq(0).append(str);
						
						str = "<img src='IMAGES/marker.png'>";
						str += "<span class='location_info'> 위치 정보 " + "</span><span class='location_info2'> " + city + " " + county + " " + village;
						str += "</span>"
						$(".set_location").eq(0).empty();
						$(".set_location").eq(0).append(str);
					}
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").children(".date").eq(0).empty();
					$(".box").eq(i).children(".weather_cont").children(".foot_head").children(".date").eq(0).append(" 오늘 / " + getDate(0) + "");
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".date").eq(1).empty();
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".date").eq(1).append(" 내일 / " + getDate(1) + "");
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".date").eq(2).empty();
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".date").eq(2).append(" 모레 / " + getDate(2) + "");
					
					var iconName = ["SKY_S00", "SKY_S01", "SKY_S02", "SKY_S03", "SKY_S04",
						"SKY_S05", "SKY_S06", "SKY_S07", "SKY_S08", "SKY_S09",
						"SKY_S10", "SKY_S11", "SKY_S12", "SKY_S13", "SKY_S14"];
					
					var iconFileName = ["38.png", "01.png-08.png", "02.png-09.png", "03.png-10.png", "12.png-40.png",
						"13.png-41.png", "14.png-42.png", "18.png", "21.png", "32.png",
						"04.png", "29.png", "26.png", "27.png", "28.png"];
					
					for( var j = 0; j < iconName.length; j++ )
					{
						if( icon1 == iconName[j] ) icon1 = iconFileName[j];
						if( icon2 == iconName[j] ) icon2 = iconFileName[j];
						if( icon3 == iconName[j] ) icon3 = iconFileName[j];
					}
					
					if( icon1.length == 7 || icon1.length == 0 ) icon1 = iconFileName[0];
					if( icon2.length == 7 || icon2.length == 0 ) icon2 = iconFileName[0];
					if( icon3.length == 7 || icon3.length == 0 ) icon3 = iconFileName[0];
					
					if( icon1.split("-").length == 2 )
					{
						if( now > 2 && now < 15 )
							icon1 = icon1.split("-")[0];
						else
							icon1 = icon1.split("-")[1];
					}
					if( icon2.split("-").length == 2 )
					{
						if( now > 2 && now < 15 )
							icon2 = icon2.split("-")[0];
						else
							icon2 = icon2.split("-")[1];
					}
					if( icon3.split("-").length == 2 )
					{
						if( now > 2 && now < 15 )
							icon3 = icon3.split("-")[0];
						else
							icon3 = icon3.split("-")[1];
					}
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".foot_like").eq(0).find("img").attr("src", "IMAGES/weather_icon/" + icon1);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".foot_like").eq(1).find("img").attr("src", "IMAGES/weather_icon/" + icon2);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".foot_like").eq(2).find("img").attr("src", "IMAGES/weather_icon/" + icon3);
				
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").find(".detail_info").empty();
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(0).find(".detail_info").eq(0).append("최고 " + max1);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(0).find(".detail_info").eq(1).append("최저 " + min1);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(0).find(".detail_info").eq(2).append("강수 " + rain1);
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(1).find(".detail_info").eq(0).append("최고 " + max2);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(1).find(".detail_info").eq(1).append("최저 " + min2);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(1).find(".detail_info").eq(2).append("강수 " + rain2);
					
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(2).find(".detail_info").eq(0).append("최고 " + max3);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(2).find(".detail_info").eq(1).append("최저 " + min3);
					$(".box").eq(i).children(".weather_cont").children(".foot_head").find(".weather_info").children(".weather_detail").eq(2).find(".detail_info").eq(2).append("강수 " + rain3);
				}
			}
		}
	});
}

var ajaxManager = (function() {
    var requests = [];

    return {
       addReq:  function(opt) {
           requests.push(opt);
       },
       removeReq:  function(opt) {
           if( $.inArray(opt, requests) > -1 )
               requests.splice($.inArray(opt, requests), 1);
       },
       run: function() {
           var self = this,
               oriSuc;

           if( requests.length ) {
               oriSuc = requests[0].complete;

               requests[0].complete = function() {
                    if( typeof(oriSuc) === 'function' ) oriSuc();
                    requests.shift();
                    self.run.apply(self, []);
               };   

               $.ajax(requests[0]);
           } else {
             self.tid = setTimeout(function() {
                self.run.apply(self, []);
             }, 100);
           }
       },
       stop:  function() {
           requests = [];
           clearTimeout(this.tid);
       }
    };
}());

function drawWeather(count)
{
	$(".foot").remove();
	
	var weather_content = "<div class='swiper-container foot'>" +
											"<div class='swiper-wrapper all'>";
	
	for( var i = 0; i < count; i++ )
	{
		var str = "<div class='swiper-slide box'>" +
							"<div class='weather_location'>" +
								"<img src='IMAGES/location.svg'>" + 
								"<div class='weather_area'></div>" +
							"</div>";
		
		for( var j = 0; j < 3; j++ )
		{
			str += "<div class='weather_cont'>" +
							"<div class='foot_head'>" +
								"<div class='date'></div>" + 
								"<div class='weather_info'>" + 
									"<div class='foot_like'>" + 
										"<img src='IMAGES/bx_loader.gif' width='50%'>" +
									"</div>" + 
									"<div class='weather_detail'>" + 
										"<div class='detail_info'></div>" + 
										"<div class='detail_info'></div>" + 
										"<div class='detail_info'></div>" +
									"</div>" +
								"</div>" + 
							"</div>" +
						"</div>";
		}
		str += "</div>";

		weather_content += str;
	}
	
	weather_content += "</div>" +
									"<div class='swiper-pagination pagi'></div>" +
								"</div>";
	
	$(".weather").append(weather_content);
	
	var foot_swiper = new Swiper('.foot', {
        pagination: '.swiper-pagination', 
        paginationClickable: true ,
        spaceBetween: 30,
        grabCursor: true
    });
}

function selectArea()
{
	$(".footer").slideToggle();
	
	$("#dynamic").slideToggle();
	$('body').css("overflow", "hidden");
	
	$(".area_content").empty();
}

function selectedArea(area_no, latitude, longitude, area_name)
{
	var localName = area_no.split("_")[0];
	
	$(".area_content").append(localName + " > " + area_name);

	tempLatitude = latitude;
	tempLongitude = longitude;
	tempAreaName = area_name;
	tempAreaNo = area_no;
	
	$('body').css("overflow", "auto");
	$(".footer").slideToggle();
}

$(document).ready(function () {

	requestCount = 1;
	ajaxManager.run();
	
	$(".tab").click(function() {	
		var index = $(".tab").index(this);
		
		if( index == 0 )		// 명소
			kind = 'area';
		else if( index == 1 )		// 음식점
			kind = 'restaurant';
		else if( index == 2 )		// 숙박
			kind = 'accommodation';
		else if( index == 3 )		// 쇼핑
			kind = 'shopping';
		else if( index == 4 )		// WIFI
			kind = 'wifi';
		
		if( loadType != 'course' || searchType != 'course' )
		{
			drawMap(areaNames);
			getAroundInfo(areaLatitude, areaLongitude);
		}
		else
		{
			// initRouteMap();
		
			markerLayer.clearMarkers();
			getAroundInfo(0, 0);
			
		}
	});
	
	$(".ckbox").eq(0).click(function() {
		if( $("#checkMC").is(":disabled") )
			alert("You need login");
	});
	
	$("#checkMC").click(function() {
		$("#checkTI").attr("checked", false);
		$(".area_content").empty();
		$('.area_selectBtn input').attr("disabled", "disabled");
		$('.area_selectBtn input').css("background-color", "#dfdfdf");
		$('.area_selectBtn input').css("color", "#999999");
		
		if( nickName == null )
		{
			alert("로그인이 필요한 서비스입니다.");
			$(this).removeAttr("checked");
			$(this).attr("checked", false);
		}
		
		if( !this.checked )
		{
			$('.selectBox').attr("disabled", "disabled");
			$('.selectBox').css("background-color", "#dfdfdf");
			$('.selectBox').css("color", "#999999");
		}
		else
		{
			$(".selectBox").eq(0).find("option").eq(0).text("나의 코스를 선택하세요");
			$(".selectBox").eq(1).empty();
			
			var str = "<option value='default' selected='selected'> 일정이 없습니다. </option>";
			
			$(".selectBox").eq(1).append(str);
			
			$(".selectBox option").removeAttr("selected");
			$($(".selectBox option")[0]).attr("selected", "selected");
			$('.selectBox').removeAttr("disabled");
			$('.selectBox').css("background-color", "white");
			$('.selectBox').css("color", "#686868");
		}
	});
	
	$("#checkTI").click(function() {
		$("#checkMC").attr("checked", false);
		$('.selectBox').attr("disabled", "disabled");
		$('.selectBox').css("background-color", "#dfdfdf");
		$('.selectBox').css("color", "#999999");
		
		if( !this.checked )
		{
			$('.area_selectBtn input').attr("disabled", "disabled");
			$('.area_selectBtn input').css("background-color", "#dfdfdf");
			$('.area_selectBtn input').css("color", "#999999");
			$(".area_content").empty();
		}
		else
		{
			$('.area_selectBtn input').removeAttr("disabled");
			$('.area_selectBtn input').css("background-color", "white");
			$('.area_selectBtn input').css("color", "#686868");
		}
	});
	
    $(".menu2").click(function () {
		$('#header').slideToggle();
    });
    $(".menu1").click(function () {
        if ($(this).hasClass("on"))
        {
            $(this).parent().siblings("#header").hide();
            $(this).css('background-color', '#2D4B71');
            $(this).css('color', '#ffffff');
            $(".menu2").css('background-color', '#f0f0f0');
            $(".menu2").css('color', '#999999');
            $(this).removeClass("on");
        }
        else
        {
            $(this).parent().siblings("#header").hide();
            $(this).css('background-color', '#2D4B71');
            $(this).css('color', '#ffffff');
            $(".menu2").css('background-color', '#f0f0f0');
            $(".menu2").css('color', '#999999');
            $(this).removeClass("on");
        }
        
        drawWeather(1);
		requestCount = 1;
		currentRequestCount = 0;
		searchType = "current";
		areaNames = "현재 위치";
		getCurrentLocation();	// 현재gps위치 좌표로 가져옴
    });
    
    $(".tab_title").eq(0).css("color","#2D4B71");
    $(".tab_title").eq(0).css("border-bottom","3px solid #2D4B71");
    
    $(".tab_title").click(function(){
    	$(".tab_title").css("color","#424242");
    	$(".tab_title").css("border-bottom","3px solid #FFFFFF");
    	$(this).css("color","#2D4B71");
    	$(this).css("border-bottom","3px solid #2D4B71");
    });
});

function transformLocation(latitude, longitude)	// 좌표계 변환
{
	var pr_3857 = new Tmap.Projection("EPSG:3857");
	var pr_4326 = new Tmap.Projection("EPSG:4326"); // wgs84
	
	var lonlat = new Tmap.LonLat(longitude, latitude).transform(pr_4326, pr_3857);
	
	return lonlat;
}

function initRouteMap()
{
	var startPosition;
	var endPosition;
	var passList = "";
	
	$("#dt_map").remove();
	$(".tab_content").prepend("<div class='map' id='dt_map'></div>");
	
	map = new Tmap.Map({div: 'dt_map',
		width: "100%",
		transitionEffect: "resize",
        animation: true
    });
	
	for( var i = 0; i < areaLatitude.length; i++ )
	{
		var lonlat = transformLocation(areaLatitude[i], areaLongitude[i]);
		
		if( i == 0 )
			startPosition = lonlat;
		else if( i == areaLatitude.length - 1 )
			endPosition = lonlat;
		else
		{
			passList += lonlat.lon + "," + lonlat.lat;
			
			if( i < areaLatitude.length - 1 )
				passList += ",0,0,0_";
			else
				passList += ",0,G,0";
		}
	}
	
	var routeFormat = new Tmap.Format.KML({extractStyles:true, extractAttributes:true});
	
	var appKey = 'e10a67d6-add9-31f0-a944-933fcb536922';
    var urlStr = "https://apis.skplanetx.com/tmap/routes?version=1&format=xml";
    
    urlStr += "&startX="+ startPosition.lon;
    urlStr += "&startY="+ startPosition.lat;
    urlStr += "&endX="+ endPosition.lon;
    urlStr += "&endY="+ endPosition.lat;
	urlStr += "&passList=" + passList;
    urlStr += "&appKey="+ appKey;
    
    var prtcl = new Tmap.Protocol.HTTP({
        url: urlStr,
        format:routeFormat
    });
    
	var routeLayer = new Tmap.Layer.Vector("route", {protocol:prtcl, strategies:[new Tmap.Strategy.Fixed()]});
	
	routeLayer.events.register("featuresadded", routeLayer, onDrawnFeatures);
	map.addLayer(routeLayer);
}

//경로 그리기 후 해당영역으로 줌
function onDrawnFeatures(e) {
    map.zoomToExtent(this.getDataExtent());
}

function getAroundInfo(latitude, longitude)
{
	if( searchType == 'course' )
	{
		var passList = "";
	
		for( var i = 0; i < areaNo.length; i++ )
			passList += areaLatitude[i] + "," + areaLongitude[i] + "-";
		
		var url = "AroundProc.jsp?passList=" + passList + "&distance=4&type=course";
		
		markerLayer = new Tmap.Layer.Markers("MarkerLayer");
		map.addLayer(markerLayer);
		
		$.get(url, function(data) {
	        var JSONData = $.parseJSON(data);
	        localData = JSONData;
	        
	        for( var i = 0; i < localData.around.length; i++ )
	    	{
	        	var tempKind = localData.around[i].kind;
	        	var areaName = localData.around[i].name;
	        	var latitude = localData.around[i].latitude;
	        	var longitude = localData.around[i].longitude;
	        	
	        	if( tempKind == kind )
	        		markMap(areaName, latitude, longitude);
	    	}
	        
	        /*var coords = new daum.maps.LatLng(centerLatitude, centerLongitude);
	        	
	    	map.setCenter(coords);*/
	    });
		
	}
	else
	{
//		var url = "AroundProc.jsp?latitude=" + latitude + "&longitude=" + longitude + "&distance=4&type=" + loadType;
		var url = "AroundProc.jsp?latitude=" + latitude + "&longitude=" + longitude + "&distance=4";
		
		$.get(url, function(data) {
	        var JSONData = $.parseJSON(data);
	        localData = JSONData;
	        
	        for( var i = 0; i < localData.around.length; i++ )
	    	{
	        	var tempKind = localData.around[i].kind;
	        	var areaName = localData.around[i].name;
	        	var latitude = localData.around[i].latitude;
	        	var longitude = localData.around[i].longitude;
	        	
	        	if( tempKind == kind )
	        		markMap(areaName, latitude, longitude);
	    	}
	        
	        var coords = new daum.maps.LatLng(centerLatitude, centerLongitude);
	        	
	    	map.setCenter(coords);
	    });
	}
}
