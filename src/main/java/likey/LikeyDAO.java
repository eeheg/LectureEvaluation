package likey;

import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LikeyDAO {
    public int like(String userID, String evaluationID, String userIP) {
        String SQL = "INSERT INTO LIKEY VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            pstmt.setString(2, evaluationID);
            pstmt.setString(3, userIP);
            return pstmt.executeUpdate();  //executeUpdate : 실제로 영향을 받은 데이터의 개수 반환 => 성공한다면 1 반환됨
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
            try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
            try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
        }
        return -1;  // 추천 중복 오류
    }
}
