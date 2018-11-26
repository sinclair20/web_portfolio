<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%-- <%@ include file="/chatRoom.jsp" %> --%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.movie.chat.open.userList.UserListDAO" %>
<%@ page import="com.movie.chat.open.userList.UserListDTO" %>
  
    <%@ page import="java.util.*" %>
<%-- <%@ page import="com.movie.user.UserDAO" %> --%>
<!DOCTYPE html>
<html>
	<%
		request.setCharacterEncoding("UTF-8");
 	  	response.setContentType("text/html; charset=UTF-8");
		/* 특정한 사람의 아이디 값을 가져오기  */
		 
		/* userID라는 이름으로 로그인이 되었다면 세션 값이 존재하기 때문에 null 값이 아닌것 
		   결과적으로 userID라는 변수안에 해당 사용자의 세션 관련 값을 스트링 형태로 변환하여 넣어줌으로써 
		   해당사용자의 접속 유무 파악 가능 */
		
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		} 
		/* String userID = request.getParameter("userID"); */		
		
		/* String WsUrl = getServletContext().getInitParameter("WsUrl"); */

	%>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="./css/bootstrap.css">
	<link rel="stylesheet" href="./css/custom.css">
	
	<!-- AJAX 사용위해 jquery를 링크로 가져오기 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>  <!-- 부트스트랩 프레임워크에서 제공하는 자바스크립트 파일 가져오기. -->
	<!-- <script type="text/javascript" src="js/chatroom.js"></script> -->
	
	<script type="text/javascript">
	
		function getUnread() {
			$.ajax ({
				type:"POST",
				url: "./chatUnread",
				data: {
					userID : encodeURIComponent('<%= userID %>')					
				},
				success: function (result) {
					if (result >= 1) {
						showUnread(result);
					} else {
						showUnread('');
					}
				}
			});
		}
		
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		
		function showUnread(result) {
			$('#unread').html(result);
		}
		
		function chatBoxFunction() {
			var userID = '<%= userID %>'
			$.ajax ({
				type:"POST",
				url: "./chatBox",
				data: {
					userID : encodeURIComponent(userID),					
				},
				success: function (data) {
					if (data == "") return;
					$('#boxTable').html(''); // boxTable의 html영역을 공백으로 초기화
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for (var i=0; i < result.length; i++) {
						if (result[i][0].value == userID) {
							result[i][0].value = result[i][1].value;
						} else {
							result[i][1].value = result[i][0].value;
						}
						addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, result[i][5].value);
					}
				}
			});
		}
		/* 
	function addBox(lastID, toID, chatContent, chatTime, unread, profile) {
			$('#boxTable').append('<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' +
					'<td style="width: 150px;">' +
					'<img class="media-object img-circle" style="margin: 0 auto; max-width: 40px; max-height: 40px;" src="' + profile + '">' + 
					'<h5>' + lastID + '</h5></td>' + 
					'<td>' + 
					'<h5>' + chatContent +
					'<span class="label label-info">' + unread + '</span></h5>' + 
					'<div class="pull-right">' + chatTime + '</div>' +
					'</td>' + 
					'</tr>'); 
		} */ 
		function getInfiniteBox() {
			setInterval(function() {
				chatBoxFunction();
			}, 3000);
		}
		
		
		
		function getFriend(findID, userProfile) {
			$('#friendResult').html( /* 결과를 담을 테이블에 담을 내용 정의. */
					'<thead>' +
					'<tr>' +
					'<th><h4>검색 결과</h4></th>' +  /* 검색결과로 제목 지어줌 */
					'</tr>' +
					'</thead>' +
					'<tbody>' +
					'<tr>' +
					'<td style="text-align: center;">' + 
					'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="'+ userProfile +'">' +﻿
					'<h3>' + findID + '</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">' + '메시지 보내기</a></td>' +   
					'</tr>' +
					'</tbody>');
		}
	
		
		function logoutToChat(){
			if (confirm("로그아웃 하시고 익명으로 채팅에 참여하시겠습니까?") == true){    //확인
			
			    $("#profileModal").modal('show');
			    /* document.form.submit(); */
			    /* $('.profileModal').modal('show'); */
			}else{   //취소
			    return;
			}
		}
		
	
	</script>
