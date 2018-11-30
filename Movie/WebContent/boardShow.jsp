<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "com.movie.board.BoardDAO" %>
<%@ page import = "com.movie.board.BoardDTO" %>
<%@ page import = "com.movie.board.comment.CommentDTO" %>
<%@ page import = "com.movie.board.comment.CommentDAO" %>
<%@ page import = "com.movie.user.UserDAO" %>
<%@ page import = "com.movie.user.UserDTO" %>
    
<!DOCTYPE html>
<html>

	<%
		/* 특정한 사람의 아이디 값을 가져오기  */
		String userID = null; 
		String userPassword = null;	
		/* userID라는 이름으로 로그인이 되었다면 세션 값이 존재하기 때문에 null 값이 아닌것 
		   결과적으로 userID라는 변수안에 해당 사용자의 세션 관련 값을 스트링 형태로 변환하여 넣어줌으로써 
		   해당사용자의 접속 유무 파악 가능*/
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
			UserDAO userDAO = new UserDAO();
			UserDTO user = userDAO.getUser(userID);
			userPassword = user.getUserPassword();
		}
		/* if (userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
			return;
		} */
		String boardID = null;
		if (request.getParameter("boardID") != null) {
			boardID = (String) request.getParameter("boardID");
			session.setAttribute("boardID", boardID);
		}
	
		if (boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "게시물을 선택해주세요.");
			response.sendRedirect("boardView.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		
		if (board.getBoardAvailable() == 0) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "삭제된 게시물입니다.");
			response.sendRedirect("boardView.jsp");
			return;			
		}
		boardDAO.hit(boardID);
		System.out.println(boardID);
		
		String commentID = (String) request.getParameter("commentID");
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
		let ajax_loading = false;
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
		
		function autoClosingAlert(selector, delay) {
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function() { alert.hide() }, delay);
		}
		
		function updateFunction() {
			var userID = '<%= userID%>';
			var boardID = '<%= boardID %>';
			var commentContent = $('.commentContent').val().replace(/\n/g, "\\\\n").replace(/\r/g, "\\\\r").replace(/\t/g, "\\\\t").replace(/\t/g, "\\\\t").replace(/<br\s*\/?>/gi, '\n');
			var commentWriter = $('.commentWriter').val();
			
			if (commentContent == '') { return; }
			
			$.ajax({
				type: "POST",
				url: "./commentUpdate",
				data: {
					userID: encodeURIComponent(userID),
					boardID: encodeURIComponent(boardID),
					commentContent: encodeURIComponent(commentContent),
					commentWriter: encodeURIComponent(commentWriter)
				},
				success: function (result) {
					if (result == 1) {
						autoClosingAlert('#successMessage', 2000);
					} else if (result == 0) {
						autoClosingAlert('#dangerMessage', 2000);
						} else {
						autoClosingAlert('#warningMessage', 2000);
					}
				}
			});
			$('.commentContent').val('');
			$('.commentWriter').val('');
		}
		 
		  
		var lastComment = $('#lastComment').text();
	    function submitFunction() {
			var userID = '<%= userID%>';
			var boardID = '<%= boardID %>';
			var commentContent = $('.commentContent').val().replace(/\n/g, "\\\\n").replace(/\r/g, "\\\\r").replace(/\t/g, "\\\\t");		

			console.log(commentContent);
			if (userID == 'null') {
				var commentWriter = $('.commentWriter').val();
				var commentPassword = $('.commentPassword').val();
				if (commentWriter == '' || commentPassword == '') {
					alert('모든 내용을 입력해주세요');	
				}		
			} else {
				var commentWriter = '<%= userID%>';
				var commentPassword = '<%= userPassword %>';
				
			}		
			if (commentContent == '') { return; }
			$.ajax({
				type: "POST",
				url: "./commentWrite",
				data: {
					userID: encodeURIComponent(userID),
					boardID: encodeURIComponent(boardID),
					commentContent: encodeURIComponent(commentContent),
					commentWriter: encodeURIComponent(commentWriter),
					commentPassword: encodeURIComponent(commentPassword)
				},
				success: function (result) {
					if (result == 1) {
						autoClosingAlert('#successMessage', 2000);
					} else if (result == 0) {
						autoClosingAlert('#dangerMessage', 2000);
					} else {
						autoClosingAlert('#warningMessage', 2000);
					}
				}
			});
			$('.commentContent').val('');
			$('.commentWriter').val('');
			$('.commentPassword').val('');
		}
	    
	    
		var lastID = 0;
		var page = 1;
		var last = 0;
		 /* 즉, if ( a ) 라면 a 가 참이되면 실행이 되는 거구, if ( !a ) 라면 a가 거짓이라면 실행 */
		function chatListFunction(type) {
			console.log(lastComment);
			if(!ajax_loading) {
				ajax_loading = true;
				var userID = '<%= userID%>'; // 널 나오는거 맞나요? 예 맞습니다. 현재 비로그인 회원으로 테스트하고있습니다.
				var boardID = '<%= boardID %>';
				var data = {
					userID: encodeURIComponent(userID),
					boardID: encodeURIComponent(boardID),			
					listType: type,
					page: page
				};
				if(page >= last+3) {
					console.log(last);
			        return;
			    }			
				
				/* console.log('요청', data); */  // 매요청마다 값이 같아요 아 0이라는 값이 전달되도록 만들었습니다. 매요청이 같아서 응답도 같아요 아.. 전 거기서 데이터를 몽땅 불러온후 
											// 이부분에서 5개씩만 순차적으로 보여주려고 했습니다. 잘못된 방법인가요??
											// 한번에 다 가져와서 스크롤이 내려갈때마다 5개씩 출력하는 방식으로 계획했습니다. 그건 문제가 없는데
											// 요청때마다 같은자료를 가져와요 
				$.ajax({
					type: "POST",
					url: "./infiniteComment", // 여기에 전달하는 변수가 lastID 넣도록 의도하신거같은데 맞나요 예 맞습니다. 변수이름이뭔가요? 음 마지막으로 출력된 댓글?  
					data: data, 
					success: function(data) {
					/* setTimeout(function() { ajax_loading = false; }, 10000); */
					if (data=="") return;
					$('#commentList').empty();
					/* console.log('ㅅㅇ공,', data); */
					//console.log();	
					//console.log(data);
					var parsed = JSON.parse(data);
					/* console.log(JSON.stringify(parsed, undefined, 3)); */
					/* var result = parsed.result; */
 					var result = parsed.result;			 					 
					for (var i = 0; i < result.length; i++) {								
						if (result[i][0].value == "null") {							
							nonmemberAddChat(result[i][0], result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, i+1, result[i][5].value);
						} else {
							addChat(result[i][0].value,  result[i][1].value,  result[i][2].value, result[i][3].value, result[i][4].value, i+1, result[i][5].value);
						}
						lastID = Number(parsed.last);
						last = i+1
					}						
					},
					complete:function() {
						ajax_loading = false;
					}
				});
			}			
		}		 
		
		
		
		
		function nonmemberAddChat(userID, commentWriter, commentContent, commentTime, commentID, commentOrder, commentPassword) {
					
					$('#commentList').append('<div class ="row">' +
		    				'<div class="col-lg-12">' +  
		    				'<div class="media">' +			
		    				'<a class="pull-left" href="#">' +
							'<span id="lastComment">' + 
		    				commentOrder +
		    				'</span>' + 
		    				/* a (commentOrder, commentLength) +  */
		    				'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
		    				'</a>' +
		    				'<div class="media-body">' +
		    				'<h4 class="media-heading">' +
		    				commentWriter +
		    				'<span class="small pull-right">' +
		    				commentTime +
		    				'</span>' +
		    				'</h4>' +
		    				'<p>' +
		    				commentContent +		    					
		    				/* '<a href="#updateCommentModal" class="btn btn-info pull-right" data-toggle="modal"  data-title="' + commentID +"r}`3*"+ commentContent + "r}`3*" +  commentPassword +'">' + */
		    				'<a href="#updateCommentModal" class="btn btn-info pull-right" data-toggle="modal"  data-title="' + commentID +"r}`3*"+ userID +"r}`3*"+commentWriter + "r}`3*" + commentContent + "r}`3*"+ commentPassword +'">댓글 수정</a>' +		    				
	                        '<a href="#" onclick="cmDeleteOpen('+ commentID +')">삭제</a>' +		    				
		    				'</p>' +		    
		    				'</div>' +
		    				'</div>' +
		    				'</div>' +
		    				'</div>' +
		    				'<hr>');	
				$('#commentList').scrollTop($('#commentList')[0].scrollHeight);			
			} 
			
			
			function addChat(userID, commentWriter, commentContent, commentTime, commentID, commentOrder, commentPassword) {

				$('#commentList').append('<div class ="row">' +
	    				'<div class="col-lg-12">' +  
	    				'<div class="media">' +			
	    				'<a id="lastComment" class="pull-left" href="#">' +	    				
	    				'<span id="lastComment">' + 
	    				commentOrder +
	    				'</span>' + 	    				
	    				'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
	    				'</a>' +
	    				'<div class="media-body">' +
	    				'<h4 class="media-heading">' +
	    				userID +
	    				'<span class="small pull-right">' +
	    				commentTime +
	    				'</span>' +
	    				'</h4>' +
	    				'<p>' +
	    				commentContent +
	    					
	    				'<a href="#updateCommentModal" class="btn btn-info pull-right" data-toggle="modal" data-title="' + commentID +"r}`3*"+ + userID +"r}`3*"+ commentWriter + "r}`3*" + commentContent + "r}`3*"+ commentPassword + '">댓글 수정</a>' + 
	    				/* '<a class="btn btn-info" href="./commentUpdate" data-toggle="modal" onclick="location.href="#commentModal"">' + */ 
	    				/* '<a href="#updateCommentModal" class="btn btn-info pull-right" data-toggle="modal"  data-title="' + commentID +"r}`3*"+ commentContent + "r}`3*" +  commentPassword +'">' + */		    	

                        '<a href="#" onclick="cmDeleteOpen('+ commentID +')">삭제</a>' +
	    				'</p>' +		    
	    				'</div>' +
	    				'</div>' +
	    				'</div>' +
	    				'</div>' +
	    				'<hr>');	
			$('#commentList').scrollTop($('#commentList')[0].scrollHeight);
		} 

		
		// 채팅 화면에 메시지 출력하는 함수
		<%-- function addChat(commentWriter, commentContent, commentTime, commentID, commentOrder, commentLength, lastComment) {
			
			var last = commentLength + 1
			
			 if (lastComment != 1) {
			  
					$('#commentList').append('<div class ="row">' +
		    				'<div class="col-lg-12">' +  
		    				'<div class="media">' +			
		    				'<a class="pull-left" href="#">' +
		    				commentOrder +
		    				/* a (commentOrder, commentLength) +  */
		    				'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
		    				'</a>' +
		    				'<div class="media-body">' +
		    				'<h4 class="media-heading">' +
		    				commentWriter +
		    				'<span class="small pull-right">' +
		    				commentTime +
		    				'</span>' +
		    				'</h4>' +
		    				'<p>' +
		    				commentContent + 
		    				'<a class="btn btn-info pull-right" data-toggle="modal" href="#commentModal" data-title="' + commentID +"r}`3*"+ commentContent +'">' +
	                        '<a href="#" onclick="cmDeleteOpen('+ commentID +')">삭제</a>' +
		    				/* '<a class="btn btn-info" href="./commentUpdate" data-toggle="modal" onclick="location.href="#commentModal"">' + */ 
		    				'</p>' +
		    				'<a href="deleteCommentAction.jsp?boardID='+ <%= boardID %> + '&&' + <%= commentID %> +'" onclick="return confirm("정말로 삭제하시겠습니까?");">' +
		    				'</div>' +
		    				'</div>' +
		    				'</div>' +
		    				'</div>' +
		    				'<hr>');					
			} else {
			
					var array = new Array();
					for (i=0; i < commentLength; i++) {
						array = i
					}
			
					b = array.length;
					commentOrder.indexOf(b)
				$('#commentList').append('<div class ="row">' +
	    				'<div class="col-lg-12">' +  
	    				'<div class="media">' +			
	    				'<a class="pull-left" href="#">' +
	    				last +
	    				/* a (commentOrder, commentLength) +  */
	    				'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
	    				'</a>' +
	    				'<div class="media-body">' +
	    				'<h4 class="media-heading">' +
	    				commentWriter +
	    				'<span class="small pull-right">' +
	    				commentTime +
	    				'</span>' +
	    				'</h4>' +
	    				'<p>' +
	    				commentContent + 
	    				'<a class="btn btn-info pull-right" data-toggle="modal" href="#commentModal" data-title="' + commentID +"r}`3*"+ commentContent +'">' +
                        '<a href="#" onclick="cmDeleteOpen('+ commentID +')">삭제</a>' +
	    				/* '<a class="btn btn-info" href="./commentUpdate" data-toggle="modal" onclick="location.href="#commentModal"">' + */ 
	    				'</p>' +
	    				'<a href="deleteCommentAction.jsp?boardID='+ <%= boardID %> + '&&' + <%= commentID %> +'" onclick="return confirm("정말로 삭제하시겠습니까?");">' +
	    				'</div>' +
	    				'</div>' +
	    				'</div>' +
	    				'</div>' +
	    				'<hr>');
			}
					$('#commentList').scrollTop($('#commentList')[0].scrollHeight);
			} 
		 --%>

		function getInfiniteChat(){
			setInterval(function() {
				chatListFunction('0');
			}, 3000);
		}
		
		function getInfiniteComment(){
			setTimeout(function() {
				page++;
				chatListFunction('0');
			}, 600);
		}
		
		var httpRequest = null;
        
        // httpRequest 객체 생성
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

        
        function checkFunc(){
            if (httpRequest.readyState == 4){
                // 결과값을 가져온다.
                var resultText = httpRequest.responseText;
                if(resultText == 1){ 
                    document.location.reload(); // 상세보기 창 새로고침
                }
            }
        }


        function cmDeleteOpen(commentID){
            var msg = confirm("댓글을 삭제합니다.");    
            if(msg == true){ // 확인을 누를경우
                deleteCmt(commentID);
            }
            else{
                return false; // 삭제취소
            }
        }
        
     // 댓글 삭제
        function deleteCmt(commentID) {
            var param="commentID="+ commentID;
            /* console.log(commentID); */
            httpRequest = getXMLHttpRequest();
            httpRequest.onreadystatechange = checkFunc;
          	/* httpRequest.open("POST", "http://localhost:8080/Movie/DeleteCommentAction.jsp", true); */
          	httpRequest.open("POST", "./deleteComment", true);
            httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=EUC-KR'); 
            httpRequest.send(param); 
        }
     

        

	</script>

