package com.movie.chat.open;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.websocket.EncodeException;

import javax.websocket.Session;

public class MainRoom {
	private static MainRoom instance = null;
	static List<Session> sessions = new ArrayList<Session>();
	
	
	public synchronized void join(Session session) { sessions.add(session); }
	public synchronized void leave(Session session) { sessions.remove(session); }
	
	public synchronized void sendMessage(String message) {
		for (Session session: sessions) {
			if (session.isOpen()) {
				try { session.getBasicRemote().sendText(message); }
				catch (IOException e) { e.printStackTrace(); }
			}
		}
		
	}

	
	public synchronized void sendMessageToOne(String message, String strToSessionId, String fromName, String strFromSession) {
		for (Session session : sessions) {
			if (session.isOpen()) {
				try {
					if (session.getId().equals(strToSessionId) || session.getUserProperties().get("name").equals(fromName) || session.getId().equals(strFromSession) ) {
						session.getBasicRemote().sendText(message);
					}					
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	
	/*public synchronized void sendMessageToOne(String message, String toUser, String fromName) {
		for (Session session : sessions) {
			if (session.isOpen()) {
				try {
					if (session.getUserProperties().get("name").equals(toUser) || session.getUserProperties().get("name").equals(fromName)) {
						session.getBasicRemote().sendText(message);
					}					
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}*/
	
	
	
	public synchronized void loginToOne(String message, String strToSessionId, String fromName) {
		for (Session session : sessions) {
			if (session.isOpen()) {
				try {
					if (session.getId().equals(strToSessionId)) {
						session.getBasicRemote().sendText(message);
					}
					/*if (session.getUserProperties().get("name").equals(fromName)) {
						session.getBasicRemote().sendText(message);
					}*/
					
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	

	public synchronized List<Session> getUserList() {
		return sessions;
	}
	
	public synchronized static MainRoom getRoom() {
		if (instance == null) { instance = new MainRoom(); }
		return instance;
	}
}
