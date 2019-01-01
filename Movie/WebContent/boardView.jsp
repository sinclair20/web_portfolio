<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "com.movie.board.BoardDAO" %>
<%@ page import = "com.movie.board.BoardDTO" %>
<%@ page import = "java.util.ArrayList" %>    
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
		
		/* if (userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
			return;
		} */				
		request.setCharacterEncoding("UTF-8");
		String searchType = "최신순";
		String search = "";
		
		if (request.getParameter("searchType") != null) {
			searchType = request.getParameter("searchType");
		}
		if (request.getParameter("search") != null) {
			search = request.getParameter("search");
		}
				
		String pageNumber = "1";  // 처음 시작페이지 1페이지로 설정
		// 사용자가 해당 페이지에 접속할때 pageNumber란 이름의 파라미터변수값을 가지고 왔다면 초기화
		if (request.getParameter("pageNumber") != null) {
			pageNumber = request.getParameter("pageNumber");
		} try {	// 사용자가 입력한 pageNumber 값이 숫자 형태일때만 처리할수 있도록 만들어주기
			Integer.parseInt(pageNumber);
		} catch (Exception e) { 
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "페이지 번호가 잘못되었습니다.");
			response.sendRedirect("boardView.jsp");
			return;
		}
						
		ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber);
		ArrayList<BoardDTO> postList = new BoardDAO().getPostList(searchType, search, Integer.parseInt(pageNumber));
		/* == 이것과 같음
		ArrayList<BoardDTO> postList = new ArrayList<BoardDTO>();
		postList = new BoardDAO().getPostList(searchType, search, Integer.parseInt(pageNumber)); */		 		
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
				<li><a href="box.jsp">메세지 함<span id="unread" class="label label-info"></span></a></li>
				<li class="active"><a href="boardView.jsp">자유게시판</a></li>
				<li><a href="openChatIndex.jsp">오픈채팅</a></li>
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
	
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class = "modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>신고 제목</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="30">							
						</div>
						<div class="form-group">
							<label>신고 내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>		
	</div>
	
	<section class="container">
	
		<form method="get" action="./boardView.jsp" class="form-inline pull-right" >
			<select name="searchType" class="form-control">
				<option value="최신순">최신순</option>
				<option value="추천순" <% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>			
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-danger" data-toggle="modal" href="#reportModal">신고</a>
		</form>
	
		
		
	<%-- 	<%
			
			ArrayList<BoardDTO> postList = new ArrayList<BoardDTO>();
			postList = new BoardDAO().getPostList(searchType, search, Integer.parseInt(pageNumber)); 
			if (postList != null) 
		%>  --%>
		<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
			<thead>
				<tr>
					<th colspan="6"><h4>자유 게시판</h4></th>
				</tr>
				<tr>
					<th style="background-color:#fafafa; color: #000000; width: 70px;"><h5>번호</h5></th>
					<th style="background-color:#fafafa; color: #000000;"><h5>제목</h5></th>
					<th style="background-color:#fafafa; color: #000000; width: 130px;"><h5>작성자</h5></th>
					<th style="background-color:#fafafa; color: #000000; width: 160px;"><h5>작성 날짜</h5></th>
					<th style="background-color:#fafafa; color: #000000; width: 70px;"><h5>조회수</h5></th>
					<th style="background-color:#fafafa; color: #000000; width: 70px;"><h5>좋아요</h5></th>
				</tr>
			</thead>
			<tbody>
 	 	
			<%
				if (postList != null)
				for (int i = 0; i < postList.size(); i++) {		
					if (i==10) break;
					BoardDTO board = postList.get(i);					
			%>			
				<tr>
					<td><%= board.getBoardID() %></td>
					<td style="text-align: left;">
					<a href="boardShow.jsp?boardID=<%= board.getBoardID() %>">					
			<%
				for (int j=0; j < board.getBoardLevel(); j++) {
			%>							
					<span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span>	
			<%
				}
			%>	
			<%
				if (board.getBoardAvailable() == 0) {	
			%>
				(삭제된 게시물입니다.)
			<%
				} else {
			%>
				<%= board.getBoardTitle() %>
			<%
				}
			%>
			
			</a></td>						
					<td><%= board.getUserID() %></td>
					<td><%= board.getBoardDate() %></td>
					<td><%= board.getBoardHit() %></td>
					<td><%= board.getLikeCount() %></td>
				</tr>
			<%
				}
			%>
				<tr>
					<td colspan="5">
						<a href="boardWrite.jsp" class="btn btn-primary pull-right" type="submit">글쓰기</a>
						<ul class="pagination" style="margin: 0 auto;" >
					<!-- 부트스트랩에 있는 페이지네이션이란 디자인요소 사용하기. -->
					<%
						// 시작페이지 정의
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new BoardDAO().targetPage(pageNumber, search); //targetPage 함수 이용해서 페이지가 얼마나 존재하는지 체크하기.
						if (startPage != 1) { // startPage가 1이 아니라면
					%>							<!-- startPage에서 1을 뺀 값으로 아이콘 출력 -->
						<!-- 기본적으로 부트스트랩의 페이지네이션은 ul태그 안에 각각의 원소가 담기는 형태로 개발 되어있기 때문에 리스트 아이템 태그 사용하면됨. -->
						<li><a href="boardView.jsp?pageNumber=<%= startPage - 1 %>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
					<%
						} else {  /* startPage 가 1이 아닌 경우는 링크 없이 이동할수 없음을 출력해줌.  */
					%>
						<li><span class="glyphicon glyphicon-chevron-left" style="color: gray;"></span></li>					
					<%
						} // 반복문 이용하여 startPage부터 이동할수 있는 페이지를 하나씩 확인해서 나열해주기.
						for (int i = startPage; i < Integer.parseInt(pageNumber); i++) {   
					%>
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<!-- 현재 사용자가 존재하는 페이지는 active 처리.  현재 페이지 자체를 보여주기.-->
						<li class="active"><a href="boardView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>
					<%
						/* 어떤 페이지까지 이동할수 있는지 보여주기. */
						for (int i = Integer.parseInt(pageNumber) + 1; i <= targetPage + Integer.parseInt(pageNumber); i++) {
							if (i < startPage + 10) { /* = 정상적인 경우 */
					%>			
							<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) { 
					%>
					 	<!-- 한번에 여러개의 페이지를 넘어갈수 있는 버튼 만들어주기. -->
						<li><a href="boardView.jsp?pageNumber=<%= startPage + 10 %>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
					<%
						} else { /* 한번에 여러개의 페이지를 건너뛰어 이동할 페이지가 없는 경우. 이동할수 없음을 알려주기 위해 회색깔로 출력해주기. */
					%>
						<li><span class="glyphicon glyphicon-chevron-right" style="color: gray;"></span></li>
					<%
						}
					%>	
						</ul>					
					</td>										
				</tr>
			</tbody>
		</table>
	</div>	
	</section>
	
	<%-- <div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="5"><h4>자유 게시판</h4></th>
				</tr>
				<tr>
					<th style="background-color:#fafafa; color: #000000; width: 70px;"><h5>번호</h5></th>
					<th style="background-color:#fafafa; color: #000000;"><h5>제목</h5></th>
					<th style="background-color:#fafafa; color: #000000;"><h5>작성자</h5></th>
					<th style="background-color:#fafafa; color: #000000; width: 100px;"><h5>작성 날짜</h5></th>
					<th style="background-color:#fafafa; color: #000000; width: 70px;"><h5>조회수</h5></th>
				</tr>
			</thead>
			<tbody>
			<%
				for (int i = 0; i < boardList.size(); i++) {
					BoardDTO board = boardList.get(i);
					
			%>
				<tr>
					<td><%= board.getBoardID() %></td>
					<td style="text-align: left;">
					<a href="boardShow.jsp?boardID=<%= board.getBoardID() %>">					
			<%
				for (int j=0; j<board.getBoardLevel(); j++) {
			%>							
					<span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span>	
			<%
				}
			%>	
			<%
				if (board.getBoardAvailable() == 0) {	
			%>
				(삭제된 게시물입니다.)
			<%
				} else {
			%>
				<%= board.getBoardTitle() %>
			<%
				}
			%>
			
			</a></td>						
					<td><%= board.getUserID() %></td>
					<td><%= board.getBoardDate() %></td>
					<td><%= board.getBoardHit() %></td>
				</tr>
			<%
				}
			%>
				<tr>
					<td colspan="5">
						<a href="boardWrite.jsp" class="btn btn-primary pull-right" type="submit">글쓰기</a>
						<ul class="pagination" style="margin: 0 auto;" >
					<%
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if (Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new BoardDAO().targetPage(pageNumber);
						if (startPage != 1) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= startPage - 1 %>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
					<%
						} else { 
					%>
						<li><span class="glyphicon glyphicon-chevron-left" style="color: gray;"></span></li>					
					<%
						}
						for (int i = startPage; i < Integer.parseInt(pageNumber); i++) {
					%>
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
						}
					%>
						<li class="active"><a href="boardView.jsp?pageNumber=<%= pageNumber %>"><%= pageNumber %></a></li>
					<%
						for (int i = Integer.parseInt(pageNumber) + 1; i <= targetPage + Integer.parseInt(pageNumber); i++) {
							if (i < startPage + 10) {
					%>			
						<li><a href="boardView.jsp?pageNumber=<%= i %>"><%= i %></a></li>
					<%
							}
						}
						if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) { 
					%>
						<li><a href="boardView.jsp?pageNumber=<%= startPage + 10 %>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
					<%
						} else {
					%>
						<li><span class="glyphicon glyphicon-chevron-right" style="color: gray;"></span></li>
					<%
						}
					%>	
						</ul>					
					</td>										
				</tr>
			</tbody>
		</table>
	</div> --%>
	

	
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