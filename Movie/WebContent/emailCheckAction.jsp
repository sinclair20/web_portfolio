<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.movie.user.UserDAO" %>
<%@ page import="com.movie.util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>


<%

	request.setCharacterEncoding("UTF-8"); // 사용자로부터 입력받은 요청정보는 전부 utf8으로 인코딩

	String code= null;
	if (request.getParameter("code") != null) {
		code = request.getParameter("code");
	}
	
	UserDAO userDAO = new UserDAO();
	String userID = null;
	if (session.getAttribute("userID") != null) { /*  userID가 로그인 되있는지 세션데이터를 이용해서 확인해주어야함 */ 
		userID = (String) session.getAttribute("userID"); /* session 값으로 object 객체를 반환해주므로 String으로 형변환해주기 */
	}
	
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
	}
	
	/* 현재 사용자가 보낸 코드가 정확히 해당 사용자의 해시값을 적용한 이메일주소와 일치하는지 확인하기  */
	String userEmail = userDAO.getUserEmail(userID);
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false; /* 사용자의 코드값과 일치하면 true, 아니면 false 값을 반환 */
	System.out.println(isRight);
	
	if (isRight == true) { /* 정확한 코드라면 */
		userDAO.setUserEmailChecked(userID); /* 실제 사용자의 이메일 인증을 처리해주는 부분 */
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else { /* 정확하지 않은 코드인 경우 */
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>