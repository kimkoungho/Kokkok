package Database;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CourseDatabase extends CustomDatabase
{ 
	String []columnList = {"", "course_no", "name", "route", "isBasic", "nickname"};
	
	public ArrayList<HashMap<String, Object>> getAreaCourseInfo(String item_id)
	{
		connectSQL();
		
		String query = "select * from course where route like '%" + item_id + "%'";

		try 
		{
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				map = new HashMap<String, Object>();

				for (int i = 1; i < columnList.length; i++)
					map.put(columnList[i], rs.getObject(i));

				list.add(map);
			}

			rs.close();
			pstmt.close();
			con.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		return list;
	}
	
	public ArrayList<HashMap<String, Object>> getDB(String local, String isBasic)
	{
		connectSQL();
		
		String query = "select * from course where course_no like ? '%' and isBasic=?";
		
		if( !local.equals("") )
			local = local.substring(0, 2);
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, local);
			pstmt.setString(2, isBasic);
			
			rs = pstmt.executeQuery();
			
			
			
			while( rs.next() )
			{
				map = new HashMap<String, Object> ();
				
				for( int i = 1; i < columnList.length; i++ )
					map.put(columnList[i], rs.getObject(i));
				
				list.add(map);
			}
			
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<HashMap<String, Object>> getMyCourseInfo(String nickname)
	{	
		connectSQL();
		
		String query = "select * from course where nickname=?";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, nickname);
			
			rs = pstmt.executeQuery();
			
			while( rs.next() )
			{
				map = new HashMap<String, Object> ();
				
				for( int i = 1; i < columnList.length; i++ )
					map.put(columnList[i], rs.getObject(i));
				
				list.add(map);
			}
			
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public HashMap<String, Object> getCourseInfo(String item_id)
	{
		connectSQL();
		
		String query = "select * from course where course_no=?";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, item_id);
			
			rs = pstmt.executeQuery();
			
			map = new HashMap<String, Object> ();
			
			rs.next();
			
			for( int i = 1; i < columnList.length; i++ )
				map.put(columnList[i], rs.getObject(i));
	
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		return map;
	}

	public int getCourseCount(String local)
	{
		connectSQL();
		String query = "select count(course_no) from course where course_no like '%"+local+"%'";

		int len=0;
		
		try
		{
			pstmt = con.prepareStatement(query);

			rs = pstmt.executeQuery();

			rs.next();
			
			len=rs.getInt(1)+1;

			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		return len;
	}
	
	public void insertCourse(String course_no,String course_name, String course_route, String isBasic, String nickname)
	{
		connectSQL();
		String query = "insert into course values(?, ?, ?, ?, ?)";

		try 
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, course_no);
			pstmt.setString(2, course_name);
			pstmt.setString(3, course_route);
			pstmt.setString(4, isBasic);
			pstmt.setString(5, nickname);
			pstmt.executeUpdate();

			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	public void deleteCourse(String course_no)
	{
		connectSQL();
		
		String query="delete from course where course_no=?";
		
		try
		{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, course_no);
			
			pstmt.executeUpdate();
			
			pstmt.close();
			con.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public int getTotalPage(String local, String isBasic)
	{
		connectSQL();
		
		if( !local.equals("") )
			local = local.substring(0, 2);
		
		String query = "select count(course_no) from course where course_no like ? '%' and isBasic=?";
		int totalPage = 0;
		
		try
		{
			pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, local);
			pstmt.setString(2, isBasic);
			
			rs = pstmt.executeQuery();
			 
			if( rs.next() )
				totalPage = rs.getInt(1);
			
			rs.close();
			pstmt.close();
			con.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return totalPage;
	}
	//0-30
	// 20 - 50
	public ArrayList<HashMap<String, Object>> getPage(String local, String isBasic, int page)
	{
		connectSQL();
		
		if( !local.equals("") )
			local = local.substring(0, 2);
		
		String query = "select * from course where course_no like ? '%' and isBasic=? limit ?, ?";
		
		list = new ArrayList<HashMap<String, Object>> ();
	
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, local);
			pstmt.setString(2, isBasic);
			pstmt.setInt(3, (page - 1) * 10);
			pstmt.setInt(4, 10);
			
			rs = pstmt.executeQuery();
			
			while( rs.next() )
			{
				map = new HashMap<String, Object> ();
				
				for( int i = 1; i < columnList.length; i++ )
					map.put(columnList[i], rs.getObject(i));
				
				list.add(map);
			}
			
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		return list;
	}
}