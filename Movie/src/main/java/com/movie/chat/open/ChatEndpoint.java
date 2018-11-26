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
import java.util.logging.Logger;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
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
import com.movie.chat.open.userList.UserListDAO;
import com.movie.util.UserList;

// 브라우저가 Websocket을 통해 서버와 통신하려면 "@ServerEndpoint"로 주석 처리 된 클래스를 만들어야합니다.
@ServerEndpoint(value = "/chat")

public class ChatEndpoint {
	private Logger log = Logger.getLogger(ChatEndpoint.class.getSimpleName());
	private Room room = Room.getRoom();
	
	UserListDAO userListDAO = new UserListDAO();
	
	@OnOpen
	public void onOpen(final Session session, EndpointConfig config){
	}
	
	@OnMessage
	public void onMessage(final Session session, final String messageJson) throws UnsupportedEncodingException, EncodeException {
		ObjectMapper mapper = new ObjectMapper();
		ChatMessage chatMessage = null;
		List<String> userList = new ArrayList<String>();
		
		
		try {
			chatMessage = mapper.readValue(messageJson, ChatMessage.class);
		} catch (IOException e) {
			String message = "Badly formatted message";
			try {
				session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, message));
			} catch (IOException ex) { log.severe(ex.getMessage()); }
		};

		Map<String, Object> properties = session.getUserProperties();
		if (chatMessage.getMessageType() == MessageType.LOGIN) {
			String name = chatMessage.getMessage();
			properties.put("name", URLDecoder.decode(name, "UTF-8"));
			String userName = chatMessage.getMessage();
			properties.put("userName", URLDecoder.decode(name, "UTF-8"));
			System.out.println(name);
						
			userListDAO.write(URLDecoder.decode(userName,"UTF-8"));
			room.join(session);
			room.sendMessage(URLDecoder.decode(name, "UTF-8") + "님이 들어왔습니다.");
		
		} else if (chatMessage.getMessageType() == MessageType.USER) {
			String name = (String) properties.get("name");			

		} else {
			String name = (String) properties.get("name");			
			room.sendMessage(URLDecoder.decode(name, "UTF-8") + "r}`3*" + chatMessage.getMessage());
		}
			
	}
		
	@OnClose
	public void onClose(Session session, CloseReason reason) {	
		String userName= (String)session.getUserProperties().get("name");
		try {
			userListDAO.deleteUser(URLDecoder.decode(userName,"UTF-8"));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		room.leave(session);
		room.sendMessage((String)session.getUserProperties().get("name") + "님이 나갔습니다.");
	}

	@OnError
	public void onError(Session session, Throwable ex) { log.info("Error: " + ex.getMessage()); }
}
