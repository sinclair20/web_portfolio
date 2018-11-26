package user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.SHA256;

// ���� :  ��Ʈ�ѷ� ���� ����.
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
		String userAge = request.getParameter("userAge");  // userAge�� �⺻������ Ÿ���� int�̳� ����ڷκ��� �Է¹޴� ���´� String �����̱⶧��.
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
		// ""(����) �κ��� ���� userProfile ���� �ε� ȸ�������Ҷ��� �⺻������ �����ʿ� ���鹮�ڿ��� ������ ���ֱ�����
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
