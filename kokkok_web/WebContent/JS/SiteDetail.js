var map;
var isRecommend;
var isScrap;
var nickName = null;
var item_id;
var kind;
var ref;

$(document).ready(function(){
	$('#map_big').click(function() {
		var url = "MapBig.jsp?kind=" + kind + "&item_id=" + item_id;
		location.href = url;
	});
	
	$('#comment_show').click(function() {
		$('body').css("overflow", "hidden");
		$("#dynamic").slideToggle();
	});
	
	$('.icon').click(function(){
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
				var url = "Around.jsp?kind=" + kind + "&item_id=" + item_id;
				location.href = url;
			}
		}
		else
			alert('로그인이 필요한 서비스입니다.');
	});
});

function moveCourseDetail(course_no)
{
	var url = "CourseDetail.jsp?course_no=" + course_no + "&kind=course";
	location.href = url;
}

function closeComment()
{
	$('body').css("overflow", "auto");
	$("#dynamic").slideToggle();
}

function drawMap(areaName, latitude, longitude)
{
	// 지도를 표시할 div
	var mapContainer = document.getElementById('dt_map'), 
		mapOption = {
			center : new daum.maps.LatLng(latitude, longitude), // 지도의 중심좌표
			level : 8
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