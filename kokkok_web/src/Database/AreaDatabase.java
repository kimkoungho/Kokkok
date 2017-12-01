package Database;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class AreaDatabase extends CustomDatabase
{ 
	String []columnList = {"", "area_no", "name", "address", "latitude", "longitude", "phone", "intro", "time", "cost", "kind"};
	
	public HashMap<String, Object> getAreaInfo(String item_id)
	{
		connectSQL();
		
		String query = "select * from area where area_no=?";
		
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
	
//	public ArrayList<Object[]> getAroundInfo(String area_no, double latitude, double longitude, double distance)
//	{
//		connectSQL();
//		
//		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from area having distance < ?";
//		
//		ArrayList <Object[]> list = new ArrayList<Object[]> ();
//		
//		try
//		{
//			pstmt = con.prepareStatement(query);
//			pstmt.setDouble(1, latitude);
//			pstmt.setDouble(2, longitude);
//			pstmt.setDouble(3, latitude);
//			pstmt.setDouble(4, distance);
//			
//			rs = pstmt.executeQuery();
//			
//			while( rs.next() )
//			{
//				Object []obj = new Object[columnList.length + 1];
//				
//				if( area_no != null && !area_no.equals(rs.getString(1)) )
//				{
//					for( int i = 1; i < columnList.length; i++ )
//						obj[i] = rs.getObject(i);
//					obj[columnList.length] = rs.getObject(columnList.length);
//					list.add(obj);
//				}
//			}
//			rs.close();
//			pstmt.close();
//			con.close();
//		} 
//		catch (SQLException e)
//		{
//			e.printStackTrace();
//		}
//
//		return list;
//	}
	
	
	public String getCourseAround(String passList, double distance)
	{
		connectSQL();
		
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from area having distance < ?";
		
		JSONObject obj = new JSONObject();
		JSONArray arr = new JSONArray();

		ArrayList<HashMap<String, Object>> tempList = new ArrayList<HashMap<String, Object>> ();
			
		try
		{
			String []temp = passList.split("-");
			
			for( int i = 0; i < temp.length; i++ )
			{
				pstmt = con.prepareStatement(query);
				pstmt.setDouble(1, Double.parseDouble(temp[i].split(",")[0]));	// latitude
				pstmt.setDouble(2, Double.parseDouble(temp[i].split(",")[1]));	// longitude
				pstmt.setDouble(3, Double.parseDouble(temp[i].split(",")[0]));	// latitude
				pstmt.setDouble(4, distance);
				
				rs = pstmt.executeQuery();
				
				while( rs.next() )
				{
					HashMap<String, Object> tempMap = new HashMap<String, Object> ();
					
					for( int j = 1; j < columnList.length; j++ )
						tempMap.put(columnList[j], rs.getObject(j));
					
					if( !tempList.contains(tempMap) )
						tempList.add(tempMap);
					
				}
				rs.close();
				pstmt.close();
			}
			
			con.close();
			
			for( int i = 0; i < tempList.size(); i++ )
			{
				HashMap<String, Object> tempMap = tempList.get(i);
				
				JSONObject tempObj = new JSONObject();
				
				for( int j = 1; j < columnList.length; j++ )
					tempObj.put(columnList[j], tempMap.get(columnList[j]));
				
				arr.add(tempObj);
			}
			
			obj.put("area", arr);
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return obj.toString();
	}
	
	
	public String getAround(String area_no, double latitude, double longitude, double distance)
	{
		connectSQL();
		
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from area having distance < ?";
		
		JSONObject obj = new JSONObject();
		JSONArray arr = new JSONArray();
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setDouble(1, latitude);
			pstmt.setDouble(2, longitude);
			pstmt.setDouble(3, latitude);
			pstmt.setDouble(4, distance);
			
			rs = pstmt.executeQuery();
			
			while( rs.next() )
			{
				if( area_no != null )
				{
					if( !area_no.equals(rs.getString(1)) )
					{
						
					}
				}
				else
				{
					JSONObject tempObj = new JSONObject();
					
					for( int i = 1; i < columnList.length; i++ )
						tempObj.put(columnList[i], rs.getObject(i));
				
					arr.add(tempObj);
				}
			}
			
			obj.put("area", arr);
			
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		return obj.toString();
	}
	
	
	
	
	public ArrayList<HashMap<String, Object>> getDB(String local)
	{
		connectSQL();
		
		String query = "select * from area where area_no like ? '%'";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, local);
			
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
	
	public int getTotalPage(String local)
	{
		connectSQL();
		
		if( !local.equals("") )
			local = local.substring(0, 2);
		
		String query = "select count(area_no) from area where area_no like ? '%'";
		int totalPage = 0;
		
		try
		{
			pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, local);
			
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
	public ArrayList<HashMap<String, Object>> getPage(String local, int page)
	{
		connectSQL();
		
		if( !local.equals("") )
			local = local.substring(0, 2);
		
		String query = "select * from area where area_no like ? '%' limit ?, ?";
	
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, local);
			pstmt.setInt(2, (page - 1) * 10);
			pstmt.setInt(3, 10);
			
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