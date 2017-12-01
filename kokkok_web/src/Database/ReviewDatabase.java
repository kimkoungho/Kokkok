package Database;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class ReviewDatabase extends CustomDatabase
{
	String[] columnList = { "", "review_no", "member_nickname", "review_name", "default_image","date", "content", "term"};

	public HashMap<String, Object> getReviewInfo(String review_no)
	{
		connectSQL();

		String query = "select * from review where review_no=?";

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, review_no);

			rs = pstmt.executeQuery();

			map = new HashMap<String, Object>();

			rs.next();

			for (int i = 1; i < columnList.length; i++)
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

	public void writeReview(String member_nickname, String review_name, String default_image,String date, String content, String term)
	{
		connectSQL();

		String subQuery = "select count(*) from review";

		String review_no = "";
		int cnt = 1;

		String query = "insert into review values(?, ?, ?, ?, ?, ?, ?)";

		try
		{
			stmt = con.createStatement();
			rs = stmt.executeQuery(subQuery);
			if (rs.next())
				cnt = rs.getInt(1) + 1;


			review_no =String.format("%010d", cnt);

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, review_no);
			pstmt.setString(2, member_nickname);
			pstmt.setString(3, review_name);
			pstmt.setString(4, default_image);
			pstmt.setString(5, date);
			pstmt.setString(6, content);
			pstmt.setString(7, term);
			
			pstmt.executeUpdate();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	//
	public ArrayList<HashMap<String, Object>> getDB()
	{
		connectSQL();

		String query = "select * from review order by date";

		list = new ArrayList<HashMap<String, Object>>();

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
	
	public ArrayList<HashMap<String, Object>> getMyReviewInfo(String member)
	{
		connectSQL();
		
		String query="select * from review where member_nickname = ?";
		
		try
		{
			pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, member);
			
			rs = pstmt.executeQuery();
			
			while( rs.next() )
			{
				map = new HashMap<String, Object> ();
				
				for( int i = 1; i < columnList.length; i++ )
					map.put(columnList[i], rs.getString(i));
				
				list.add(map);
			}
			
			rs.close();
			pstmt.close();
			con.close();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		return list;
	}
	
	public int getReviewCount()
	{
		connectSQL();
		
		String query="select count(*) from review";
		
		int ret=0;
		
		try
		{
			pstmt=con.prepareStatement(query);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
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
	
	public ArrayList<HashMap<String, Object>> getSearchReview(String content, String area, String tag)
	{
		connectSQL();

		String query = "select * from review where content like '%"+content+"%' "
				+"and content like '%"+area+"%' and review_no in "
				+"(select item_id from tag where kind='review' and tag_content like '%"+tag+"');";

		list = new ArrayList<HashMap<String, Object>>();
		
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
	
	public void deleteReview(String review_no)
	{
		connectSQL();
		
		String query="delete from review where review_no=?";
		
		try
		{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, review_no);
			
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