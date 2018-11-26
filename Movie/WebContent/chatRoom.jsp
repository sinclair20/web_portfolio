<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ page import="com.movie.chat.open.ChatEndpoint" %> --%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="com.movie.chat.open.userList.UserListDAO" %>
<%@ page import="com.movie.chat.open.userList.UserListDTO" %>
  
    <%@ page import="java.util.*" %>
<%@ page import = "java.io.*"%>
<%@ page import = "javax.servlet.*"%>  
  <%@ page import = "javax.servlet.http.*"%>
  
<%@ page import = "javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
<link rel="stylesheet" href="./css/bootstrap.css">
<link rel="stylesheet" href="./css/custom.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<title>Insert title here</title>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");

/* 	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	 */
 	String nickName = request.getParameter("nickName");		
	String userID = (String) session.getAttribute("userID"); 
	 
	if (nickName == null) {	 	
		nickName = userID;
	}
	String WsUrl = getServletContext().getInitParameter("WsUrl");	

	 ArrayList<String> users = new ArrayList<String>();
	UserListDAO userListDAO = new UserListDAO();
	ArrayList<UserListDTO> userList = userListDAO.getUserList();
	System.out.println("userList: "+userList);
	System.out.println("userList.size(): "+userList.size());
	for (int i=0; i < userList.size(); i++) {
		users.add(i, userList.get(i).toString()); 	
	}

	 System.out.println("Arrays: "+users);
	/* if (!userList.isEmpty()) {
	for (int i=0; i < userList.size(); i++) {
		users = userList.get(i).toString() + ",";
		
	
		}
	}
 */	
	if (users.contains(nickName)) {
		System.out.println("존재");
		
		session.setAttribute("messageType", "실패 메시지");
		session.setAttribute("messageContent", "이미 존재하는 닉네임입니다. 다시 설정해 주세요.");
		response.sendRedirect("openChatIndex.jsp");
		
		return;
	}
		
	System.out.println("---------");
	
%>
<script type="text/javascript">
let ajax_loading = false;
var page = 1;
var last = 0;
function chatListFunction(name) {
	
	if(!ajax_loading) {
		
		ajax_loading = true;
		<%-- var userID = '<%= userID%>'; // 널 나오는거 맞나요? 예 맞습니다. 현재 비로그인 회원으로 테스트하고있습니다.
		var boardID = '<%= boardID %>'; --%>
		var data = {
			name: encodeURIComponent(name),
			page: page
			
		/*	boardID: encodeURIComponent(boardID),			
			page: page */
		};
		if(page >= last+5) {
			console.log(last);
	        return;
	    }			
		
		console.log(name);

		/* console.log('요청', data); */  // 매요청마다 값이 같아요 아 0이라는 값이 전달되도록 만들었습니다. 매요청이 같아서 응답도 같아요 아.. 전 거기서 데이터를 몽땅 불러온후 
									// 이부분에서 5개씩만 순차적으로 보여주려고 했습니다. 잘못된 방법인가요??
									// 한번에 다 가져와서 스크롤이 내려갈때마다 5개씩 출력하는 방식으로 계획했습니다. 그건 문제가 없는데
									// 요청때마다 같은자료를 가져와요 
		$.ajax({
			type: "POST",
			url: "./userList", // 여기에 전달하는 변수가 lastID 넣도록 의도하신거같은데 맞나요 예 맞습니다. 변수이름이뭔가요? 음 마지막으로 출력된 댓글?  
			data: data, 
			success: function(data) {
			/* setTimeout(function() { ajax_loading = false; }, 10000); */
			if (data=="") return;
			$('#userWindow').empty();
			/* console.log('ㅅㅇ공,', data); */
			//console.log();	
			//console.log(data);
			var parsed = JSON.parse(data);
			/* console.log(JSON.stringify(parsed, undefined, 3)); */
			/* var result = parsed.result; */
			var result = parsed.result;		
			
			for (var i = 0; i < result.length; i++) {
		
				nonmemberAddChat(result[i][0].value);
			}
				/* if (result[i][0].value == "null") {							
				nonmemberAddChat(result[i][0], result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, i+1, result[i][5].value);
				} else {
					addChat(result[i][0].value,  result[i][1].value,  result[i][2].value, result[i][3].value, result[i][4].value, i+1, result[i][5].value);
				}
				lastID = Number(parsed.last); */
				last = i+1
			},						
		
			complete:function() {
				ajax_loading = false;
			}
	
		});
	}
}


function nonmemberAddChat(userName) {
	
	$('#userWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +  
			'<div class="media">' +			
			'<a class="pull-left" href="#">' +
			'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
			'</a>' +
			'<div class="media-body">' +
			'<h4 class="media-heading">' +
			userName +
			'<span class="small pull-right">' +
			'</span>' +
			'</h4>' +
			'<p>' +	    					
			/* '<a href="#updateCommentModal" class="btn btn-info pull-right" data-toggle="modal"  data-title="' + commentID +"r}`3*"+ commentContent + "r}`3*" +  commentPassword +'">' + */
					    				
			'</p>' +		    
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'<hr>');	
	$('#userWindow').scrollTop($('#userWindow')[0].scrollHeight);			
} 


