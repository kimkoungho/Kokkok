<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	String review_no=request.getParameter("review_no");

	ReviewDatabase rd=new ReviewDatabase();
	AreaDatabase ad=new AreaDatabase();
	ImageDatabase id=new ImageDatabase();
	RecommendDatabase rcd=new RecommendDatabase();
	CommentDatabase cmd=new CommentDatabase();
	MyItemDatabase md=new MyItemDatabase();
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	HashMap<String, Object> hash=rd.getReviewInfo(review_no);
	
	int r_cnt=rcd.getRecommendCount("review", review_no);
	boolean isRecommend = rcd.isRecommend(nickName, "review", review_no);
	
	ArrayList<HashMap<String, Object>> list=cmd.getDB("review", review_no, 1);
	
	String review_content=(String)hash.get("content");
		
%>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="UTF-8">
    <!-- 반응형 임포트 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!-- [if lt IE 9] -->
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <!-- [endif] -->
    <!-- 동수 꺼-->
    <!-- <link href="lib/jquery.bxslider.css" rel="stylesheet" /> -->
    <link rel="stylesheet" href="CSS/ReviewDetail.css" />
    <title>후기 세부 정보</title>
    <!-- 여기 있어야 실행됨 반응형 -->
    <script src="JS/jquery.js"></script>
    <script src="JS/jquery.masonry.min.js"></script>
    <script src="dist/js/swiper.min.js"></script>
    <link rel="stylesheet" href="dist/css/swiper.min.css">
</head>

