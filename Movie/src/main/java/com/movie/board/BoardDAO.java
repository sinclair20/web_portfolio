package com.movie.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {
	
	DataSource dataSource;
	
	public BoardDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/movie");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public int write(String userID, String boardTitle, String boardContent, String boardFile, String boardRealFile) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO board SELECT ?, IFNULL((SELECT MAX(boardID) + 1 FROM board), 1), ?, ?, now(), 0, ?, ?, IFNULL((SELECT MAX(boardGroup) + 1 FROM board), 0), 0, 0, 1, 0	";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, boardTitle);
			pstmt.setString(3, boardContent);
			pstmt.setString(4, boardFile);
			pstmt.setString(5, boardRealFile);
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
	
	
	public BoardDTO getBoard(String boardID) {
		BoardDTO board = new BoardDTO();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM board WHERE boardID = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 11));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardAvailable(rs.getInt("boardAvailable"));
				board.setLikeCount(rs.getInt("likeCount"));
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
		return board;
	}
	
	
	
	public ArrayList<BoardDTO> getList(String pageNumber) {
		
		ArrayList<BoardDTO> boardList = null;		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM board WHERE boardGroup > (SELECT MAX(boardGroup) FROM board) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM board) - ? ORDER BY boardGroup DESC, boardSequence ASC";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
			pstmt.setInt(2, (Integer.parseInt(pageNumber) -1) * 10);
			rs = pstmt.executeQuery();
			boardList = new ArrayList<BoardDTO>();

			while (rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 11));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardAvailable(rs.getInt("boardAvailable"));
				board.setLikeCount(rs.getInt("likeCount"));
				boardList.add(board);
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
		return boardList;
	}
	
	
	
	public ArrayList<BoardDTO> getPostList(String searchType, String search, int pageNumber) {
		
		ArrayList<BoardDTO> postList = null;		
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			if (searchType.equals("최신순")) {				
				// 쿼리 두번으로 나누어 날리기.
// "SELECT * FROM BOARD WHERE boardGroup > (SELECT MAX(boardGroup) FROM BOARD) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM BOARD) - ? ORDER BY boardGroup DESC, boardSequence ASC";			
				//SQL = "SELECT * FROM BOARD WHERE boardTitle OR boardContent LIKE ? HAVING (boardGroup > (SELECT MAX(boardGroup) FROM BOARD) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM BOARD) - ?) ORDER BY boardGroup DESC, boardSequence ASC"; 
				SQL = "SELECT * FROM board WHERE CONCAT(boardTitle, boardContent) LIKE ? HAVING (boardGroup > (SELECT MAX(boardGroup) FROM board) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM board) - ?) ORDER BY boardGroup DESC, boardSequence ASC";
					//(SELECT * FROM BOARD WHERE boardGroup > (SELECT MAX(boardGroup) FROM BOARD) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM BOARD) - ? ORDER BY boardGroup DESC, boardSequence ASC)\";

				/*
				SQL = "SELECT * FROM BOARD WHERE CONCAT(boardTitle, boardContent) LIKE " +
					  "? ORDER BY boardID"; */					 
			} 
			else if (searchType.equals("추천순")){
				SQL = "SELECT * FROM board WHERE CONCAT(boardTitle, boardContent) LIKE ? HAVING (boardGroup > (SELECT MAX(boardGroup) FROM board) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM board) - ?) ORDER BY likeCount DESC";
				//SQL = "SELECT * FROM BOARD WHERE CONCAT(boardTitle, boardContent) LIKE ? ORDER BY boardID boardGroup > (SELECT MAX(boardGroup) FROM BOARD) - ? AND boardGroup <= (SELECT MAX(boardGroup) FROM BOARD) - ? ORDER BY boardGroup DESC, boardSequence ASC";
			
			}
			
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");			
			pstmt.setInt(2, pageNumber * 10);
			pstmt.setInt(3, (pageNumber -1) * 10);
		
			rs = pstmt.executeQuery();
			postList = new ArrayList<BoardDTO>();

			while (rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 16));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardAvailable(rs.getInt("boardAvailable"));
				board.setLikeCount(rs.getInt("likeCount"));
				postList.add(board);
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
		return postList;
	}
	
	
	
	
	
	public int hit(String boardID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE board SET boardHit = boardHit + 1 WHERE boardID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
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
	
	
	public String getFile(String boardID) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT boardFile FROM board WHERE boardID = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString("boardFile");
			}
			return "";
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
		return "";
	}
	
	
	public String getRealFile(String boardID) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT boardRealFile FROM board WHERE boardID = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString("boardRealFile");
			}
			return "";
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
		return "";
	}
	
	// 안쓰이는 함수.
	// 해당 페이지를 기준으로 다음 페이지가 존재하는지 물어보는 함수.
	public boolean nextPage(String pageNumber, String search) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//String SQL = "SELECT * FROM BOARD WHERE boardGroup >= ?";
		String SQL = "SELECT * FROM board WHERE boardTitle OR boardContent LIKE ? AND boardGroup > ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, search);
			pstmt.setInt(2, Integer.parseInt(pageNumber) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;  // 한개라도 다음페이지에 게시글이 존재한다면 true값 반환
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
		return false;
	}
	

	
	
	public int update(String boardID, String boardTitle, String boardContent, String boardFile, String boardRealFile) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE board SET boardTitle = ?, boardContent = ?, boardFile = ?, boardRealFile = ? WHERE boardID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, boardTitle);
			pstmt.setString(2, boardContent);
			pstmt.setString(3, boardFile);
			pstmt.setString(4, boardRealFile);
			pstmt.setInt(5, Integer.parseInt(boardID));
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
	

	
	public int delete(String boardID) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE board SET boardAvailable = 0 WHERE boardID = ?";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(boardID));
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
	
	
	
	public int reply(String userID, String boardTitle, String boardContent, String boardFile, String boardRealFile, BoardDTO parent) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "INSERT INTO board SELECT ?, IFNULL((SELECT MAX(boardID) + 1 FROM board), 1), ?, ?, now(), 0, ?, ?, ?, ?, ?, 1, 0";
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, boardTitle);
			pstmt.setString(3, boardContent);
			pstmt.setString(4, boardFile);
			pstmt.setString(5, boardRealFile);
			pstmt.setInt(6, parent.getBoardGroup());
			pstmt.setInt(7, parent.getBoardSequence() + 1);
			pstmt.setInt(8, parent.getBoardLevel() + 1);
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
	
	
	
	public int replyUpdate(BoardDTO parent) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String SQL = "UPDATE board SET boardSequence = boardSequence + 1 WHERE boardGroup = ? AND boardSequence > ?";				
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, parent.getBoardGroup());
			pstmt.setInt(2, parent.getBoardSequence());			
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
	
	
	public int targetPage(String pageNumber, String search) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 페이지가 얼마나 존재하는지 계산하는 함수.
		//String SQL = "SELECT COUNT(boardGroup) FROM BOARD WHERE boardGroup > ? ";
		String SQL = "SELECT COUNT(boardGroup) FROM board WHERE CONCAT (boardTitle, boardContent) LIKE ? AND boardGroup > ?";
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");	
			pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) / 10; //���°������ 10�� ���� ���� ��ȯ.
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
		return 0; //���� �߻��� 0 ��ȯ.
	}
	
	
	public int like(String boardID) {
		String SQL = "UPDATE board SET likeCount = likeCount + 1 WHERE boardID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(boardID));
			return pstmt.executeUpdate();
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
		return -1;
	}
	
	
	public String getUserID(String boardID) {
		String SQL = "SELECT userID FROM board WHERE boardID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(boardID));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
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
		return null; // 존재하지 않는 아이디
	}
}
