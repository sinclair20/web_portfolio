<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%-- <%@ include file="/chatRoom.jsp" %> --%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.movie.chat.open.userList.UserListDAO" %>
<%@ page import="com.movie.chat.open.userList.UserListDTO" %>
<%@ page import="com.movie.user.UserDAO" %>
  
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
		
		function findFunction() {
			var userID = '<%=userID%>';			
			$.ajax({
				type: "POST",
				url: './UserFindServlet',
				data: {userID: userID},
				success: function (result) {
					if (result == -1) {
						$('#checkMessage').html('친구를 찾을 수 없습니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();
					}
					else {
						$('#checkMessage').html('친구찾기에 성공했습니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
						var data = JSON.parse(result);
						var profile = data.userProfile;
						console.log(profile);
						getUserProfile(userID, profile);
					}
					$('#checkModal').modal("show");
				}
			});
		}
		

		function getUserProfile(findID, userProfile) {
			$('#userProfile').html( /* 결과를 담을 테이블에 담을 내용 정의. */
					'<thead>' +
					'<tr>' +
					'<th style="text-align: center;"><h4>' + findID + '로 로그인' + '</h4></th>' +  /* 검색결과로 제목 지어줌 */
					'</tr>' +
					'</thead>' +
					'<tbody>' +
					'<tr>' +
					'<td style="text-align: center;">' + 
					'<a href="./chatRoom.jsp">' +
					'<img class="media-object img-circle" style="max-width: 300px; height: 300px; margin: 0 auto;" src="'+ userProfile +'">' +
					'</a>' +﻿
					'<h4 style="text-align: center;">' +
					'<button type="submit" name="userID">' + 
					findID + ' 님' + 
					'</button>' +
					'</h4>' +
					'</td>' +
					'</tr>' +					
					'</tbody>');
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
		
		function getInfiniteBox() {
			setInterval(function() {
				chatBoxFunction();
			}, 3000);
		}
		
		
		
		function getFriend(findID, userProfile) {
			$('.friendResult').html( /* 결과를 담을 테이블에 담을 내용 정의. */
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
				logout();	
			    /* document.form.submit(); */
			    /* $('.profileModal').modal('show'); */
			}else{   //취소
			    return;
			}
		}
		

		function logout () {
			
			
			window.location.href = "http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/logoutAction.jsp";
		
		}
		
		
		
	</script>
	
<style type="text/css">

body{

    font-family: verdana,sans-serif;

    margin: 0;

}

.slideshow-container{

    width: 800px;

    position: relative;

    margin: auto;


}

.numbers{

    position: absolute;

    top: 0;

    color: #f2f2f2;

    padding: 8px 12px;

    font-size: 12px;

}

.myslides{

    display: none;

}
 
.prev {

    position: absolute;

    top: 50%;

    font-size: 18px;

    font-weight: bold;

    padding: 16px;

    margin-top: -22px;

    border-radius: 0 3px 3px 0;

    color: #fff;

    cursor: pointer;

    }

    .next{

    right: 300px;

    border-radius: 3px 0 0 3px;

    position: absolute;

    top: 50%;

    font-size: 18px;

    font-weight: bold;

    padding: 16px;

    margin-top: -22px;

    border-radius: 0 3px 3px 0;

    color: #fff;

    cursor: pointer;


}

.prev:hover,.next:hover{

background-color: rgba(0,0,0,0.8);

}

.caption{

    text-align: center;

    position: absolute;

    bottom: 8px;

    width: 100%;

    color: #f2f2f2;

    font-size: 15px;

    padding: 8px 22px;

}

.dots{

    width: 13px;

    height: 13px;

    background: gray;

    display: inline-block;

    border-radius: 50%;

    cursor: pointer;

}


@keyframes fade{

    from {opacity: 0.4;}

    to {opacity: 1;}

}

.active, .dot:hover {
    background-color: #333;
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
	
	<!-- 
		<td><a class="btn btn-info" data-toggle="modal" href="#loginModal">내 아이디로 채팅하기</a></td>					
		<td><a class="btn btn-info" data-toggle="modal" href="#profileModal">익명채팅</a></td>
	 -->
	<div class="container">
	<% 
		if (userID == null) {
	%>
	<!-- <form action="./openChat.jsp" method="post"> -->
	<form action="./chatRoom.jsp" method="post">
		<div class="container">	
			<div class="row" style="padding-top:10px"> <!-- 하나의 row는 12 coloum 만큼의 공간을 가지고 있음 -->
				<hr>
				<div class="col-md-6" style="text-align:center;">														
					<div class="col-md-6" style="text-align: center;">
					<h3>내 아이디로 채팅 참여</h3>
					<div>
					<table>
					
					<tbody>
					<tr>
					<td style="text-align: center;"> 
					<a data-toggle="modal" href="#loginModal">
					<img class="media-object img-circle" style="max-width: 300px; margin: 0 auto; " src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/userIcon.png">
					
					</a>					
					</td>   
					</tr>
					</tbody>
					</table>
					</div>
					<div style="padding-top:30px; padding-left:40px;" class="col-lg-6 center-block"><a style="padding-left:10px" class="btn btn-info" data-toggle="modal" href="#loginModal">내 아이디로 채팅하기</a></div>									
				</div>					
				</div>
				<div class="col-md-6" style="text-align: center;">
					<div class="col-md-6" style="text-align: center;">
					
					<h3>익명으로 채팅 참여</h3>
					<div>
					<table>
					
					<tbody>
					<tr>
					<td style="text-align: center;">
					<a href="#profileModal" data-toggle="modal"> 
					<img class="media-object img-circle" style="max-width: 300px; height: 300px; margin: 0 auto; " src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/anonymousLogin.jpg">
					</a>
					
					</td>   
					</tr>
					</tbody>
					</table>
					<div class="col-lg-6 center-block" style="padding-top:30px; padding-left:100px;"><a class="btn btn-info" data-toggle="modal" href="#profileModal">익명 채팅</a></div>									
					</div>
					</div>
				</div>				
			</div>		
		</div>
	</form>
	<%
		} else {
	%>
		<!-- <form action="./openChat.jsp" method="post"> -->
		<form action="./chatRoom.jsp" method="post">
		<div class="container">	
				
			<div class="row" style="padding-top:10px"> <!-- 하나의 row는 12 coloum 만큼의 공간을 가지고 있음 -->
				<hr>
				<div class="col-md-6" style="text-align:center;">
									
					<div style="text-align: center; padding-right: 70px;"><h3>내 아이디로 채팅</h3></div>
					<table id="userProfile" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd; max-width: 450px;"></table>
										
				</div>
								
				<div class="col-md-6" style="text-align: center;">					
					<div>
					<table>
					<thead>
					<tr>
					<th><h3 style="text-align:center;">
					<a onclick="logoutToChat();" style="color: black;">익명으로 로그인</a>
					</h3></th>
					</tr>
					</thead>
					<tbody>
					<tr>
					<td style="text-align: center; padding-top:60px;"> 
					<a onclick="logoutToChat();">
					<img class="media-object img-circle" style="max-width: 300px; height: 300px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/anonymousLogin.jpg">			
					</a>					
					</td>   
					</tr>
					</tbody>
					</table>
					<div style="padding-top: 20px;" class="col-lg-6 center-block"><input type="button" onclick="logoutToChat();" value="익명으로 채팅참여"/></div>					
					</div>
				</div>				
			</div>		
		</div>
		</form>
	<%
		}
	 %>
	 </div>
	

	<%
		if (userID != null) { //null이 아니면 실행하라고 ..;;
	%>
	<div class="modal fade" id="userProfileModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
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
							<div class="friendResult"  style="max-width: 540px; text-align: center; border: 1px solid #dddddd;">
								<script type="text/javascript">
								$('.friendResult').html( /* 결과를 담을 테이블에 담을 내용 정의. */
									
									'<div class="slideshow-container">' +
									'<div class="myslides">' +
									'<div class="numbers">1 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' +
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/1.jpg"></div>' +
									'<div class="caption">Text 1</div>' +
									'</div>' +


									'<div class="myslides">' +
									'<div class="numbers">2 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' +
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/2.jpg"></div>' +
									'<div class="caption">Text 2</div>' +
									'</div>' +


									'<div class="myslides">' +
									'<div class="numbers">3 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' + 
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/3.jpg"></div>' +
									'<div class="caption">Text 3</div>' +
									'</div>' +

									'<div class="myslides">' +
									'<div class="numbers">4 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' + 
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/4.jpg"></div>' +
									'<div class="caption">Text 4</div>' +
									'</div>' +


									'<a class="prev" onclick="plusSlides(-1)">&#10094;</a>' +
									'<a class="next" onclick="plusSlides(1)">&#10095;</a>' +
									'</div>' +

									'<br>' +
									'<div style="text-align:center">' + 
									'<span name="img1" class="dots" onclick="currentSlide(1)"></span>' + 
									'<span name="img2" class="dots" onclick="currentSlide(2)"></span>' +
									'<span name="img3" class="dots" onclick="currentSlide(3)"></span>' +
									'<span name="img4" class="dots" onclick="currentSlide(4)"></span>' +
									'</div>' +
									'</td>' +   
									'</tr>' +
									'</tbody>');
								</script>
								<div>
								<div>
 								<input style="width:360px; height:50px" class="form-control nickName" name="nickName" type="text" 
								class="txtLogin" maxlength="20" placeholder="닉네임 입력" required>
								<button type="submit" class="btn pull-right">완료</button>
								</div>
								<div style="display:none;">
								<textarea style="width:360px; height:50px" class="form-control imgSrc" maxlength="50" name="imgSrc"></textarea>
								</div>
								<%-- <a href='chat2.jsp>완료</a> --%>
								<!-- <td><a href="chat2.jsp" class="btn btn-primary pull-right"><h4>완료</h4></a></td> -->
								
								
								</div>
							</div>
						</div>
					</form>
				</div>
			</div> <!-- <div class = "modal-content"> -->
		</div>
	</div>		
	<%
		} else {
	%>
	<div class="modal fade" id="profileModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
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
							<div class="friendResult"  style="max-width: 540px; text-align: center; border: 1px solid #dddddd;">
								<script type="text/javascript">
								$('.friendResult').html( /* 결과를 담을 테이블에 담을 내용 정의. */
									
									'<div class="slideshow-container">' +
									'<div class="myslides">' +
									'<div class="numbers">1 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' +
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/1.jpg"></div>' +
									'<div class="caption">Text 1</div>' +
									'</div>' +


									'<div class="myslides">' +
									'<div class="numbers">2 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' +
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/2.jpg"></div>' +
									'<div class="caption">Text 2</div>' +
									'</div>' +

									'<div class="myslides">' +
									'<div class="numbers">3 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' + 
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/3.jpg"></div>' +
									'<div class="caption">Text 3</div>' +
									'</div>' +

									'<div class="myslides">' +
									'<div class="numbers">4 / 4</div>' +
									'<div style="display:table-cell; vertical-align:middle; text-align:center">' + 
									'<img style="max-width: 500px; height: 560px; margin: 0 auto;" src="http://ec2-13-124-231-86.ap-northeast-2.compute.amazonaws.com:8080/Movie/images/4.jpg"></div>' +
									'<div class="caption">Text 4</div>' +
									'</div>' +

									'<a class="prev" onclick="plusSlides(-1)">&#10094;</a>' +
									'<a class="next" onclick="plusSlides(1)">&#10095;</a>' +
									'</div>' +

									'<br>' +
									'<div style="text-align:center">' + 
									'<span name="img1" class="dots" onclick="currentSlide(1)"></span>' + 
									'<span name="img2" class="dots" onclick="currentSlide(2)"></span>' +
									'<span name="img3" class="dots" onclick="currentSlide(3)"></span>' +
									'<span name="img4" class="dots" onclick="currentSlide(4)"></span>' +
									'</div>' +
									'</td>' +   
									'</tr>' +
									'</tbody>');
								</script>
								<div>
								<div>
								<input style="width:360px; height:50px" class="form-control nickName" name="nickName" type="text" 
								class="txtLogin" maxlength="20" placeholder="닉네임 입력" required>
								<button type="submit" class="btn pull-right">완료</button>
								</div>
								<div style="display:none;">
								<textarea style="width:360px; height:50px" class="form-control imgSrc" maxlength="50" name="imgSrc"></textarea>
								</div>
								<%-- <a href='chat2.jsp>완료</a> --%>
								<!-- <td><a href="chat2.jsp" class="btn btn-primary pull-right"><h4>완료</h4></a></td> -->
								
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>	
	</div>
	<%
		}
	%>

	
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class = "modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">로그인</h5>
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
	
	
	
<script type="text/javascript">


var httpRequest = null;

//httpRequest 객체 생성
function getXMLHttpRequest(){
 var httpRequest = null;

 if (window.ActiveXObject){
     try{
         httpRequest = new ActiveXObject("Msxml2.XMLHTTP");    
     } catch(e) {
         try{
             httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
         } catch (e2) { httpRequest = null; }
     }
 }
 else if(window.XMLHttpRequest){
     httpRequest = new window.XMLHttpRequest();
 }
 return httpRequest;    
}		



var slideIndex = 1;
showSlide(slideIndex);



function plusSlides(n) {
	  showSlide(slideIndex += n);
	}



function currentSlide(n) {
    showSlide(slideIndex = n);
    slideIndex = n;
    /* sendIndex(n);  */
    if (n == 2) {
    	
		 $('.imgSrc').text("http://localhost:8000/localMovie/images/2.jpg");
	    } else if (n == 3 ) {
	    	
	    	$('.imgSrc').text("http://localhost:8000/localMovie/images/3.jpg");
	    } else if (n == 4 ) {
	    	
	    	$('.imgSrc').text("http://localhost:8000/localMovie/images/4.jpg");
	    } else {
	    	
	    	$('.imgSrc').text("http://localhost:8000/localMovie/images/1.jpg");
	    }
}	
    	  
    	 


function showSlide(n){
    if (n == 2) {
    	
		 $('.imgSrc').text("http://localhost:8000/localMovie/images/2.jpg");
	    } else if (n == 3 ) {
	    	
	    	$('.imgSrc').text("http://localhost:8000/localMovie/images/3.jpg");
	    } else if (n == 4 ) {
	    	
	    	$('.imgSrc').text("http://localhost:8000/localMovie/images/4.jpg");
	    } else {
	    	
	    	$('.imgSrc').text("http://localhost:8000/localMovie/images/1.jpg");
	    }
	
    var i;
    var slides = document.getElementsByClassName("myslides");
    var dots = document.getElementsByClassName("dots");

    if (n > slides.length) { slideIndex = 1};

    if (n < 1) { slideIndex = slides.length};

    for (i=0; i < slides.length; i++) {
        slides[i].style.display = "none";
    };

    for (i=0; i < dots.length; i++) {
        dots[i].className = dots[i].className.replace(" active","");
    };

    slides[slideIndex-1].style.display = "block";
    dots[slideIndex-1].className += " active";
}
console.log("slideIndex: ",slideIndex);
		
		
/* 	  function cmDeleteOpen(commentID){
var msg = confirm("댓글을 삭제합니다.");    
if(msg == true){ // 확인을 누를경우
	deleteFunction(commentID);
}
else{
    return false; // 삭제취소
}
} */



 /*
 function checkFunc(){
  if (httpRequest.readyState == 4){
      // 결과값을 가져온다.
      var resultText = httpRequest.responseText;
     if(resultText == 1){ 
           document.location.reload(); // 상세보기 창 새로고침 
      	
      }  
  }
} 
 */


// 댓글 삭제


		
</script> 
	
	
	
	

		<script type="text/javascript">
			$(document).ready(function() {
		
				
			<%
				if (userID != null) {
			%>	
				findFunction();
				getUnread();
				getInfiniteUnread();
				
			<%
				}
			%>
			
						
		<%	
			 String isLogout = (String) request.getParameter("isLogout");
			
			if (isLogout != null && isLogout.equals("Y")) {
				System.out.println("2. a: " + isLogout);
				System.out.println("모달창 띄우기");
		%>
	 		$('#profileModal').modal('show');
	 		history.replaceState({}, null, location.pathname);

		<%
			}
			
		%> 
		
		
				
			});
				
		</script>
			
				
</body>
</html>