function getInfiniteComment(){
	setTimeout(function() {
		page++;
		chatListFunction('0');
		
	}, 600);
}

function getInfiniteChat(){
	setInterval(function() {
		chatListFunction('0');
		console.log('getInfiniteChat()');
	}, 3000);
}


</script>


</head>

<body>

<!-- 
<div id="chatContainer">
	<div id="loginPanel">
	모달창을 이부분 id로 설정해주어야함. 
		<div id="infoLabel">Type a name to join the room</div>
		<div style="padding: 10px;">
			<input id="txtLogin" type="text" class="loginInput"
				onkeyup="proxy.login_keyup(event)" />
			<button type="button" class="loginInput" onclick="proxy.login()">Login</button>
		</div>
	</div>   
 	<div id="msgPanel">
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
 -->
 	<div id="chatRoom" class="container bootstrap snippet" >
		<div class="row">
			<div class="col-xs-12  col-lg-8">
				<div class="portlet portlet-default">
					<div class="portlet-heading ">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창</h4>							
						</div>
						<div class="clearfix">
						
						</div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div>
						
						</div>
						<div id="messageWindow" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height:600px;">						
						</div>
						<div class="portlet-footer">
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<!-- <textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="메시지를 입력하세요." maxlength="100"></textarea> -->
									<input id="inputMessage" 	title="Enter to send message"
											onkeyup="proxy.sendMessage_keyup(event)"
											style="height: 30px; width: 100%">
								</div>	 
								<div class="form-group col-xs-2">
									<!-- <button type="button" id="sendButton" class="btn btn-default pull-right" onclick="proxy.sendMessage_keyup(event)">전송</button> -->
									<button type="button" id="sendButton" class="btn btn-default pull-right" onclick="proxy.sendMessage();">전송</button>									
									<div class="clearfix"></div>
								</div>							
							</div>
						</div>
					</div>				
				</div>	
			</div>
				<div class="col-lg-4">
			
				<div class="portlet portlet-default" >
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>접속한 유저목록</h4>							
						</div>
						<div class="clearfix">
						
						</div>
					</div>
						<div id="chat" class="panel-collapse collapse in">
						<div>
						 
						</div>
						<div id="userWindow" class="portlet-body chat-widget" style="overflow: scroll; height:400px; overflow-y: scroll;" >						
						</div>					
					</div>	
				</div>
			
			</div>
					
		</div>	
	</div>

	
	

<script type="text/javascript">
/*Websocket을 만들고 서버와 통신하는 Javscript는 "chatroom.js"파일에 구현되어 있습니다.
"CreateProxy"함수는 "index.jsp"파일의 "DOMContentLoaded"이벤트에서 사용됩니다.*/

var inputMessage = document.getElementById('inputMessage');

