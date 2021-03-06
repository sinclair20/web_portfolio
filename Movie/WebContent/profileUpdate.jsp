<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.movie.user.UserDTO" %>
<%@ page import="com.movie.user.UserDAO" %>
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
		UserDTO user = new UserDAO().getUser(userID);
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
	
	var audio = null;
	var playSound = function() {
		if (audio == null) {
			audio = new Audio('content/sounds/ring.wav');
		}		
		audio.play(); 
	};
	
		
		function getUnread() {
			
			$.ajax ({
				type:"POST",
				url: "./chatUnread",
				data: {
					userID : encodeURIComponent('<%= userID %>')					
				},
				success: function (result) {
					var unread = Number($('#unread').text());
					console.log("unread", unread);
					if (result >= 1) {
						console.log("result1 ", result);
						console.log("unread1 ", unread);
						showUnread(result);
						if ( result == unread +1 ){
							
							console.log("result2 ", result);
							console.log("unread2 ", unread);
							playSound();
						}
						
						
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
		function passwordCheckFunction() {
			var userPassword1 = $('#userPassword1').val();
			var userPassword2 = $('#userPassword2').val();
			if (userPassword1 != userPassword2) {
				$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
			} else {
				$('#passwordCheckMessage').html('');			
			}
		}
		
		 function fileUpload(fis) {

	            var str = fis.value;

	            $('#span').text(fis.value.substring(str.lastIndexOf("\\")+1));

	            // 이미지를 변경한다.

	              var reader = new FileReader();

		      reader.onload = function(e){

			$('#loadImg').attr('src', e.target.result);

		      }

		reader.readAsDataURL(fis.files[0]);

		}

	</script>
	
	<style type="text/css">
		.center-block {
		    display: block;
		    margin-left: auto;
		    margin-right: auto;
		 }
	</style>
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
				<li><a href="openChatIndex.jsp">오픈채팅</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
						 aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span>
					</a>		
					<ul class="dropdown-menu">
						<li><a href="update.jsp">회원정보 수정</a></li>
						<li class="active"><a href="profileUpdate.jsp">프로필 수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li> 	
					</ul>			 
				</li>
			</ul>
		</div>
	</nav>
	
<div class="container">
	<form method="post" action="./userProfile" enctype="multipart/form-data">	
	<section class="container mt-5 mb-5" style="max-width: 560px;">
		<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th colspan="3"><h4>프로필 사진 수정 양식</h4></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td style="width: 110px;"><h5>아이디</h5></td>
				<td><h5><%= user.getUserID() %></h5>
				<input type="hidden" name="userID" value="<%= user.getUserID() %>"></td>
			</tr>
			<tr>
				<td style="width: 110px;"><h5>사진 업로드</h5></td>
				<td colspan="2">
					<input type="file" name="userProfile" class="file" onchange="fileUpload(this);">
					<div class="input-group col-xs-12">
						<span class="input-group-addon"><i class="glyphicon glyphicon-picture"></i></span>
							<input type="text" class="form-control input-lg" disabled placeholder="이미지를 업로드 하세요">
							<span class="input-group-btn">
								<button class="browse btn btn-primary input-lg" type="button"><i class="glyphicon glyphicon-search"></i>파일 찾기</button>
							</span>
					</div>					
				</td>
			</tr>
			<tr>
			<td>
			<h5>미리보기</h5>
				</td>
				<td>
				<img class="center-block" src="images/file.png" id="loadImg" style="width: 50px;height:50px;" style="align=center"/>
				</td>
			</tr>				
			<tr>
				<td style="text-align: left;" colspan="3"><h5 style="color: red;"></h5><input class="btn btn-primary pull-right" type="submit" value="등록"></td>
			</tr>
		</tbody>
		
		</table>	
	</section>	
	</form>
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
	<script>
		$('#messageModal').modal("show");
	</script>
	
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
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
	<script type="text/javascript">
		$(document).on('click','.browse', function() {  //browse 버튼에 대한 액션처리
			var file = $(this).parent().parent().parent().find('.file');
			file.trigger('click');
		});
		$(document).on('change', '.file', function() { // file 클래스의 값이 변경되면 디자인통해 화면으로 보여주기
			$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
		});
	</script>
</body>
</html>