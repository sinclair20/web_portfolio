<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%
		request.setCharacterEncoding("UTF-8");
		/* 특정한 사람의 아이디 값을 가져오기  */
		String userID = null; 
		/* userID라는 이름으로 로그인이 되었다면 세션 값이 존재하기 때문에 null 값이 아닌것 
		   결과적으로 userID라는 변수안에 해당 사용자의 세션 관련 값을 스트링 형태로 변환하여 넣어줌으로써 
		   해당사용자의 접속 유무 파악 가능 */
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		String searchType = "최신순";
		String search = "";
		
		if (request.getParameter("searchType") != null) {
			searchType = request.getParameter("searchType");
		}
		if (request.getParameter("search") != null) {
			search = request.getParameter("search");
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
					userID : encodeURIComponent('<%= userID %>'),					
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
	</script>
	
	<style type="text/css"> /*css코딩 작석하겠다는 의미*/
			.jumbotron {
				background-image: url('images/jumboImage.jpg');
				/* background-size: cover;/* 이미지 크기가 작아도 알아서 화면에 맞춰줌*/ */
				text-shadow: black 0.2px 0.2px 0.2px;
				color: white;
				width:100%;
  				height: 95vh;  			
			}
			input::placeholder {
				 	color:white; 				 	
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
				<li class="active"><a href="index.jsp">메인</a>				
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">메세지 함<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
				<li><a href="openChatIndex.jsp">오픈채팅</a></li>				
			</ul>
		
			<form method="get" action="./boardView.jsp" class="navbar-form navbar-left" style="padding-top:10px;">
			
			<select name="searchType" class="form-control" style="background-color:transparent; color:white;">
				<option value="최신순">최신순</option>
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>			
			<input type="text" name="search" class="form-control mx-1 mt-2" style="background-color:transparent; color:white;" placeholder="내용을 입력하세요">
			<button type="submit" class="btn btn-primary mx-1 mt-2" style="background-color:transparent; color:white;" >검색</button>			
		</form>
			
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
		
	
	
	<div class="jumbotron">
		
	
		<h1 class="text-center center">영화 채팅 커뮤니티</h1><!-- 텍스트 가운데 정렬해주는 클래스 -->
		<p class="text-center">영화 평론 게시판과 채팅기능을 이용할 수 있는 웹 사이트 입니다.</p>
			<section class="container">
			<div class="row" style="padding-top:200px"> <!-- 하나의 row는 12 coloum 만큼의 공간을 가지고 있음 -->
		<hr>
			<div class="col-md-4" style="text-align:center;">
				<h3 style="padding-left: 20px; "><a href="boardView.jsp" style="color: white;">영화 평론 게시판</a></h3>				
				<!-- <p><a class="btn btn-default" data-target="#modal" data-toggle="modal">자세히 알아보기</a></p> -->
				<p style="padding-left:10px; padding-top:10px;"> 영화에 대한 글을 쓰고<br>실시간 댓글을 통해 자유롭게<br>토론을 나누세요</p>
			</div>
			<div class="col-md-4" style="text-align:center;">
				<h3><a href="find.jsp" style="color: white;">친구 채팅</a></h3>
				<p style="padding-top:10px;"> 친구찾기 기능을 통해<br> 1:1 채팅을 나누세요</p>
				
			</div>
			<div class="col-md-4" style="text-align:center;">
				<h3><a href="openChatIndex.jsp" style="color: white;">오픈 채팅</a></h3>
				<p style="padding-top:10px;"> 회원, 비회원 상관없이<br> 자유롭게 채팅을 나누세요<br></p>
			</div>
		</div>	
	
			</section>
		
		</div>
		
	
	
		<footer style="background-color: #000000; color: #ffffff">
			<div class="container">
				<br>
				<div class="row">
					<div class="col-sm-2" style="text-align: center;"><h5>Copyright &copy; 2018</h5><h5>지창호(Changho JI)</h5></div>
					<div class="col-sm-4"><h4>개발자 소개</h4><p>저는 웹개발자 지창호 입니다. 가천대에서 경영학을 전공, 컴퓨터공학을 복수전공 하였으며 Java, JSP, Servlet, MySQL, Ajax, jQuery, Bootstrap 을 사용하여 개발했습니다.</p></div>
					<div class="col-sm-2"><h4 style="text-align: center;">네비게이션</h4>
						<div class="list-group">
							<a href="index.jsp" class="list-group-item">개발자 소개</a>							
						</div>
					</div>
					<div class="col-sm-2"><h4 style="text-align: center;">SNS</h4>
						<div class="list-group">
							<a href="https://www.facebook.com/profile.php?id=100008338392748" class="list-group-item">페이스북</a>
							<a href="https://www.youtube.com/channel/UCi518vMAISgSOZ759VnjlrA?view_as=subscriber" class="list-group-item">유튜브</a>
							<a href="https://blog.naver.com/sinclair_j" class="list-group-item">네이버 TV</a>
						</div>
					</div>
					<div class="col-sm-2"><h4 style="text-align: center;"><span class="glyphicon glyphicon-ok"></span>&nbsp;by 지창호</h4></div> 
				</div>	
			</div>
		</footer>
		
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
</body>
</html>