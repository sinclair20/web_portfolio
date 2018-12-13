package com.movie.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movie.util.SHA256;



//서블릿 :  컨트롤러 역할 수행.
@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String userID = request.getParameter("userID");
		String userPassword1 = request.getParameter("userPassword1");
		String userPassword2 = request.getParameter("userPassword2");
		String userName = request.getParameter("userName");
		String userAge = request.getParameter("userAge");   // userAge의 기본데이터 타입은 int이나 사용자로부터 입력받는 형태는 String 형태이기때문.
		String userGender = request.getParameter("userGender");
		String userEmail = request.getParameter("userEmail");
		String userProfile = request.getParameter("userProfile");
		String userEmailHash = request.getParameter("userEmailHash");
		
		boolean userEmailChecked = Boolean.parseBoolean(request.getParameter("userEmailChecked")); 
		

		
		if (userID == null || userID.equals("") || userPassword1 == null || userPassword1.equals("") ||
			userPassword2 == null || userPassword2.equals("") || userName == null || userName.equals("") ||
			userAge == null || userAge.equals("") || userGender == null || userGender.equals("") ||
			userEmail == null || userEmail.equals("")) {
			
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "��� ������ �Է��ϼ���.");
			response.sendRedirect("userJoin.jsp");
			return;
		}
		
		if (!userPassword1.equals(userPassword2)) {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
			response.sendRedirect("userJoin.jsp");
			return;
		}
		
		//
		// ""(공백) 부분은 원래 userProfile 인자 인데 회원가입할때는 기본적으로 프로필에 공백문자열이 들어가도록 해주기위해
		int result = new UserDAO().register(userID, userPassword1, userName, userAge, userGender, userEmail, "",  SHA256.getSHA256(userEmail), userEmailChecked);
		if (result == 1) {
			request.getSession().setAttribute("userID", userID);
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "ȸ�����Կ� �����߽��ϴ�. �̸��� ������ �������ּ���.");
			response.sendRedirect("emailSendAction.jsp");
		} else {
			request.getSession().setAttribute("messageType", "���� �޽���");
			request.getSession().setAttribute("messageContent", "�̹� �����ϴ� ȸ���Դϴ�.");
			response.sendRedirect("userJoin.jsp");
		}
	}
}
