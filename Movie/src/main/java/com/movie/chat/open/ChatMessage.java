package com.movie.chat.open;

import java.util.ArrayList;

import javax.json.JsonValue;

//������ ��ȭ���� ��� �޽����� �����մϴ�. �װ��� "ChatMessage.java"���Ͽ� ���� �� �޽��� ������ �޽��� ���븸�� ������ �ֽ��ϴ�.

public class ChatMessage {
	private MessageType messageType;
	private String message;
	

	public void setMessageType(MessageType v) { this.messageType = v; }
	public MessageType getMessageType() { return this.messageType; }
	public void setMessage(String v) { this.message = v; }
	public String getMessage() { return this.message; }

	
}
