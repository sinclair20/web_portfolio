package com.movie.chat.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movie.board.comment.CommentDAO;

/**
 * Servlet implementation class ChatRoomDeleteServlet
 */
@WebServlet("/ChatRoomDeleteServlet")
public class ChatRoomDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
  	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   		request.setCharacterEncoding("UTF-8");
   		response.setContentType("text/html; charset=UTF-8");
   		
   		HttpSession session = request.getSession();
   		String fromID = request.getParameter("fromID");
   		String toID = request.getParameter("toID");
        System.out.println("fromID:" + fromID);
        System.out.println("toID:" + toID);
   		ChatDAO chatDAO = new ChatDAO();
   		chatDAO.deleteChatRoom(fromID, toID);
        
        /*response.getWriter().write(getID(URLDecoder.decode(boardID,"UTF-8"), lastCommentID));*/
       
   		}
  	
}
