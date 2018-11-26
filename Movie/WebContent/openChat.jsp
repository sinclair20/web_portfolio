<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ page import="java.util.ArrayList" %>
<%@ page import="com.movie.chat.open.userList.UserListDAO" %>
<%@ page import="com.movie.chat.open.userList.UserListDTO" %>
    <%@ page import="java.util.*" %>
<!DOCTYPE html>
<% String WsUrl = getServletContext().getInitParameter("WsUrl"); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name='viewport' content='minimum-scale=1.0, initial-scale=1.0,
	width=device-width, maximum-scale=1.0, user-scalable=no'/>
<title>single-room-chat</title>
<link rel="stylesheet" type="text/css" href="content/styles/site.css">
<!-- <script type="text/javascript" src="js/chatroom.js"></script> --> 
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
 <%
 	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	
	String nickName = request.getParameter("nickName");
	
	session.setAttribute("nickName", nickName);
	System.out.println("nickName:" + nickName);
	

	UserListDAO userListDAO = new UserListDAO();
ArrayList<UserListDTO> userList = userListDAO.getUserList();
	
	if (userList.contains(nickName)) {
		System.out.println("존재");
	}
 %>
<script type="text/javascript">

	var wsUri = '<%=WsUrl%>';
	var proxy = CreateProxy(wsUri);
	var nickName = '<%=nickName%>';
	document.addEventListener("DOMContentLoaded", function(event) {
		/* console.log(document.getElementById('loginPanel')); */
		proxy.initiate({
			/* loginPanel: document.getElementById('loginPanel'), */
			msgPanel: document.getElementById('msgPanel'),
			txtMsg: document.getElementById('txtMsg'),
			/* txtLogin: document.getElementById('txtLogin'), */
			msgContainer: document.getElementById('msgContainer')
		});
	});

</script>
</head>
<body>
<div id="container">
	<!-- <div id="loginPanel">
	모달창을 이부분 id로 설정해주어야함. 
		<div id="infoLabel">Type a name to join the room</div>
		<div style="padding: 10px;">
			<input id="txtLogin" type="text" class="loginInput"
				onkeyup="proxy.login_keyup(event)" />
			<button type="button" class="loginInput" onclick="proxy.login()">Login</button>
		</div>
	</div>   -->
	<div id="msgPanel" style="display: none">
		<div id="msgContainer" style="overflow: auto;"></div>
		<div id="msgController">
			<textarea id="txtMsg" 
				title="Enter to send message"
				onkeyup="proxy.sendMessage_keyup(event)"
				style="height: 30px; width: 100%"></textarea>
			<button style="height: 30px; width: 100px" type="button"
				onclick="proxy.logout()">Logout</button>
		</div>
	</div>
</div>
</body>
</html>