var map;
var kind;
var type;
var centerLatitude;
var centerLongitude;

var areaNo;
var areaNames;
var areaLatitude;
var areaLongitude;
var areaCount;

function drawMap(areaName, latitude, longitude)
{
	// 지도를 표시할 div
	var mapContainer = document.getElementById('dt_map'), 
		mapOption = {
			center : new daum.maps.LatLng(latitude, longitude), // 지도의 중심좌표
			level : 5
			// 	지도의 확대 레벨
	}
	
	// 지도를 생성합니다
	map = new daum.maps.Map(mapContainer, mapOption);

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
	map.setCenter(coords);
}

function transformLocation(latitude, longitude)	// 좌표계 변환
{
	var pr_3857 = new Tmap.Projection("EPSG:3857");
	var pr_4326 = new Tmap.Projection("EPSG:4326"); // wgs84
	
	var lonlat = new Tmap.LonLat(longitude, latitude).transform(pr_4326, pr_3857);
	
	return lonlat;
}

function markMap(areaName, latitude, longitude)
{
	if( kind.includes("course") )
	{
		markerLayer = new Tmap.Layer.Markers("MarkerLayer");
		map.addLayer(markerLayer);
		
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

function initRouteMap()
{
	var startPosition;
	var endPosition;
	var passList = "";
	
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
	if( kind.includes("course") )
	{
		var passList = "";
	
		for( var i = 0; i < areaNo.length; i++ )
			passList += areaLatitude[i] + "," + areaLongitude[i] + "-";
		
		var url = "AroundProc.jsp?passList=" + passList + "&distance=4&type=course";
		
		$.get(url, function(data) {
	        var JSONData = $.parseJSON(data);
	        var localData = JSONData;
	        
	        for( var i = 0; i < localData.around.length; i++ )
	    	{
	        	var tempKind = localData.around[i].kind;
	        	var areaName = localData.around[i].name;
	        	var latitude = localData.around[i].latitude;
	        	var longitude = localData.around[i].longitude;
	        	
	        	if( tempKind == type )
	        		markMap(areaName, latitude, longitude);
	    	}
	        
	       /* var coords = new daum.maps.LatLng(centerLatitude, centerLongitude);
	        	
	    	map.setCenter(coords);*/
	    });
		
	}
	else
	{
//		var url = "AroundProc.jsp?latitude=" + latitude + "&longitude=" + longitude + "&distance=4&type=" + loadType;
		var url = "AroundProc.jsp?latitude=" + latitude + "&longitude=" + longitude + "&distance=4";
		
		$.get(url, function(data) {
	        var JSONData = $.parseJSON(data);
	        var localData = JSONData;
	        
	        for( var i = 0; i < localData.around.length; i++ )
	    	{
	        	var tempKind = localData.around[i].kind;
	        	var areaName = localData.around[i].name;
	        	var latitude = localData.around[i].latitude;
	        	var longitude = localData.around[i].longitude;
	        	
	        	if( tempKind == type )
	        		markMap(areaName, latitude, longitude);
	    	}
	        
	        var coords = new daum.maps.LatLng(centerLatitude, centerLongitude);
	        	
	    	map.setCenter(coords);
	    });
	}
}