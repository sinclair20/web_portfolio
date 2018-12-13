package com.movie.board.comment;



import java.io.IOException;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DeleteCommentServlet")
public class DeleteCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   		request.setCharacterEncoding("UTF-8");
   		response.setContentType("text/html; charset=UTF-8");
   		
   		HttpSession session = request.getSession();
   		String commentID = request.getParameter("commentID");
   		String boardID = request.getParameter("boardID");
   		String lastCommentID = request.getParameter("lastCommentID");
        CommentDAO commentDAO = new CommentDAO();
        boolean result = commentDAO.deleteComment(commentID);
        
        /*response.getWriter().write(getID(URLDecoder.decode(boardID,"UTF-8"), lastCommentID));*/
        
        PrintWriter out = response.getWriter();
        
	    if(result) out.println("1");
	    
	    out.close();
			
   		}
   	
   	
   
	}



