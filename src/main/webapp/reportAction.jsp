<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="java.util.Properties"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>

<%
    String userID = null;
    //session.getAttribute("userID") : 로그인이 되어있는 상태
    if(session.getAttribute("userID") != null) {
        //userID에 해당 session 값을 넣어준다.
        userID = (String) session.getAttribute("userID");
    }
    //로그인하지 않은 상태
    if(userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해주세요.');");
        script.println("location.href = 'userLogin.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String reportTitle = null;
    String reportContent = null;
    if(request.getParameter("reportTitle") != null) {
        reportTitle = request.getParameter("reportTitle");
    }
    if(request.getParameter("reportContent") != null) {
        reportContent = request.getParameter("reportContent");
    }
    if(reportTitle == null || reportContent == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('입력이 안 된 사항이 있습니다.')");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }

    //구글 smtp가 기본적으로 제공하는 양식을 그대로 사용
    String host = "http://localhost:8080/";
    String from = "TESTsjh8924@gmail.com";
    String to = "TESTsjh8924@gmail.com";  //받는 사람
    String subject = "강의평가 사이트에서 접수된 신고 메일입니다.";
    String content = "신고자: " + userID + "<br>제목: " + reportTitle + "<br>내용: " + reportContent;

    //구글 smtp서버를 이용하기 위해서 정보 설정하기
    //SMTP 서버 이용하기(22.05.30~) : 구글 2단계인증 > 앱비밀번호 생성(Gmail SMTP) > 앱 비밀번호 16자리를 Gmail 비밀번호로 사용
    Properties p = new Properties();
    p.put("mail.smtp.user", from);  //나의 구글 이메일 계정
    p.put("mail.smtp.host", "smtp.googlemail.com");  //구글에서 제공하는 smtp 서버
    p.put("mail.smtp.port", "465");  //465번 포트 사용 (정해져있음 - 구글서비스가 제공)
    p.put("mail.smtp.starttls.enable", "true");  //starttls의 사용 가능 => true로 설정
    p.put("mail.smtp.auth", "true");
    p.put("mail.smtp.debug", "true");
    p.put("mail.smtp.socketFactory.port", "465");
    p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    p.put("mail.smtp.socketFactory.fallback", "false");

    //인증메일 발송하기
    try {
        Authenticator auth = new Gmail();
        Session ses = Session.getInstance(p, auth);  //구글 계정으로 Gmail 인증 수행
        ses.setDebug(true);  //디버깅 설정
        MimeMessage msg = new MimeMessage(ses);  //MimeMesssage 객체로 실제로 메일을 보낼 수 있게 함
        msg.setSubject(subject);  //메일 제목
        Address fromAddr = new InternetAddress(from);
        msg.setFrom(fromAddr);  //보내는 사람 정보 넣기
        Address toAddr = new InternetAddress(to);
        msg.addRecipient(Message.RecipientType.TO, toAddr);  //받는 사람 정보 넣기
        msg.setContent(content, "text/html;charset=UTF8");  //메일 내용 (UTF8 인코딩으로 전송)
        Transport.send(msg);  //메일 전송
    } catch (Exception e) {
        e.printStackTrace();
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('오류가 발생했습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
    PrintWriter script = response.getWriter();
    script.println("<script>");
    script.println("alert('정상적으로 신고되었습니다.');");
    script.println("location.href='index.jsp';");
    script.println("</script>");
    script.close();
    return;
%>