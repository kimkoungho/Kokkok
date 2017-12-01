package Database;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class MyItemDatabase extends CustomDatabase
{
	String[] columnList = { "", "member_nickname", "kind", "item_id" };

	public ArrayList<HashMap<String, Object>> getMyArea(String kind, String member_nickname)
	{
		connectSQL();
		
		AreaDatabase ad=new AreaDatabase();
		
		String query="select * from area where area_no in" +"(select item_id from myItem where kind=? and member_nickname=?)";
		
		list = new ArrayList<HashMap<String, Object>>();

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2,member_nickname);
		
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				map = new HashMap<String, Object>();

				for (int i = 1; i < ad.columnList.length; i++)
					map.put(ad.columnList[i], rs.getObject(i));

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
	
	public ArrayList<HashMap<String, Object>> getMyRestaurant(String kind, String member_nickname)
	{
		connectSQL();
		
		RestaurantDatabase ad=new RestaurantDatabase();
		
		String query="select * from restaurant where rst_no in" +"(select item_id from myItem where kind=? and member_nickname=?)";
		
		list = new ArrayList<HashMap<String, Object>>();

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2,member_nickname);
		
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				map = new HashMap<String, Object>();

				for (int i = 1; i < ad.columnList.length; i++)
					map.put(ad.columnList[i], rs.getObject(i));

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
	
	public ArrayList<HashMap<String, Object>> getMyAccommodation(String kind, String member_nickname)
	{
		connectSQL();
		
		AccommodationDatabase ad=new AccommodationDatabase();
		
		String query="select * from accommodation where acc_no in" +"(select item_id from myItem where kind=? and member_nickname=?)";
		
		list = new ArrayList<HashMap<String, Object>>();

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2,member_nickname);
		
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				map = new HashMap<String, Object>();

				for (int i = 1; i < ad.columnList.length; i++)
					map.put(ad.columnList[i], rs.getObject(i));

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
	
	public ArrayList<HashMap<String, Object>> getMyShopping(String kind, String member_nickname)
	{
		connectSQL();
		
		ShoppingDatabase sd=new ShoppingDatabase();
		
		String query="select * from shopping where shop_no in" +"(select item_id from myItem where kind=? and member_nickname=?)";
		
		list = new ArrayList<HashMap<String, Object>>();

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2,member_nickname);
		
			rs = pstmt.executeQuery();

			while (rs.next())
			{
				map = new HashMap<String, Object>();

				for (int i = 1; i < sd.columnList.length; i++)
					map.put(sd.columnList[i], rs.getObject(i));

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
	
	public ArrayList<HashMap<String, Object>> getMyCourse(String kind, String member_nickname)
	{
		connectSQL();
		
		
		CourseDatabase cd=new CourseDatabase();
		
		String query = "select * from course where course_no in" + "(select item_id from myItem where kind=? and member_nickname=?)";
	
		list = new ArrayList<HashMap<String, Object>>();
	
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, member_nickname);
			
			rs = pstmt.executeQuery();
	
			while (rs.next())
			{
				map = new HashMap<String, Object>();
	
				for (int i = 1; i < cd.columnList.length; i++)
					map.put(cd.columnList[i], rs.getObject(i));
	
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
	
	public boolean isScrap(String member_nickname, String kind, String item_id)
	{
		connectSQL();
		
		String query = "select count(*) from myItem where member_nickname=? and kind=? and item_id=?";
		
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

	public void writeMyItem(String member_nickname, String kind, String item_id)
	{
		connectSQL();
	
		String query = "insert into myItem values(?, ?, ?)";
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

	public int getScrapCount(String kind, String item_id)
	{
		connectSQL();
		
		String query="select count(*) from myItem where kind=? and item_id=?";
		
		int ret = 0;
		
		try
		{
			pstmt = con.prepareStatement(query);
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
	
	public void deleteMyItem(String kind, String item_id)
	{
		connectSQL();
		
		String query="delete from myItem where kind=? and item_id=?";
		
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