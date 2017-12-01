<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="ErrorPage.jsp" %>
    
<%
	request.setCharacterEncoding("utf-8");

	String nickName=(String)session.getAttribute("userNickname");
	
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("review");
	
%>

<!doctype html>
<html>
<head>
   <title>후기 작성하기</title>
    <!-- 반응형 임포트 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!-- [if lt IE 9] -->
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <!-- [endif] -->
    <!-- 동수 꺼-->
    <!-- <link href="lib/jquery.bxslider.css" rel="stylesheet" /> -->
    <link rel="stylesheet" href="dist/CSS/swiper.min.css">
    <title></title>
    <!-- 여기 있어야 실행됨 반응형 -->
    <script src="JS/jquery.js"></script>
    <script src="JS/jquery.masonry.min.js"></script>
    <script src="dist/js/swiper.min.js"></script>
    <script src="dist/js/moment.min.js"></script>
   <script src="dist/js/jquery.daterangepicker.js"></script>
   
    <link rel="stylesheet" href="dist/css/daterangepicker.css" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.12.0/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
    
    <link rel="stylesheet" href="CSS/ReviewMake.css"/>
    <script src="JS/ReviewMake.js"></script>
</head>
<body> 
   
   
   <div id="head">
            <!-- <button id="cancel_btn">취소</button> -->
            <input type="button" id="cancel_btn" value="취소"/>
            <span id="title">여행기 작성</span>
            <!-- <button id="save_btn">저장</button> -->
            <input type="button" id="save_btn" value="저장"/>
    </div>
    
     <!-- <form name="mainForm" action="ReviewMakeProc.jsp" method="post" encType="multipart/form-data">  -->
    
     <div id="container">
            <div id="content">
                <div class="default">
                    <div class="default_img"  style="background-image:url('IMAGES/review_default.svg')">
                        <img src="IMAGES/transparency.png" class="default_image" onClick="$('#file_default').click();"/>
                    </div>
                    <div class="re_title">
                        <input type="text" id="review_title" placeholder="나의 여행기 제목을 입력해주세요"  name="review_title"/>
                    </div>
                    <div class="toggle_tag_list">
                     <span class="tag_list" id="add_tag"># 태그</span>
                  </div>
                  <div class="toggle_input_tag" style="display:none">
                     <input type="text" class="tag_content" placeholder="# 태그"/>
                     <input type="button" class="tag_btn" value="추가"/>
                  </div>
                    <div class="date">
                        <img src="IMAGES/calendar.svg" id="date-range23" class="date_icon">
                        <span id="date-range-text"></span>
                        <input type="text" style="display:none" name="review_term"/>
                    </div>
                </div>
            
         <div class="total_review_wrap">
               <div class="day_review">
                  <div class="date_bar">
                     <div class="review_date">1일차</div>
                  </div>
                  
                      <div class="canvas">
                          <img src="IMAGES/circle.svg" width="100%"/>    
                          </div>
                         <input type="button" class="area_add_btn" value="+ 명소 추가하기"/>
                    		
                    <!-- <button class="area_add_btn">+ 명소 추가하기</button> -->
               </div>
                
            </div>
        </div>
   </div>
   <div id='toggle'>
   
   </div>
   
   <!-- </form> -->
   <!-- <div id="dynamic" style="display:none"> -->
      <iframe src="SiteList.jsp?local=&type=review&page=1" id="dynamic" style="display:none" name="dynamic"></iframe>
   <!-- </div> -->
      
      <form name="mainForm" id="mainForm" action="ReviewMakeProc.jsp" method="post" encType="multipart/form-data" style="display:none">
         <input type="file" id="file_default" style="display:none" name="review_image"/>
         <input type="text" id="review_name" style="display:none;" name="review_name"/>
         <input type="text" id="review_date" style="display:none;" name="review_date"/>
         <input type="text" id="tag_list" style="display:none;" name="tag_list"/>
         <input type="text" style="display:none;" name="member_nick" value='<%=nickName%>'/>
      </form>
        
        <script>
           $(window).load(function() {
               var now = new Date();
               var year= now.getFullYear();
               var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
               var day = now.getDate() > 9 ? now.getDate() : '0'+now.getDate();
               var e_day=Number(day)+1;
               e_day = e_day > 9 ? e_day : '0'+e_day;
                       
               var text = year + '-' + mon + '-' + day + " ~ "+year + '-' + mon + '-' + day;
               $('#date-range-text').text(text);
   
           });
           
           $('#save_btn').click(function(){
              //폼에 인덱스 별로 area_no 값 넣기
              var parent=$('#content').children('.total_review_wrap');
              for(var i=0; i<parent.children('.day_review').length; i++){
                 var area_list=parent.children('.day_review').eq(i).children('.box_site');
                 
                 for(var j=0; j<area_list.length; j++){
                    var area_no=area_list.eq(j).attr('id');
                    var area_name=i+"_"+j+"_areaName";
                    var text="<input type='text' class='area_name' name='"+area_name+"' value='"+area_no+"'/>";
                    $('#mainForm').append(text);
                 }
              }
              
              document.mainForm.review_name.value=$('#review_title').val();
              document.mainForm.review_date.value=$('#date-range-text').text();
              
              var tag_val="";
              for(var i=0; i<$('.toggle_tag_list').children().length; i++){
                 tag_val+=$('.toggle_tag_list').children('.tag_list').eq(i).text();
              }
              document.mainForm.tag_list.value=tag_val;
              
              document.mainForm.submit();
           });
           $('#cancel_btn').click(function(){
              //이전페이지
              history.back();
           });
           

        </script>
</body>
</html>