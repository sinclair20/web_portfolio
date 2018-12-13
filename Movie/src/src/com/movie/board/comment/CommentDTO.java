package com.movie.board.comment;

public class CommentDTO {
	
	private int boardID;
	private int commentID;
	private String commentContent;
	private String commentWriter;
	private String commentDate;
	private String userID;
	private String commentPassword;
	
	
	
	
	public String getCommentPassword() {
		return commentPassword;
	}
	public void setCommentPassword(String commentPassword) {
		this.commentPassword = commentPassword;
	}
	public int getCommentID() {
		return commentID;
	}
	public void setCommentID(int commentID) {
		this.commentID = commentID;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getCommentWriter() {
		return commentWriter;
	}
	public void setCommentWriter(String commentWriter) {
		this.commentWriter = commentWriter;
	}
	public String getCommentDate() {
		return commentDate;
	}
	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
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

	
}
