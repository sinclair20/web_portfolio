package com.movie.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	public static Connection getConnection() {
		try {
			/*String dbURL = "jdbc:mysql://localhost:3306/Movie?useTimezone=true&serverTimezone=UTC";*/
			String dbURL = "jdbc:mysql://54.180.114.30:3306/Movie?useTimezone=true&serverTimezone=UTC";
			String dbID = "sinclair";
			String dbPassword = "842693aa!!";
			Class.forName("com.mysql.cj.jdbc.Driver");
			return DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}

 