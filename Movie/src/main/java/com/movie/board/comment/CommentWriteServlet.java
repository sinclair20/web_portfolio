package com.movie.board.comment;

import java.io.IOException;


import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movie.user.UserDAO;
import com.movie.user.UserDTO;



@WebServlet("/CommentWriteServlet")
public class CommentWriteServlet  {
	private static final long serialVersionUID = 1L;
   	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   		request.setCharacterEncoding("UTF-8");
   		response.setContentType("text/html; charset=UTF-8");
  
   		HttpSession session = request.getSession();
   		

   		CommentDAO commentDAO = new CommentDAO();
   		String boardID = (String) session.getAttribute("boardID");
   		
   		/*String userID = request.getParameter("userID");*/
   		String userID = (String) session.getAttribute("userID");
   		UserDAO userDAO = new UserDAO();
   		UserDTO user = userDAO.getUser(userID);
   		
   		/*if (!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �� �����ϴ�.");
			response.sendRedirect("index.jsp");
			return;
		}*/
   		String commentContent = request.getParameter("commentContent");   		 		
   		System.out.println("userID :" + userID);
   		
   		   		
   		/*if ((userID == null || userID.equals("")) && (commentWriter == null || commentWriter.equals(""))) {
   			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "�г����� �Է����ּ���.");
			response.sendRedirect("boardShow.jsp");
			return;
   		}*/
   		String commentWriter = request.getParameter("commentWriter");
	   	String commentPassword = request.getParameter("commentPassword");  
	   	
   		
   		System.out.println("userPassword" + user.getUserPassword());

   		
   		
   		/*String commentContent = (String) session.getAttribute("commentContent");*/
   		/*String commentWriter = request.getParameter("commentWriter");*/
   		System.out.println("commentContent :" + commentContent);
   		
   		if (commentContent == null || commentContent.equals("")) {
   			session.setAttribute("messageType", "���� �޽���");
			session.setAttribute("messageContent", "������ �Է����ּ���");
			response.sendRedirect("boardShow.jsp");
			return;
   		}
   		
   		
		
   		/*String boardID = request.getParameter("boardID");*/
   		
   		System.out.println("boardID :" + boardID);
   		
   		if (userID == null || userID.equals("")) {
   			commentDAO.nonmemberWrite(URLDecoder.decode(commentContent,"UTF-8"), URLDecoder.decode(commentWriter,"UTF-8"), boardID, URLDecoder.decode(commentPassword,"UTF-8"));   			
   		} else {
   			commentDAO.write(URLDecoder.decode(commentContent,"UTF-8"), URLDecoder.decode(commentWriter,"UTF-8"), boardID, userID, user.getUserPassword());	
   		}   		
   	/*	session.setAttribute("messageType", "���� �޽���");
		session.setAttribute("messageContent", "���������� �Խù��� �ۼ��Ǿ����ϴ�.");
		response.sendRedirect("boardShow.jsp");*/		
   		return;
	}

}
