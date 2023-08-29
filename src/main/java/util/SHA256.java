package util;

import java.security.MessageDigest;

/*
기존에 존재하던 이메일값에 해시값을 적용하고,
사용자가 인증코드로 링크를 타고 들어가 인증할 때
대표적으로 사용하는 것이 SHA256
 */
public class SHA256 {

    //input(Email)을 넣었을 때 해시값을 반환하는 메소드
    public static String getSHA256 (String input) {
        StringBuffer result = new StringBuffer();
        try {
            //사용자가 입력한 값에 SHA-256 알고리즘을 적용
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            //salt: 단순한 SHA-256은 해킹의 위험이 있으므로 salt 값을 적용한다. (digest를 reset, update 하여 salt 값 적용)
            byte[] salt = "Hello! this is Salt.".getBytes();
            digest.reset();
            digest.update(salt);
            //배열변수를 만들어 UTF-8로 해시를 적용한 값을 char변수에 담아준 후 문자형으로 변환
            byte[] chars = digest.digest(input.getBytes("UTF-8"));
            for(int i = 0; i < chars.length; i++) {
                String hex = Integer.toHexString(0xff & chars[i]); //hex값(0xff)과 해시값을 적용한 char의 index를 &연산으로 붙임
                if(hex.length() == 1) result.append("0"); //한자리 수인 경우 0을 붙여서 두자리 수의 16진수로 만듦.
                result.append(hex);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.toString();  //해시값 결과 반환
    }

}
