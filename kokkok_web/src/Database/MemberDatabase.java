package Database;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class MemberDatabase extends CustomDatabase{

	String []columnList = {"", "id","nickname"};
	
	
	public void insertMember(String id, String nickname){

		connectSQL();

		String query = "insert into member values(?, ?)";

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, nickname);
			
			pstmt.executeUpdate();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	public int getMemeber(String nickname){
		connectSQL();

		String query = "select count(*) from member where nickname=?";

		int cnt=0;
		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, nickname);

			rs = pstmt.executeQuery();

			rs.next();

			cnt=rs.getInt(1);

			rs.close();
			pstmt.close();
			con.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		return cnt;
	}
	
	public HashMap<String, Object> getMemberInfo(String id){
		connectSQL();

		String query = "select * from member where id=?";

		try
		{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);

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
	
	public boolean isID(String id)
	{
		connectSQL();
		
		String query="select * from member where id=?";
		
		boolean flag=false;
		try
		{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, id);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
				flag=true;
			
			rs.close();
			pstmt.close();
			con.close();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		return flag;
	}
}