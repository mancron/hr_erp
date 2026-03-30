<!-- detail.jsp -->
<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HR ERP</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<%
    // 브라우저 캐시 방지 설정
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
    
    // 세션이 없으면 부모 창을 로그인 페이지로 이동
    if (session == null || session.getAttribute("userName") == null) {
%>
        <script>
            alert("세션이 만료되었거나 로그인이 필요합니다. 로그인 화면으로 이동합니다.");
            // iframe을 감싸고 있는 진짜 부모 창의 주소를 변경
            window.parent.location.href = "http://localhost/auth/login";
        </script>
<%
        return; // 자바스크립트만 출력하고 아래 HTML 코드는 렌더링하지 않고 종료
    }
%>
<body>
  <div class="tabs">
  	  
  </div>


</body>
</html>