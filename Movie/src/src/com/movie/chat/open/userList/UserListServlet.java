package com.movie.chat.open.userList;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movie.board.comment.CommentDAO;
import com.movie.board.comment.CommentDTO;

/**
 * Servlet implementation class UserListServlet
 */
@WebServlet("/UserListServlet")
public class UserListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
   		
		String name = request.getParameter("name");
		String page = request.getParameter("page");
		/*
		System.out.println("name" + name);
		System.out.println("page" + page);

		*/
		
		/*if(userID == null || userID.equals("") || commentWriter == null || commentWriter.equals("") ||  listType == null ||  listType.equals(""))
			
			response.getWriter().write("");
		else 
		}*/	
		if (name.equals("0")) {
			try {												
				response.getWriter().write("");
			} catch (Exception e) {
				response.getWriter().write("");			
			}			
		}
		response.getWriter().write(getID(page));
	}		
	
			/*response.getWriter().write("");*/
	
		//else response.getWriter().write(getTen(URLDecoder.decode(fromID, "UTF-8"), URLDecoder.decode(toID, "UTF-8")));
		

	public String getID (String page) throws UnsupportedEncodingException {
		StringBuffer result = new StringBuffer("");
		UserListDAO userListDAO = new UserListDAO();
		ArrayList<UserListDTO> usersList = userListDAO.getUserList();
		
		 
		if (usersList.size() == 0) return "";
		/*if (result.length() >= 1) result.setLength(0);*/
		result.append("{\"result\":[");			
		for (int i = 0; i < Integer.parseInt(page)*5; i++) {	
			result.append("[{\"value\": \"" + usersList.get(i).getUserName() + "\"}]");
					
			if (i == usersList.size() - 1 || i == Integer.parseInt(page) * 5 - 1) {
				break;
			} else {				 
				result.append(",");
			}
		}		
		/*result.append("], \"last\":\"" + userList.get(userList.size() - 1) + "\"}");*/
		result.append("]}");
		return result.toString();
	}
	
	
}
