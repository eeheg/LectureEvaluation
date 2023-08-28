package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

    public static Connection getConnection() {
        try {
            String dbURL = "jdbc:mysql://54.180.8.7:3306/lectureevaluation";
            String dbID = "admin";
            String dbPassword = "admin";
//            String dbURL = "jdbc:mysql://localhost:3306/LectureEvaluation";
//            String dbID = "root";
//            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