var CreateProxy = function(wsUri) {
	var websocket = null;
	var audio = null;
	var elements = null;
	var nickName = encodeURIComponent('<%=nickName%>');
	var jbAry = new Array();
	var jbAryy = new Array();
	
	var userAry = new Array();
	var userAryy = new Array();
	

	var playSound = function() {
		if (audio == null) {
			audio = new Audio('content/sounds/beep.wav');
		}		
		audio.play(); 
	};
	
 	var showMsgPanel = function() {
			/* elements.loginPanel.style.display = "none"; */
			elements.msgPanel.style.display = "block";
			elements.txtMsg.focus();
	};
			
	
 	 var hideMsgPanel = function() {
			/* elements.loginPanel.style.display = "block"; */
			elements.msgPanel.style.display = "block";
			/* elements.txtLogin.focus(); */
	}
/* 
	var displayMessage = function(msg) {		
		if (elements.msgContainer.childNodes.length == 100) {
			  elements.msgContainer.removeChild(elements.msgContainer.childNodes[0]);
			} 			
	 		var div = document.createElement('div');
			div.className = 'msgrow';
			var textnode = document.createTextNode(msg);
			div.appendChild(textnode); 
			elements.msgContainer.appendChild(div); 
			
			elements.msgContainer.scrollTop = elements.msgContainer.scrollHeight;
	};
	 */
	 
	 function showName(chat) {			
	       
    	 $('#messageWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +   
			'<div class="media">' +
			'<a class="pull-left" href="#">' +			
			'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
			'</a>' +
			'<div class="media-body">' +
			'<h4 class="media-heading">' +					
			'<span class="small pull-right">' +
			'</span>' +
			'</h4>' +
			'<h4>' +
			'<p style="text-align: center">' +
			chat + 
			'</p>' +
			'</h4>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'<hr>'); 
    	 	     	 
    $('#messageWindow').scrollTop($('#messageWindow')[0].scrollHeight);   		
  /*  	textarea.value += input + "\n"; */
    /*  webSocket.send(inputMessage.value); */
    /* inputMessage.value = ""; */              	
} 

	
	 function showChat(nick, chatMessage) {			
	       
    	 $('#messageWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +   
			'<div class="media">' +			
			'<a class="pull-left" href="#">' +
			'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
			'</a>' +
			'<div class="media-body">' +
			'<h4 class="media-heading">' +			
			nick +			
			'<span class="small pull-right">' +
			'</span>' +
			'</h4>' +
			'<p>' +
			chatMessage + 
			'</p>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'<hr>'); 
    	 	     	 
    $('#messageWindow').scrollTop($('#messageWindow')[0].scrollHeight);   		
  /*  	textarea.value += input + "\n"; */
    /*  webSocket.send(inputMessage.value); */
    /* inputMessage.value = ""; */              	
} 
  
	var clearMessage = function() {
		elements.msgContainer.innerHTML = '';
	};
	
	return {
		login: function() {
			/* elements.txtLogin.focus(); */
			/*var name = elements.txtLogin.value.trim();*/
			
			var name = nickName;
			console.log(name);
			if (name == '') { return; }
			
			/*elements.txtLogin.value = '';*/
			
			// Initiate the socket and set up the events
			if (websocket == null) {
		    	websocket = new WebSocket(wsUri);
		    	
		    	websocket.onopen = function() {
		    		var message = { messageType: 'LOGIN', message: name };
		    		var userList = { messageType: 'USER', message: name };
		    		console.log(message.messageType);
		    		console.log(message.message);	
		    				    		
		    		websocket.send(JSON.stringify(message));
		    		websocket.send(JSON.stringify(userList));
		    		
		        };
		        
		        websocket.onmessage = function(e) {
		        	/* displayMessage(e.data); */
		        	var chat = e.data;
		        	console.log(chat);
		        	if (chat.match('r}`3*')){
			            var jbAry = chat.split('r}`3*');
			            for ( var i in jbAry ) {
			            	jbAryy[i] = jbAry[i]
			            }
			            var nick = jbAryy[0]
			            var ChatMessage = jbAryy[1]
			            console.log(nick);
			            console.log(chat);
			   			            
			        	showChat(nick, ChatMessage);
		        	} else if (chat.match('님이 들어왔습니다.')){
		        		var userAry = chat.split('님이 들어왔습니다.')		        			
		        		var name = userAry[0];
		        		chatListFunction(name);
		        		
		        		
		        		console.log('a', chat);
	        			showName(chat);
		        			
		        	} else if (chat.match('님이 나갔습니다.')){
		        		var userAry = chat.split('님이 나갔습니다.')	        			
	        			var name = userAry[0]
		        		showName(chat);
		        		
		        		console.log('b', chat);
		        	}
		        };
		        
		        websocket.onerror = function(e) {};
		        
		        websocket.onclose = function(e) {
		        	websocket = null;		        	
		        	/* clearMessage(); */
		        	/* hideMsgPanel(); */
		        };
			}
		},
		
		sendMessage: function() {
			/* elements.txtMsg.focus(); */
			
			if (websocket != null && websocket.readyState == 1) {
				/* var input = elements.txtMsg.value.trim(); */
				var input = $('#inputMessage').val();
				if (input == '') { return; }
				
				/* elements.inputMessage.value = ''; */
				
				var message = { messageType: 'MESSAGE', message: input };
				// Send a message through the web-socket
				websocket.send(JSON.stringify(message));
				inputMessage.value = "";   						    		     
			}
		},
		
		/* kecode 13은 enter를 의미 */
		login_keyup: function(e) { if (e.keyCode == 13) { this.login(); } },
		sendMessage_keyup: function(e) { if (e.keyCode == 13) { this.sendMessage(); } },
		initiate: function(e) {
			elements = e;
			/*elements.txtMsg.focus(); */
			/*elements.txtLogin.focus();*/
		}
	}
};

/* document.addEventListener("DOMContentLoaded", function(event) {
	console.log(document.getElementById('loginPanel'));
	proxy.initiate({
		loginPanel: document.getElementById('loginPanel'),
		msgPanel: document.getElementById('msgPanel'),
		txtMsg: document.getElementById('txtMsg'),
		txtLogin: document.getElementById('txtLogin'), 
		msgContainer: document.getElementById('msgContainer'),
		chatContainer: document.getElementById('chatContainer'),
	});
}); */



var wsUri = '<%=WsUrl%>';
var proxy = CreateProxy(wsUri);
proxy.login();

</script>





	<script type="text/javascript">
	getInfiniteChat();  
		
		  
		$(document).ready(function() {
			
			$('#userWindow').scroll(function() {									
				/* http://ankyu.entersoft.kr/Lecture/jquery/jquery_02_31.asp */
				var scrollSize = $(window).scrollTop() + $(window).height();
				var documentSize = $(document).height();
					if (scrollSize >= documentSize - 5) {
						/* console.log('bottom'); */
						/* chatListFunction('0'); */																					  
						getInfiniteComment();
						console.log('bottom');
					}   
				
				});
			
		});
			
	</script>
	
	
	
</body>

</html>