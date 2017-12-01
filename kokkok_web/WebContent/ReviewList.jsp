<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String nickName=(String)session.getAttribute("userNickname");
	String area=request.getParameter("area");
	String content=request.getParameter("content");
	String tag=request.getParameter("tag");

	String searchVal="";
	if(area==null || area=="")
		area="";
	else
		searchVal+=area+", ";
	if(content==null || content=="")
		content="";
	else
		searchVal+=content+", ";
	if(tag==null || tag=="")
		tag="";
	else
		searchVal+="#"+tag;
	
	ReviewDatabase rvd=new ReviewDatabase();
	RecommendDatabase rd=new RecommendDatabase();
	MyItemDatabase id=new MyItemDatabase();
	
	ArrayList<HashMap<String, Object>> list=rvd.getSearchReview(content, area, tag);
	//System.out.println(list.size());
	
	for(int i=0; i<list.size(); i++){
		String item_id=(String)list.get(i).get("review_no");
		
		int rd_count=rd.getRecommendCount("review", item_id);
		int id_count=id.getScrapCount("review", item_id);
		
		list.get(i).put("rd_cnt",rd_count);
		list.get(i).put("id_cnt",id_count);
		
		String review_content=(String)list.get(i).get("content");
		//json 쪼개기
		
		ArrayList<String> areaList=new ArrayList<String>();
		
		try{
			JSONParser parser=new JSONParser();
			JSONArray date_arr=(JSONArray)parser.parse(review_content);//일차별 array
			//System.out.println(date_arr.size());
			
			for(int j=0; j<date_arr.size(); j++){
				JSONArray area_arr=(JSONArray)date_arr.get(j);
				for(int k=0; k<area_arr.size(); k++){
					JSONObject itemObj=(JSONObject)area_arr.get(k);
					
					String area_no=(String)itemObj.get("area");
					areaList.add(area_no);
				}
			}
			
			list.get(i).put("areaList",areaList); 
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
%>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <!-- 반응형 임포트 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!-- [if lt IE 9] -->
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <!-- [endif] -->
    <!-- 동수 꺼-->
    <!-- <link href="lib/jquery.bxslider.css" rel="stylesheet" /> -->
    <link rel="stylesheet" href="CSS/ReviewList.css" />
    <title> 후기 리스트 </title>
    <!-- 여기 있어야 실행됨 반응형 -->
    <script src="JS/jquery.js"></script>
    <script src="JS/jquery.masonry.min.js"></script>
    <script src="JS/ReviewList.js" type="text/javascript"></script>
    <script src="dist/js/swiper.min.js"></script>
    <link rel="stylesheet" href="dist/css/swiper.min.css">
</head>
<body>
	
	<div id="head">
		<div class="lnb">
            <span class="condition">검색 조건</span>
            <span class="con_3"><%=searchVal %></span>
            <span class="change"> 조건 변경 </span>
        </div>
        
        <div class="num">총 <%=list.size() %> 건</div>
	</div>
	
	<div class="container">
		<%
		for(int i=0; i<list.size(); i++)
		{
			String imageUrl=(String)list.get(i).get("default_image");
			
		%>
		<div class="box" id='<%=list.get(i).get("review_no")%>'>
			<div class="box_header">
				<span class="member">
					<%=list.get(i).get("member_nickname") %>님의 여행기  <font color="#d0d0d0"><b>|</b></font> 
				</span>
				<span class="box_icon">
					<span class="icon_img"> 
						<img src="IMAGES/like.svg" class="recommend_icon" style="width: 11%" />
					</span> 
					<span class="icon_text"><%=list.get(i).get("rd_cnt") %></span>
				 	<span class="icon_img"> 
				 		<img src="IMAGES/reply.svg" class="myitem_icon"style="width: 11%" />
					</span>
					<span class="icon_text"><%=list.get(i).get("id_cnt") %></span>
				</span>
			</div>
			<div class="area_content" style="background-image:url('<%=imageUrl%>');">
				<img src="IMAGES/transparency4.png" width="100%">
				<div class="area_item">
					<span class="area_item_title"><%=list.get(i).get("review_name") %></span>
					<span class="area_item_member"> | <%=list.get(i).get("member_nickname") %></span>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>
	
	<div class="main2"> 
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
            <input type="text" class="menu2_textbox" id="search_content"/>
        </div>
        <div class="menu2_tag">
            <div class="ckbox" >
                <input type="checkbox" id="check3" class="chk"/>
                <label for="check3" class="check_text">태그</label>
            </div>
            <input type="text" class="menu2_textbox" id="search_tag"/>
        </div>
        <button class="search_btn">검   색</button>
    </div>
    
	<script>
		$(window).load(function(){
	  	  	$('.menu2_text').attr("disabled",true);
	  	  	$('.menu2_textbox').attr("disabled",true);
	  	  // $('.container').css("height",window.innerWidth*1.4);
	  		$('.main2').css({ "position": "absolute", "top": $('.lnb').height(), "left": "0px" });
	  	  
	    });
		
		$(window).resize(function() {		
			if( this.resizeTO )
		        clearTimeout(this.resizeTO);
		      
		    this.resizeTO = setTimeout(function() {
		        $(this).trigger('resizeEnd');
		    }, 0);
	    });
		// resize가 최종완료된 후 실행되는 callback 함수
		$(window).on('resizeEnd', function() {
			// $('.container').css("height",window.innerWidth*1.3);
			$('.main2').css({ "position": "absolute", "top": $('.lnb').height(), "left": "0px" });
		});
		
		$('.recommend_icon').click(function(){
			var item_id=$(this).parent('.box_icon').parent('.box_header').parent('.box').attr('id');
			
			var nowUrl="ReviewList.jsp?area="+'<%=area%>'+"&content="+'<%=content%>'+"&tag="+'<%=tag%>';
			var url="AddMyItem.jsp?kind=review&item_id="+item_id+"&url="+nowUrl;
			//alert(url);
			//location.replace(url);
		});
		$('.myitem_icon').click(function(){
			var item_id=$(this).parent('.box_icon').parent('.box_header').parent('.box').attr('id');
			
			var nowUrl="ReviewList.jsp?area="+'<%=area%>'+"&content="+'<%=content%>'+"&tag="+'<%=tag%>';
			var url;//댓글
			//location.replace(url);
		});
		$('.box').click(function(){
			var url="ReviewDetail.jsp?review_no="+$(this).attr('id');
			location.href=url;
		});
	</script>
</body>
</html>