</head>
<body id="body">



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
	
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;" >
			<thead>
				<tr>
					<th colspan="4"><h4>게시물 보기</h4></th>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>제목</h5></td>
					<td colspan="3"><h5><%= board.getBoardTitle() %></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>작성자</h5></td>
					<td colspan="1"><h5><%= board.getUserID() %></h5></td>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>좋아요</h5></td>
					<td colspan="1"><h5><%= board.getLikeCount() %></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>작성 날짜</h5></td>
					<td colspan="1"><h5><%= board.getBoardDate() %></h5></td>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>조회수</h5></td>
					<td colspan="1"><h5><%= board.getBoardHit() + 1%></h5></td>
					
				</tr>
				<tr>
					<td style="vertical-align: middle; min-height: 150px; background-color: #fafafa; color: #000000; width: 80px;"><h5>글 내용</h5></td>
					<td colspan="3" style="text-align: left;"><h5><%= board.getBoardContent() %></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>첨부 파일</h5></td>
					<td colspan="3"><h5><a href="boardDownload.jsp?boardID=<%= board.getBoardID() %>"><%= board.getBoardFile() %></a></h5></td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="5" style="text-align: right;">					
						<a href="boardView.jsp" class="btn btn-primary">목록</a>
						<a href="likeAction.jsp?boardID=<%= board.getBoardID() %>">(추천: <%= board.getLikeCount() %>)</a>	
						<a href="boardReply.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary">답변</a>
						<%
							if (userID != null && userID.equals(board.getUserID())) {
						%>														
							<a href="boardUpdate.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary">수정</a>
							<a href="boardDelete?boardID=<%= board.getBoardID() %>" class="btn btn-primary" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>		
						<%
							} 
						%>						
					</td>					
				</tr>
			</tbody>
		</table>
	</div>

	
	 <%
       	if (userID != null) {       	
     %>	
	     <div class="container">
	    	<form class="form-horizontal" style="margin-top: 10px; width: 600px;">
		  <div class="form-group">
		    <div class="col-sm-10">
		    	<textarea class="form-control commentContent" name="commentContent" placeholder="남기고 싶은 말" required="required"></textarea>      
		    </div>
		    <div class="col-sm-2">
		      <button id="submit" type="button" class="form-control btn btn-primary" onclick="submitFunction();">글쓰기</button>
		    </div>
		  </div>
		  
		</form>
		</div>
	<%
       	} else {
	%>
	    <div class="container">
	    <form class="form-horizontal" style="margin-top: 10px; width: 600px;">
	  		<div class="form-group">
	    	<div class="col-sm-10">
	      		<input type="text" class="form-control commentWriter" name="commentWriter" placeholder="글쓴이" required="required">
	      		<input type="password" class="form-control commentPassword" name="commentPassword" placeholder="비밀번호" required="required">
	    	</div>
	    	<div class="col-sm-2">
	      		<button id="submit" type="button" class="form-control btn btn-primary" onclick="submitFunction();">글쓰기</button>
	    	</div>
	  	</div>
	  	<div class="form-group">
	    	<div class="col-sm-12">
	      		<textarea class="form-control commentContent" name="commentContent" placeholder="댓글을 입력해주세요." required="required"></textarea>
	    	</div>
	    	
	  	</div>
		</form>
		</div>
	<%
       	}
	%>
	
	
	<div class="modal fade" id="updateCommentModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class = "modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">댓글 수정</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
				</div>
				<div class="modal-body">							
				<form method="post" action="./commentUpdate">				 
					<section class="container mt-5 mb-5" style="max-width: 560px;">
						<div id="modal" class="input-group" role="group" aria-label="..." style="margin-top: 10px; width: 540px;">
						<div style="display:none">						
							<textarea class="commentID" name="commentID" id="commentID"></textarea>
							<textarea class="commentPassword" name="commentPassword" id="commentPassword"></textarea>
						</div>					
					    <textarea class="form-control commentContent" rows="3" name="commentContent" placeholder="댓글을 입력하세요." style="width: 540px;" ></textarea>				    
					    <div class="btn-group btn-group-sm" role="group" aria-label="...">       
					        <button type="submit" class="btn btn-default" >댓글 쓰기</button>
						    </div> 
						</div>		
					</section>
				</form>			
				</div>
			</div>
		</div>		
	</div>
	
				
	<div id="chat" class="panel-collapse collapse in">
		<div id="commentList" class="portlet-body chat-widget" style="width: auto; height:600px; padding:30px;">						
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
	
