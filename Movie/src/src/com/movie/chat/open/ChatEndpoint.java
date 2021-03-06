package com.movie.chat.open;

import java.io.IOException;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Logger;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.CloseReason;
import javax.websocket.EncodeException;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.movie.chat.member.ChatDAO;
import com.movie.chat.open.userList.UserListDAO;


// 브라우저가 Websocket을 통해 서버와 통신하려면 "@ServerEndpoint"로 주석 처리 된 클래스를 만들어야합니다.
@ServerEndpoint(value = "/chat")
public class ChatEndpoint {
	private Logger log = Logger.getLogger(ChatEndpoint.class.getSimpleName());
	private MainRoom mainRoom = MainRoom.getRoom();
	private static final Set<MainRoom> connections = new CopyOnWriteArraySet<MainRoom>();
	private Session session;
	UserListDAO userListDAO = new UserListDAO();
	ArrayList<String> userList = new ArrayList<String>();
	ArrayList<String> userNames = new ArrayList<String>();
	static List<String> dataList;
	
	@OnOpen
	public void onOpen(final Session session, EndpointConfig config){
	}
		
	@OnMessage
	public void onMessage(final Session session, final String messageJson) throws EncodeException, IOException {
		
		ObjectMapper mapper = new ObjectMapper();
		ChatMessage chatMessage = null;
		

		try {
			chatMessage = mapper.readValue(messageJson, ChatMessage.class);
		} catch (IOException e) {
			String message = "Badly formatted message";
			try {
				session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, message));
			} catch (IOException ex) { log.severe(ex.getMessage()); }
		};
		
		Map<String, Object> properties = session.getUserProperties();
		if (chatMessage.getMessageType().equals(MessageType.LOGIN)) {
			String name = chatMessage.getMessage();
			System.out.println(name);
			properties.put("name", URLDecoder.decode(name, "UTF-8"));
			
			
			int number = name.indexOf("r}`3*");
			String names = name.substring(0, number);
			
			/*if (!userNames.isEmpty() && isExistsName(names)) {
				String sessionId = session.getId();
				System.out.println("중복됨 " + names);
				mainRoom.leaveUser(sessionId,"1wnd:qh.r");
			}*/
			
			
			UserListDAO userListDAO = new UserListDAO();
			
			userListDAO.write(names);
			mainRoom.join(session);
			
			this.session = session;
			connections.add(mainRoom);
						
			mainRoom.sendMessage(URLDecoder.decode(name, "UTF-8") + sendUserList() + "님이 들어왔습니다.");
		
		} else if (chatMessage.getMessageType() == MessageType.MESSAGE) {
			
			String name = (String) properties.get("name");
			mainRoom.sendMessage(URLDecoder.decode(name, "UTF-8") + "r}`3*" + chatMessage.getMessage());
					
		} else if (chatMessage.getMessageType() == MessageType.LOGINTOONECHAT) {
						
			System.out.println("1대1");
			String strMsg = chatMessage.getMessage();
			String strFrom = chatMessage.getFromPerson();
			String strTo = chatMessage.getChatPerson();
			String strToSession = chatMessage.getChatPersonSession();
			
			loginToOneChat(strToSession, strTo, strFrom, strMsg);				
			
		} else if (chatMessage.getMessageType() == MessageType.MESSAGETOONE) {
			
			
			System.out.println("1대1");
			String strMsg = chatMessage.getMessage();
			String strFrom = chatMessage.getFromPerson();
			String strTo = chatMessage.getChatPerson();
			String strToSession = chatMessage.getChatPersonSession();
			String strFromSession = chatMessage.getFromPersonSession();
			System.out.println("strFromSession: "+strFromSession);
		
			sendToOne(strToSession, strTo, strFrom, strMsg, strFromSession);				
			
		}
	} 
	
		

		public String sendUserList() {
			
			for (Session ses : mainRoom.getUserList()) {
				
				int i = 0;
				userList.add(i, ses.getId() + "$5_~" + ses.getUserProperties().get("name").toString().replace("r}`3*", "(&c-1./") );
				userNames.add(i, ses.getUserProperties().get("name").toString().split("r}`3*")[0]);
				i++;
					
				
				HashSet<String> distinctData = new HashSet<String>(userList);
			    dataList = new ArrayList<String>(distinctData);
			    System.out.println("dataList: " + userList);
			
			}
			 return "r}`3*" + dataList;
		 }
		
	
		

		
		public void sendToOne(String strCurSessionId, String strTo, String strFrom, String strMessage, String strFromSession){
			
			String fromName = (String) session.getUserProperties().get("name");
			String[] toName = strTo.split("http://");
			System.out.println("toName: " + toName);
			System.out.println("toName2: " + toName[0].toString());
			String strMsg = toName[0].toString() + "r}`3*" + strFrom + "r}`3*" + strMessage;
			
			mainRoom.sendMessageToOne(strMsg, strCurSessionId, fromName, strFromSession);
		}
		
	
		

		public void loginToOneChat(String strCurSessionId, String strTo, String strFrom, String strMessage){	
			String fromName = (String) session.getUserProperties().get("name");
			System.out.println("fromName: "+fromName);
			
			String fromSessionId = "";
			for (Session session : MainRoom.sessions) {
				if (session.isOpen()) {
					if ( session.getUserProperties().get("name").equals(fromName)) {
						fromSessionId = session.getId(); 
					}
				}
			}
			System.out.println("세션아이디: "+fromSessionId);
			String strMsg = strCurSessionId + "r}`3*" + strTo + "r}`3*" +fromSessionId+ "r}`3*" +strFrom + "님이 1:1 채팅방에 입장하셨습니다."; 
			System.out.println("strFrom: "+ strFrom);
			mainRoom.loginToOne(strMsg, strCurSessionId, fromName);
		}
	
		
			
		@OnClose
		public void onClose(Session session, CloseReason reason) {	
			String name= (String) session.getUserProperties().get("name");
			int number = name.indexOf("r}`3*");
			String names = name.substring(0, number);
			try {
			userListDAO.deleteUser(URLDecoder.decode(names,"UTF-8"));
			} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
				e.printStackTrace();
			}
			mainRoom.leave(session);
			mainRoom.sendMessage((String) session.getUserProperties().get("name") + "님이 나갔습니다.");
		}
/*
			@OnError
			public void onError(Session session, Throwable ex) { log.info("Error: " + ex.getMessage()); }*/
		}
			
	

