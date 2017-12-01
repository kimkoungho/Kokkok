package Database;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class TagDatabase extends CustomDatabase
{
	String[] columnList = { "", "kind", "item_id", "tag_content"};
	
	public ArrayList<HashMap<String, Object>> getBestTag(String kind){
		connectSQL();
		
		String query="select *, count(*) from tag "
				+"group by tag_content having kind=? order by count(*) desc";
		
		try{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, kind);
			
			rs=pstmt.executeQuery();
			while(rs.next()){
				map = new HashMap<String, Object>();
				for(int i=1; i<columnList.length; i++)
					map.put(columnList[i], rs.getString(i));
				
				list.add(map);
			}
			
			rs.close();
			pstmt.close();
			con.close();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return list;
	}
	public ArrayList<HashMap<String, Object>> getDB(String tag){
		connectSQL();
		
		String query="select * from tag where tag_content=?";
		
		try{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, tag);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				map = new HashMap<String, Object>();
				for(int i=1; i<columnList.length; i++)
					map.put(columnList[i], rs.getString(i));
				list.add(map);
			}
			
			rs.close();
			pstmt.close();
			con.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}
	public void insertTag(String kind, String item_id, String tag_content){
		
		connectSQL();
		
		String tagList[]=tag_content.split("#");
		String query="insert into tag values(?, ?, ?)";
		
		try{
			pstmt=con.prepareStatement(query);
			pstmt.setString(1, kind);
			pstmt.setString(2, item_id);
			for(int i=1; i<tagList.length; i++){
				String tag="#"+tagList[i];
				if(tag==null) continue;
				
				pstmt.setString(3, tag);
				pstmt.executeUpdate();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
}