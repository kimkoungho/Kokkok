<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="Database.*" %>
<%@ page errorPage="ErrorPage.jsp" %>

<%
		request.setCharacterEncoding("UTF-8");
	
		String saveFolder="review";
		
		ServletContext context = getServletContext();
		String realFolder = context.getRealPath(saveFolder);
		
		System.out.println(realFolder);
		
		/* String realFolder="/Users/kimkyeongho/Documents/workspace/kokkok4.0/WebContent/IMAGES/review";//경로
		String renamePath="/Users/kimkyeongho/Documents/workspace/kokkok4.0/WebContent/"; */
		
		int sizeLimit = 1000 * 1024 * 1024;
		String encType = "UTF-8";
		DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();

		MultipartRequest multi = new MultipartRequest(request, realFolder, sizeLimit, encType, policy);

		ReviewDatabase rd=new ReviewDatabase();
		ImageDatabase id=new ImageDatabase();
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
		Date today=new Date();
		
		String nickName=(String)session.getAttribute("userNickname");
	
		String review_name=multi.getParameter("review_name");
		String default_img="";
		String date=sdf.format(today);
		String content="";
		String term=multi.getParameter("review_date");
		String tag_list=multi.getParameter("tag_list");
		
		int review_cnt=rd.getReviewCount();
		
		String start_day=term.split("~")[0].trim();
		String end_day=term.split("~")[1].trim();
		
		long diffDays=0;
		try {
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	        Date beginDate = formatter.parse(start_day);
	        Date endDate = formatter.parse(end_day);
	         
	        // 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
	        long diff = endDate.getTime() - beginDate.getTime();
	        diffDays = diff / (24 * 60 * 60 * 1000);
	 		diffDays++;
	        
	        System.out.println("날짜차이=" + diffDays);
	         
	    } catch (ParseException e) {
	        e.printStackTrace();
	    }
		
		ArrayList<String> content_list=new ArrayList<String>();
		ArrayList<String> area_list=new ArrayList<String>();
		
		Enumeration names=multi.getParameterNames();
		while(names.hasMoreElements()){
			String name=(String)names.nextElement();
			//System.out.println(name);
			String data=multi.getParameter(name);

			if(name.equals("review_name")){
			}else if(name.equals("review_date")){
			}else if(name.equals("member_nick")){
			}else if(name.equals("tag_list")){
			}else{
				String kind=name.split("_")[2];
				if(kind.equals("areaName")){
					area_list.add(name);
				}else{
					content_list.add(name);	
				}
				
			}
		}
		// content_list.sort(String.CASE_INSENSITIVE_ORDER);
		// area_list.sort(String.CASE_INSENSITIVE_ORDER);
		
		Collections.sort(content_list);
		Collections.sort(area_list);
		
		JSONArray date_arr=new JSONArray();//일차별 array
		for(int k=0; k<diffDays; k++){
			JSONArray area_arr=new JSONArray();
			for(int i=0; i<area_list.size(); i++){
				if(Integer.parseInt(area_list.get(i).split("_")[0])==k){
					JSONObject itemObj=new JSONObject();
					
					JSONArray content_arr=new JSONArray();
					for(int j=0; j<content_list.size(); j++){
						if(content_list.get(j).split("_")[1].equals(area_list.get(i).split("_")[1])){
							JSONObject obj=new JSONObject();
							if(multi.getParameter(content_list.get(j))!="")
								obj.put(content_list.get(j).split("_")[3],multi.getParameter(content_list.get(j)));
							
							content_arr.add(obj);
						}
					}
					itemObj.put("area", multi.getParameter(area_list.get(i)));
					itemObj.put("review", content_arr);
					area_arr.add(itemObj);
				}
			}
			date_arr.add(k, area_arr);
			System.out.println(area_arr);
		}
		
		String review_no=String.format("%010d",(review_cnt+1));
		
		ArrayList<String> image_list=new ArrayList<String>(); 
		Enumeration files=multi.getFileNames();
		while(files.hasMoreElements()){
			String name=(String)files.nextElement();
			String str=multi.getOriginalFileName(name);
			
			if(name.equals("review_image")){
				if(str==null){
					default_img="IMAGES/review_noImage.png";
					continue;
				}
				String newName=nickName+"_"+review_no+"_"+String.format("%04d",new Integer(0))+str.substring(str.lastIndexOf("."));
				File oldFile=new File(realFolder+"/"+str);
				File newFile=new File(realFolder+"/"+newName);
				oldFile.renameTo(newFile);
				default_img="review/"+newName;
			}else{
				image_list.add(name);
			}
		}
		
		// image_list.sort(String.CASE_INSENSITIVE_ORDER);
		Collections.sort(image_list);
		
		for(int i=0; i<image_list.size(); i++){
			String name=image_list.get(i);
			String str=multi.getOriginalFileName(name);
			
			if(str==null) continue;
			String newName=nickName+"_"+review_no+"_"+String.format("%04d",i+1)+str.substring(str.lastIndexOf("."));
			File oldFile=new File(realFolder+"/"+str);
			File newFile=new File(realFolder+"/"+newName);
			oldFile.renameTo(newFile);
			
			String []index_tot=name.split("_");
			JSONArray area_arr=(JSONArray)date_arr.get(Integer.parseInt(index_tot[0]));
			JSONObject itemObj=(JSONObject)area_arr.get(Integer.parseInt(index_tot[1]));
			JSONArray content_arr=(JSONArray)itemObj.get("review");
			JSONObject obj=new JSONObject();
			obj.put("image","review/"+newName);
			System.out.println(content_arr);
			System.out.println(name);
			content_arr.add(Integer.parseInt(index_tot[2]), obj);
			
			//id.writeImage("review", String.format("%010d",review_cnt+1), newName);
		}
		
		
		content=date_arr.toString();
		
		
		//System.out.println(date_arr);
		//System.out.println(member_nickname+"-"+review_name+"-"+default_img+"-"+date+"-"+term+"-"+tag_list);
		
		TagDatabase tb=new TagDatabase();
		tb.insertTag("review", review_no, tag_list);
		rd.writeReview(nickName, review_name, default_img, date, content, term);
		
		response.sendRedirect("ReviewDetail.jsp?review_no=" + review_no);
%>