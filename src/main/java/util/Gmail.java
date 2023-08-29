package util;

/*
pom.xml에 외부라이브러리 넣기 (dependency)
- javamail 1.4.7
- javabeans activation framework(JAF) 1.1.1
 */
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator {
    //나의 구글 아이디,비밀번호를 넣는다. 메일을 전송할 관리자의 Gmail계정.
    //구글비밀번호: 앱비밀번호
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication("TESTsjh8924@gmail.com", "wsmtrgplypwczztf");
    }
}