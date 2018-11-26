package likey;

public class LikeyDTO {
	
	String userID;
	int boardID;
	String userIP;
	
	
	public LikeyDTO(String userID, int boardID, String userIP) {
		super();
		this.userID = userID;
		this.boardID = boardID;
		this.userIP = userIP;
	}
	
	public LikeyDTO () {
		
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public int getBoardID() {
		return boardID;
	}

	public void setBoardID(int boardID) {
		this.boardID = boardID;
	}

	public String getUserIP() {
		return userIP;
	}

	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}

	
	
	
	
	
}
