<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
</head>
<body>
	<%
	/* 	request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8"); */
		String previousPage = request.getHeader("referer");
		
		if (previousPage.equals("http://localhost:8000/localMovie/openChatIndex.jsp")) {
			session.invalidate();			
			response.sendRedirect("openChatIndex.jsp?isLogout=Y"); 
			return;
		} else {
			session.invalidate();
			response.sendRedirect("index.jsp");
		} 
	%> 
	<!-- <script>
		location.href = 'index.jsp';
	</script> -->
</body>
</html>