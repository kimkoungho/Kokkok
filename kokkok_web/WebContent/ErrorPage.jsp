<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<title>오류</title>
	
	<script src="JS/jquery.js"></script>
	
	<style type="text/css">
		body {
			overflow: hidden;
			margin: 0;
			background-color: rgb(214, 219, 225);
		}
	
		.replace {
			position: absolute;
			left: 0;
			width: 100%;
		}
		.replace img {
			width: 100%;
			height: 100%;
		}
	</style>
</head>

<body>
	<div class="replace">
		<img src="IMAGES/replace.png">
	</div>
	
	
	<script>
		$(window).load(function () {
			
			var w = $(window).innerWidth();
			var h = $(window).innerHeight();
			
			$(".replace").css("height", w / 2);
			$(".replace").css("top", (h - w / 2) / 2);
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
			var w = $(window).innerWidth();
			var h = $(window).innerHeight();
			
			$(".replace").css("height", w / 2);
			$(".replace").css("top", (h - w / 2) / 2);
		});
	</script>
</body>
</html>