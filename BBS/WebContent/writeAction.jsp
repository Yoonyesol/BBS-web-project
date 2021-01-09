<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장 작성 위해 필요 -->
<%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" /> <!-- 현재 페이지에서만 빈즈 사용 -->
<!-- 이 페이지 안에 넘어온 userID와 userPassword가 담기게 된다 -->
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<% 
	    String userID = null;
	    if(session.getAttribute("userID") != null){ 
	    	userID = (String)session.getAttribute("userID");
	    }
	    if(userID == null){  //로그인이 되어 있지 않은 유저 처리
	    	PrintWriter script = response.getWriter();
	    	script.println("<script>");
	    	script.println("alert('로그인이 필요합니다.')");
	    	script.println("location.href = 'login.jsp'");
	    	script.println("</script>");
	    } else {
	    	 if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null){
	    		PrintWriter script = response.getWriter();
	    		script.println("<script>");
	    		script.println("alert('입력되지 않은 사항이 존재합니다.')");
	    		script.println("history.back()");
	    		script.println("</script>");
	    	} else {
	    		BbsDAO bbsDAO = new BbsDAO();
	    		int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); 
	    		if(result == -1){  //db오류
	    			PrintWriter script = response.getWriter();
	    			script.println("<script>");
	    			script.println("alert('글쓰기에 실패했습니다.')");
	    			script.println("history.back()");
	    			script.println("</script>");
	    		} 
	    		else {  //글쓰기 성공
	    			PrintWriter script = response.getWriter();
	    			script.println("<script>");
	    			script.println("location.href = 'bbs.jsp'");
	    			script.println("</script>");
	    		}  
	    	}
		}
	%>
</body>
</html>