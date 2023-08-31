<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDTO"%>
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
    String evaluationID = null;
    if(request.getParameter("evaluationID") != null) {
        evaluationID = request.getParameter("evaluationID");
    }
    EvaluationDAO evaluationDAO = new EvaluationDAO();
    if(userID.equals(evaluationDAO.getUserID(evaluationID))) {
        int result = new EvaluationDAO().delete(evaluationID);
        if(result == 1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('삭제가 완료되었습니다.')");
            script.println("location.href='index.jsp';");
            script.println("</script>");
            script.close();
            return;
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터베이스 오류가 발생했습니다.')");
            script.println("history.back()");
            script.println("</script>");
            script.close();
            return;
        }
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('본인이 작성한 글만 삭제할 수 있습니다.')");
        script.println("history.back()");
        script.println("</script>");
        script.close();
        return;
    }
%>