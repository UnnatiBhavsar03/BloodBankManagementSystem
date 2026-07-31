package net.javaguide.login.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    public static String getDbUrl() {
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = System.getProperty("db.url");
        }
        if (url == null || url.trim().isEmpty()) {
            url = "jdbc:mysql://localhost:3306/BloodBank";
        }
        return url;
    }

    public static String getDbUser() {
        String user = System.getenv("DB_USER");
        if (user == null || user.trim().isEmpty()) {
            user = System.getProperty("db.user");
        }
        if (user == null || user.trim().isEmpty()) {
            user = "root";
        }
        return user;
    }

    public static String getDbPassword() {
        String password = System.getenv("DB_PASSWORD");
        if (password == null || password.trim().isEmpty()) {
            password = System.getProperty("db.password");
        }
        if (password == null || password.isEmpty()) {
            throw new IllegalStateException("Database password not configured! Please set the 'DB_PASSWORD' environment variable or 'db.password' system property.");
        }
        return password;
    }

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            Class.forName("com.mysql.jdbc.Driver");
        }
        return DriverManager.getConnection(getDbUrl(), getDbUser(), getDbPassword());
    }
}
