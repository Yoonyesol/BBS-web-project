## BBS-project

### 오류 해결  
이미 존재하는 아이디입니다 오류 해결(아예 데이터베이스에 입력 자체가 안됨)  
DRIVER TEST CLASS 만들고 실행해서 드라이버 연결은 되어 있음을 확인  
그래도 여전히 INSERT오류 
-> 
1. 각 파일 돌아다니면서 오타 수정 
2. String dbURL = "jdbc:mysql://localhost:3306/BBS"; 을 아래와 같이 변경하여 오류 없앰 
String dbURL = "jdbc:mysql://localhost:3306/BBS?characterEncoding=UTF-8&serverTimezone=UTC"; 
3. JDBC 드라이버를 MYSQL버전과 맞게 다시 설치(압축 파일은 현재 코드 짜기 진행중인 자바 프로젝트 가장 상위 폴더 아래에 풀었음) 
->오류 잡음. 데이터베이스에 입력 성공.    
이제 데이터베이스 입력 후 joinAction페이지에서 백지로 멈춰 있는 오류 생김  
->joinAction.jsp 파일에서 마지막 else if(result==0){...} 을 else로 바꿈.  
회원가입이 안되는 부분만 예외(result == 1)로 두고, 
회원가입 후 메인.jsp로 넘어가는 경로를 걸리는 부분이 없이 클린하게 만들어 해결. 유튜브의 댓글 참조함. 
