<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="Database.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
	request.setCharacterEncoding("utf-8");

	String type = request.getParameter("type");
	String kind = request.getParameter("kind");
	String item_id = request.getParameter("item_id");
	
	RecommendDatabase rd = new RecommendDatabase();// 추천 지우고
	MyItemDatabase mid = new MyItemDatabase();//스크랩 지우고
	CourseDatabase cd=new CourseDatabase();
	CommentDatabase cmd=new CommentDatabase();
	ReviewDatabase rvd=new ReviewDatabase();
	
	if( type.equals("mypage") )
	{
		if(kind.equals("course"))
		{
			cd.deleteCourse(item_id);
			rd.deleteRecommend(kind, item_id);
			cmd.deleteComment(kind, item_id);
			mid.deleteMyItem(kind, item_id);
		}
		else if(kind.equals("review"))
		{
			
			rd.deleteRecommend(kind, item_id);
			cmd.deleteComment(kind, item_id);
			mid.deleteMyItem(kind, item_id);
			
			// 후기 이미지 지우자
			HashMap<String, Object> review=rvd.getReviewInfo(item_id);
			
			ArrayList<String> img_list=new ArrayList<String>();
			img_list.add((String)review.get("default_image"));
			
			String content=(String)review.get("content");
			try
			{
				JSONParser parser=new JSONParser();
	    		JSONArray date_arr=(JSONArray)parser.parse(content);//일차별 array
	    		for(int j=0; j<date_arr.size(); j++)
	    		{
	    			JSONArray area_arr=(JSONArray)date_arr.get(j);
	    			for(int k=0; k<area_arr.size(); k++)
	    			{
	     				JSONObject itemObj=(JSONObject)area_arr.get(k);
	     				JSONArray item_list=(JSONArray)itemObj.get("review");
	           			for(int l=0; l<item_list.size(); l++)
	           			{
	           				JSONObject obj=(JSONObject)item_list.get(l);
	           				String img=(String)obj.get("image");
	           				if(img!=null)
	           					img_list.add(img);
	           			}
	    			}
	    		}
	    		
	    		String realFolder = "";
				String saveFolder = "review";
				
				ServletContext context = getServletContext();
				realFolder = context.getRealPath(saveFolder);
				
	    		for(int i=0; i<img_list.size(); i++)
	    		{
	    			String pathAndName = realFolder + "\\" + img_list.get(i).substring(img_list.get(i).indexOf("/"));
	    			
	    			File file = null;
	    			
	    			if( !pathAndName.contains("\\IMAGES\\") )
	    				file = new File(pathAndName);
	
					if( file != null )
	    				file.delete();
	    		}
	    		rvd.deleteReview(item_id);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	}
	else
	{
		mid.deleteMyItem(kind, item_id);
	}
%>

<script>
	var url;
	
	if( <%=type.equals("mypage")%> )
		url = 'MyPage.jsp';
	else if( <%=type.equals("myscrap")%> )
		url = 'MyScrap.jsp';
	
	alert("삭제되었습니다.");
	
	javascript:location.replace(url);
</script>
