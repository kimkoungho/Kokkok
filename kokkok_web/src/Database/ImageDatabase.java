package Database;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class ImageDatabase extends CustomDatabase
{ 
	String []columnList = {"", "kind", "item_id", "url"};
	
	public ArrayList<String> getImageURLList(String kind, String item_id)
	{
		connectSQL();
		
		String query = "select url from image where kind=? and item_id=?";
		
		ArrayList<String> list = new ArrayList<String> ();
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			
			rs = pstmt.executeQuery();
			
			while( rs.next() )
			{
				list.add(rs.getString(1));
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
	
	public void insertImage(String kind, String item_id, String url){
		connectSQL();
		
		String query="insert into image values(?, ?, ?)";
		
		try{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			pstmt.setString(3, url);
			
			pstmt.executeUpdate();
			
			pstmt.close();
			con.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void updateImage(String kind, String item_id, String url){
		connectSQL();
		
		String query="update image set url=? where kind=? and item_id=?";
		
		try{
			pstmt=con.prepareStatement(query);
			
			pstmt.setString(1, url);
			pstmt.setString(2, kind);
			pstmt.setString(3, item_id);
			
			pstmt.executeUpdate();
			
			pstmt.close();
			con.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public String getMemberImageURL(String member_nickname)
	{
		connectSQL();
		
		String memberImageURL = null;
		
		String query="select url from image where item_id=?";
		
		try
		{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, member_nickname);
			
			rs = pstmt.executeQuery();
			
			if( rs.next() )
				memberImageURL = rs.getString(1);
			
			rs.close();
			pstmt.close();
			con.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return memberImageURL;
	}
}