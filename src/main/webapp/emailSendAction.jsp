<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.mail.Authenticator" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Address" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>

<%
    UserDAO userDAO = new UserDAO();
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

    boolean emailChecked = userDAO.getUserEmailChecked(userID);
    if(emailChecked == true) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 이메일 인증이 완료된 회원입니다.');");
        script.println("location.href = 'index.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    //구글 smtp가 기본적으로 제공하는 양식을 그대로 사용
    String host = "http://localhost:8080/";
    String from = "TESTsjh8924@gmail.com";  //보내는 사람
    String to = userDAO.getUserEmail(userID);  //받는 사람
    String subject = "강의평가를 위한 이메일 인증 메일입니다.";
    String content = "다음 링크에 접속하여 이메일 인증을 진행하세요." +
            "<a href='" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";

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
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>강의평가 웹 사이트</title>
    <link rel="stylesheet" href="./css/custom.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" crossorigin="anonymous">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="index.jsp">메인</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
                        회원 관리
                    </a>
                    <div class="dropdown-menu" aria-labelledby="dropdown">
                        <% if (userID == null) { %>
                        <a class="dropdown-item" href="userLogin.jsp">로그인</a>
                        <a class="dropdown-item" href="userJoin.jsp">회원가입</a>
                        <% } else { %>
                        <a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
                        <% } %>
                    </div>
                </li>
            </ul>
            <form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
                <input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
            </form>
        </div>
    </nav>
    <section class="container mt-3" style="max-width:560px;">
        <div class="alert alert-success mt-4" role="alert">
            이메일 주소 인증 메일이 전송되었습니다. 회원가입 시 입력했던 이메일에 접속하여 인증해주세요.
        </div>
    </section>

    <footer class="bg-dark mt-4 p-5 text-center" style="color:#FFFFFF;">
        Copyright &copy; 2018 나동빈 All Rights Reserved.
    </footer>

    <!-- 제이쿼리 자바스크립트 추가하기 -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" crossorigin="anonymous"></script>
    <!-- 부트스트랩 자바스크립트 추가하기 -->
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>

</body>
</html>