<body>
	<div class="content">
        <div class="surf_img" style="background-image:url('<%=hash.get("default_image") %>')">
        	<img src="IMAGES/transparency.png" width="100%"/>
        </div>
        <div class="user_wrap">
            <div class="name">
            	<%
	               	String member_nickname = (String) hash.get("member_nickname");
	               
	                String imageURL = id.getMemberImageURL(member_nickname);
	                
	            	if( imageURL.contains("kakao") )
	               		out.println("<img src='" + id.getMemberImageURL(member_nickname) + "' class='icon_img1'>");
	               	else
	               		out.println("<img src='IMAGES/user_icon.svg' class='icon_img1'>");
            	%>
            <div class="icon_text1"><%=hash.get("member_nickname") %></div>	
            </div>
            <div class="state_icon">
          	 	<div class="icon_text2"> <%=list.size() %> </div>
           		<img src="IMAGES/reply.svg" class="icon_img2" />
      		   	<div class="icon_text2"> <%=r_cnt %> </div>
      		   	<img src="IMAGES/like.svg"  class="icon_img2" />
            </div>
        </div>
        <div class="review_wrap">
            <div class="my_title"><%=hash.get("review_name") %></div>
            <div class="plus">
                	<img src="IMAGES/like.svg" class="like_icon" />
                	<div class="plus_sub">추천해요!</div>
            </div>
            <div class="calender">
           		 <div class="date_text"><%=hash.get("term") %></div>
           		 <img src="IMAGES/calendar.svg" class="date_icon">
            </div>
        </div>           
    </div>
	<div class="total_review_wrap">
        <%
        try{
    		JSONParser parser=new JSONParser();
    		JSONArray date_arr=(JSONArray)parser.parse(review_content);//일차별 array
    		//System.out.println(date_arr.size());
    		
    		for(int j=0; j<date_arr.size(); j++){
    			JSONArray area_arr=(JSONArray)date_arr.get(j);
        %>
        	<div class="date_bar">
	            		<div class="review_date"><%=(j+1) %>일차</div>
	        </div>
			
                <%
                 for(int k=0; k<area_arr.size(); k++){
     				JSONObject itemObj=(JSONObject)area_arr.get(k);
     				
     				String area_no=(String)itemObj.get("area");
     				HashMap<String, Object> item_area=ad.getAreaInfo(area_no);
     				String item_area_img=id.getImageURLList("area", area_no).get(0);
        				
                %>
                <div class="day_review">
                <div class="site_wrap">
                	<div class="canvas">
                    		<img src="IMAGES/circle.svg" width="100%"/>    
                   	</div>
                   	<div class="box_site">
        				 <div class="site_title"> <b> <%=area_no.substring(0,2) %> > <%=item_area.get("name") %></b>
          				  <span class="arrow">	<img src="IMAGES/next.svg" width="80%">  </span>  </div>
        				 <div class="site_img" style="background-image:url('<%=item_area_img%>');" >
         					  <img src="IMAGES/transparency5.png" > 
       					  </div>
       					  <div class="site_content">            
           					 <img src="IMAGES/location2.svg" class="location_img">
           					 <div class="site_info"> <%=item_area.get("address") %> </div>
            
           					 <div class="site_like">
               					<span class="like">
                 					<img src="IMAGES/scrap2.svg" style="width:40%;">
                   					<span class="like_cont"><%=md.getScrapCount("area", area_no) %></span>
               					 </span>
               					 <span class="like">
                  					<img src="IMAGES/like.svg" style="width:40%;">
                   					<span class="like_cont"><%=rcd.getRecommendCount("area", area_no) %></span>
              					 </span>
            				  </div>
         					</div>
        				</div>
         				<div class="site_line"><img src="IMAGES/line.svg" width="100%"> </div>
                </div>
           	</div>
            <div class="show_review">
            <%
       			JSONArray item_list=(JSONArray)itemObj.get("review");
       			for(int l=0; l<item_list.size(); l++)
       			{
       				JSONObject obj=(JSONObject)item_list.get(l);
       				String content=(String)obj.get("content");
       				String img=(String)obj.get("image");
       				String title=(String)obj.get("title");
       		%>
       		<%
       				if(img!=null)
       				{
       		%>
                <div class="show_pic" style="background-image:url('<%=img %>');">
                	<img src="IMAGES/transparency5.png" width="100%" >
    
                </div>
            <%
       				}
       				else if(title!=null)
       				{
            %>
                <div class="show_title"><%=title %></div>
            <%
	   				}
	   				else if(content!=null)
	   				{
            %>
                <div class="show_cont"><%=content %></div>
            <%
   					}
       			}
       		 %>
             </div>
     	<%
             }
   		}
	}catch(Exception e){
		e.printStackTrace();
	}
   	%>
   	</div>
 
    <div class="user_reply_wrap">
        <div class="user_title">
            <span class="comment">의견</span>
            <span class="more"> 더보기 > </span>
        </div>
    <%
    for( int i = list.size() - 1; i >= 0; i-- )
    {
    %>
        <div class="user_comment">
            <div class="user_pic">
            	<%
	               	member_nickname = (String) list.get(i).get("member_nickname");
	               
	                imageURL = id.getMemberImageURL(member_nickname);
	                
	            	if( imageURL.contains("kakao") )
	               		out.println("<img src='" + imageURL + "' style='width:100%;'>");
	               	else
	               		out.println("<img src='IMAGES/user_icon.svg' style='width:100%;'>");
	            	%>
           	</div>
            <div class="user_con_wrap">
                <div class="user_name"><%=list.get(i).get("member_nickname") %></div>
                <div class="date"><%=sdf.format(list.get(i).get("date")) %></div>
                <div class="user_reply_comment"><%=list.get(i).get("content") %></div>
            </div>
        </div>
     <%
     	if( i == list.size()-2 )
     		break;
    }
     %>
    </div>
    
    <iframe src="Comment.jsp?kind=review&item_id=<%=review_no%>&level=1" id="dynamic" style="display:none" name="dynamic"></iframe>
    
    <script>
    	$(window).load(function() {
    		$(".icon_img1").css("height", $(".icon_img1").width());
    		$(".user_pic img").css("height", $(".user_pic img").width());
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
			$(".icon_img1").css("height", $(".icon_img1").width());
			$(".user_pic img").css("height", $(".user_pic img").width());
		});
    
    	
    
    	$(".plus").click(function() {
    		
    		if( <%=nickName==null%> )
    			alert("로그인이 필요한 서비스입니다.");
    		else
   			{
   				if( <%=isRecommend%> )
   					alert("이미 추천하셨습니다.");
   				else
				{
   					var url = "DetailProc.jsp?ref=ReviewDetail&type=recommend&kind=review&item_id=" + '<%=review_no%>';
					location.replace(url);
					alert('추천했습니다.');
				}
   			}
    	});
    	
    	$(".more").click(function() {
    		$('body').css("overflow", "hidden");
			$("#dynamic").slideToggle();
    	});
    	
    	function closeComment()
    	{
    		$('body').css("overflow", "auto");
    		$("#dynamic").slideToggle();
    	}
    </script>
    
</body>
</html>