</head>
<body>
	<!-- index 페이지를 메인페이지로 삼기 위해 세션작업 해주기 -->
	
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" 
				data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>	
			<a class="navbar-brand" href="index.jsp">영화 커뮤니티</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1"> <!-- id 속성 값은 button의 data-target 값과 똑같은 이름으로 지어주어야함. -->
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a>				
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">메시지 함<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
				<li class="active"><a href="openChatIndex.jsp">오픈채팅</a></li>
			</ul>
			<%
				if (userID == null) {					
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
						 aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span>
					</a>					 
	     			<ul class="dropdown-menu">
						<li><a href="userLogin.jsp">로그인</a></li>
					 	<li><a href="userJoin.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<% 
				} else {  //로그인 되었을 경우
			%>
			
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
						 aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span>
					</a>		
					<ul class="dropdown-menu">
						<li><a href="update.jsp">회원정보 수정</a></li>
						<li><a href="profileUpdate.jsp">프로필 수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li> 	
					</ul>			 
				</li>
			</ul>
			<%
				}
			%>				
		</div>
	</nav>
	
	
	<div class="container">
	<% 
		if (userID == null) {
	%>
	<!-- <form action="./openChat.jsp" method="post"> -->
	<form action="./chatRoom.jsp" method="post">
	<div class="container">	
		<table class="table" style="margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>프로필 설정</h4></th>
				</tr>
			</thead>			
			<tbody id="boxTable">
				<tr>
					<td><a class="btn btn-info" data-toggle="modal" href="#loginModal">내 아이디로 채팅하기</a></td>					
					<td><a class="btn btn-info" data-toggle="modal" href="#profileModal">익명채팅</a></td>
				</tr>				
			</tbody>		
		</table>
	</div>
	</form>
	<%
		} else {
	%>
		<!-- <form action="./openChat.jsp" method="post"> -->
		<form action="./chatRoom.jsp" method="post">
		<div class="container">	
			<table class="table" style="margin: 0 auto;">
				<thead>
					<tr>
						<th><h4>프로필 설정</h4></th>
					</tr>
				</thead>			
				<tbody id="boxTable">
					<tr>
						<%-- <td><a href="chat2.jsp"><h4><%=userID%></h4></a></td> --%>
						
						<td class="col-lg 6"><button type="submit" name="userID"><%=userID%></button></td>
											
						<td class="col-lg 6"><input type="button" value="alert" onclick="logoutToChat()" />익명으로 채팅참여</td>
<!-- 						<td><a class="btn btn-info" data-toggle="modal" href="#profileModal">익명채팅</a></td>
						<td><button id="logoutchat">클릭</button></td> -->
					</tr>				
				</tbody>		
			</table>
		</div>
		 </form>
	<%
		}
	 %>
	 </div>
	


	<div class="modal fade" id="profileModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
	<%
		if (userID != null) { 
	%>
		<div class="modal-dialog">
			<div class = "modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">프로필 설정</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<!-- <form action="./openChat.jsp" method="post"> -->
					<form action="./chatRoom.jsp" method="post">
						<div class="container">
							<table id="friendResult" class="table table-bordered table-hover" style="max-width: 540px; text-align: center;" border: 1px solid #dddddd;>
								<script type="text/javascript">
								$('#friendResult').html( /* 결과를 담을 테이블에 담을 내용 정의. */
									'<thead>' +
									'<tr>' +
									'<th><h4>검색 결과</h4></th>' +  /* 검색결과로 제목 지어줌 */
									'</tr>' +
									'</thead>' +
									'<tbody>' +
									'<tr>' +
									'<td style="text-align: center;">' + 
									'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="http://localhost:8080/Movie/images/userIcon.png">' +﻿
									'<h3>' + '</h3></td>' +   
									'</tr>' +
									'</tbody>');
								</script>
								<tr>
								<td>
								<input style="width:360px; height:50px" class="form-control" id="nickName" name="nickName" type="text" 
								class="txtLogin" maxlength="20" placeholder="닉네임 입력">
								<%-- <a href='chat2.jsp>완료</a> --%>
								<!-- <td><a href="chat2.jsp" class="btn btn-primary pull-right"><h4>완료</h4></a></td> -->
								<button type="submit" class="btn pull-right">완료</button>
								</td>
								</tr>
							</table>
						</div>
					</form>
				</div>
			</div>
		</div>		
	<%
		} else {
	%> 
		<div class="modal-dialog">
			<div class = "modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">프로필 설정</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<!-- <form action="./openChat.jsp" method="post"> -->
					<form action="./chatRoom.jsp" method="post">
						<div class="container">
							<table id="friendResult" class="table table-bordered table-hover" style="max-width: 540px; text-align: center;" border: 1px solid #dddddd;>
								<script type="text/javascript">
								$('#friendResult').html( /* 결과를 담을 테이블에 담을 내용 정의. */
									'<thead>' +
									'<tr>' +
									'<th><h4>검색 결과</h4></th>' +  /* 검색결과로 제목 지어줌 */
									'</tr>' +
									'</thead>' +
									'<tbody>' +
									'<tr>' +
									'<td style="text-align: center;">' + 
									'<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto;" src="http://localhost:8080/Movie/images/userIcon.png">' +﻿
									'<h3>' + '</h3></td>' +   
									'</tr>' +
									'</tbody>');
								</script>
								<tr>
								<td>
								<input style="width:360px; height:50px" class="form-control" id="nickName" name="nickName" type="text" 
								class="txtLogin" maxlength="20" placeholder="닉네임 입력" >
								<%-- <a href='chat2.jsp>완료</a> --%>
								<!-- <td><a href="chat2.jsp" class="btn btn-primary pull-right"><h4>완료</h4></a></td> -->
								<button type="submit" class="btn pull-right">완료</button>
								</td>
								</tr>
							</table>
						</div>
					</form>
				</div>
			</div>
		</div>	
	<%
		}
	%>
	</div>
	

	
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class = "modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">							
				<form method="post" action="./userLogin">				 
				<section class="container mt-5 mb-5" style="max-width: 560px;">
					<div class="sign-up input-group"><h5>로그인</h5></div>
<!-- 					<div><input style="width:360px; height:50px" class="form-control" name="userID" type="text" id="userID" maxlength="20" placeholder="아이디"></div> -->
						<div><input style="width:360px; height:50px" class="form-control" name="userID" type="text" id="userID" maxlength="20" placeholder="아이디"></div>
						<div><input style="width:360px; height:50px" class="form-control" name="userPassword" type="password" id="userPassword" maxlength="20" placeholder="비밀번호"></div>
						
				   		<!-- <input id="loginButton" type="submit" name="loginButton" class="btn btn-primary center-block" value="로그인"> -->
				   		<button type="submit" class="loginInput">로그인</button>		
				</section>
				</form>			
				</div>
			</div>
		</div>		
	</div>
	
	
		<%
		String messageContent = null;	
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		
		if (messageContent != null) {
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if (messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body" >
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
					
			</div>
		</div>
	</div>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<script>
		$('#messageModal').modal("show");
	</script>
	
	
	
	
	<%
		if (userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function() {
				getUnread();
				getInfiniteUnread();
				
			});
		</script>
	<%
		}
	%>
</body>
</html>