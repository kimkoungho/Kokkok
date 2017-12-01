package Database;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class RecommendDatabase extends CustomDatabase
{ 
	String []columnList = {"", "member_nickname", "kind", "item_id"};
	
	public ArrayList<HashMap<String, Object>> getBestInfo(String kind , String local)
	{
		connectSQL();
		
		String query = "select *, count(*) from recommend where kind=? and item_id like '"+local+"%'" + " group by item_id limit 4";

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			
			rs = pstmt.executeQuery();
			
			while( rs.next() )
			{
				map = new HashMap<String, Object> ();
				
				for( int i = 1; i < columnList.length; i++ )
					map.put(columnList[i], rs.getString(i));
				
				map.put("recommendCount", rs.getString(4));
				
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
	
	public void insertRecommend(String member_nickname, String kind, String item_id)
	{
		connectSQL();
		
		String query = "insert into recommend values(?, ?, ?)";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, member_nickname);
			pstmt.setString(2, kind);
			pstmt.setString(3, item_id);
	
			pstmt.executeUpdate();
			
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	public boolean isRecommend(String member_nickname, String kind, String item_id)
	{
		connectSQL();
		
		String query = "select count(*) from recommend where member_nickname=? and kind=? and item_id=?";
		
		int count = 0;
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, member_nickname);
			pstmt.setString(2, kind);
			pstmt.setString(3, item_id);
	
			rs = pstmt.executeQuery();
			
			rs.next();
			
			count = rs.getInt(1);
		
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		if( count == 0 )
			return false;
		else
			return true;
	}
	
	public int getRecommendCount(String kind, String item_id)
	{
		connectSQL();
		
		String query = "select count(*) from recommend where kind=? and item_id=?";
		int count = 0;
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			count = rs.getInt(1);
			
			rs.close();
			pstmt.close();
			con.close();
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		return count;
	}
	
	public void deleteRecommend(String kind, String item_id)
	{
		connectSQL();
		
		String query="delete from recommend where kind=? and item_id=?";
		
		try
		{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			
			pstmt.executeUpdate();
			
			pstmt.close();
			con.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
}