package com.movie.chat.open.userList;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movie.board.comment.Action;
import com.movie.board.comment.ActionForward;
import com.movie.board.comment.CommentDAO;

	
	public class UserForwardAction implements Action
	{
	    @Override
	    public ActionForward execute(HttpServletRequest request,

	            HttpServletResponse response) throws Exception {
	    		response.setContentType("text/html;charset=euc-kr");
	    		System.out.println("이동페이지");
	    		response.sendRedirect("openChatIndex.jsp");
		   			        
	    		return null;
	    }
		
	    public UserForwardAction() throws Exception
	    {
	    }

	}
	
