<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	//var url="ReviewMain1.jsp?area="+area+"&content="+content+"&tag="+tag;	

	String nickName=(String)session.getAttribute("userNickname");
	
	CourseDatabase cd = new CourseDatabase();
	RecommendDatabase rd = new RecommendDatabase();
	ImageDatabase id = new ImageDatabase();
	ReviewDatabase rvd=new ReviewDatabase();
	TagDatabase td=new TagDatabase();
	
	ArrayList<HashMap<String, Object>> list=rd.getBestInfo("review", "");
	ArrayList<HashMap<String, Object>> list1=td.getBestTag("review");
	/* System.out.println(list1.size()); */
	
	for(int i=0; i<list.size(); i++){
		String item_id=(String)list.get(i).get("item_id");
		HashMap<String, Object> hash=rvd.getReviewInfo(item_id);
		list.get(i).put("review_name",hash.get("review_name"));
		list.get(i).put("default_image",hash.get("default_image"));
		list.get(i).put("tag_list", hash.get("tag")); //수정필요
		
		String review_content=(String)hash.get("content");
		//json 쪼개기
		
		ArrayList<String> contentList=new ArrayList<String>();
		try{
			JSONParser parser=new JSONParser();
			JSONArray date_arr=(JSONArray)parser.parse(review_content);//일차별 array
			/* System.out.println(date_arr.size()); */
			
			for(int j=0; j<date_arr.size(); j++){
				JSONArray area_arr=(JSONArray)date_arr.get(j);
				for(int k=0; k<area_arr.size(); k++){
					JSONObject itemObj=(JSONObject)area_arr.get(k);
					
					String area_no=(String)itemObj.get("area");
					JSONArray content_arr=(JSONArray)itemObj.get("review");
					for(int l=0; l<content_arr.size(); l++){
						JSONObject obj=(JSONObject)content_arr.get(l);
						String tmp=(String)obj.get("content");
						if(tmp!=null)
							contentList.add(tmp);
						//System.out.println(obj);
					}
				}
			}
			
			list.get(i).put("contentList",contentList); 
			/* System.out.println(contentList); */
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	

%>

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
    <title>후기 메인</title>
    <!-- 반응형 임포트 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!-- [if lt IE 9] -->
    	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <!-- [endif] -->

    <script src="JS/jquery.js"></script>
    <script src="JS/jquery.masonry.min.js"></script>
    <!-- Swiper JS -->
    <script src="dist/js/swiper.min.js"></script>
    <script src="JS/ReviewMain.js"></script>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="dist/css/swiper.min.css">
	<link rel="stylesheet" href="CSS/ReviewMain.css">
</head>

<body>
	<div class="nav">
        <div class="menu1" style="border-right: 1px solid #cccccc;" >
            <img src="IMAGES/write.svg" style="margin: 0 5% 0 13%; width: 9%;" class="menu_icon"/>
            <div class="menu_text">나의 여행기 작성</div>
        </div>
        
        <div class="menu2">
            <img src="IMAGES/finder.svg" style="margin: 0 5% 0 11%; width: 13%;" class="menu_icon"/>
            <div class="menu_text">여행기 찾기</div>
        </div>
    </div>
 
    <div class="main_container">
        <div class="title">추천! 가볼만한 곳</div>

        <div class="swiper-container main">
        
        
            <div class="swiper-wrapper">
                <div class="swiper-slide main-slide">
                    <img src="IMAGES/transparency2.png" class="review_container" style="background-image:url('IMAGES/review_main01.svg');">
                </div>
                
                <div class="swiper-slide main-slide">
                    <img src="IMAGES/transparency2.png" class="review_container" style="background-image:url('IMAGES/review_main02.svg');">
                </div>
                
                <div class="swiper-slide main-slide">
                    <img src="IMAGES/transparency2.png" class="review_container" style="background-image:url('IMAGES/review_main03.svg');">
                </div>
                
                <div class="swiper-slide main-slide">
                    <img src="IMAGES/transparency2.png" class="review_container" style="background-image:url('IMAGES/review_main04.svg');">
                </div>
            </div>
            
            
            <div class="swiper-pagination"></div>
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>
        </div>
     </div>
     
     <div class="main_container">
        <div class="title">요즘 뜨는 여행 태그</div>
        <div class="tag_list">
        	<%
        	for(int i=0; i<list1.size(); i++)
        	{
        	%>
            <span class="tag_item"><%=list1.get(i).get("tag_content") %></span>
            <%
        	}
            %>
        </div>
   	 </div>
	
    <div class="foot_container">
        <div class="title">BEST 여행기</div>
		<div class="line_style1"></div>
        <div class="swiper-container foot">
            <div class="swiper-wrapper">
            	<%
            	for(int i=0; i<list.size(); i++)
            	{
            		String image_url=(String)list.get(i).get("default_image");
            		/* System.out.println(image_url); */
            		ArrayList<String> contentList=(ArrayList<String>)list.get(i).get("contentList");
            		/* System.out.println(contentList); */
            	%>
                <div class="swiper-slide foot-slide">
                    <div class="foot_head">
                    
                    	<%
	                	String member_nickname = (String) list.get(i).get("member_nickname");
	             		
	                	String imageURL = id.getMemberImageURL(member_nickname);
	                
	                	if( imageURL.contains("kakao") )
	                		out.println("<img src='" + imageURL + "'>");
	               		else
	                		out.println("<img src='IMAGES/user_icon.svg'>");
       				 	%>
       				 	
                        <div class="foot_area_name"><%=list.get(i).get("member_nickname") %></div>
                    </div>
                    <div class="foot_like">
                            <img src="IMAGES/like.svg" class="like_img"/>
                   			<div class="like_text"><%=list.get(i).get("recommendCount") %></div>
                    </div>
                    <div class="foot_tit">
                        <%=list.get(i).get("review_name") %>
                    </div>
                    <div class="foot_con">
                        <%
                        	if(contentList.size()>1)
                        		out.println(contentList.get(0));
                        %>
                    </div>
                    <div class="foot_img">
                        <img src="IMAGES/transparency.png" class="foot_img2" style="background-image:url('<%=image_url%>')" />
                    </div>
                </div>
               <%
            	}
                %>
            </div>
            <div class="swiper-scrollbar"></div>
    	</div>
    </div>
        
    <div id="main2"> 
        <div class="menu2_area"> 
            <div class="ckbox">
                <input type="checkbox" id="check1" class="chk"/>
                <label for="check1" class="check_text">지역</label>
            </div>
            <select name="job" class="menu2_text">
            	<option value="">지역을 선택하세요</option>
                <option value="괴산군">괴산군</option>
				<option value="단양군">단양군</option>
				<option value="보은군">보은군</option>
				<option value="영동군">영동군</option>
				<option value="옥천군">옥천군</option>
				<option value="음성군">음성군</option>
				<option value="제천시">제천시</option>
				<option value="증평군">증평군</option>
				<option value="진천군">진천군</option>
				<option value="청주시">청주시</option>
				<option value="충주시">충주시</option>
            </select>
        </div>
        <div class="menu2_name">
            <div class="ckbox">
                <input type="checkbox" id="check2" class="chk"/>
                <label for="check2" class="check_text">내용</label>
            </div>
            <input type="text" class="menu2_textbox" id="search_content" placeholder="내용으로 검색"/>
        </div>
        <div class="menu2_tag">
            <div class="ckbox" >
                <input type="checkbox" id="check3" class="chk"/>
                <label for="check3" class="check_text">태그</label>
            </div>
            <input type="text" class="menu2_textbox" id="search_tag" placeholder="태그로 검색"/>
        </div>
        <input type="button" class="search_btn" value="검   색">
    </div>
    
    <script>
	    $('.menu1').click(function() {
	    	
			if( <%=nickName == null%> ){
				alert('로그인이 필요한 서비스입니다.');
			}else{
				location.href="ReviewMake.jsp";
			}
			
		});
    
          $(window).load(function(){
        	  $('.menu2_text').attr("disabled",true);
        	  $('.menu2_textbox').attr("disabled",true);
        	  $('#main2').css({ "position": "absolute", "top": $('.nav').height(), "left": "0px" });
        	  
        	  $(".foot_head img").css("height", $(".foot_head img").width());
          });
          
       // resize가 최종완료되기전까지 resize 이벤트를 무시(최대화의 경우 resize가 계속발생하는 것을 방지)
  		$(window).resize(function() {
  			if( this.resizeTO )
  		        clearTimeout(this.resizeTO);

  		    this.resizeTO = setTimeout(function() {
  		        $(this).trigger('resizeEnd');
  		    }, 0);
  		});
          
          $(window).resize(function(){
        	  $('#main2').css({ "position": "absolute", "top": $('.nav').height(), "left": "0px" });
        	  $(".foot_head img").css("height", $(".foot_head img").width());
          });
            var main_swiper = new Swiper('.main', {
                nextButton: '.swiper-button-next',
                prevButton: '.swiper-button-prev',
                spaceBetween: 30
            });
            
            var foot_swiper = new Swiper('.foot', {
                scrollbar: '.swiper-scrollbar',
                scrollbarHide: true,
                slidesPerView: 2.3,
                spaceBetween: 10,
                grabCursor: true
            });
        	
    </script>
</body>
</html>