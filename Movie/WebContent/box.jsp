<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%
		/* 특정한 사람의 아이디 값을 가져오기  */
		String userID = null; 
		/* userID라는 이름으로 로그인이 되었다면 세션 값이 존재하기 때문에 null 값이 아닌것 
		   결과적으로 userID라는 변수안에 해당 사용자의 세션 관련 값을 스트링 형태로 변환하여 넣어줌으로써 
		   해당사용자의 접속 유무 파악 가능*/
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
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
		
		function deleteCheck(toID) {
			if (confirm('대화방을 삭제하시겠습니까?') == true){
				console.log('deleteCheck()');
				deleteRoom(toID);
			} else {
				return;
			}
		}
		
		
		
		
		function deleteRoom(toID) {
			
			$.ajax({
				type: "POST",
				url: "./chatRoomDelete",				
				data: {
					fromID: encodeURIComponent('<%=userID%>'),
					toID: encodeURIComponent(toID),										
				},
				success: function () {					
					$('.delete').parent().parent().parent().remove();
					alert('대화방이 삭제되었습니다.')					
				}
			});			
		}
		
		
		
		function chatBoxFunction() {
			var userID = '<%= userID %>'
			console.log()
			$.ajax ({
				type:"POST",
				url: "./chatBox",
				data: {
					userID : encodeURIComponent(userID),					
				},
				success: function (data) {
					/* if (data == "") return; */
					console.log("chatBoxFunction 1")
					$('#boxTable').html(''); // boxTable의 html영역을 공백으로 초기화
					if (data == "") return;
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
		
		function addBox(lastID, toID, chatContent, chatTime, unread, profile) {
			$('#boxTable').append(
					'<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' + 
					'<tr>' +
					'<td class="col-lg-3" style="width: 150px;">' +
					'<img class="media-object img-circle" style="margin: 0 auto; max-width: 40px; max-height: 40px;" src="' + profile + '">' + 
					'<h5>' + lastID + '</h5></td>' + 
					'<td class="col-lg-6">' + 
					'<h5>' + chatContent +
					'<span class="label label-info">' + unread + '</span></h5>' + 
					'</td>' +
					'<td class="col-lg-3">' +
					'<a href="#" style="margin-top:30px;" class="delete btn btn-danger pull-right" onclick="deleteCheck(' + "'" + toID + "'"+ ')">삭제</a>' +
					'<div class="pull-right">' + chatTime + '</div>' +
					'</td>' +
					'</tr>'); 
		}
		
		function getInfiniteBox() {
			setInterval(function() {
				chatBoxFunction();
			}, 3000);
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
				<li class="active"><a href="box.jsp">메시지 함<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
				<li><a href="openChatIndex.jsp">오픈채팅</a></li>
			</ul>
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
		</div>
	</nav>
	
	<div class="container">
		<table class="table" style="margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>주고받은 메시지 목록</h4>
				</tr>
			</thead>
			<div style="overflow-y: auto; width: 100%; max-height: 450px;">
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; margin: 0 auto;">
					<tbody id="boxTable">
					</tbody>
				</table>
			</div>
		</table>
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
					<div class="modal-body">
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
				chatBoxFunction();
				getInfiniteBox();
			});
		</script>
	<%
		}
	%>
</body>
</html>