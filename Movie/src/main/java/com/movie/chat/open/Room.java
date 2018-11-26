package com.movie.chat.open;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.websocket.EncodeException;

import javax.websocket.Session;

public class Room {
	private static Room instance = null;
	private List<Session> sessions = new ArrayList<Session>();
	
	
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
	public synchronized void sendUserList(List<String> userList) {
		for (Session session: sessions) {	
			 try {
				try {
					session.getBasicRemote().sendObject(userList);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} catch (EncodeException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	
	public synchronized static Room getRoom() {
		if (instance == null) { instance = new Room(); }
		return instance;
	}
}
