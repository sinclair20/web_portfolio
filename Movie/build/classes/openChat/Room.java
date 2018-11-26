package openChat;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.websocket.Session;

// Room.java"는 모든 활성 웹 소켓 연결에 대한 메시지 브로드 캐스팅을 처리하는 대화방을 구현합니다.
public class Room {
	private static Room instance = null;
	private List<Session> sessions = new ArrayList<Session>();

	public synchronized void join(Session session) { sessions.add(session); }
	public synchronized void leave(Session session) { sessions.remove(session); }
	public synchronized void sendMessage(String name, String message) {
		for (Session session: sessions) {
			if (session.isOpen()) {
				try { session.getBasicRemote().sendText(name, message); }
				catch (IOException e) { e.printStackTrace(); }
			}
		}
	}

	public synchronized static Room getRoom() {
		if (instance == null) { instance = new Room(); }
		return instance;
	}
}
