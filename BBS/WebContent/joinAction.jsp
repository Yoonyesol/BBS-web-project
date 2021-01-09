<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장 작성 위해 필요 -->
<%request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" /> <!-- 현재 페이지에서만 빈즈 사용 -->
<!-- 이 페이지 안에 넘어온 userID와 userPassword가 담기게 된다 -->
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<% 
		//로그인된 유저는 로그인 및 회원가입 페이지에 들어갈 수 없게 함
	    String userID = null;
	    if(session.getAttribute("userID") != null){ //로그인 세션을 가지고 있다면
	    	userID = (String)session.getAttribute("userID"); //세션값을 가질수 있게 함
	    }
	    if(userID != null){ //이미 로그인 한 유저는 또다시 로그인을 할 수 없음
	    	PrintWriter script = response.getWriter();
	    	script.println("<script>");
	    	script.println("alert('이미 로그인 되어 있습니다.')");
	    	script.println("location.href = 'main.jsp'");
	    	script.println("</script>");
	    }	
	    if(user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null 
			|| user.getUserGender() == null || user.getUserEmail() == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력되지 않은 사항이 존재합니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			UserDAO userDAO = new UserDAO();	//회원가입 시도(join함수 활용)
												//각각의 변수들을 입력받아서 만들어진 user라는 인스턴스가 join 함수의 매개변수가 됨					
			int result = userDAO.join(user); 
			if(result == -1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			} 
			else { //정상적인 회원가입 완료
				session.setAttribute("userID", user.getUserID()); //로그인 한 사용자에게 세션 부여
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}  
		}
	%>
</body>
</html>