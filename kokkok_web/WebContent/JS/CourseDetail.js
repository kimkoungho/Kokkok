var dateNo = new Array();
var areaNo = new Array();
var areaName = new Array();
var areaLatitude = new Array();
var areaLongitude = new Array();
var areaImage = new Array();
var recommendCount = new Array();
var routeInfo = new Array();

var routeData = new Array();
var urlData = new Array();
var distances = new Array();
var times = new Array();

var dateCount = 0;
var currentIndex = 0;	// 현재 화면에 표시되는 일차 코스의 인덱스
var ctx;	// canvas의 context

var centerLonlat;
var map;

var nickName = null;
var item_id;
var routeDate = 1;
var isRecommend;
var isScrap;

$(document).on("click", ".area", function() {
	var url = "SiteDetail.jsp?area_no=" + $(this).attr("id") + "&kind=" + kind;
	location.href = url;
});

$(document).ready(function() {
	
	$('.icon').click(function() {
		var menu=$(this).index();
		
		if( nickName != null )
		{
			//로그인 정보 확인
			if(menu == 0)	//추천
			{ 
				if( isRecommend == 'true' )
					alert('이미 추천하셨습니다.');
				else
				{
					var url = "DetailProc.jsp?ref=" + ref + "&type=recommend&kind=" + kind + "&item_id=" + item_id;
					location.replace(url);
					alert('추천했습니다.');
				}
			}
			else if(menu == 1)	//스크랩
			{
				if( isScrap == 'true' )
					alert('이미 스크랩하셨습니다.');
				else
				{
					var url = "DetailProc.jsp?ref=" + ref + "&type=scrap&kind=" + kind + "&item_id=" + item_id;
					location.replace(url);
					alert('스크랩했습니다.');
				}
			}
			else if(menu == 2)	//의견 남기기
			{
				$('body').css("overflow", "hidden");
				$("#dynamic").slideToggle();
			}
			else if(menu == 3)	//주변 정보
			{
				location.href = "Around.jsp?kind=course&item_id=" + item_id + "&routeDate=" + routeDate;
			}
		}
		else
			alert('로그인이 필요한 서비스입니다.');
	});
	
	$('#comment_show').click(function() {
		$('body').css("overflow", "hidden");
		$("#dynamic").slideToggle();
	});
});

function closeComment()
{
	$('body').css("overflow", "auto");
	$("#dynamic").slideToggle();
}

function mapOpen()
{
	$('#map').slideToggle();
}

function transformLocation(latitude, longitude)	// 좌표계 변환
{
	var pr_3857 = new Tmap.Projection("EPSG:3857");
	var pr_4326 = new Tmap.Projection("EPSG:4326"); // wgs84
	
	var lonlat = new Tmap.LonLat(longitude, latitude).transform(pr_4326, pr_3857);
	
	return lonlat;
}