<%-- 	
	<%
		if (userID != null) {
	%>
		<script type="text/javascript">
				chatListFunction('0');
				getInfiniteChat()
			$(document).ready(function() {
				/* getInfiniteUnread();
				chatListFunction('0'); 
				getInfiniteChat();*/
				
				getUnread();
				$("#body").scrollTop(0);				
			
					$(window).scroll(function() {									
						var scrollSize = $(window).scrollTop() + $(window).height();
						var documentSize = $(document).height();
						var lastComment = $('#lastComment').text();
						console.log(lastComment);
							if (scrollSize <= documentSize - 5) {
								/* console.log('bottom'); */
								page++;
								if (page <= lastComment) {
									console.log(lastComment);
									getInfiniteComment(); 
									/* chatListFunction('0'); */
								}							
							} 
					});
								
						
				
				$('#updateCommentModal').on('show.bs.modal', function (event) {    // myModal 윈도우가 오픈할때 아래의 옵션을 적용
					
					var userID = '<%=userID%>';
					var userPassword = '<%=userPassword%>';
					/* console.log(userPassword); */

						/* console.log("회원인증");  */
				    var jbAry = new Array();
					var jbAryy = new Array();  
					 
					var button = $(event.relatedTarget); 				     // 모달 윈도우를 오픈하는 버튼
					var titleTxt = button.data('title');				     // 버튼에서 data-title 값을 titleTxt 변수에 저장
					var jbAry = titleTxt.split('r}`3*');
					for (var i in jbAry) {
						  jbAryy[i] = jbAry[i];
					 }
					var commentID = jbAryy[0];
					var commentContent = jbAryy[1];
					var commentWriter = jbAryy[2];
					var commentPassword = jbAryy[3];
					/* console.log(commentWriter); */
					if (userID == commentWriter) {
						var str = '회원 비밀번호를 입력해주세요';
					    var content = prompt('메시지창', str);
							if (userID == commentWriter && userPassword == content) {								
								 var modal = $(this);
							     modal.find('#commentID').text(commentID); 		// 모달위도우에서 .modal-title을 찾아 titleTxt 값을 치환
							     modal.find('#commentContent').text(commentContent);
							     $(location).attr('href', "#updateCommentModal");				     
							     
							} else {
								$(location).attr('href', "boardShow.jsp?boardID=<%= board.getBoardID() %>");
							}
					} else {
						var str = '비밀번호를 입력해주세요';
					    var content = prompt('메시지창', str);
					    /* console.log("4"); */
					    if (commentPassword == content) {
					    	/* consol.log('aaa'); */
							 var modal = $(this);
						     modal.find('#commentID').text(commentID); 		// 모달위도우에서 .modal-title을 찾아 titleTxt 값을 치환
						     modal.find('#commentContent').text(commentContent);
						     console.log("2");
						     $(location).attr('href', "#updateCommentModal");				     
						} else {
							console.log("3");
							$(location).attr('href', "boardShow.jsp?boardID=<%= board.getBoardID() %>");
						}
					}					
				}); 
			});			
			
			
		</script>
	<%
		} else {
	%> --%>
	
	<script type="text/javascript">
		$("#body").scrollTop(0);
		chatListFunction('0');
		getInfiniteChat();  
		$(document).ready(function() {
			
			$(window).scroll(function() {									
				/* http://ankyu.entersoft.kr/Lecture/jquery/jquery_02_31.asp */
				var scrollSize = $(window).scrollTop() + $(window).height();
				var documentSize = $(document).height();
					if (scrollSize >= documentSize - 5) {
						/* console.log('bottom'); */
						/* chatListFunction('0'); */																					  
						
						getInfiniteComment();
					}   
				
				});
			
	
	
				
				
				$('#updateCommentModal').on('hidden.bs.modal', function () {
					    $(this).find('textarea').trigger('reset');
					    $(this).find('textarea').trigger("reset");
					    $(this).find('.commentContent').trigger("reset");
					    


				})
				
		
		
		
			$('#updateCommentModal').on('show.bs.modal', function (event) {    // myModal 윈도우가 오픈할때 아래의 옵션을 적용
								
				var jbAry = new Array();
				var jbAryy = new Array();  
					 
				var button = $(event.relatedTarget); 				     // 모달 윈도우를 오픈하는 버튼
				var titleTxt = button.data('title');				     // 버튼에서 data-title 값을 titleTxt 변수에 저장
				var jbAry = titleTxt.split('r}`3*');
				for (var i in jbAry) {
					jbAryy[i] = jbAry[i];
				}
				var commentID = jbAryy[0];
				var userID = jbAryy[1];
				var commentWriter = jbAryy[2];
				var commentContent = jbAryy[3];
				var commentPassword = jbAryy[4];
				console.log(commentID);
				console.log(userID);
				console.log(commentWriter);
				console.log(commentContent);
				console.log(commentPassword);
				
				if (userID == '[object Object]') {
					var str = '비밀번호를 입력해주세요';
					var content = prompt('메시지창', str);
					if (content == commentPassword) {
						var modal = $(this);					
						modal.find('.commentID').text(commentID); 		// 모달위도우에서 .modal-title을 찾아 titleTxt 값을 치환
					     modal.find('.commentContent').text(commentContent);
						console.log('11');
					     $(location).attr('href', "#updateCommentModal");
					} else {
						console.log('33');
						$(location).attr('href', "boardShow.jsp?boardID=<%= board.getBoardID() %>");
					}		
				} else if (userID != '[object Object]') {
					var str = '회원 비밀번호를 입력해주세요';
					var content = prompt('메시지창', str);
					var modal = $(this);						
					if (content == commentPassword) {
						modal.find('.commentID').text(commentID); 		// 모달위도우에서 .modal-title을 찾아 titleTxt 값을 치환
					    modal.find('.commentContent').text(commentContent);
					    console.log('22');
					    $(location).attr('href', "#updateCommentModal");
					} else {
						console.log('33');
						$(location).attr('href', "boardShow.jsp?boardID=<%= board.getBoardID() %>");
					}										
				} 
				
					/* 
					if (userID == commentWriter && userPassword == content) {
					   	modal.find('#commentID').text(commentID); 		// 모달위도우에서 .modal-title을 찾아 titleTxt 값을 치환
					    modal.find('#commentContent').text(commentContent);				
						$(location).attr('href', "#updateCommentModal");
					 // 유저가 자신이 쓴 댓글이 아닌 다른유저나 비회원이 쓴 댓글을 클릭한 경우
					} else if (commentPassword == content) { 						
					    modal.find('#commentContent').text(commentContent);				
					    $(location).attr('href', "#updateCommentModal");
					}  */
					<%-- else {
						$(location).attr('href', "boardShow.jsp?boardID=<%= board.getBoardID() %>");
					}
						 --%>
					
			});
			
			
			<%
				if (userID != null) {
			%>				
					getUnread();
					getInfiniteUnread();				
			<%
				}
			%>
			
			/* 	$('#commentModal').on('show.bs.modal', function (event) {    // myModal 윈도우가 오픈할때 아래의 옵션을 적용
			var jbAry = new Array();
			var jbAryy = new Array();  
			 
			var button = $(event.relatedTarget); 				     // 모달 윈도우를 오픈하는 버튼
			  var titleTxt = button.data('title');				     // 버튼에서 data-title 값을 titleTxt 변수에 저장
			  var jbAry = titleTxt.split('r}`3*');
			  for (var i in jbAry) {
				  jbAryy[i] = jbAry[i];
			  }				  
			  var commentID = jbAryy[0];
			  var commentContent = jbAryy[1];
			  var commentPassword = jbAryy[2];
			  console.log(commentPassword);
			  var str = '비밀번호를 입력해주세요';
		      var content = prompt('메시지창', str);
		    if (commentPassword == str) {
		    		 var modal = $(this);
					  modal.find('.commentID').text(commentID); 		// 모달위도우에서 .modal-title을 찾아 titleTxt 값을 치환
					  modal.find('#commentContent').text(commentContent);
		    	 }else {
		    		 return;
		    	 }
		    	 
			  
			});
			 */
		});
	</script>
	<%-- <%
		}
	%>
 --%>
	 


</body>
</html>