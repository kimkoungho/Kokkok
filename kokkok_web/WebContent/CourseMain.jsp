<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="Database.*"%>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	String localArr[] = {"전체", "괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시", "충주시"};

   	request.setCharacterEncoding("utf-8");

  	String nickName=(String)session.getAttribute("userNickname");
   	String currentPage1 = request.getParameter("page1");
  	String currentPage2 = request.getParameter("page2");
  
   String local = request.getParameter("local");
   String tab = request.getParameter("tab");
   String kind = "course";
   
   if( currentPage1 == null )
	   currentPage1 = "1";
  if( currentPage2 == null )
	   currentPage2 = "1";
  
  
   int currentLocal = 0;
   
   if (local == null)
      local = "전체";
   
   	for( int i = 0; i < localArr.length; i++ )
	{
		if( local.equals(localArr[i]) )
		{
			currentLocal = i;
			break;
		}
	}
   	
   	int pageCnt1 = 1;
	int totalPage1 = 0;
	int totalPageSet1 = 0;
	int currentPageSet1 = 0;
	
	int pageCnt2 = 1;
	int totalPage2 = 0;
	int totalPageSet2 = 0;
	int currentPageSet2 = 0;

	if( currentPage1 != null )
		pageCnt1 = Integer.parseInt(currentPage1);
	if( currentPage2 != null )
		pageCnt2 = Integer.parseInt(currentPage2);
	
   if( local.equals("전체") ) 
		local = "";

   AreaDatabase ad = new AreaDatabase();
   CourseDatabase cd1 = new CourseDatabase();
   CourseDatabase cd2 = new CourseDatabase();
   RecommendDatabase rd = new RecommendDatabase();
   ImageDatabase id = new ImageDatabase();
   CommentDatabase cmtd = new CommentDatabase();
   MyItemDatabase myId = new MyItemDatabase();
   
   totalPage1 = cd1.getTotalPage(local, "true");
   totalPage2 = cd2.getTotalPage(local, "false");
	
	if( totalPage1 > 0 && totalPage1 % 10 == 0 )
		totalPage1 /= 10;
	else
		totalPage1 = totalPage1 / 10 + 1;
	
	if( totalPage1 > 0 && totalPage1 % 5 == 0 )
		totalPageSet1 = totalPage1 / 5;
	else
		totalPageSet1 = totalPage1 / 5 + 1;
	
	if( pageCnt1 % 5 == 0 )
		currentPageSet1 = pageCnt1 / 5;
	else
		currentPageSet1 = pageCnt1 / 5 + 1;
   
	
	/********************************************/
	
	if( totalPage2 > 0 && totalPage2 % 10 == 0 )
		totalPage2 /= 10;
	else
		totalPage2 = totalPage2 / 10 + 1;
	
	if( totalPage2 > 0 && totalPage2 % 5 == 0 )
		totalPageSet2 = totalPage2 / 5;
	else
		totalPageSet2 = totalPage2 / 5 + 1;
	
	if( pageCnt2 % 5 == 0 )
		currentPageSet2 = pageCnt2 / 5;
	else
		currentPageSet2 = pageCnt2 / 5 + 1;
   

	/*****************************************************************/
   
   ArrayList<HashMap<String, Object>> re_list = cd1.getDB(local, "true");

   for (int i = 0; i < re_list.size(); i++)
   {
      re_list.get(i).put("recommendCount", rd.getRecommendCount(kind, (String) re_list.get(i).get("course_no")));
      re_list.get(i).put("scrapCount", myId.getScrapCount(kind, (String) re_list.get(i).get("course_no")));
      re_list.get(i).put("commentCount", cmtd.getCommentCount(kind, (String) re_list.get(i).get("course_no")));
      
      String[] dateRouteList = ((String) re_list.get(i).get("route")).split("-");
      String area = dateRouteList[0].split(",")[0];
      String ImageUrl = id.getImageURLList("area", area).get(0);
      
      if(ImageUrl.equals("IMAGES/no_image.png"))
    	  ImageUrl="IMAGES/course_noImage.png";

      area = area.substring(0, 2);
      re_list.get(i).put("area", area);
      re_list.get(i).put("image", ImageUrl);
   }

   ArrayList<HashMap<String, Object>> usr_list = cd2.getDB(local, "false");

   for (int i = 0; i < usr_list.size(); i++) 
   {
      usr_list.get(i).put("recommendCount", rd.getRecommendCount(kind, (String) usr_list.get(i).get("course_no")));
      usr_list.get(i).put("scrapCount", myId.getScrapCount(kind, (String) usr_list.get(i).get("course_no")));
      usr_list.get(i).put("commentCount", cmtd.getCommentCount(kind, (String) usr_list.get(i).get("course_no")));
      
      String[] dateRouteList = ((String) usr_list.get(i).get("route")).split("-");
      String area = dateRouteList[0].split(",")[0];
      String ImageUrl = id.getImageURLList("area", area).get(0);
      
      if(ImageUrl.equals("IMAGES/no_image.png"))
    	  ImageUrl="IMAGES/course_noImage.png";

      area = area.substring(0, 2);
      usr_list.get(i).put("area", area);
      usr_list.get(i).put("image", ImageUrl);
   }
   
   //코스만들기 뿌려줄 리스트
   
   ArrayList<HashMap<String, Object>> fav_course_list = (ArrayList)myId.getMyCourse("course", nickName).clone();
   //System.out.println(fav_course_list);
   //route=청주_0000042,청주_0000033,청주_0000060-,
   for (int i = 0; i < fav_course_list.size(); i++)
   {
      String[] dateRouteList = ((String) fav_course_list.get(i).get("route")).split("-");
      ArrayList<HashMap<String, Object>> temp=new ArrayList<HashMap<String, Object>>();
      for(int j=0; j<dateRouteList.length; j++)
      {
         String[] dayList=dateRouteList[j].split(",");
         for(int k=0; k<dayList.length; k++)
         {
            HashMap<String, Object> hash=ad.getAreaInfo(dayList[k]);
            temp.add(hash);
         }
      }
      fav_course_list.get(i).put("area_list", temp);
   }
   //System.out.println(fav_course_list);
   
   ArrayList<HashMap<String, Object>> fav_area_list = (ArrayList)myId.getMyArea("area", nickName).clone();
   for(int i=0; i<fav_area_list.size(); i++)
   {
      String ImageUrl = id.getImageURLList("area", (String)fav_area_list.get(i).get("area_no")).get(0);
      fav_area_list.get(i).put("image",ImageUrl);
      
      int rc_cnt=rd.getRecommendCount("area", (String)fav_area_list.get(i).get("area_no"));
      fav_area_list.get(i).put("recommend_cnt",rc_cnt);
   }
   //System.out.println(fav_area_list);
