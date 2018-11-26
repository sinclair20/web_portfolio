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
		session.invalidate();
	/* 	String previousPage = request.getHeader("referer");
		if (previousPage.equals("http://localhost:8080/Movie/openChatIndex.jsp")) {
			response.sendRedirect("openChatIndex.jsp");
		} else {
			response.sendRedirect("index.jsp");
		} */
	%>
	<script>
		location.href = 'index.jsp';
	</script>
</body>
</html>