
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter" %>
 <%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="com.movie.board.comment.CommentDAO" %>
<%@ page import="com.movie.board.comment.Action" %>
<%@ page import="com.movie.board.comment.ActionForward" %>

<%

 class DeleteCommentAction implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    
    	
        String commentID = request.getParameter("commentID");
        
        CommentDAO commentDAO = new CommentDAO();
        boolean result = commentDAO.deleteComment(commentID);
        
        PrintWriter out = response.getWriter();
 
        
        if(result) out.println("1");
        
        out.close();
        return null;
    }
}
 

%> 
 