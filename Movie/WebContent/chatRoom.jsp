<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ page import="com.movie.chat.open.ChatEndpoint" %> --%>

<%@ page import="java.util.ArrayList" %>

<%@ page import="com.movie.user.UserDAO" %>
<%@ page import="com.movie.user.UserDTO" %>
<%@ page import="com.movie.chat.open.userList.UserListDAO" %>
<%@ page import="com.movie.chat.open.userList.UserListDTO" %>
<%@ page import="java.util.HashMap" %>
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
	String WsUrl = getServletContext().getInitParameter("WsUrl");
	UserDAO userDAO = new UserDAO();
	UserListDAO userListDAO = new UserListDAO();
	
	
	String imgSrc = request.getParameter("imgSrc");
	String nickName = request.getParameter("nickName");
	
	
	String userID = (String) session.getAttribute("userID");
	
	System.out.println("1. userID:" + userID);
	System.out.println("2. nickName:" + nickName);
	System.out.println("3. userDAO.getProfile(userID):" + userDAO.getProfile(userID));



	if (nickName == null) {	 	
		nickName = userID;
	}
		

	ArrayList<String> users = new ArrayList<String>();
	
	ArrayList<UserListDTO> userList = userListDAO.getUserList();
	
	System.out.println("userList: " + userList);
	System.out.println("userList.size(): " + userList.size());
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
 	if (nickName == null) {
 		session.setAttribute("messageType", "실패 메시지");
		session.setAttribute("messageContent", "닉네임을 설정하시고 입장해주세요.");
		response.sendRedirect("openChatIndex.jsp");
 	}
 	
	if (users.contains(nickName)) {
		System.out.println("존재");
		
		session.setAttribute("messageType", "실패 메시지");
		session.setAttribute("messageContent", "이미 존재하는 닉네임입니다. 다시 설정해 주세요.");
		response.sendRedirect("openChatIndex.jsp");
		
		
	}
 	
	
	
 	
	System.out.println("---------");
	
	
%>
<script type="text/javascript">
function noEvent() { // 새로 고침 방지
    if (event.keyCode == 116) {
        alert("새로고침을 할 수 없습니다.");
        event.keyCode = 2;
        return false;
    } else if (event.ctrlKey
            && (event.keyCode == 78 || event.keyCode == 82)) {
        return false;
    }
}
document.onkeydown = noEvent;





let ajax_loading = false;
var page = 1;
var last = 0;
function chatListFunction(name) {
	
	if(!ajax_loading) {
		var ss = '<%=imgSrc%>'
		if ('<%=userDAO.getProfile(userID)%>' != "http://localhost:8000/localMovie/images/userIcon.png") {
			ss = '<%=userDAO.getProfile(userID)%>';
		}
		ajax_loading = true;
		<%-- var imgSrc = '<%=imgSrc%>'; --%>
		/* console.log("imgSrc",imgSrc); */
		var data = {
			name: encodeURIComponent(name),
			imgSrc: encodeURI(ss),
			/* imgSrc: encodeURIComponent(imgSrc), */
			page: page
		
		};
		
		if(page >= last+5) {
			console.log(last);
	        return;
	    }			
		
		console.log(name);
		$.ajax({
			type: "POST",
			url: "./userList",  
			data: data, 
			success: function(data) {
			
			if (data=="") return;
			$('#userWindow').empty();
			var parsed = JSON.parse(data);
			var result = parsed.result;		
			
			for (var i = 0; i < result.length; i++) {
		
				nonmemberAddChat(result[i][0].value, result[i][1].value);
			}
			var l = i;
				last = l+1
				
			},						
		
			complete:function() {
				ajax_loading = false;
			}
	
		});
	}
}


function nonmemberAddChat(userName, userProfile) {
	
	$('#userWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +  
			'<div class="media">' +			
			'<a class="pull-left" href="#">' +
			'<img class="media-object img-circle" src="'+ userProfile +'" style="width:70px; height: 70px; cursor: pointer;" onclick="imgPop('+"'"+userProfile+"'"+')"/>' +			
			'</a>' +
			'<div class="media-body">' +
			'<h3>' +
			userName +
			'<span class="small pull-right">' +
			'</span>' +
			'</h3>' +
				    
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'<hr>');	
	$('#userWindow').scrollTop($('#userWindow')[0].scrollHeight); 			
} 


