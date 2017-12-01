package Database;

import java.util.ArrayList;
import java.util.HashMap;
import java.sql.*;

public class CustomDatabase
{
	Connection con;
	ResultSet rs;
	Statement stmt;
	PreparedStatement pstmt;
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>> ();
	HashMap<String, Object> map = new HashMap<String, Object> ();
	
	protected void connectSQL()
	{
		try
		{
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/kokkok", "kouser", "kopass");
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}