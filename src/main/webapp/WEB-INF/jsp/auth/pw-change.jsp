<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경</title>
    <%-- 팀장님이 말씀하신 CSS 폴더 경로로 연결 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/pw_change.css">
</head>
<body>

<div class="pw-change-container">
    <h3>비밀번호 변경</h3>
    <form action="${pageContext.request.contextPath}/auth/pw-change" method="post">
        <div class="form-group">
            <label>현재 비밀번호</label>
            <input type="password" name="currentPw" required>
        </div>
        
        <div class="form-group">
            <label>새 비밀번호</label>
            <input type="password" name="newPw" required>
        </div>
        
        <div class="form-group">
            <label>새 비밀번호 확인</label>
            <input type="password" name="confirmPw" required>
        </div>
        
        <button type="submit" class="submit-btn">
            비밀번호 변경 저장
        </button>
    </form>
</div>

<script>
    // 페이지 로드 시 에러 메시지 처리
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        
        if (error === 'mismatch') {
            alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
        } else if (error === 'fail') {
            alert("현재 비밀번호가 일치하지 않거나 변경에 실패했습니다.");
        }
        
        // 알림 후 URL 파라미터 제거 (깔끔하게 주소 유지)
        if (error) {
            const cleanUrl = window.location.origin + window.location.pathname;
            window.history.replaceState({}, document.title, cleanUrl);
        }
    };
</script>

</body>
</html>