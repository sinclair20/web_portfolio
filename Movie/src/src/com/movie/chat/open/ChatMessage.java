package com.movie.chat.open;

import java.util.ArrayList;

import javax.json.JsonValue;

//간단한 대화방의 경우 메시지도 간단합니다. 그것은 "ChatMessage.java"파일에 구현 된 메시지 유형과 메시지 내용만을 가지고 있습니다.

public class ChatMessage {
	private MessageType messageType;
	private String message;
	private String chatPerson = "";
	private String fromPerson = "";
	private String chatPersonSession = "";
	private String fromPersonSession = "";
	

	public void setMessageType(MessageType v) { this.messageType = v; }
	public MessageType getMessageType() { return this.messageType; }
	public void setMessage(String v) { this.message = v; }
	public String getMessage() { return this.message; }
	
	public String getChatPerson() {
		return chatPerson;
	}

	public void setChatPerson(String chatPerson) {
		this.chatPerson = chatPerson;
	}

	public String getFromPerson() {
		return fromPerson;
	}

	public void setFromPerson(String fromPerson) {
		this.fromPerson = fromPerson;
	}

	public String getChatPersonSession() {
		return chatPersonSession;
	}

	public void setChatPersonSession(String chatPersonSession) {
		this.chatPersonSession = chatPersonSession;
	}
	
	public String getFromPersonSession() {
		return fromPersonSession;
	}
	public void setFromPersonSession(String fromPersonSession) {
		this.fromPersonSession = fromPersonSession;
	}
	
	
}
