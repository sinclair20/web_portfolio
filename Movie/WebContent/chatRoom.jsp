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
<link rel="stylesheet" href="./css/sendToOne.css">

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
	System.out.println("1. imgSrc:" + imgSrc);
	
	String userID = (String) session.getAttribute("userID");
	
	System.out.println("1. userID:" + userID);
	System.out.println("2. nickName:" + nickName);
	System.out.println("3. userDAO.getProfile(userID):" + userDAO.getProfile(userID));
	if (imgSrc == null || nickName == null) {
		imgSrc = userDAO.getProfile(userID);
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
	
	
	
	
	<!-- <div class="popup-box chat-popup" id="qnimate" style="display:none">
	<div>
    		  <div class="popup-head">
				<div class="popup-head-left pull-left"><img src="http://bootsnipp.com/img/avatars/bcf1c0d13e5500875fdd5a7e8ad9752ee16e7462.jpg" alt="iamgurdeeposahan"> Gurdeep Osahan</div>
					  <div class="popup-head-right pull-right">
						<div class="btn-group">
    								  <button class="chat-header-button" data-toggle="dropdown" type="button" aria-expanded="false">
									   <i class="glyphicon glyphicon-cog"></i> </button>
									  <ul role="menu" class="dropdown-menu pull-right">
										<li><a href="#">Media</a></li>
										<li><a href="#">Block</a></li>
										<li><a href="#">Clear Chat</a></li>
										<li><a href="#">Email Chat</a></li>
									  </ul>
						</div>
						
						<button data-widget="remove" id="removeClass"  class="chat-header-button pull-right" type="button"><i class="glyphicon glyphicon-off"></i></button>
                      </div>
			  </div>
			  <div id="data" style="display:none"> 
			  </div> 
			<div id="childMessageWindow" class="popup-messages">
    		
			
			<div class="direct-chat-messages">
               	
               	<div class="chat-box-single-line">
								<abbr class="timestamp">October 8th, 2015</abbr>
					</div>
					
					
					
					
					Message. Default to the left
                    <div class="direct-chat-msg doted-border">
                      <div class="direct-chat-info clearfix">
                        <span class="direct-chat-name pull-left">Osahan</span>
                      </div>
                      /.direct-chat-info
                      <img alt="message user image" src="http://bootsnipp.com/img/avatars/bcf1c0d13e5500875fdd5a7e8ad9752ee16e7462.jpg" class="direct-chat-img">/.direct-chat-img
                      <div class="direct-chat-text">
                        Hey bro, how’s everything going ?
                      </div>
					  <div class="direct-chat-info clearfix">
                        <span class="direct-chat-timestamp pull-right">3.36 PM</span>
                      </div>
						<div class="direct-chat-info clearfix">
						<span class="direct-chat-img-reply-small pull-left">
							
						</span>
						<span class="direct-chat-reply-name">Singh</span>
						</div>
                      /.direct-chat-text
                    </div>
                    /.direct-chat-msg
					
					
					<div class="chat-box-single-line">
						<abbr class="timestamp">October 9th, 2015</abbr>
					</div>
			
					
					
					Message. Default to the left
                    <div class="direct-chat-msg doted-border">
                      <div class="direct-chat-info clearfix">
                        <span class="direct-chat-name pull-left">Osahan</span>
                      </div>
                      /.direct-chat-info
                      <img alt="iamgurdeeposahan" src="http://bootsnipp.com/img/avatars/bcf1c0d13e5500875fdd5a7e8ad9752ee16e7462.jpg" class="direct-chat-img">/.direct-chat-img
                      <div class="direct-chat-text">
                        Hey bro, how’s everything going ?
                      </div>
					  <div class="direct-chat-info clearfix">
                        <span class="direct-chat-timestamp pull-right">3.36 PM</span>
                      </div>
						<div class="direct-chat-info clearfix">
						  <img alt="iamgurdeeposahan" src="http://bootsnipp.com/img/avatars/bcf1c0d13e5500875fdd5a7e8ad9752ee16e7462.jpg" class="direct-chat-img big-round">
						<span class="direct-chat-reply-name">Singh</span>
						</div>
                      /.direct-chat-text
                    </div>
                    /.direct-chat-msg
	          </div>  
			</div>
			<div class="popup-messages-footer">
			
			<input id="messageTo" title="Enter to send message" onkeyup="proxy.sendToOneMessage_keyup(event)" style="height: 30px; width: 100%" maxlength="50">
			<div class="btn-footer">
			<button class="bg_none"><i class="glyphicon glyphicon-film"></i> </button>
			<button class="bg_none"><i class="glyphicon glyphicon-camera"></i> </button>
            <button class="bg_none"><i class="glyphicon glyphicon-paperclip"></i> </button>
			<button class="bg_none pull-right"><i class="glyphicon glyphicon-thumbs-up"></i> </button>
			</div>
			</div>
			</div>
	  </div>	
	    -->

	

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
	
	var nameSessionId = new Map();

	var popups = [];
	var total_popups = 0;
	
	console.log("imgSrc: ",imgSrc)
	var jbAry = new Array();
	var jbAryy = new Array();
	
	var userAry = new Array();
	var users = new Array();
	

	var playSound = function() {
		if (audio == null) {
			audio = new Audio('content/sounds/ring.wav');
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
	
 	


 	function userLeave(chat,img) {			
	       
    	$('#messageWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +   
			'<div class="media">' +
			'<a class="pull-left" href="#">' +			
			'<img class="media-object img-circle" src="'+ img +'" style="width:30px; height: 30px;" alt="">' +
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
  	/* 	textarea.value += input + "\n"; */
    /*  webSocket.send(inputMessage.value); */
    /*  inputMessage.value = ""; */              	
} 
 	 
 	 
	 function showName(chat, img, time) {			
	       
    	 $('#messageWindow').append('<div class ="row">' +
			'<div class="col-lg-12">' +   
			'<div class="media">' +
			'<a class="pull-left" href="#">' +			
			'<img class="media-object img-circle" src="'+ img +'" style="width:30px; height: 30px;" alt="">' +
			'</a>' +
			'<div class="media-body">' +
			'<h4 class="media-heading">' +					
			'<span class="small pull-right">' +
			time +
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
    /*  textarea.value += input + "\n"; */
    /*  webSocket.send(inputMessage.value); */
    /*  inputMessage.value = ""; */              	
} 
	 function display_popups() {
			var right = 330;

			var iii = 0;
			
			for (iii; iii < total_popups; iii++) {
				if (popups[iii] != undefined) {
					var element = document.getElementById(popups[iii]);
					element.style.right = right + "px";
					right = right + 350;
					element.style.display = "block";
				}
			}

			for (var jjj = iii; jjj < popups.length; jjj++) {
				var element = document.getElementById(popups[jjj]);
				element.style.display = "none";
			}
		}
	 
	 function calculate_popups() {
			var width = window.innerWidth;
			if (width < 540) {
				total_popups = 0;
			}
			else {
				width = width - 200;
				//350 is width of a single popup box
				total_popups = parseInt(width / 350);
			}

			display_popups();
		}
	 
	 
	 window.removePopUp = function (fromToName) {
		 var element = document.getElementsByClassName(fromToName)[0];
			element.style.display = "none";
			popups.splice(popups.indexOf(fromToName),1);  
			 
		 $('.'+fromToName).removeClass('popup-box chat-popup ' +fromToName); }
 
 

	 window.popUp = function (fromName, fromImg, toName, toImg, toSessionId, fromSessionId) {
			
			
		 var data = fromName + "," + fromImg + "," + toName + "," + toImg + "," + toSessionId + "," + fromSessionId;
		 console.log("데이터", data);
		 var fromToName = fromName + toName;
		 var toFromName = toName + fromName;
		 
		 for (var iii = 0; iii < popups.length; iii++) {
				//already registered. Bring it to front.
				if (fromToName == popups[iii] || toFromName == popups[iii]) {
					/* Array.remove(popups, iii); */
					
					popups.splice(popups.indexOf(popups[iii]),1);
					
					popups.unshift(fromToName);
					popups.unshift(toFromName);
					var width = window.innerWidth;
					if (width < 540) {
						total_popups = 0;
					}
					else {
						width = width - 200;
						//350 is width of a single popup box
						total_popups = parseInt(width / 350);
					}
					
					var right = 330;

					var iii = 0;
					
					for (iii; iii < total_popups; iii++) {
						if (popups[iii] != undefined) {
							console.log("popups[iii]: ",popups[iii]);
							var element = document.getElementsByClassName(popups[iii])[0];
							console.log("element: ",element);
							/* if (element === undefined ){
								popUp(fromName, fromImg, toName, toImg, toSessionId, fromSessionId);
								return;
							} */
							element.style.right = right + "px";
							right = right + 350;
							element.style.display = "block";
						}
					}

					for (var jjj = iii; jjj < popups.length; jjj++) {
						var element = document.getElementsByClassName(popups[jjj])[0];
						element.style.display = "none";
					}
					return;
				}
			}
		 
		 //Array.Unshift() 메서드 : 배열 시작에 새 요소를 삽입
		 popups.unshift(fromToName);
		 total_popups ++;
		 popups.unshift(toFromName);
		 total_popups ++;
		 
		 console.log("popups[]: ", popups);
		 var html = '';
			/* html += '<div class="popup-box chat-popup" id="'+fromName+toName+'">'; */
			html += '<div class="popup-box chat-popup '+fromToName +" "+toFromName+'" style="display:none;">';
			html += '<div>';
			html += '<div class="popup-head">';
			html += '<div class="popup-head-left pull-left"><img src="'+toImg+'" alt="iamgurdeeposahan"><h4>'+toName+'님과의 채팅방입니다.</h4></div>';
			html += '<div class="popup-head-right pull-right">';
			html += '<div class="btn-group">';
			html += '<button class="chat-header-button" data-toggle="dropdown" type="button" aria-expanded="false">';
			html += '<i class="glyphicon glyphicon-cog"></i> </button>';
			html += '<ul role="menu" class="dropdown-menu pull-right">';
			html += '<li><a href="#">Block</a></li>';
			html += '</ul>';
			html += '</div>';
			/* html += '<a onclick="removePopUp('+"'"+fromToName+"'"+')";>';
			html += '<button data-widget="remove"  id="removeClass"  class="chat-header-button pull-right" type="button"><i class="glyphicon glyphicon-off"></i></button>';
			html += '</a>'; */
			
			html += '<button onclick="removePopUp('+"'"+fromToName+"'"+')"; data-widget="remove"  id="removeClass"  class="chat-header-button pull-right" type="button"><i class="glyphicon glyphicon-off"></i></button>';
			
			html += '</div>';
			html += '</div>';
			html += '<div style="display:none">'; 
			html += '<input class="data">';			
			html += '</input>';
			html += '</div>';
			html += '<div id="childMessageWindow" class="popup-messages">';			
			html += '</div>';
			html += '<div class="popup-messages-footer">';
			
			/* html += '<input class="messageTo" title="Enter to send message" onclick="sendToOne('+"'"+fromName+"'"+","+"'" + fromImg+"'"+"," +"'"+ toName+"'" +","+"'"+ toImg+"'"+","+"'" + toSessionId+"'"+');" onkeyup="proxy.sendToOneMessage_keyup(event)" style="height: 30px; width: 100%" maxlength="50">'; */
			html += '<input id="messageTo" title="Enter to send message"  onkeyup="proxy.sendToOneMessage_keyup(event)" style="height: 30px; width: 100%" maxlength="50">';
		 	
		 	
			/* html += '<input id="messageTo" title="Enter to send message"  style="height: 30px; width: 100%" maxlength="50">'; */
			
			html += '<div class="btn-footer">';
			html += '</form>';
			html += '<button class="bg_none"><i class="glyphicon glyphicon-film"></i> </button>';
			html += '<button class="bg_none"><i class="glyphicon glyphicon-camera"></i> </button>';
			html += '<button class="bg_none"><i class="glyphicon glyphicon-paperclip"></i> </button>';
			html += '</div>';
			html += '</div>';
			html += '</div>';
			html += '</div>';
			
			
			document.getElementsByTagName("body")[0].innerHTML = document.getElementsByTagName("body")[0].innerHTML + html;
			$('.data').val(data);
			/* document.getElementsByClassName("data").value() = data; */
			console.log("data7: ", data);
			
			
			 var width = window.innerWidth;
				if (width < 540) {
					total_popups = 0;
				}
				else {
					width = width - 200;
					//350 is width of a single popup box
					total_popups = parseInt(width / 350);
				}
				
				
				var right = 330;

				var iii = 0;
				
				for (iii; iii < total_popups; iii++) {
					if (popups[iii] != undefined) {
						console.log("popups[iii]: ",popups[iii]);
						var element = document.getElementsByClassName(popups[iii])[0];
						console.log("element: ",element);
						/* if (element === undefined ){
							popUp(fromName, fromImg, toName, toImg, toSessionId, fromSessionId);
							return;
						} */
						element.style.right = right + "px";
						right = right + 350;
						element.style.display = "block";
					}
				}

				for (var jjj = iii; jjj < popups.length; jjj++) {
					var element = document.getElementsByClassName(popups[jjj])[0];
					element.style.display = "none";
				}
				

				
		}


	 
	 window.chatBoxPopUp = function (fromName, fromImg, toName, toImg, toSessionId, fromSessionId) {
		 /* $('#qnimate').attr('id', fromName + toName); */
		 console.log("1. fromSessionId: ", fromSessionId);
		 popUp(fromName, fromImg, toName, toImg, toSessionId, fromSessionId);
		
		/* W=Number(300); 
		H=Number(540);
		 
		O="width="+W+",height="+H+"";
	    
		//부모 창에서 자식 창의 문서에 접근할 땐 window.open() 함수가 반환하는 객체를 이용 
		var winOpen = window.open("","chatBox",O, 'resizable=yes');
		 */ 
		//Window.open()으로 원도우 객체가 생성될 때 자바스크립트는 window.opener 프로퍼티에 윈도우를 연 객체(부모)를 저장한다.
		//이를 이용하면 자식 창에서 부모 창을 컨트롤하거나 서로간 데이터를 주고받는게 가능하다.
		/* 
	    // window.name = "부모창 이름"; 
	    winOpen.name = "chatRoom";
	    var frm = document.createElement("form");
	    frm.setAttribute("charset", "UTF-8");
	    frm.setAttribute("action","chatBox.jsp");
	    frm.setAttribute("target","chatBox");
	    frm.setAttribute("method","Post");
	    document.body.appendChild(frm);
	    var input_id = document.createElement("input");
	    input_id.setAttribute("type","hidden");
	    input_id.setAttribute("name", "data");
	    input_id.setAttribute("value", fromName +','+ fromImg+','+toName+','+toImg);
	    frm.appendChild(input_id);
	    frm.submit();
	    */
	    /* $('#userWindow').append(html); */
	    
	    
	   return oneToOne(fromName, fromImg, toName, toImg, toSessionId, fromSessionId) 
	 }
 
	 

	
	 function showChat(nick, img, message, time) {			
	       
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
			message +
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

	 
	 function isUser(name, img, toSessionId) {
		 
			var fromName = '<%=nickName%>';
			var fromImg = '<%=imgSrc%>';
			console.log("i: ", fromName);
			/* var i = nameSessionId.has(fromName); */
			var myId = nameSessionId.get(fromName);

			console.log("i: ", myId);
			
			if (name == '<%=nickName%>') {
				return '<img src="images/online-icon.png">&nbsp;' + name + '(You)<div class="line"></div>'
			} else {
				return '<img src="images/online-icon.png">&nbsp;<span>'
				+ name + '</span>&nbsp;<a id="addClass" onclick="javascript:chatBoxPopUp('+"'"+fromName+"'"+","+"'"+fromImg+"'"+","+ "'"+name+"'"+","+"'"+img+"'"+ ","+"'"+ toSessionId +"'"+ ","+"'"+ myId +"'"+');" title="Click to Chat"><img src="images/chat.png"></a><div class="line"></div>'
				
			}
		}
	 
	 

	 
	function userAddList(nameImg) {
			
		var array = new Array();
		var arr = new Array();
		console.log("userAddlist- nameImg: ",nameImg);
		array = nameImg.split('(&c-1./');	
		var img = array[1];
		
		arr = array[0].replace(" ","").split('$5_~');
		var toSessionId = arr[0];
		console.log("toSessionId: ",toSessionId);
		var name = arr[1];
		nameSessionId.set(name, toSessionId);
		
		
		
		
		$('#userWindow').append('<div id="'+name+'" class ="row">' +
				'<div class="col-lg-12">' +  
				'<div class="media">' +			
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" src="'+ img +'" style="width:70px; height: 70px; cursor: pointer;" onclick="imgPop('+"'"+img+"'"+')"/>' +			
				isUser(name, img, toSessionId) +			
				'</a>' +
				'<div class="media-body">' +					
				'<h3>' +
				name +
				'<span id="listenChat'+ name +'" class="small pull-right">' +
				'</span>' +
				'</h3>' +				    
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');	
		$('#userWindow').scrollTop($('#userWindow')[0].scrollHeight); 			
		}

	var clearMessage = function() {
		elements.msgContainer.innerHTML = '';
	};
	
	return {
		login: function() {
			/* elements.txtLogin.focus(); */
			/*var name = elements.txtLogin.value.trim();*/
			
			var nick = nickName;
			
			if (name == '') { return; }
			
			/*elements.txtLogin.value = '';*/
			var name = nick +'r}`3*' + imgSrc;
			
			// Initiate the socket and set up the events
			if (websocket == null) {  
		    	websocket = new WebSocket(wsUri);
		    	
		    	websocket.onopen = function() {
		    		var message = { messageType: 'LOGIN', message: name};
		    		

		            window.oneToOne = function(fromName, fromImg, toName, toImg, toSessionId, fromSessionId){
		            	
		            	
		            	
						var oneToOneMessage = { messageType: 'LOGINTOONECHAT', message: '', chatPerson : toName +'r}`3*'+ toImg,
								fromPerson : fromName + 'r}`3*'+ fromImg,
								chatPersonSession : toSessionId,
								fromPersonSession : fromSessionId};
				    				    		
				   		websocket.send(JSON.stringify(oneToOneMessage));				   		
		            }
		    		
		    		console.log(message.messageType);
		    		console.log(message.message);	
		    				    		
		    		websocket.send(JSON.stringify(message));
		    		
		    	}
			
		        
		        websocket.onmessage = function(e) {
		        	/* displayMessage(e.data); */
		        	var chat = e.data;
		        	console.log("e.fromPerson: ",e.fromPerson);
		        	console.log("chat: ",chat);
		        	if (chat.match('님이 들어왔습니다.')){
		        		console.log("chat", chat);
		        		
		        		var userAry = chat.split('님이 들어왔습니다.')
		        		console.log("userAry", userAry);
		        		var nameImg = userAry[0];
		        		console.log("nameImg", nameImg);
		        		var jbAryy = nameImg.split('r}`3*');
		        		console.log("jbAryy", jbAryy);
		        		
		        	    var name = jbAryy[0];
		        		var img = jbAryy[1]; 
		        		var userList = jbAryy[2];
		        		console.log("name2: ",name);
		        		console.log("img2: ",img);
		        		console.log("userList: ",userList);
		        		
		        		/* if(results != null) {  //여기서 주의할 부분은 널 체크가 필요하다는 것이다. results가 null인데 .length를 하면 스크립트 에러가 발생한다!
									        		
		        		} */
		        		users = userList.split(',');
		        		console.log("users: ",users);
		        		$('#userWindow').empty();
		        		for (var i = 0; i < users.length; i++) {		        			
							console.log("로긍ㅇㅇ: ", users[i]);
							userAddList(users[i].replace('[','').replace(']',''));								
						}

		        		/* userAddList(name, img);  */
		        		/* nonmemberAddChat(name, img); */
		        		var currentDate = new Date();            
			            var msg = currentDate.getHours()+"시 "
				        msg += currentDate.getMinutes()+"분 ";
				        msg += currentDate.getSeconds()+"초";
		        		playSound();

		        		showName(name+'님이 들어왔습니다.', img, msg);
		        			
		        	} else if (chat.match('님이 나갔습니다.')){
		        		var userAry = chat.split('님이 나갔습니다.')	        				        			
		        		var nameImg = userAry[0];
		        		var jbAryy = nameImg.split('r}`3*');
		        		var name = jbAryy[0];
		        		var img = jbAryy[1];
		        		nameSessionId.delete(name);


		        		$('#'+name).remove();
		        		/* $('.lastCom'+commentID).remove(); */
		        		
		        		
		        	} else if (chat.match('님이 1:1 채팅방에 입장하셨습니다.')){
		        		var userAry = chat.split('r}`3*');
		        		console.log("1:1 이미지 변경: ",userAry);
		        		var toSessionId = userAry[0];
		        		var fromName = userAry[1];
		        		var fromImg = userAry[2];
		        		var fromSessionId = userAry[3];
		        		var toName = userAry[4];
		        		var toImg = userAry[5].replace('님이 1:1 채팅방에 입장하셨습니다.','');
		        		console.log("toSessionId ", toSessionId);
		        		console.log("fromName ", fromName);
		        		console.log("fromImg ", fromImg);
		        		console.log("fromSessionId ", fromSessionId);
		        		console.log("toName ", toName);
		        		console.log("toImg ", toImg);
		        		
		        		$('#listenChat' + fromName).html('<a onclick="popUp('+"'"+fromName+"'"+","+"'"+fromImg+"'"+","+"'"+toName+"'"+","+"'"+toImg+"'"+","+"'"+ toSessionId +"'"+","+"'"+ fromSessionId +"'"+');"><img src="images/online-icon.png">&nbsp;<p>' + toName + '님에게 메시지가 도착했습니다.</p><div class="line"></a>'); 		        		
		        		
		        		
		        		function loginTochatBox(fromName, toName, img) {					        		       
		        			$('.'+toName+fromName).find('#childMessageWindow').append('<div class ="row">' +
		        				'<div class="col-lg-12">' +   
		        				'<div class="media">' +
		        				'<a class="pull-left" href="#">' +			
		        				'<img class="media-object img-circle" src="'+ img +'" style="width:30px; height: 30px;" alt="">' +
		        				'</a>' +
		        				'<div class="media-body">' +
		        				'<h4 class="media-heading">' +					
		        				'<span class="small pull-right">' +		        			
		        				'</span>' +
		        				'</h4>' +
		        				'<h4>' +
		        				'<p style="text-align: center">' +
		        				fromName + 
		        				'</p>' +
		        				'</h4>' +
		        				'</div>' +
		        				'</div>' +
		        				'</div>' +
		        				'</div>' +
		        				'<hr>'); 						                      
		        		}
		        		/* if ($('#childMessageWindow').text() != "") {			
		   			 		return;
		   		 		}  */
		        		loginTochatBox(toName  + '님에게 1:1 채팅 초대 메시지를 보냈습니다.',toName, img);  
		        		console.log("1111");
		        		
		        		
		        	} else if (chat.match("3c_A&!")) {
		        		console.log("일대일메세지: ");
		        		console.log("ㄴㄴ:",chat);
		        		var jbAry = chat.split("r}`3*");
		        		
			            console.log("일대일메세지: ", jbAry);
			            var toName = jbAry[0];
			            var fromName = jbAry[1];
			            var fromImg = jbAry[2];
			            var message = jbAry[3].replace('3c_A&!','')
			            
			            console.log("시작");
			            console.log(jbAry);
			            console.log(nick);
			            console.log(img);
			            console.log(message);
			            
			            
			            var currentDate = new Date();            
			            var msg = currentDate.getHours()+"시 "
				        msg += currentDate.getMinutes()+"분 ";
				        msg += currentDate.getSeconds()+"초";
		        		 
				        
				        
				       function messageToOne(toName, fromName, fromImg, message, msg) {			
		        		       
				    	   $('.'+toName+fromName).find('#childMessageWindow').append('<div class="row">' +
		        				'<div class="col-lg-12">' +   
		        				'<div class="media">' +			
		        				'<a class="pull-left" href="#">' +
		        				'<img class="media-object img-circle" src="'+ fromImg +'" style="width:60px; height: 60px; cursor: pointer;" onclick="imgPop('+"'"+fromImg+"'"+')"/>' +
		        				/* '<img class="media-object img-circle" style="width:80px; height: 80px;" src="'+ img +'" alt="">' + */
		        				'</a>' +
		        				'<div class="media-body">' +
		        				'<h3 style="color:black" class="media-heading">' +			
		        				fromName +			
		        				'<span style="color:black" class="small pull-right">' +
		        				msg +
		        				'</span>' +
		        				'</h3>' +
		        				'<p style="color:black">' +
		        				'<font size="4">' +
		        				message +
		        				'<font>' + 
		        				'</p>' +
		        				'</div>' +
		        				'</div>' +
		        				'</div>' +
		        				'</div>' +
		        				'<hr>');  		        	              	
		        			}  		
			            	messageToOne(toName, fromName, fromImg, message, msg);
			            	
		        			console.log("일대일실행");
		        			
		        	} else {
			            var jbAry = chat.split('r}`3*');
			            console.log("jbAry", jbAry);
			            var nick = jbAry[0];
			            var img = jbAry[1];
			            var Message = jbAry[2];
			            var time = jbAry[3];
			            console.log(nick);
			            console.log(chat);
			            
			            var currentDate = new Date();            
			            var msg = currentDate.getHours()+"시 "
				        msg += currentDate.getMinutes()+"분 ";
				        msg += currentDate.getSeconds()+"초";
				        
				        
			            showChat(nick, img, Message, msg);
			   
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
				
				
				<%-- if (imgSrc == "http://localhost:8000/localMovie/images/character1.jpg") {
				  sendImg = "r}`3*http://localhost:8000/localMovie/images/character1.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/character2.jpg") {
			    	sendImg= "r}`3*http://localhost:8000/localMovie/images/character2.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/character3.jpg") {
			    	sendImg = "r}`3*http://localhost:8000/localMovie/images/character3.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/character4.jpg") {
			    	sendImg = "r}`3*http://localhost:8000/localMovie/images/character4.jpg";
			    } else {
			    	sendImg = 'r}`3*<%=userDAO.getProfile(userID)%>';
			    }  --%>
			    		   
			    var input = $('#inputMessage').val(); 
				
				
				if (input == '') { return; }
				
				/* elements.inputMessage.value = ''; */
				
				var message = { messageType: 'MESSAGE', message: input };
		
				
				// Send a message through the web-socket
				websocket.send(JSON.stringify(message));
				inputMessage.value = "";
			}
		},
		
		sendToOneMessage: function(e) {
			/* elements.txtMsg.focus(); */
			
			if (websocket != null && websocket.readyState == 1) {
				
				
				<%-- if (imgSrc == "http://localhost:8000/localMovie/images/character1.jpg") {
				  sendImg = "r}`3*http://localhost:8000/localMovie/images/character1.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/character2.jpg") {
			    	sendImg= "r}`3*http://localhost:8000/localMovie/images/character2.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/character3.jpg") {
			    	sendImg = "r}`3*http://localhost:8000/localMovie/images/character3.jpg";
			    } else if (imgSrc == "http://localhost:8000/localMovie/images/character4.jpg") {
			    	sendImg = "r}`3*http://localhost:8000/localMovie/images/character4.jpg";
			    } else {
			    	sendImg = 'r}`3*<%=userDAO.getProfile(userID)%>';
			    }  --%>
			    		   
			    
				var jbAry = new Array();
				
				var data = $('.data').val();
				console.log("data7: ", data);
							    
			    var fromName = data.split(',')[0];
			    var fromImg = data.split(',')[1];
			    var toName = data.split(',')[2];
			    var toImg = data.split(',')[3];
			    var toSessionId = data.split(',')[4];
			    var fromSessionId = data.split(',')[5];
			    console.log("1",fromName);
			    console.log("1",fromImg);
			    console.log("1",toName);
			    console.log("1",toSessionId);
			    console.log("1",fromSessionId);
			    
			    
			    
				if ($('.'+toName+fromName).find('#messageTo').val() == '') { return; }
				/* var input = $('#messageTo').val().split('자르기')[1] + '3c_A&!'; */
				var input = $('.'+toName+fromName).find('#messageTo').val() + '3c_A&!';  				
			    console.log('인풋:',input);
			    console.log("data: ", data)
				
				/* elements.inputMessage.value = ''; */
				
				var oneToOneMessage = { messageType: 'MESSAGETOONE', message: input,
										chatPerson : toName + toImg,
										fromPerson : fromName + 'r}`3*'+ fromImg,
										chatPersonSession : toSessionId,
										fromPersonSession : fromSessionId};
		
				
				// Send a message through the web-socket
				/* websocket.send(JSON.stringify(oneToOneMessage)); */
				/* messageTo.value = ""; */
				
	            websocket.send(JSON.stringify(oneToOneMessage));
	            
	            $('.'+toName+fromName).find('#messageTo').val("");
				}	
			},
		
		/* kecode 13은 enter를 의미 */
		login_keyup: function(e) { if (e.keyCode == 13) { this.login(); } },
		sendMessage_keyup: function(e) { if (e.keyCode == 13) { this.sendMessage(); } },
		sendToOneMessage_keyup: function(e) { if (e.keyCode == 13) { console.log("sendToOneMessage_keyup"); this.sendToOneMessage(e); } },
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
	/* getInfiniteChat();   */
		
		  console.log("레디 밖");
		$(document).ready(function() {
			
			console.log("로그 2");
				  
				            
				  
		 
			$('#userWindow').scroll(function() {									
				
				var scrollSize = $(window).scrollTop() + $(window).height();
				var documentSize = $(document).height();
					if (scrollSize >= documentSize - 5) {
					
						console.log('bottom');
					}   
				
				});
			
		})
			
	</script>
	
	
	
</body>

</html>