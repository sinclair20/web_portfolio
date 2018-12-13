package com.movie.board.comment;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movie.board.BoardDAO;
import com.movie.board.BoardDTO;
import com.movie.chat.member.ChatDAO;

@WebServlet("/CommentUpdateServlet")
public class CommentUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   		request.setCharacterEncoding("UTF-8");
   		response.setContentType("text/html; charset=UTF-8");
   		
   		HttpSession session = request.getSession();
   		String userID = request.getParameter("userID");
   		
   		String commentID = request.getParameter("commentID");
   		String boardID = (String) session.getAttribute("boardID");
   		String commentContent= request.getParameter("commentContent");
   		System.out.println("commentIddddd: " + commentID);
   		System.out.println("boardID: " + boardID);
   		System.out.println("commentContent: " + commentContent);
   		CommentDAO commentDAO = new CommentDAO();
   		
   		/*BoardDAO boardDAO = new BoardDAO();
   		BoardDTO board = boardDAO.getBoard(boardID);*/
   		/*if (!userID.equals(comment.getUserID())) {
   			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
   		}*/
   		
   		
   	
   		
   		commentDAO.update(boardID, commentID, URLDecoder.decode(commentContent, "UTF-8"));
   		session.setAttribute("messageType", "성공 메시지");
		session.setAttribute("messageContent", "댓글이 성공적으로 수정되었습니다.");
		response.sendRedirect("boardShow.jsp?boardID="+boardID);
		System.out.println("댓글 수정");
		return;
		
	}

}