function addChat(userName) {
	
	$('#userWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +  
			'<div class="media">' +			
			'<a class="pull-left" href="#">' +
			'<img class="media-object img-circle" style="width:30px; height: 30px;" alt="">' +
			'</a>' +
			'<div class="media-body">' +
			'<h3 class="media-heading">' +
			userName +
			'<span class="small pull-right">' +
			'</span>' +
			'</h4>' +
			'<p>' +	    					
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





function imgPop(img){ 
   img1= new Image(); 
   img1.src=(img); 
   imgControll(img); 
} 
  
function imgControll(img){ 
 if((img1.width!=0)&&(img1.height!=0)){ 
    viewImage(img); 
  } 
  else{ 
     controller = "imgControll('"+img+"')"; 
     intervalID = setTimeout(controller,10); 
  } 
}

function viewImage(img){ 
	 /* O="width="+500+",height="+500+",scrollbars=yes"; */
	 W=Number(img1.width * 0.6); 
	 H=Number(img1.height * 0.6); 
	 O="width="+W+",height="+H+""; 
	 imgWin=window.open("","",O); 
	 imgWin.document.write("<html><head><title>:*:*:*: 이미지상세보기 :*:*:*:*:*:*:</title></head>");
	 imgWin.document.write("<body topmargin=0 leftmargin=0>");
	 imgWin.document.write("<img src="+img+" onclick='self.close()' style='max-width:"+W+"; max-height:auto; cursor:pointer;' title ='클릭하시면 창이 닫힙니다.'>");
	 imgWin.document.close();
}

</script>


</head>

<body oncontextmenu="return false">


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
								
									<input id="inputMessage" title="Enter to send message"
											onkeyup="proxy.sendMessage_keyup(event)"
											style="height: 30px; width: 100%" maxlength="50">
								</div>	 
								<div class="form-group col-xs-2">
								
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
						<div id="userWindow" class="portlet-body chat-widget" style="overflow: scroll; height:500px; overflow-y: scroll;" >						
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
	var imgSrc = encodeURI('<%=imgSrc%>');
	
	
	console.log("imgSrc: ",imgSrc)
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
			
			elements.msgPanel.style.display = "block";
			elements.txtMsg.focus();
	};
			
	
 	 var hideMsgPanel = function() {			
			elements.msgPanel.style.display = "block";			
	}
	 
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

	
	 function showChat(nick, chatMessage, img, time) {			
	       
    	 $('#messageWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +   
			'<div class="media">' +			
			'<a class="pull-left" href="#">' +
			'<img class="media-object img-circle" src="'+ img +'" style="width:80px; height: 80px; cursor: pointer;" onclick="imgPop('+"'"+img+"'"+')"/>' +
			/* '<img class="media-object img-circle" style="width:80px; height: 80px;" src="'+ img +'" alt="">' + */
			'</a>' +
			'<div class="media-body">' +
			'<h3 style="color:#8C8C8C" class="media-heading">' +			
			nick +			
			'<span class="small pull-right">' +
			time +
			'</span>' +
			'</h3>' +
			'<p>' +
			'<font size="4">' +
			chatMessage +
			'<font>' + 
			'</p>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'<hr>'); 
              	
} 
	 
	 function showUserChat(nick, chatMessage) {			
	       
    	 $('#messageWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +   
			'<div class="media">' +			
			'<a class="pull-left" href="#">' +
			'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%=userDAO.getProfile(userID)%>" alt="">' +
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
			            var img = jbAryy[2]
			            var time = jbAryy[3]
			            console.log(nick);
			            console.log(chat);
			            
			            var currentDate = new Date();            
			            var msg = currentDate.getHours()+"시 "
				        msg += currentDate.getMinutes()+"분 ";
				        msg += currentDate.getSeconds()+"초";
				        
			            showChat(nick, ChatMessage, img, msg);	
			            
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
			var sendImg = "";
			if (websocket != null && websocket.readyState == 1) {
				
				
				if (imgSrc == "http://localhost:8000/localMovie/images/1.jpg") {
				  sendImg = "r}`3*http://localhost:8000/localMovie/images/1.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/2.jpg") {
			    	sendImg= "r}`3*http://localhost:8000/localMovie/images/2.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/3.jpg") {
			    	sendImg = "r}`3*http://localhost:8000/localMovie/images/3.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/4.jpg") {
			    	sendImg = "r}`3*http://localhost:8000/localMovie/images/4.jpg";
			    } else {
			    	sendImg = 'r}`3*<%=userDAO.getProfile(userID)%>';
			    }
			    		   
				var input = $('#inputMessage').val() + sendImg
				
				if ($('#inputMessage').val() == '') { return; }
				
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