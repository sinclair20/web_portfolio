<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Random"%>
<%@ page import="java.net.URLDecoder" %>
<!-- http://choiyb2.tistory.com/81 -->
<%@ page import="com.movie.user.UserDAO" %>
<% request.setCharacterEncoding("UTF-8");%>

<!DOCTYPE html>
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<link rel="stylesheet" href="./css/bootstrap.css">
	<link rel="stylesheet" href="./css/custom.css">
	
    <title>Testing websockets</title>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</head>
<body>
   <%   
      request.setCharacterEncoding("UTF-8");
   	  response.setContentType("text/html; charset=UTF-8");
      String nickName = request.getParameter("nickName");
	  String nonmember = null;
	  System.out.println(nickName);
      //String userID = (String) session.getAttribute("userID");    // 세션에 userName이라는 data가 있는 경우? 로그온되어있는 상태
      /* session.setAttribute("userID", userID); */	
   	  /* String userID = (String) request.getParameter("userID"); */
	  
      String userID = (String) session.getAttribute("userID");
      String Profile = new UserDAO().getProfile(userID);
      
      if (userID == null) {   // userName이라는 data가 없는 경우, 로그온되어있지 않은 상태. 비회원 처리
         Random random = new Random();
         String nonProfile = new UserDAO().getProfile(userID);
         nonmember = nickName;   // ex:) 비회원21334 등의 형태로 임시 name이 부여된다.
      }
      
      System.out.println("nonmember:"+nonmember);
      System.out.println("userID:"+userID);
      System.out.println("----------");
      /* 확인 결과 세션 값 가져 오는건 정상적으로 가져옴  */
    %>
    <fieldset>

        <!-- <textarea id="messageWindow" rows="10" cols="50" readonly="true"></textarea> -->
        <!-- <div id="messageWindow" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height:600px;">
        </div> -->
        
    <div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id="messageWindow" class="portlet-body chat-widget" style="overflow-y: auto; width: 600px; height:600px;">
						<!-- <textarea id="messageWindow" style="overflow-y: auto; width: 600px; height:600px;">
						</textarea>		 -->			
						</div>
						<div class="portlet-footer">
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<input style="height: 80px;" id="inputMessage" class="form-control" placeholder="메시지를 입력하세요." maxlength="100"></input>
								</div>	
								<div class="form-group col-xs-2"> 
									<button type="button" id="sendButton" class="btn btn-default pull-right" onclick="send();">전송</button>
									<div class="clearfix"></div>
								</div>							
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
    <br/>
        <!-- <input id="inputMessage" type="text"/>
        <input type="submit" id="send" value="send" onclick="send()"/> 
         -->
    </fieldset>
    
    <script type="text/javascript">
    
    
    function onOpen(event) {
    	messageWindow.value += "연결 성공\n";
    }
    
    var messageWindow = document.getElementById('messageWindow');
    var webSocket = new WebSocket('ws://localhost:8080/Movie/broadcasting');
    var inputMessage = document.getElementById('inputMessage');
    var Profile = '<%=Profile%>';
    var userID = <%=userID%>;
    <%-- var userID = encodeURIComponent(<%= userID %>); --%>
    var nonmember = '<%=nonmember%>';
   
    <%-- var nonmember = encodeURIComponent('<%=nonmember%>'); --%>
    console.log(nonmember);
    console.log(userID);
        
    <%-- var userName = encodeURIComponent('<%=userName%>'); --%>
       
    webSocket.onerror = function(event) {
      onError(event)
    };
    
    webSocket.onopen = function(event) {
      onOpen(event)
    };
    
    webSocket.onmessage = function(event) {
      onMessage(event)
    };
    
    
    /* 
    function onMessage(event) {
    	messageWindow.value += "상대 : " + event.data + "\n";
    } 
    */
 	 
  <%--  function onMessage(event) {
    	
  		var input = event.data    	
    	if (userID == null){            
    		var ID = String(nonmember);
    	
    	 $('#messageWindow').append('<div class ="row">' +
				'<div class="col-lg-12">' +   
				'<div class="media">' +			
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%= Profile %>" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				비회원 +
				'<span class="small pull-right">' +
				'</span>' +
				'</h4>' +
				'<p>' +
				a + 
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>'); 
				
				print(Profile, ID, input);
		} else {
			var ID = String(userID); 
    		$('#messageWindow').append('<div class ="row">' +
    				'<div class="col-lg-12">' +   
    				'<div class="media">' +			
    				'<a class="pull-left" href="#">' +
    				'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%= Profile %>" alt="">' +
    				'</a>' +
    				'<div class="media-body">' +
    				'<h4 class="media-heading">' +
    				'<%=userID%>' +
    				'<span class="small pull-right">' +
    				'</span>' +
    				'</h4>' +
    				'<p>' +
    				a + 
    				'</p>' +
    				'</div>' +
    				'</div>' +
    				'</div>' +
    				'</div>' +
    				'<hr>');
    			print(Profile, ID, input);
    	}
    } --%>
    
    

    
    function onError(event) {
      alert(event.data);
    }
    
<%--    
	 function send() {
    	var input = $('#inputMessage').val();
    	var fromProfile = '<%= fromProfile %>';
        input = String(input);
        if(input != ""){   // input에 값이 있다면(메세지가 비어있지 않다면)
           input = '<%=userID%>' + ' : ' + input
           input = encodeURIComponent('<%=userName%>' + ' : ' + input);// 메세지의 앞 쪽에 userName을 붙여 URI 인코딩하여 전송한다.
           $("#messageWindow").scrollTop($("#messageWindow")[0].scrollHeight);
        }
       	textarea.value += input + "\n";
        webSocket.send(input.value);
        inputMessage.value = "";    	
    }
 --%>

 	
 	
 
 
 	function send() {
  			
    	var input = $('#inputMessage').val();
    	
        
		var non = nonmember;
		console.log(non);
        if (userID== null) {
        	var ID = non;
        	console.log(ID);            
        		<%-- $('#messageWindow').append('<div class ="row">' +
				'<div class="col-lg-12">' +   
				'<div class="media">' +			
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%= Profile %>" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				'<%=nonmember%>' +
				'<span class="small pull-right">' +
				'</span>' +
				'</h4>' +
				'<p>' +
				input + 
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>'); --%>
				print(Profile, ID, input);
        } else {
        	var ID = userID;	
        		<%-- $('#messageWindow').append('<div class ="row">' +
				'<div class="col-lg-12">' +   
				'<div class="media">' +			
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%= Profile %>" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				'<%=userID%>' +
				'<span class="small pull-right">' +
				'</span>' +
				'</h4>' +
				'<p>' +
				input + 
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>'); --%>	
				print(Profile, ID ,input);						        
        }
        $('#messageWindow').scrollTop($('#messageWindow')[0].scrollHeight);   		
      /*  	textarea.value += input + "\n"; */
        webSocket.send(inputMessage.value);
        inputMessage.value = "";   
        console.log(ID);        	
    } 

 	/* 
    function onMessage(event) {
    	messageWindow.value += "상대 : " + event.data + "\n";
    } 
    */
    
    /* function onMessage(event) {
    	/* messageWindow.value += "상대 : " + event.data + "\n";
    	var input = event.data;
    	print(Profile, ID, input);
    } */ 
    
	 
    function onMessage(event) {
 	    	
 	  		var input = event.data; 
 	  		if (userID == null) {
 	  			var ID = nonmember;
 	  			print(Profile, ID, input);
 	  		} else {
 	  			var ID = userID;
 	  			print(Profile, ID, input);
 	  		} 
}	
 	  		<%-- $('#messageWindow').append('<div class ="row">' +
 					'<div class="col-lg-12">' +   
 					'<div class="media">' +			
 					'<a class="pull-left" href="#">' +
 					'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%= Profile %>" alt="">' +
 					'</a>' +
 					'<div class="media-body">' +
 					'<h4 class="media-heading">' +
 					'<%=userID%>' +
 					'<span class="small pull-right">' +
 					'</span>' +
 					'</h4>' +
 					'<p>' +
 					input + 
 					'</p>' +
 					'</div>' +
 					'</div>' +
 					'</div>' +
 					'</div>' +
 					'<hr>'); --%>
 
 	
 	
  	function print(Profile, ID, input) {

 		$('#messageWindow').append('<div class ="row">' +
				'<div class="col-lg-12">' +   
				'<div class="media">' +			
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width:30px; height: 30px;" src ="<%= Profile %>"alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				ID +
				'<span class="small pull-right">' +
				'</span>' +
				'</h4>' +
				'<p>' +
				input + 
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');
    	}
  	
  	
 	<%-- } else {
 		$('#messageWindow').append('<div class ="row">' +
				'<div class="col-lg-12">' +   
				'<div class="media">' +			
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width:30px; height: 30px;" src="<%= Profile %>" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				ID +
				'<span class="small pull-right">' +
				'</span>' +
				'</h4>' +
				'<p>' +
				input + 
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');
 		} --%>
    
 	    console.log(nonmember);   
    window.onload = function() {   // 실제 채팅과 마찬가지로, Enter 키가 눌렸을 때도  전송 버튼이 눌린 것처럼 처리.
        document.getElementById('inputMessage').onkeypress = function searchKeyPress(event) {
            if (event.keyCode == 13) {   // enter 키의 keyCode는 13
                document.getElementById('sendButton').click();   // sendbutton이 click되었다는 이벤트 발생
                
            }
        };        
        document.getElementById('sendButton').onclick = doSomething;
    }
    

  </script>
</body>
<!--
클라이언트측 HTML 및 자바스크립트 소스이다
var webSocket = new WebSocket('ws://localhost:8080/WebSocketEx/broadcasting') 부분은
웹서버가 로컬에 있으며 포트는 8080번을 사용하고 이클립스 기준으로 프로젝트 이름이 WebSocketEX이고
서버에서 웹 소켓 자바 소스의 @ServerEndpoint 어노테이션이 broadcasting을 호출하는 것이다
-->

</html>