%>
<html>
<head>
   <meta charset="utf-8">
   <title>코스 정보 보기</title>
   <!-- 반응형 임포트 -->
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
   <!-- [if lt IE 9] -->
   <!-- <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script> -->
   <!-- [endif] -->
    <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css"> -->
   <script src="JS/jquery.js"></script>
   <script src="JS/jquery.masonry.min.js"></script>
   <!-- Swiper JS -->
   <script src="dist/js/swiper.min.js"></script>
   <script src="JS/CourseMain.js"></script>
   
   <link rel="stylesheet" href="dist/css/swiper.min.css">
   <link rel="stylesheet" href="CSS/CourseMain.css">
</head>

<body>

	<div id="header">
	   <div id="tabs">
	      <span class="tab_menu" id=R_course>추천 코스</span>
	      <span class="tab_menu" id=U_recommend >사용자 추천</span>
	      <span class="tab_menu" id=coursemake>코스 만들기</span>
	   </div>
	   
	   <div class="gnb">
	      <div class="section">
	         <span class="area_name"> 전체 </span>
	         <span class="area_name"> 괴산군 </span> 
	         <span class="area_name"> 단양군 </span> 
	         <span class="area_name"> 보은군 </span>
	         <span class="area_name"> 영동군 </span> 
	         <span class="area_name"> 옥천군 </span>
	         <span class="area_name"> 음성군 </span> 
	         <span class="area_name"> 제천시 </span>
	         <span class="area_name"> 증평군 </span> 
	         <span class="area_name"> 진천군 </span>
	         <span class="area_name"> 청주시 </span> 
	         <span class="area_name"> 충주시 </span>
	      </div>
	   </div>
   </div>
   
   <div class="swiper-container" id="all_container">
      <!-- Add Pagination -->
      <div class="swiper-pagination"></div>

      <div class="swiper-wrapper">
         <div class="swiper-slide">
            
            <div class="container" id="container_site1">
               
               <%
               for (int i = 0; i < re_list.size(); i++) 
               {
               %>
               <div class="box">
                  <img src="IMAGES/transparency4.png" class="area_content" style="background-image:url('<%=re_list.get(i).get("image")%>')" />
                     <div class="box_area" id="<%=re_list.get(i).get("course_no")%>">
                        <div class="course_site">
                           <img src="IMAGES/location2.svg" style="float: left; width: 15%; margin-top: 3%; margin-left: 4%;" />
                           <div class="location_text"> <%=re_list.get(i).get("area")%></div>
                                 </div>
                                 <div class="spot_name"><%=re_list.get(i).get("name")%></div>
                             <div class="isBasic_text1">한국 관광 공사 추천</div>      
                             </div>         
                  <div class="area_item">
                        <img src="IMAGES/like.svg" class="icon_img" />
                        <span class="area_item_list"> 
                            <%=re_list.get(i).get("recommendCount") %>
                        </span> 
                        <img src="IMAGES/scrap2.svg" class="icon_img" />
                        <span class="area_item_list"> 
                           <%=re_list.get(i).get("scrapCount") %>
                        </span>
                        <img src="IMAGES/reply.svg" class="icon_img" />
                        <span class="area_item_list">
                           <%=re_list.get(i).get("commentCount") %>
                        </span>
                     </div>
               </div>
               <%
                  }
               %>
            </div>
            
            <div id="nav1">
		<%
		if( currentPageSet1 > 1 )
		{
			int beforePageSetLastPage = 5 * (currentPageSet1 - 1);
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + beforePageSetLastPage + "&page2=" + currentPage2;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back_more.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_back_more.svg' width=30px height=30px>");
		
		if( pageCnt1 > 1 )
		{
			int beforePage = pageCnt1 - 1;
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + beforePage + "&page2=" + currentPage2;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");

		}
		else
			out.println("<IMG SRC='IMAGES/move_back.svg' width=30px height=30px>");
		
		int firstPage = 5 * (currentPageSet1 - 1);
		int lastPage = 5 * currentPageSet1 ;
		
		if( currentPageSet1 == totalPageSet1 )
			lastPage = totalPage1;
		
		for( int i = firstPage + 1; i <= lastPage; i++ )
	      {
	         if( pageCnt1 == i )
	         {
	            out.println("&nbsp;");
	            out.println("<B style='color: #2b5686'>" + i + "</B>");
	            out.println("&nbsp;");
	         }
	         else
	         {
	            String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + i + "&page2=" + currentPage2;
	            out.println("&nbsp;");
	            out.println("<a href=" + retUrl + " style='color:#888888'>" + i + "</a>");
	            out.println("&nbsp;");
	         }
		}
		   
		if( totalPage1 > pageCnt1 )
		{
			int nextPage = pageCnt1 + 1;
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + nextPage + "&page2=" + currentPage2;
			
			String click="javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_next.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next.svg' width=30px height=30px>");
		
		if( totalPageSet1 > currentPageSet1 )
		{
			int nextPageSet = 5 * currentPageSet1 + 1;
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + nextPageSet + "&page2=" + currentPage2;
			
			String click = "javascript:location.href='" + retUrl;	
			 out.println("<IMG SRC='IMAGES/move_next_more.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next_more.svg' width=30px height=30px>");
		
	%>
	</div>
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
         </div>

         <div class="swiper-slide">
           
            <div class="container" id="container_site2">
            
               <%
               for (int i = 0; i < usr_list.size(); i++) 
               {
               %>
               <div class="box">
                  <img src="IMAGES/transparency4.png" class="area_content" style="background-image:url('<%=usr_list.get(i).get("image")%>')" />
                  <div class="box_area" id="<%=usr_list.get(i).get("course_no")%>">
                        <div class="course_site">
                           <img src="IMAGES/location2.svg" style="float: left; width: 15%; margin-top: 3%; margin-left: 4%;" />
                           <div class="location_text"> <%=usr_list.get(i).get("area")%></div>
                                 </div>
                                 <div class="spot_name"><%=usr_list.get(i).get("name")%></div>
                                 <div class="isBasic_text2">사용자 추천</div>
                  </div>
                  <div class="area_item">
                        <img src="IMAGES/like.svg" class="icon_img" />
                        <span class="area_item_list"> 
                            <%=usr_list.get(i).get("recommendCount") %>
                        </span> 
                        <img src="IMAGES/scrap2.svg" class="icon_img" />
                        <span class="area_item_list"> 
                           <%=usr_list.get(i).get("scrapCount") %>
                        </span>
                        <img src="IMAGES/reply.svg" class="icon_img" />
                        <span class="area_item_list">
                           <%=usr_list.get(i).get("commentCount") %>
                        </span>
                     </div>
               </div>
               
               <%
                  }
               %>	
            </div>
            
            
            
            <div id="nav2">
		<%
		if( currentPageSet2 > 1 )
		{
			int beforePageSetLastPage = 5 * (currentPageSet2 - 1);
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + currentPage1 + "&page2=" + beforePageSetLastPage;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back_more.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_back_more.svg' width=30px height=30px>");
		
		if( pageCnt2 > 1 )
		{
			int beforePage = pageCnt2 - 1;
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + currentPage1 + "&page2=" + beforePage;
			
			String click = "javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_back.svg' onclick=" + click + "' style=cursor:hand width=30px height=30px>");

		}
		else
			out.println("<IMG SRC='IMAGES/move_back.svg' width=30px height=30px>");
		
		firstPage = 5 * (currentPageSet2 - 1);
		lastPage = 5 * currentPageSet2 ;
		
		if( currentPageSet2 == totalPageSet2 )
			lastPage = totalPage2;
		
		for( int i = firstPage + 1; i <= lastPage; i++ )
	      {
	         if( pageCnt2 == i )
	         {
	            out.println("&nbsp;");
	            out.println("<B style='color: #2b5686'>" + i + "</B>");
	            out.println("&nbsp;");
	         }
	         else
	         {
	            String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + currentPage1 + "&page2=" + i;
	            out.println("&nbsp;");
	            out.println("<a href=" + retUrl + " style='color:#888888'>" + i + "</a>");
	            out.println("&nbsp;");
	         }
		}
		   
		if( totalPage2 > pageCnt2 )
		{
			int nextPage = pageCnt2 + 1;
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + currentPage1 + "&page2=" + nextPage;
			
			String click="javascript:location.href='" + retUrl;	
			out.println("<IMG SRC='IMAGES/move_next.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next.svg' width=30px height=30px>");
		
		if( totalPageSet2 > currentPageSet2 )
		{
			int nextPageSet = 5 * currentPageSet2 + 1;
			String retUrl = "CourseMain.jsp?local=" + local +"&page1=" + currentPage1 + "&page2=" + nextPageSet;
			
			String click = "javascript:location.href='" + retUrl;	
			 out.println("<IMG SRC='IMAGES/move_next_more.svg' onClick=" + click + "' style=cursor:hand width=30px height=30px>");
		}
		else
			out.println("<IMG SRC='IMAGES/move_next_more.svg' width=30px height=30px>");
		
	%>
	</div>
            
            
         </div>

         <div class="swiper-slide">
         
	            <div class="white_wrap">
	               <div class="write_title">
	                  <span> 나의 스크랩 코스 </span>
	                  <span class="title_count"> <%=fav_course_list.size() %> 건 </span>
	                  <span class="title_link" id="title_toggle_btn">
	                     <a href="#"> + 더보기 </a>
	                  </span>
	               </div>
	
	               
	               <div class="course_container">
	                  <%
	               if(fav_course_list.size()>0)
	               {
	                  ArrayList<HashMap<String,Object>> area_list=(ArrayList)fav_course_list.get(0).get("area_list");
	                  String course_name=(String)fav_course_list.get(0).get("name");
	               %>
	                  <div class="course_box" style="display: block">
	                     <div class="course_title">
	                        <span class="course_name"> <%=course_name %> </span>
	                        <span class="course_btn"> 담기 </span>
	                     </div>
	                     
	                     <div class="course_path">
	                        <%
	                        for(int j=0; j<area_list.size(); j++)
	                        {
	                        %>
	                        <span class='<%=area_list.get(j).get("area_no") %>'>
	                              <%
	                                 String name=(String)area_list.get(j).get("name");
	                              //System.out.println(name);
	                              if(name.length()>7){
	                            	 name=name.substring(0,7)+".. ";
	                              }
	                              
	                              if(j!=area_list.size()-1)
	                                    name+=", ";
	                                 
	                                 out.println(name);
	                              %>
	                        </span>
	                        <%
	                        }
	                        %>
	                     </div>
	                  </div>
	                  <%
	               }
	                  
	               for(int i=1; i<fav_course_list.size(); i++)
	               {
	            	   String course_name=(String)fav_course_list.get(i).get("name");
	            	   
	                  ArrayList<HashMap<String,Object>> area_list=(ArrayList)fav_course_list.get(i).get("area_list");
	               %>
	                  <div class="course_box">
	                     <div class="course_info_none" style="display: none" id='<%=(String)fav_course_list.get(i).get("course_no")%>'></div>
	                     <div class="course_title">
	                        <span class="course_name"><%=course_name%> </span>
	                        <span class="course_btn"> 담기 </span>
	                     </div>
	                     
	                     <div class="course_path">
	                     <%
	                     for(int j=0; j<area_list.size(); j++)
	                     {
	                     %>
	                        <span class='<%=area_list.get(j).get("area_no") %>'>
	                        <%
	                              String name=(String)area_list.get(j).get("name");
			                        //System.out.println(name);
			                        if(name.length()>7){
			                      	 name=name.substring(0,7)+".. ";
			                        }
	                              if(j!=area_list.size()-1)
	                                 name+=", ";
	                              
	                              out.print(name);
	                        %>
	                        </span>
	                     <%
	                     }
	                     %>
	                     </div>
	                  </div>
	                  <%
	               }
	               %>
	               </div>
	            </div>
            
	            <div class="white_wrap">
	               <div class="write_title">
	                  <span> 나의 스크랩 명소 </span>
	                  <span class="title_count"> <%=fav_area_list.size() %> 곳 </span>
	                  <span class="title_link" id="search_btn"> + 명소 찾기 </span>
	               </div>
	               
	
	               <div class="best_container">
	               <%
	               for(int i=0; i<fav_area_list.size(); i++)
	               {
	            	   String area_name=(String)fav_area_list.get(i).get("name");
	            	   
	                   if(area_name.length()>7){
	                 	 area_name=area_name.substring(0,7)+".. ";
	                   }
	               %>
	                  <div class="best_box">
	                     <div class="bestCourse">
	                        <div class="area_info_none" style="display: none" id='area@<%=(String)fav_area_list.get(i).get("area_no")%>'></div>
	                        
	                        <div class="show_course">
	                           <div class="img_check">
	                              <img src="IMAGES/check.png" width="100%" />
	                           </div>
	                           <img src="IMAGES/transparency5.png" class="scrap_image" style="background-image:url('<%=fav_area_list.get(i).get("image") %>')">
	                        </div>
	                        
	                        <div class="content_box">
	                           <div class="content_title">
	                              <b> <%=area_name%> </b>
	                           </div>
	                           
	                           <div class="content_addr"> 
	                           <%
	                           	String addr = (String)fav_area_list.get(i).get("address");
	                           
	                           	if( addr.length() > 30 )
	                           		addr = addr.subSequence(0, 27) + "...";
	                           
	                           	out.println(addr);
	                           %>
	                           </div>
	                           
	                           <div class="icon_box">
	                              <span class="like_icon">
	                                 <img src="IMAGES/like.svg" width="100%" />
	                              </span>
	                              
	                              <span class="like"> <%=fav_area_list.get(i).get("recommend_cnt") %> </span>
	                              
	                          
	                           </div>
	                        </div>
	                     </div>
	                  </div>
	                  <%
	               }
	               %>
	               </div>
	            </div>
			
			
         </div>
         
      </div>
   </div>
 
   <div class="mkcourse_wrap">
      <div class="mkcourse">코스 만들기 ></div>
   </div>
   
   <div id="view_wrap_ww">
      <div id="state_view1" style="display: none">
         <div class="view_title"> 코스 일정 계획 </div>
         <div class="suc_box">
            <input type="text" class="input_name" placeholder="나만의 코스 이름을 입력하세요" />
            <div id="write_suc">완료</div>
         </div>
         <div class="tab_box">
            <div class="view_header">
               <div class="state_title"> 여행 일수 </div>
               <select name="date_select" class="date">
                  <option value=""> 여행 일수를 선택하세요 </option>
                  <option value="당일치기"> 당일치기 </option>
                  <option value="1박2일"> 1박 2일 </option>
                  <option value="2박3일"> 2박 3일 </option>
                  <option value="3박4일"> 3박 4일 </option>
               </select>
            </div>
            
            <div id="item">
               <div class="name"> 
                  &nbsp;1일차
                  <div class="fold_icon">
                     <img src="IMAGES/fold.png" width="25%">
                  </div>
               </div>
               
               <div class="day_wrap">
                  <div class="course_day">
                     <div class="site_box">
                        <div class="info"> 현재 담긴 명소 *********곳 (최대 5곳 선택 가능) </div>
                        <select name="site_select" class="site">
                           <option value="">담을 명소를 선택하세요</option>
                           <option value="명소1">명소1</option>
                           <option value="명소2">명소2</option>
                           <option value="명소3">명소3</option>
                           <option value="명소4">명소4</option>
                           <option value="명소5">명소5</option>
                        </select>
                     </div>
                     
                     <div class="tot_wrap">
                        <div class="order"></div>
                        <div class="day_site_wrap_total">
                           <div class="day_site_wrap" id="wrap0">
                              <div class="day_site"></div>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
   
   <form name="mform" action="CourseMakeProc.jsp">
      <input type="text" name="course_user" style="display: none" id="course_user" />
      <input type="text" name="course_route" style="display: none" id="course_route_text" />
      <input type="text" name="course_name" style="display: none" id="name_text" />
   </form>
   
   <script>
   var other_height=$('.isBasic_text1').innerHeight()*2;
   var box_height=$('.area_content').innerHeight();

   $(window).load(function(){  
       //$('.spot_name').css("height", box_height-other_height);
       //$('.spot_name').css("padding-top", (box_height-other_height)/3 );
       //$('.spot_name').css("padding-bottom", (box_height-other_height)/3 );
       
       	$('.area_name').eq(<%=currentLocal%>).css("color", "#5970AD");
		$('.area_name').eq(<%=currentLocal%>).css("border-bottom", "2px solid #5970AD");
		
		$('.area_name').eq(<%=currentLocal%>).css("color", "#5970AD");
		$('.area_name').eq(<%=currentLocal%>).css("border-bottom", "2px solid #5970AD");
       
       $('.mkcourse_wrap ').css({ "bottom": 0});
       
       list1Set();
       
	   	if( <%=tab != null%> )
			$(".tab_menu").eq(2).trigger("click");
	   	
	   	$("#all_container").css("left", "0");
	   	$("#all_container").css("top", $("#header").outerHeight(true));
	   	
	   	$('#nav1').css("left", 0);
		$("#nav1").css("top", $("#container_site1").outerHeight(true));
		
		$('#nav2').css("left", 0);
		$("#nav2").css("top", $("#container_site2").outerHeight(true));
		
		headerSize = $("#header").outerHeight(true);
   });

   $(window).resize(function() {
       if( this.resizeTO )
            clearTimeout(this.resizeTO);
          
        this.resizeTO = setTimeout(function() {
            $(this).trigger('resizeEnd');
        }, 0);
       
        list1Set();
    });
    
   $(window).on('resizeEnd', function() {
       /* $('.spot_name').css("height", (box_height-other_height) -5);
       $('.spot_name').css("padding-top", (box_height-other_height)/3 );
       $('.spot_name').css("padding-bottom", (box_height-other_height)/3 ); */
       $('.mkcourse_wrap ').css({ "bottom": 0});
       list1Set();
       
       $("#all_container").css("left", "0");
	   	$("#all_container").css("top", $("#header").outerHeight(true));
       
	   	$('#nav1').css("left", 0);
		$("#nav1").css("top", $("#container_site1").outerHeight(true));
		
		$('#nav2').css("left", 0);
		$("#nav2").css("top", $("#container_site2").outerHeight(true));
		
		headerSize = $("#header").outerHeight(true);
   }); 
   
      $('#write_suc').click(function() {
         var size=$('#item').children('.day_wrap').length;
         
         var course_route="";
         for(var i=0; i<size; i++) {
            var day_wrap=$('#item').children('.day_wrap').eq(i);
            
            var site_total=day_wrap.children('.course_day').children('.tot_wrap').children('.day_site_wrap_total');
            
            //alert(site_total.children('.day_site_wrap').length);
            var temp=1;
            
            if(i==0)
               temp=2;
            
            if(site_total.children('.day_site_wrap').length<temp)
            {
               alert((i+1)+"일차에 관광지를 선택하세요");
               return;
            }
            
            var j=0;
            if(i==0)
               j=1;
            for(; j<site_total.children('.day_site_wrap').length; j++){
               var area=site_total.children('.day_site_wrap').eq(j).children('.day_site').attr('Id');
               
               if(area==null) continue;
               
               course_route=course_route+area;
               if(j!=site_total.children().length-1)
                  course_route = course_route+",";
               /* alert(area); */
            }
            /* if(i!=size-1) */
               course_route=course_route+"-";
         }
         
         // alert(course_route);
         
         //var title=prompt('여행기 제목을 입력하세요');
         var title=$(this).prev().val();
         
         document.mform.course_route.value=(course_route);
         document.mform.course_name.value=(title);
         document.mform.course_user.value=('<%=nickName%>');

         // alert($('#course_route_text').text());
         document.mform.submit();
      });
      
      var cnt=0;
      $('.mkcourse').click(function() {
    	  
    	  
         $('.site').empty();
         $('.site').append("<option value='0'>담을 명소를 선택하세요</option>");

         cnt=0;
         for (var i = 0; i < $('.course_box').length; i++)
         {
            var course_box = $('.course_box').eq(i);
            if (course_box.hasClass("on"))
            {
               var title_list = course_box.children(".course_path").text();
               var pk_list = course_box.children(".course_path").children();
               var list = title_list.split(",");
               //alert(list);
               var option_list = $('.site option');

               //alert(option_list[])
               for (var j = 0; j < list.length; j++)
               {
                  var title = list[j];
                  var pk = pk_list[j].className;

                  var duplicate_flag = false;

                  var values = $(".site option").map(function() {
                     if (pk == $(this).val())
                        duplicate_flag = true;
                  });

                  //alert(duplicate_flag);

                  if (duplicate_flag == false)
                  {
                     // alert(document.getElementById(pk));
                     if (document.getElementById(pk) == null)
                     {
                        var text = "<option value='" + pk + "'>" + title + "</option>";
                        $('.site').append(text);
                        cnt++;
                     }
                  }
               }
            }
         }

         for (var i = 0; i < $('.img_check').length; i++)
         {
            var img_check = $('.img_check').eq(i);
            if (img_check.hasClass("on"))
            {
               var title = img_check.parent().next().children(
                     ".content_title");
               var pk = $(".area_info_none").eq(i).attr("id");
               pk = pk.split('@')[1];

               var duplicate_flag = false;

               var values = $(".site option").map(function()
               {
                  if (pk == $(this).val())
                     duplicate_flag = true;
               });
               if (duplicate_flag == false)
               {
                  //alert(document.getElementById(pk));
                  if (document.getElementById(pk) == null)
                  {
                     var text = "<option value='" + pk + "'>" + title.text() + "</option>";
                     $('.site').append(text);
                     cnt++;
                  }
               }
            }
         }

         if($('#state_view1').css("display")=="none"){
            $('body').css('overflow','hidden');   
         }else{
            $('body').css('overflow','scroll');
         }

         
   
         $('.info').text('현재 담긴 명소 '+cnt+'곳 (최대 5곳 선택 가능)');
         
         
         $("#state_view1").css("height", $(window).outerHeight() - $(".mkCourse").outerHeight() + 10);
         
         $('#state_view1').slideToggle();
      });
      
      
      $('.tab_menu').on('click', function()
      {
    	  var index = $(this).index();
    	  
    		
          if( index == 2 )
       	  {
       	  		if( <%=nickName == null%> )
       	  			alert('로그인이 필요한 서비스입니다.');
       	  		else
   	  			{
	       	  		$(".tab_menu").css("background-color", "#f0f0f0");
	         	 	$(this).css("background-color", "#2D4B71");
	         	 	
	         	 	main_swiper.slideTo(index);
   	  			}
       	  }
          else
      	  {
          		$(".tab_menu").css("background-color", "#f0f0f0");
         	 	$(this).css("background-color", "#2D4B71");
         	 	
         	 	main_swiper.slideTo(index);
      	  }
    	  
         
      });

      $('.area_name').on('click', function()
      {
         var index = $(this).index();
         var url = "CourseMain.jsp?local=";
  
          
         switch(index)
         {	
            case 0:break;
            case 1:url = url + "괴산군";break;
            case 2:url = url + "단양군";break;
            case 3:url = url + "보은군";break;
            case 4:url = url + "영동군";break;
            case 5:url = url + "옥천군";break;
            case 6:url = url + "음성군";break;
            case 7:url = url + "제천시";break;
            case 8:url = url + "증평군";break;
            case 9:url = url + "진천군";break;
            case 10:url = url + "청주시";break;
            case 11:url = url + "충주시";break;
         }
         
         url += "&page1=" + <%=currentPage1%> + "&page2=" + <%=currentPage2%>;
         
         location.href = url;
      });

      var main_swiper = new Swiper('.swiper-container', {
    
         onSlideChangeStart : function(evt)
         {
        	 
          	 	$(".tab_menu").css("color", "#555555");
 	            	$(".tab_menu").css("background-color", "#f0f0f0");
 	           		$(".tab_menu").eq(evt.activeIndex).css("color", "#ffffff");
 	           	 	$(".tab_menu").eq(evt.activeIndex).css("background-color", "#2D4B71");
 	           	 	
  	           	 if(evt.activeIndex == 2)
  	              	$(".mkcourse_wrap").show(200);
  	       	 	else
  	              $(".mkcourse_wrap").hide();
         },
         onSlideChangeEnd : function(evt)
         {
            if (evt.activeIndex == 2)
           	{
              //First Slide is active
              	$('.section').parent().slideUp();
              	$("#all_container").css("top", headerSize - $(".gnb").outerHeight(true));
          	}
            else
            {
               $('.section').parent().slideDown();
               $("#all_container").css("top", headerSize);
               
            }
            if( evt.activeIndex == 2 && <%=nickName == null%> )
  			{
            	alert('로그인이 필요한 서비스입니다.');
            	$(".tab_menu").eq(1).trigger("click");
  			}
         }
      /* pagination : '.swiper-pagination',
      paginationClickable : true,
      paginationType : 'progress' */
      
      });
      
      $(".box_area").click(function() {
    	  var url = "CourseDetail.jsp?course_no=" + this.id;
    	  
    	  location.href = url;
      });
      
   </script>

</body>
</html>