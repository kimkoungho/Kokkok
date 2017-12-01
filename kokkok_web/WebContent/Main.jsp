<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="Database.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String nickName = (String) session.getAttribute("userNickname");

	RecommendDatabase rd = new RecommendDatabase();
	AreaDatabase ad = new AreaDatabase();
	ImageDatabase id = new ImageDatabase();

	ArrayList<HashMap<String, Object>> best_list = rd.getBestInfo("area", "");
	//System.out.println(best_list);
	for (int i = 0; i < best_list.size(); i++) {
		HashMap<String, Object> hash = best_list.get(i);
		String area_no = (String) hash.get("item_id");
		String name = (String) ad.getAreaInfo(area_no).get("name");
		String image = (String) id.getImageURLList("area", area_no).get(0);

		best_list.get(i).put("area_no", area_no);
		best_list.get(i).put("area", area_no.substring(0, 2));
		best_list.get(i).put("name", name);
		best_list.get(i).put("image", image);
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
	<!-- [if lt IE 9] -->
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<!-- [endif] -->
	<script type="text/javascript"
		src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
	<script type="text/javascript"
		src="http://netdna.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
	
	<link href="lib/jquery.bxslider.css" rel="stylesheet" />
	<!-- <script type="text/javascript" src="JS/slide.js"></script>
		<script type="text/javascript" src="JS/slide2.js"></script> -->
	<link href="lib/jquery.bxslider.css" rel="stylesheet" />
	<link rel="stylesheet" href="CSS/Main.css" />
	<script src="JS/jquery.js"></script>
	<!-- <script src="JS/bootstrap_wrap.js"></script> -->
	<script src="JS/jquery.masonry.min.js"></script>
	<script src="dist/js/swiper.min.js"></script>
	<link rel="stylesheet" href="dist/css/swiper.min.css">
	<script src="JS/Main.js" type="text/javascript"></script>
	<title>메인</title>
</head>

<body>

	<div id="fullcarousel" data-interval="3000" class="carousel slide"
		data-ride="carousel">
		<div class="carousel-inner">
			<div class="item">
				<img src="IMAGES/main01.jpg" width="100%">
				<div class="carousel-caption">
					<div class="head_title">충북의 명소</div>
					<div class="head_cont">충북 여행을 계획하고 있다면?</div>
					<div class="bt">
						<a href="SiteList.jsp?page=1">명소 정보 보기</a>
					</div>
				</div>
			</div>
			<div class="item active">
				<img src="IMAGES/main07.jpg" width="100%">
				<div class="carousel-caption">
					<div class="head_title">충북 여행 코스</div>
					<div class="head_cont">추천 여행 코스가 궁금하다면?</div>
					<div class="bt">
						<a href="CourseMain.jsp?page1=1&page2=1">코스 정보 보기</a>
					</div>
				</div>
			</div>
			<div class="item">
				<img src="IMAGES/main11.jpg" width="100%">
				<div class="carousel-caption">
					<div class="head_title">충북 여행기</div>
					<div class="head_cont">여행지에 대한 후기가 궁금하다면?</div>
					<div class="bt">
						<a href="ReviewMain.jsp">여행기 보기</a>
					</div>
				</div>
			</div>
			<div class="item">
				<img src="IMAGES/main10.jpg" width="100%">
				<div class="carousel-caption">
					<div class="head_title">주변정보 찾기</div>
					<div class="head_cont">여행에 유용한 주변 정보를 찾는다면?</div>
					<div class="bt">
						<a href="Around.jsp?kind=default">주변정보 찾기</a>
					</div>
				</div>
			</div>

		</div>
		<a class="left carousel-control" href="#fullcarousel"
			data-slide="prev"><i class="icon-prev fa fa-angle-left"></i></a> <a
			class="right carousel-control" href="#fullcarousel" data-slide="next"><i
			class="icon-next fa fa-angle-right"></i></a>
	</div>

	
	<div class="area_title"><img src="IMAGES/title_bar.png" width="3%" style="float: left; margin-right: 2%;">지역별 명소</div>
		<div class="content">
			<div id="course_title">
				<div class="siteline_1" id="up">
					<div class="toursite_1" style="margin-left: 11%">
						<img src="IMAGES/main_area/area01.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area02.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area03.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area04.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area05.png" />
					</div>
				</div>
				<div class="siteline_2" id="down">
					<div class="toursite_1" style="margin-left: 2.5%;">
						<img src="IMAGES/main_area/area06.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area07.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area08.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area09.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area10.png" />
					</div>
					<div class="toursite_1">
						<img src="IMAGES/main_area/area11.png" />
					</div>
				</div>
			</div>

		</div>
	<div class="area_title"><img src="IMAGES/title_bar.png" width="3%" style="float: left; margin-right: 2%;">다가오는 축제 정보</div>
	<div id="carousel2" data-interval="6000" class="carousel slide"
		data-ride="carousel">
		<div class="carousel-inner">
			<div class="item">
				<div class="review_img"
							style="background-image: url('IMAGES/festival/festival02.svg');">
							<img src="IMAGES/festival/festival-default.png" width="100%"/>
						</div>
			</div>
			<div class="item active">
				<div class="review_img"
							style="background-image: url('IMAGES/festival/festival03.svg');">
							<img src="IMAGES/festival/festival-default.png" width="100%"/>
						</div>
			</div>
			<div class="item">
				<div class="review_img"
							style="background-image: url('IMAGES/festival/festival04.svg');">
							<img src="IMAGES/festival/festival-default.png" width="100%"/>
						</div>
			</div>
			<div class="item">
				<div class="review_img"
							style="background-image: url('IMAGES/festival/festival05.svg');">
							<img src="IMAGES/festival/festival-default.png" width="100%"/>
						</div>
			</div>

		</div>
		<a class="left carousel-control" href="#carousel2"
			data-slide="pre"><i class="icon-prev fa fa-angle-left"></i></a> <a
			class="right carousel-control" href="#carousel2" data-slide="next"><i
			class="icon-next fa fa-angle-right"></i></a>
	</div>
		
		<div class="footer">
			<div class="area_title"><img src="IMAGES/title_bar.png" width="3%" style="float: left; margin-right: 2%;">BEST 명소</div>
			<div class="foot_wrap">

				<%
					for (int i = 0; i < best_list.size(); i++) {
						String image = (String) best_list.get(i).get("image");
				%>
				<div class="foot-slide" id='<%=best_list.get(i).get("area_no")%>'>
					<div class="foot_head">
						<div class="foot_area_name"><%=best_list.get(i).get("area")%></div>
					</div>
					<div class="foot_like">
						<img src="IMAGES/like.svg" class="like_img" />
						<div class="like_text"><%=best_list.get(i).get("recommendCount")%></div>
					</div>
					<div class="foot_tit"><%=best_list.get(i).get("name")%></div>
					<div class="foot_img">
						<img src="IMAGES/transparency.png" class="foot_img2"
							style="background-image: url('<%=image%>');">
					</div>
				</div>
				<%
					}
				%>

			</div>

		</div>



		<script>
			var main_swiper = new Swiper('.main', {
				nextButton : '.swiper-button-next',
				prevButton : '.swiper-button-prev',
				spaceBetween : 30,
				autoplay : 5500
			});
		</script>
</body>
</html>