package com.movie.board;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movie.board.comment.CommentDAO;
import com.movie.board.comment.CommentDTO;

@WebServlet("/BoardDeleteServlet")
public class BoardDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
		
	}
	
  	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  		request.setCharacterEncoding("UTF-8");
  		response.setContentType("text/html;charset=UTF-8");
  		HttpSession session = request.getSession();
  		String userID = (String) session.getAttribute("userID"); 
  		String boardID = request.getParameter("boardID");
  		
  		if (boardID == null || boardID.equals("")) {  			
  			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;  			
  		} 
  		
  		BoardDAO boardDAO = new BoardDAO();
  		BoardDTO board = boardDAO.getBoard(boardID);
  		if (!userID.equals(board.getUserID())) {
  			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;  	
  		}
  		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
  		String prev = boardDAO.getRealFile(boardID);
  		
  		CommentDAO commentDAO = new CommentDAO();
  		
  		int numberOfComment =  commentDAO.getNumberOfComment(boardID);
  		System.out.println("1  " + numberOfComment);
  		// 게시글에 코멘트 달려있으면 코멘트 플래그값 변경해줌
  		if ( numberOfComment > 0) {
  			commentDAO.deleteCommentList(boardID);
  			System.out.println("2  " + numberOfComment);
  		}
  		
  		int result = boardDAO.delete(boardID);
  		
  		if (result == -1) {
  			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;   			
  		} else {
  			File prevFile = new File(savePath + "/" + prev);
  			if (prevFile.exists()) {
  				prevFile.delete();
  			}
  			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "삭제에 성공했습니다.");
			response.sendRedirect("boardView.jsp");
  		}
  		
  	}
}
