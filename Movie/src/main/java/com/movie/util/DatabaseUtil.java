package com.movie.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	public static Connection getConnection() {
		try {
			/*String dbURL = "jdbc:mysql://localhost:3306/Movie?useTimezone=true&serverTimezone=UTC";*/
			String dbURL = "jdbc:mysql://mydatabase.cf41ikdvjruh.ap-northeast-2.rds.amazonaws.com:3306/movie?useTimezone=true&serverTimezone=UTC";			
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

 