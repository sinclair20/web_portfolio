package com.movie.board.comment;



import java.io.IOException;

import java.io.PrintWriter;

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
   		int commentID = Integer.parseInt(request.getParameter("commentID"));
   		System.out.println("commentIDddd : " + commentID);

        CommentDAO commentDAO = new CommentDAO();
        boolean result = commentDAO.deleteComment(commentID);
        
    
	    
	    PrintWriter out = response.getWriter();
	
	    // 정상적으로 댓글을 삭제했을경우 1을 전달한다.
	    if(result) out.println("1");
	    
	    out.close();
	    
   		
   		}
   	
   	public class CommentDeleteAction implements Action
		{
		    @Override
		    public ActionForward execute(HttpServletRequest request,
		            HttpServletResponse response) throws Exception {
		    
			   		int commentID = Integer.parseInt(request.getParameter("commentID"));
			   		System.out.println("commentIDddd : " + commentID);

			        CommentDAO commentDAO = new CommentDAO();
			        boolean result = commentDAO.deleteComment(commentID);
			        
		        
		        response.setContentType("text/html;charset=UTF-8");
		        PrintWriter out = response.getWriter();
		 
		        // 정상적으로 댓글을 삭제했을경우 1을 전달한다.
		        if(result) out.println("1");
		        
		        out.close();
		        return null;
		    }
		}
		
	}



