package Database;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import sun.security.ssl.RSASignature;

public class CommentDatabase extends CustomDatabase
{
	String[] columnList = { "", "comment_no", "member_nickname", "kind", "item_id", "level", "parent_item_id", "date", "content" };

	public int getCommentCount(String kind, String item_id)
	{
		connectSQL();
	
		String query="select count(*) from comment where kind=? and item_id=? and level=1";
	
		int ret=0;
	
		try
		{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
		
			rs=pstmt.executeQuery();
		
			if( rs.next() )
				ret=rs.getInt(1);
		
			rs.close();
			pstmt.close();
			con.close();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	
		return ret;
	}
	
	public HashMap<String, Object> getParentCommentInfo(String comment_no)
	{
		connectSQL();
		
		String query = "select * from comment where comment_no=?";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, comment_no);
			rs = pstmt.executeQuery();
			
			map = new HashMap<String, Object>();
			
			rs.next();
			
			for( int i = 1; i < columnList.length; i++ )
				map.put(columnList[i], rs.getObject(i));

			rs.close();
			pstmt.close();
			con.close();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		return map;
	}
	
	public void insertCommentInfo(String member_nickname, String kind, String item_id, int level, String parent_item_id, String date, String content)
	{
		connectSQL();
		
		String query = "select max(comment_no) from comment";

		try
		{
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			int count = 1;
			
			while( rs.next() )
				count = rs.getInt(1) + 1;
			
			String commend_no = String.format("%010d", count);
			
			query = "insert into comment values(?, ?, ?, ?, ?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, commend_no);
			pstmt.setString(2, member_nickname);
			pstmt.setString(3, kind);
			pstmt.setString(4, item_id);
			pstmt.setInt(5, level);
			pstmt.setString(6, parent_item_id);
			pstmt.setString(7, date);
			pstmt.setString(8, content);
			
			pstmt.executeUpdate();
			
			rs.close();
			pstmt.close();
			stmt.close();
			con.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	
	public ArrayList<HashMap<String, Object>> getDB(String kind, String item_id, int level)
	{
		connectSQL();

		String query = "select * from comment where kind=? and item_id=? and level=? order by date";

		list = new ArrayList<HashMap<String, Object>>();

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			pstmt.setInt(3, level);

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
	
	public ArrayList<HashMap<String, Object>> getSubDB(String kind, String item_id, int level, String parent_item_id)
	{
		connectSQL();

		String query = "select * from comment where kind=? and item_id=? and level=? and parent_item_id=? order by date";

		list = new ArrayList<HashMap<String, Object>>();

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			pstmt.setInt(3, level);
			pstmt.setString(4, parent_item_id);

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
	
	public void updateCommentInfo(String comment_no, String content)
	{
		connectSQL();

		String query = "update comment set content=? where comment_no=?";
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, content);
			pstmt.setString(2, comment_no);
			pstmt.executeUpdate();
			
			pstmt.close();
			con.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	public void deleteCommentInfo(String comment_no)
	{
		connectSQL();

		String query = "select comment_no from comment where parent_item_id=?";
		
		ArrayList<String> tempList = new ArrayList<String> ();
		
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, comment_no);
			rs = pstmt.executeQuery();
			
			while( rs.next() )
				tempList.add(rs.getString(1));
			
			query = "delete from comment where comment_no=?";
			
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, comment_no);
			pstmt.executeUpdate();
			
			for( int i = 0; i < tempList.size(); i++ )
			{
				query = "delete from comment where comment_no=? or parent_item_id=?";
				
				pstmt = con.prepareStatement(query);
				pstmt.setString(1, tempList.get(i));
				pstmt.setString(2, tempList.get(i));
				pstmt.executeUpdate();
			}
			
			rs.close();
			pstmt.close();
			con.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	public void deleteComment(String kind, String item_id)
	{
		connectSQL();
		
		String query="delete from comment where kind=? and item_id=?";
		
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
	
//	public HashMap<String, Object> getCommentInfo(String comment_no)
//	{
//		connectSQL();
//
//		String query = "select * from comment where comment_no=?";
//
//		try
//		{
//			pstmt = con.prepareStatement(query);
//			pstmt.setString(1, comment_no);
//
//			rs = pstmt.executeQuery();
//
//			map = new HashMap<String, Object>();
//
//			rs.next();
//
//			for (int i = 1; i < columnList.length; i++)
//				map.put(columnList[i], rs.getObject(i));
//
//			rs.close();
//			pstmt.close();
//			con.close();
//		}
//		catch (SQLException e)
//		{
//			e.printStackTrace();
//		}
//		return map;
//	}
//
//	public void writeComment(String member_nickname, String kind, String item_id, String date, String content, String sub_comment_no)
//	{
//		connectSQL();
//
//		String subQuery = "select count(comment_no) from comment";
//
//		String comment_no = "";
//		int cnt = 1;
//
//		String query = "insert into comment values(?, ?, ?, ?, ?, ?, ?)";
//
//		try
//		{
//			stmt = con.createStatement();
//			rs = stmt.executeQuery(subQuery);
//			if (rs.next())
//				cnt = rs.getInt(1) + 1;
//
//			for (int i = 1; i <= 9 - cnt / 10; i++)
//				comment_no += "0";
//
//			comment_no += cnt;
//
//			pstmt = con.prepareStatement(query);
//			pstmt.setString(1, comment_no);
//			pstmt.setString(2, member_nickname);
//			pstmt.setString(3, kind);
//			pstmt.setString(4, item_id);
//			pstmt.setString(5, date);
//			pstmt.setString(6, content);
//			pstmt.setString(7, sub_comment_no);
//			
//			pstmt.executeUpdate();
//		}
//		catch (SQLException e)
//		{
//			e.printStackTrace();
//		}
//	}
//
//	//
//	public ArrayList<HashMap<String, Object>> getDB(String kind, String item_id)
//	{
//		connectSQL();
//
//		String query = "select * from comment where kind=? and item_id=? order by date";
//
//		list = new ArrayList<HashMap<String, Object>>();
//
//		try
//		{
//			pstmt = con.prepareStatement(query);
//			pstmt.setString(1, kind);
//			pstmt.setString(2, item_id);
//
//			rs = pstmt.executeQuery();
//
//			while (rs.next())
//			{
//				map = new HashMap<String, Object>();
//
//				for (int i = 1; i < columnList.length; i++)
//					map.put(columnList[i], rs.getObject(i));
//
//				list.add(map);
//			}
//
//			rs.close();
//			pstmt.close();
//			con.close();
//		} catch (SQLException e)
//		{
//			e.printStackTrace();
//		}
//		return list;
//	}
//	
//	public int getCommentCount(String kind, String item_id)
//	{
//		connectSQL();
//		
//		String query="select count(*) from comment where kind=? and item_id=?";
//		
//		int ret=0;
//		
//		try
//		{
//			pstmt=con.prepareStatement(query);
//			pstmt.setString(1, kind);
//			pstmt.setString(2, item_id);
//			
//			rs=pstmt.executeQuery();
//			
//			if( rs.next() )
//				ret=rs.getInt(1);
//			
//			rs.close();
//			pstmt.close();
//			con.close();
//		}
//		catch(SQLException e)
//		{
//			e.printStackTrace();
//		}
//		
//		return ret;
//	}
}