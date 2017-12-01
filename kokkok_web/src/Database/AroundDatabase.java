package Database;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class AroundDatabase extends CustomDatabase
{ 
	String []columnList = {"", "kind", "item_id", "name", "address", "latitude", "longitude"};
	
	public String getAround(String item_id, double latitude, double longitude, double distance)
	{
		connectSQL();
		
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from around having distance < ?";
		
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
				if( item_id != null )
				{
					if( !item_id.equals(rs.getString(1)) )
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
			
			obj.put("around", arr);
			
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
	
	public String getCourseAround(String passList, double distance)
	{
		connectSQL();
		
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from around having distance < ?";
		
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
			
			obj.put("around", arr);
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}

		return obj.toString();
	}
	
	public ArrayList<HashMap<String, Object>> getPage2(String passList, double distance, int page)
	{
		connectSQL();
		
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from around where not kind = 'wifi' having distance < ?";
		
		ArrayList<HashMap<String, Object>> tempList = new ArrayList<HashMap<String, Object>> ();
		ArrayList<String> nameList = new ArrayList<String> ();
			
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
					
					if( !nameList.contains((String)tempMap.get("name")) )
					{
						nameList.add((String)tempMap.get("name"));
						tempList.add(tempMap);
					}
				}
				rs.close();
				pstmt.close();
			}
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		ArrayList<HashMap<String, Object>> tempList2 = new ArrayList<HashMap<String, Object>> ();
		
		int cnt = 0;
		
		for( int i = (page - 1) * 10; i < tempList.size(); i++ )
		{
			cnt++;
			
			tempList2.add(tempList.get(i));
			
			if( cnt == 10 )
				break;
		}

		return tempList2;
	}
	
	public int getTotalPage2(String passList, double distance)
	{
		connectSQL();
		
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from around where not kind = 'wifi' having distance < ?";
		
		ArrayList<HashMap<String, Object>> tempList = new ArrayList<HashMap<String, Object>> ();
		ArrayList<String> nameList = new ArrayList<String> ();
			
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
			
					if( !nameList.contains((String)tempMap.get("name")) )
					{
						nameList.add((String)tempMap.get("name"));
						tempList.add(tempMap);
					}
				}
				
				rs.close();
				pstmt.close();
			}
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	
		return tempList.size();
	}
	
	public int getTotalPage(String item_id, double latitude, double longitude, double distance)
	{
		connectSQL();
		
		String query = "select count(*) from around where not kind=? and ((6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude))))) < ?";
		
		int totalPage = 0;
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, "wifi");
			pstmt.setDouble(2, latitude);
			pstmt.setDouble(3, longitude);
			pstmt.setDouble(4, latitude);
			pstmt.setDouble(5, distance);
			
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
	public ArrayList<HashMap<String, Object>> getPage(String item_id, double latitude, double longitude, double distance, int page)
	{
		connectSQL();
	
		String query = "select *, (6371 * acos(cos(radians(?)) * cos( radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin( radians(latitude)))) as distance from around where not kind = ? having distance < ?  limit ?, ?";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setDouble(1, latitude);
			pstmt.setDouble(2, longitude);
			pstmt.setDouble(3, latitude);
			pstmt.setString(4, "wifi");
			pstmt.setDouble(5, distance);
			pstmt.setInt(6, (page - 1) * 10);
			pstmt.setInt(7, 10);
			
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