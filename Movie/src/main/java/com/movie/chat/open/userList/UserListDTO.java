package com.movie.chat.open.userList;

import java.util.ArrayList;


public class UserListDTO {
	private String userName;
	private String userProfile;
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getUserProfile() {
		return userProfile;
	}
	public void setUserProfile(String userProfile) {
		this.userProfile = userProfile;
	}
	
	@Override
	public String toString() {
	  return userName;
	}

}
