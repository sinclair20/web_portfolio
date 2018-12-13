package com.movie.chat.open.userList;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class UserListDAO {
	
	DataSource dataSource;
	
	public UserListDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/movie");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	
/*	public int write(String userName, String userProfile) {
		
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO userlist(userName, userProfile) SELECT ?, ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM userlist WHERE userName = ?)";		
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userName);
			pstmt.setString(2, userProfile);
			pstmt.setString(3, userName);
			
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	*/
	public int write(String userName) {
		
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO userlist(userName) SELECT ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM userlist WHERE userName = ?)";
		
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userName);
			pstmt.setString(2, userName);
			System.out.println(userName);
			

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;
	}
	
	
	public ArrayList<UserListDTO> getUserList() {
		/*HashMap<String , String> userArray = new HashMap<String , String>();*/
		ArrayList<UserListDTO> userArray = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "SELECT * FROM userlist";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);	
			rs = pstmt.executeQuery();	
			userArray = new ArrayList<UserListDTO>();
		/*	if (rs.getInt("commentID") < lastID) {
				return "";
			}*/
			while (rs.next()) {
				UserListDTO userList = new UserListDTO();
				userList.setUserName(rs.getString("userName"));
				userList.setUserProfile(rs.getString("userProfile"));
				/*comment.setCommentDate(rs.getString("commentDate").substring(5, 16));*/
				
				userArray.add(userList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		/*System.out.println("userArray"+userArray);*/
		return userArray;
	}
	
	public boolean deleteUser(String userName) {
		Connection conn = null;
		PreparedStatement pstmt = null;		
		
        boolean result = false;

		String SQL = "DELETE FROM userlist WHERE userName = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);

			pstmt.setString(1, userName);
			
			conn.setAutoCommit( false );
			
			int flag = pstmt.executeUpdate();
            if(flag > 0){
                result = true;
                conn.commit(); // 완료시 커밋
            }    
            
			return result;			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return false;
	}
	
	
	
	public String getProfile (String name) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "SELECT userProfile FROM userlist WHERE name = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if(rs.getString("userProfile").equals("") || rs.getString("userProfile").equals(null)) {
					return "http://localhost:8000/localMovie/images/userIcon.png";
				}
				return "http://localhost:8000/localMovie/upload/" + rs.getString("userProfile");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "http://localhost:8000/localMovie/images/userIcon.png";
	}
	
	
	
	public int writeProfile(String userName, String userProfile) {
		
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE userlist SET userProfile = ? WHERE userName = ? ";
		/*String SQL = "INSERT INTO userlist(userProfile) SELECT ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM userlist WHERE userName = ?)";*/
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userProfile);
			pstmt.setString(2, userName);

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;
	}


}
