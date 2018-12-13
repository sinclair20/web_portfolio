package com.movie.board.comment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class CommentDAO {
		
	DataSource dataSource;
		
	public CommentDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/movie");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int write(String commentContent, String commentWriter, String boardID, String userID, String userPassword) {
	
			
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String SQL = "INSERT INTO comment SELECT IFNULL((SELECT MAX(commentID) + 1 FROM comment), 1), ?, ?, now(), ?, ?, ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, commentContent.replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
			pstmt.setString(2, commentWriter);
			pstmt.setInt(3, Integer.parseInt(boardID));
			pstmt.setString(4, userID);
			pstmt.setString(5, userPassword);
			
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
	
	
	
	public int nonmemberWrite(String commentContent, String commentWriter, String boardID, String commentPassword) {
				
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String SQL = "INSERT INTO comment SELECT IFNULL((SELECT MAX(commentID) + 1 FROM comment), 1), ?, ?, now(), ?, null, ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, commentContent.replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
			pstmt.setString(2, commentWriter);
			pstmt.setInt(3, Integer.parseInt(boardID));
			pstmt.setString(4, commentPassword);
			
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
	
	
	public CommentDTO getComment(String boardID) {
		CommentDTO comment = new CommentDTO();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
			
		
		/*String SQL = "SELECT * comment WHERE boardID = ? AND commentID = ?";*/
		String SQL = "SELECT * FROM comment WHERE boardID = ? ORDER BY commentID DESC LIMIT 1"; 
		try {
			
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			
			rs = pstmt.executeQuery();			
			
			while (rs.next()) {
				comment.setBoardID(rs.getInt("boardID"));
				comment.setCommentID(rs.getInt("commentID"));
				comment.setUserID(rs.getString("userID"));
				comment.setCommentWriter(rs.getString("commentWriter").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				comment.setCommentContent(rs.getString("commentContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				/*comment.setCommentDate(rs.getString("commentDate").substring(5, 16));*/
				int commentDate = Integer.parseInt(rs.getString("commentDate").substring(11, 13));
				String timeType = "오전";
				if (commentDate >= 12) {
					timeType = "오후";
					commentDate -= 12;
				}
				comment.setCommentDate(rs.getString("commentDate").substring(0, 11) + " " + timeType + " " + commentDate + ":" + rs.getString("commentDate").substring(14, 16) + "");
				comment.setCommentPassword(rs.getString("commentPassword"));
				
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
		return comment;
	}
	
	
	/*public ArrayList<CommentDTO> getCommentList(String boardID, String commentID, String page) {
				
		String lastID = String.valueOf((Integer.parseInt(page) * 5)); 
		System.out.println(lastID);
		ArrayList<CommentDTO> commentList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "SELECT * FROM COMMENT WHERE boardID = ? AND ? < commentID < ? ORDER BY commentDate";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			pstmt.setString(2, commentID);
			pstmt.setString(3, lastID);
			rs = pstmt.executeQuery();	
			commentList = new ArrayList<CommentDTO>();
			if (rs.getInt("commentID") < lastID) {
				return "";
			}
			while (rs.next()) {
				CommentDTO comment = new CommentDTO();
				comment.setBoardID(rs.getInt("boardID"));
				comment.setCommentID(rs.getInt("commentID"));
				comment.setUserID(rs.getString("userID"));
				comment.setCommentWriter(rs.getString("commentWriter"));
				comment.setCommentContent(rs.getString("commentContent"));
				comment.setCommentDate(rs.getString("commentDate").substring(0, 11));
				comment.setCommentPassword(rs.getString("commentPassword"));
				commentList.add(comment);
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
		return commentList;
	}*/
	
	public ArrayList<CommentDTO> getCommentList(String boardID, String commentID) {
		
		ArrayList<CommentDTO> commentList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "SELECT * FROM comment WHERE boardID = ? AND commentID > ? ORDER BY commentDate";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			pstmt.setString(2, commentID);			
			rs = pstmt.executeQuery();	
			commentList = new ArrayList<CommentDTO>();
		/*	if (rs.getInt("commentID") < lastID) {
				return "";
			}*/
			while (rs.next()) {
				CommentDTO comment = new CommentDTO();
				comment.setBoardID(rs.getInt("boardID"));
				comment.setCommentID(rs.getInt("commentID"));
				comment.setUserID(rs.getString("userID"));
				comment.setCommentWriter(rs.getString("commentWriter").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				comment.setCommentContent(rs.getString("commentContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				/*comment.setCommentDate(rs.getString("commentDate").substring(5, 16));*/
				int commentDate = Integer.parseInt(rs.getString("commentDate").substring(11, 13));
				String timeType = "오전";
				if (commentDate >= 12) {
					timeType = "오후";
					commentDate -= 12;
				}
				comment.setCommentDate(rs.getString("commentDate").substring(0, 11) + " " + timeType + " " + commentDate + ":" + rs.getString("commentDate").substring(14, 16) + "");
				comment.setCommentPassword(rs.getString("commentPassword"));
				commentList.add(comment);
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
		return commentList;
	}	
	
	
	
	
	
	public int update(String boardID, String commentID, String commentContent) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE comment SET commentContent = ? WHERE boardID = ? AND commentID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, commentContent);			
			pstmt.setInt(2, Integer.parseInt(boardID));
			pstmt.setInt(3, Integer.parseInt(commentID));
			return pstmt.executeUpdate();			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}		
		return -1;
	}
	
	
	public boolean deleteComment(String commentID) {
		Connection conn = null;
		PreparedStatement pstmt = null;		
		
        boolean result = false;

		String SQL = "DELETE FROM comment WHERE commentID = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);

			pstmt.setInt(1, Integer.parseInt(commentID));
			
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


	
/*public ArrayList<ChatDTO> getCommentListByID (String boardID) {
		
		CommentDAO commentDAO = new CommentDAO();
		CommentDTO comment = commentDAO.getComment(boardID); 
		
		ArrayList<CommentDTO> commentList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 7강 에서 나온 SQL문과 변했는지
		String SQL = "SELECT * FROM CHAT WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) AND chatID > ? ORDER BY chatTime";
		String SQL = "SELECT * FROM COMMENT WHERE boardID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(URLDecoder.decode(chatID,"UTF-8")));
			rs = pstmt.executeQuery();
			chatList = new ArrayList<ChatDTO>();
			while (rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if (chatTime >= 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime +  ":" + rs.getString("chatTime").substring(14, 16) + "");
				chatList.add(chat);
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
		return chatList;  
	}
	*/
}
