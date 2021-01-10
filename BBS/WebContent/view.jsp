<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 반응형 웹의 메타 택 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%  
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		int bbsID = 0;
		if(request.getParameter("bbsID") != null){  //매개변수로 넘어온 bbsID라는 id가 존재한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0){  //번호가 존재하지 않을 시 글을 볼 수 없다.
			PrintWriter script = response.getWriter();
	    	script.println("<script>");
	    	script.println("alert('유효하지 않은 글입니다.')");
	    	script.println("location.href = 'bbs.jsp'");
	    	script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);  //유효한 글이라면, 글의 구체적인 정보를 받아올 수 있도록 인스턴스 생성
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example=navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs.example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<% 
				if(userID == null){ //로그인이 되어 있지 않은 경우	
			%>		
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%	
				}
			%>
		</div>
	</nav>
	<div class="container">
		<!-- 홀수 짝수 행 번갈아가며 색상 달라짐 -->
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기 양식</th>
				</tr>
			</thead>
			<tbody>
				<tr>	
					<td style="width: 20%;">글 제목</td>
					<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
					<!-- 글 제목에 특수문자 처리 해 주지 않을 시 스크립트 문장을 그대로 인식해 실행되므로 해킹수단으로 사용될 수 있음.(크로스 사이트 스크립팅 공격) 반드시 특수문자 처리해 줄것 -->
				</tr>
				<tr>	
					<td>작성자</td>
					<td colspan="2"><%= bbs.getUserID() %></td>
				</tr>
				<tr>	
					<td>작성일자</td>
					<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
				</tr>
				<tr>	
					<td>내용</td>
					<td colspan="2"> 
						<div class="bbs-content" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></div>
						<!-- 안에 div 생성해서 style 속성을 적용해주어야 더 안정적. div없이 td에 스타일 적용시 크롬, 파이어폭스에서 적용되지 않는 문제 발생가능 -->
					</td>			
				</tr>
			</tbody>
		</table>
		<a href="bbs.jsp" class="btn btn-primary">목록</a>
		<%
			if(userID != null && userID.equals(bbs.getUserID())){  //해당 글의 작성자가 유저아이디와 동일하다면
		%>
				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
		<%
			}
		%>
		<input type="submit" class="btn btn-primary pull-right" value="글쓰기">	
	</div>
	<!-- 애니메이션 담당 js 참조 -->
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>