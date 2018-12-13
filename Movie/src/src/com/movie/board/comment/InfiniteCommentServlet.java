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

@WebServlet("/InfiniteCommentServlet")

public class InfiniteCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
   		HttpSession session = request.getSession();

		String boardID = request.getParameter("boardID");
   		String userID = (String) session.getAttribute("userID");
   		String commentWriter = request.getParameter("commentWriter");
		String listType = request.getParameter("listType");
		String page = request.getParameter("page");
		/*System.out.println(page);*/

		String commentContent = request.getParameter("commentContent");
	
		if(userID == null || userID.equals("") || commentWriter == null || commentWriter.equals("") ||  listType == null ||  listType.equals(""))
			
			response.getWriter().write("");
		else if (listType.equals("0")) {
			try {								
				if (!URLDecoder.decode(userID, "UTF-8").equals((String) session.getAttribute("commentWriter"))) {
					response.getWriter().write("");
					return;
				}
			} catch (Exception e) {
				response.getWriter().write("");
				
			}
		}		
		response.getWriter().write(getID(URLDecoder.decode(boardID,"UTF-8"),listType, page));
		
	}
			/*response.getWriter().write("");*/
	
		//else response.getWriter().write(getTen(URLDecoder.decode(fromID, "UTF-8"), URLDecoder.decode(toID, "UTF-8")));
		

	public String getID (String boardID, String commentID, String page) throws UnsupportedEncodingException {
		StringBuffer result = new StringBuffer("");
		CommentDAO commentDAO = new CommentDAO();
		ArrayList<CommentDTO> commentList = commentDAO.getCommentList(URLDecoder.decode(boardID, "UTF-8"),URLDecoder.decode(commentID, "UTF-8"));
		
		
		if (commentList.size() == 0) return "";
		/*if (result.length() >= 1) result.setLength(0);*/
		result.append("{\"result\":[");			
		for (int i = 0; i < Integer.parseInt(page)*3; i++) {	
			result.append("[{\"value\": \"" + commentList.get(i).getUserID() + "\"},");
			result.append("{\"value\": \"" + commentList.get(i).getCommentWriter() + "\"},");
			result.append("{\"value\": \"" + commentList.get(i).getCommentContent() + "\"},");
			result.append("{\"value\": \"" + commentList.get(i).getCommentDate() + "\"},");
			result.append("{\"value\": \"" + commentList.get(i).getCommentID() + "\"},");
			result.append("{\"value\": \"" + commentList.get(i).getCommentPassword() + "\"},");			
			result.append("{\"value\": \"" + commentList.size() +  "\"}]");
			/*if (i != commentList.size() -1) result.append(",");*/		
			if (i == commentList.size() - 1 || i == Integer.parseInt(page) * 3 - 1) {
				break;
			} else {
				result.append(",");
			}
		}		
		result.append("], \"last\":\"" + commentList.get(commentList.size() - 1).getCommentID() + "\"}");		
		return result.toString();
	}
}



