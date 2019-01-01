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
		
			while (rs.next()) {
				UserListDTO userList = new UserListDTO();
				userList.setUserName(rs.getString("userName"));
				
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
	
	

}
