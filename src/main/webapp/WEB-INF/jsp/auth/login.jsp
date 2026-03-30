<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>HR ERP - 인사관리 통합 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>

    <div class="login-card">
        <div class="logo-area">
            <i class="fa-solid fa-hotel" style="font-size: 40px; color: #3498db; margin-bottom: 15px;"></i>
            <h2>HR ERP</h2>
            <p>인사관리 통합 시스템</p>
        </div>

        <form action="${pageContext.request.contextPath}/auth/login.do" method="post">
            <div class="input-group">
                <label class="input-label">아이디 <span class="required">*</span></label>
                <input type="text" name="username" class="input-box" placeholder="아이디" 
                       value="<%= request.getParameter("prevUser") != null ? request.getParameter("prevUser") : "" %>" required>
            </div>

            <div class="input-group">
                <label class="input-label">비밀번호 <span class="required">*</span></label>
                <input type="password" name="password" class="input-box" placeholder="비밀번호" required>
            </div>

            <% 
                String msg = request.getParameter("msg");
                if (msg != null && msg.startsWith("login_fail")) { 
                    String count = msg.substring(msg.lastIndexOf("_") + 1);
            %>
                <div class="alert-box alert-danger">
                    <i class="fa-solid fa-circle-xmark alert-icon"></i>
                    <p>아이디/비밀번호 오류 (<%= count %>/5회)</p>
                </div>
            <% } else if ("locked".equals(msg)) { %>
                <div class="alert-box alert-danger">
                    <i class="fa-solid fa-lock alert-icon"></i>
                    <p><strong>계정 잠김:</strong> 담당자에게 문의하세요.</p>
                </div>
            <% } else { %>
                <div class="alert-box alert-default">
                    <i class="fa-solid fa-triangle-exclamation alert-icon"></i>
                    <p>5회 연속 실패 시 계정이 잠깁니다</p>
                </div>
            <% } %>

            <button type="submit" class="login-btn">로그인</button>
        </form>

        <%-- 하단 문의 정보 --%>
        <div class="footer-info">
            <span class="contact-title">비밀번호 분실 및 계정 잠금 문의</span>
            <span class="phone-number">
                <i class="fa-solid fa-phone"></i> 인사팀: 051-890-0000
            </span>
        </div>
    </div>

<script>
window.onload = function() {
    const url = new URL(window.location.href);
    const msg = url.searchParams.get('msg');
    
    if (msg) {
        if (msg === 'logout') {
            alert("로그아웃 되었습니다.");
        } else if (msg === 'pw_success') {
            alert("비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요.");
        } else if (msg === 'locked') {
            alert("⚠️ 보안 경고\n비밀번호 5회 오류로 계정이 잠겼습니다.\n인사팀(051-890-0000)으로 문의하여 잠금을 해제하세요.");
        }
        
        // URL 파라미터 정리
        url.searchParams.delete('msg');
        url.searchParams.delete('prevUser');
        window.history.replaceState({}, document.title, url.pathname);
    }
};
</script>
</body>
</html>