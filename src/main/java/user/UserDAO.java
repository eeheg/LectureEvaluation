package user;

import util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    //ID, Password를 받아서 로그인 시도
        public int login (String userID, String userPassword) {
            String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DatabaseUtil.getConnection();
                pstmt = conn.prepareStatement(SQL);
                pstmt.setString(1, userID);
                rs = pstmt.executeQuery();  //executeQuery : 데이터를 조회하고 ResultSet으로 결과 확인

                //사용자가 입력한 ID에 해당하는 PW(DB)가 사용자가 입력한 PW(input)와 같은지를 비교
                if (rs.next()) {
                    if(rs.getString(1).equals(userPassword)) {
                        return 1;  //로그인 성공
                    }
                    else {
                        return 0;  //비밀번호 틀림
                    }
                }
                return -1;  //아이디 없음
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
                try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
                try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
            }
            return -2;  // 데이터베이스 오류
        }

    //사용자의 정보를 입력받아서 회원가입을 수행
    public int join (UserDTO user) {
        String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, false)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, user.getUserID());
            pstmt.setString(2, user.getUserPassword());
            pstmt.setString(3, user.getUserEmail());
            pstmt.setString(4, user.getUserEmailHash());
            return pstmt.executeUpdate();  //executeUpdate : 실제로 영향을 받은 데이터의 개수 반환 => 성공한다면 1 반환됨
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
            try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
            try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
        }
        return -1;  // 회원가입 실패
    }

    // 사용자의 ID 값을 받아서 userEmail을 반환
    public String getUserEmail(String userID) {
        String SQL = "SELECT userEmail FROM USER WHERE userID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
            try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
            try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
        }
        return null;  // 데이터베이스 오류
    }

    //사용자가 현재 Email 인증이 되었는지 확인
    public boolean getUserEmailChecked (String userID) {
        String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getBoolean(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
            try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
            try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
        }
        return false;  // 데이터베이스 오류
    }

    //특정한 사용자의 Email 인증을 수행
    public boolean setUserEmailChecked (String userID) {
        String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            pstmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
            try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
            try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
        }
        return false;  // 데이터베이스 오류
    }
}

