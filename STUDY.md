## BBS-project

### main.jsp
```
<!-- 반응형 웹의 메타 택 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
```  
* viewport : 웹페이지가 사용자에게 보여지는 영역. 브라우저나 모바일 등에 보이는 부분을 모두 포함한다. 반응형 웹을 구현할 때 사용.   
* width=device-width : 페이지의 너비를 기기의 스크린 너비로 설정. 즉, 렌더링 영역을 기기의 뷰포트의 크기와 같게 만들어 준다.   
* initial-scale=1 : 처음 페이지 로딩시 확대/축소가 되지 않은 원래 크기를 사용하도록 함. 0~10 사이의 값을 가진다.   
* 출처: [쉬고 싶은 개발자](https://offbyone.tistory.com/110)   
   
```
<%  //로그인이 된 경우 로그인 정보를 담을 수 있게 해주는 코드
      String userID = null;
      if(session.getAttribute("userID") != null){
	userID = (String) session.getAttribute("userID");
      }
%>
```  
* 세션: 웹 서버 쪽의 웹 컨테이너에 상태를 유지하기 위한 정보를 저장. 웹 브라우저 당 1개씩 생성되어 웹 컨테이너에 저장된다.   
* session.getAttribute("userID")   
	- getAttribute(String name): 세션 속성명이 name인 속성의 값을 Object 타입으로 리턴한다. 해당 되는 속성명이 없을 경우에는 null 값을 리턴한다.   
* 출처: [개발이 하고 싶어요](https://hyeonstorage.tistory.com/125)   
```
<button type="button" class="navbar-toggle collapsed"
	data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
	aria-expanded="false">
```
* Collapse: 제목을 클릭하면 해당 내용이 펼쳐지고 다른 내용은 접히는 특수 효과
* data-toggle : "collapse"로 설정 (a태그)
* aria-expanded : 웹 접근성 측면에서 열린 부분은 true, 닫힌부분은 false