//경로 정보 로드
function searchRoute(startX, startY, endX, endY, passList, currentDate)
{
	var appKey = 'e10a67d6-add9-31f0-a944-933fcb536922';
    var urlStr = "https://apis.skplanetx.com/tmap/routes?version=1&format=xml";
    
    var url;

    urlStr += "&startX="+ startX;
    urlStr += "&startY="+ startY;
    urlStr += "&endX="+ endX;
    urlStr += "&endY="+ endY;
	urlStr += "&passList=" + passList;
    urlStr += "&appKey="+ appKey;
    
    url = "startX=" + startX + "-startY=" + startY + "-endX=" + endX + "-endY=" + endY + "-passList=" + passList;
    
    urlData[currentDate] = url;
    
    ajaxManager.addReq({
    		type: "get"
			,queue: true
			,async: false
			,dataType: "xml"
			,url: urlStr
			,success: function(xml) {
				routeData[currentDate] = xml;
				
				if( dateCount - 1 == currentDate )
				{
					var count = 0;
					
					for( var i = 0; i < dateCount; i++ )
					{
						var type = "";
						var distance = 0;
						var time = 0;
						
						var placeMark = $(routeData[i]).find("Placemark");
						
						$(placeMark).each(function() {
							if( ($(this).find("pointType").text().includes("B") || $(this).find("pointType").text().includes("E"))&& !type.includes($(this).find("pointType").text()) )
							{
								type += $(this).find("pointType").text();
				
								distances[count] = distance;
								times[count++] = time;
						
								distance = 0;
								time = 0;
							}
							else if( $(this).find("nodeType").text().includes("LINE") )
							{
								distance += parseInt($(this).find("distance").text());
								time += parseInt($(this).find("time").text());
							}
						});
					}
					viewCourse();
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

function routeInfoInit()
{
	var currentDate = -1;
	var startPosition;
	var endPosition;
	var passList;
	var routeCnt;
	
	ajaxManager.run();
	
	for( var i = 0; i < dateNo.length; i++ )
	{
		if( currentDate < dateNo[i] || i == dateNo.length - 1 )
		{	
			if( currentDate > -1 )
			{
				if( i < dateNo.length - 1 )
				{
					endPosition = transformLocation(areaLatitude[i - 1], areaLongitude[i - 1]);
				
					if( routeCnt == 2 )
						passList = "";
					else
					{
						var arr = passList.split(",0,0,0_");
						passList = passList.substring(0, passList.length - arr[arr.length - 2].length - 14);
						passList += ",0,G,0";
					}
				}
				else
				{
					endPosition = transformLocation(areaLatitude[i], areaLongitude[i]);
					
					if( routeCnt == 1 )
						passList = "";
					else
					{
						var arr = passList.split(",0,0,0_");
						passList = passList.substring(0, passList.length - arr[arr.length - 1].length - 7);
						passList += ",0,G,0";
					}
				}
				dateCount++;
				searchRoute(startPosition.lon, startPosition.lat, endPosition.lon, endPosition.lat, passList, currentDate);
			}
			currentDate = dateNo[i];
			startPosition = transformLocation(areaLatitude[i], areaLongitude[i]);
			passList = "";
			routeCnt = 1;
		}
		else
		{
			var lonlat = transformLocation(areaLatitude[i], areaLongitude[i]);
			passList += lonlat.lon + "," + lonlat.lat + ",0,0,0_";
			routeCnt++;
		}
	}
}

function setLayers()
{
	var context = {
			getColor: 
				function(feature)
				{
					var color = '#aaaaaa';

					if ( feature.attributes.clazz && feature.attributes.clazz == 4) 
						color = '#ee0000';

					else if( feature.cluster )
					{
						var onlyFour = true;

						for(var i = 0; i < feature.cluster.length; i++)
						{
							if( onlyFour && feature.cluster[i].attributes.clazz != 4 )
								onlyFour = false;
						}
						
						if( onlyFour == true )
							color = '#ee0000';
					}
					return color;
				}
	};

	var style = new Tmap.Style({
		pointRadius: 5,
		fillColor: "${getColor}",
		fillOpacity: 1,
		strokeColor: "#FF0000",
		strokeWidth: 2,
		strokeOpacity: 1,
		graphicZIndex: 1
	}, {
			context: context
	});

	var v_option = {renderers: ['Canvas', 'SVG', 'VML'], styleMap:style};
	kmlLayer = new Tmap.Layer.Vector("kml", v_option);
	markers = new Tmap.Layer.Markers("MarkerLayer");
	map.addLayer(kmlLayer);
	map.addLayer(markers);	
}

function initTmap()
{
	// centerLL = new Tmap.LonLat(startX, startY);

	map = new Tmap.Map({div: 'dt_map',
		width: "100%",
		height: window.innerHeight * 0.5 + 'px',
		transitionEffect: "resize",
        animation: true
    });
	
	setLayers();
	
	for( var i = 0; i < dateNo.length; i++ )
	{
		if( dateNo[i] == currentIndex )
		{
			centerLonlat = transformLocation(areaLatitude[i], areaLongitude[i]);
		
			var kmlForm = new Tmap.Format.KML({extractStyles:true, extractAttributes:true}).read(routeData[currentIndex]);	
			
			for( var j = 0; j < kmlForm.length; j++ )
				kmlLayer.addFeatures([kmlForm[j]]);

			kmlLayer.events.register("featuresadded", kmlLayer, onDrawnFeatures);	// 줌 때문에 지도들의 확대level이 다름
			
//			setTimeout(stop, 500)

			break;
		}
	}
   	map.setCenter(centerLonlat, 10);
};
//경로 그리기 후 해당영역으로 줌
function onDrawnFeatures(e){
    map.zoomToExtent(this.getDataExtent());
}

function viewCourse()
{
	var str = "<div class='canvas'></div>" + 
				"<div id='detail'>";
	
	var routeCount = 0;
	var imageLoadingCount = 0;
	
	var imageHeight = $(window).outerWidth() * 0.3;
	
	for( var i = 0; i < dateNo.length; i++ )
	{	
		if( dateNo[i] == currentIndex )
		{
			str += "<div class='area' id='" + areaNo[i] +"'>" +
							"<div class='area_name'>" + 
								" <div class='area_content'>" +
									" <div class='site_area'>" +
									areaNo[i].split("_")[0] +
									"</div>" +
								"</div>" +
								"<div class='site_name'>" + 
									areaName[i] +
								"</div>" +
							"</div>" +
							
							"<div class='area_img'>" + 
								"<img height='" + imageHeight + "px' class='area_image' src='"+ areaImage[i] + "'>" + 
							"</div>" + 
							" <div class='site_like'>" +
								"<img src='IMAGES/like.svg' width='10%'>" +
								"<div class='icon_text2'>" +
								recommendCount[i] +
								"</div>" +
							"</div>" +
						"</div>";
			
			routeCount++;
		}
		else if( dateNo[i] > currentIndex )
			break;
	}
	
	str += "</div>";
	
	// course의 내용을 로드하기 전에 모든 자식내용을 지우고 로드
	$('#course').empty();
	$('#course').append(str).find('img').load(function() {
		// canvas 그리기 관련 부분
		
		imageLoadingCount++;
			
		if( imageLoadingCount == routeCount )
		{
			var w = $('.canvas').outerWidth();
//			var h = $('.area').outerHeight(true) * (routeCount - 1) + $('.area_name').outerHeight(true);
			var h = $('.area').outerHeight(true) * routeCount;
			
			$('.canvas').append("<canvas id='canvas' width='" + w + "px' height='" + h +"px'> 해당 브라우저는 canvas를 지원하지 않습니다.</canvas>");
	
			drawCanvas(routeCount);
		}
	});
	
	var s = "<div class='map_box'>" + 
			"<img src='IMAGES/location.svg' class='icon_image3' />" +
			"<span class='map_click' onclick=mapOpen()>경로 지도 보기</span><div class='plus' onclick=goAround()>+ 주변 정보 보기</div></div><div id='map'><div id='dt_map'></div><div class='plus_box' onclick='javascript:posting()'>지도 크게 보기</div></div>";
	
	$('#mapView').empty();
	$('#mapView').append(s);
	
	initTmap();
	
	$('#map').hide();	
}

function goAround()
{
	location.href = "Around.jsp?kind=course&item_id=" + item_id + "&routeDate=" + routeDate;
	
	return true;
}

function posting()
{
	location.href = "MapBig.jsp?kind=course&routeURL=" + urlData[currentIndex];
}

function drawCanvas(routeCount)
{
	var canvas = document.getElementById('canvas');
	ctx = canvas.getContext("2d");
	
	var r = $('.area_content').outerHeight() / 2;
	var l = $('.area').outerHeight(true) -  r;
	var w = canvas.width * 0.5;
	var h = (l - r) * 2 / 3;
	
	var x = canvas.width * 0.9;
	var y = r + 4;
	
	var tempCount = 0;
	
	for( var i = 0; i < dateNo.length; i++ )
	{
		if( dateNo[i] < currentIndex )
			tempCount++;
		else
			break;
	}
	
	if( currentIndex > 0 )
		tempCount--;
	
	for( var i = tempCount; i < tempCount + routeCount; i++ )
	{
		y += r;
		
		if( i - tempCount + 1 < routeCount )
		{
			ctx.font="bold 3vw arial";
			var lineHeight = ctx.measureText(' ').width * 7.5;
			
			var imageObj = new Image();
			imageObj.src = 'IMAGES/car.svg';
			
			drawLine(x, y, l - r);
//			drawRect(canvas.width * 0.08, y + (l - r) / 6, w+25, h);
			// drawText('자동차', canvas.width * 0.13, y + ((l - r) / 6) + lineHeight*1.5);
			ctx.drawImage(imageObj, canvas.width * 0.28, y + ((l - r) / 6) + lineHeight, lineHeight * 2, lineHeight);
			drawText('거리 : 약 ' + Math.round(distances[i] / 1000) + 'km', canvas.width * 0.12, y + ((l - r) / 6) + lineHeight * 3.5) ;
			drawText('시간 : 약 ' + Math.round(times[i] / 60) + '분', canvas.width * 0.12, y + ((l - r) / 6) + lineHeight * 4.5);
			
		}
		y += l;
	}
	
	var r = $('.area_content').outerHeight() / 2;
	var l = $('.area').outerHeight(true) -  r;
	var w = canvas.width * 0.5;
	var h = (l - r) * 2 / 3;
	
	var x = canvas.width * 0.9;
	var y = r + 4;
	for( var i = 0; i < routeCount; i++ )
	{
		drawCircle(x, y, r);
		y += r;
		y += l;
	}
}

function drawLine(x, y, l)
{
	ctx.beginPath();
	ctx.strokeStyle = "#D8D8D8";
    ctx.moveTo(x, y);
    ctx.lineTo(x, y + l);
    ctx.lineWidth = 4;
    ctx.stroke();
}

function drawCircle(x, y, r)
{
	ctx.beginPath();
    ctx.arc(x, y, r, 0, 2 * Math.PI, true);
	ctx.fillStyle = "#3D5A8D";
    ctx.fill();
    ctx.strokeStyle = "#F1F1F1";
    ctx.linewidth = 4;
    ctx.stroke();
}

function drawRect(x, y, w, h)
{
	ctx.strokeStyle = "#F1F1F1";
	ctx.linewidth = 1;
	ctx.fillStyle = "#F9F9F9";
    ctx.fillRect(x, y, w, h);
    ctx.rect(x, y, w, h);
    ctx.stroke();
}

function drawText(text, x, y)
{
	ctx.font="bold 3.5vw arial";
	ctx.fillStyle = "#505050";
	ctx.fillText(text, x, y);
}