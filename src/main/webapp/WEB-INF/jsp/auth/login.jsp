<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>HR ERP - 인사관리 통합 시스템</title>
    <%-- 경로가 꼬이지 않도록 ${pageContext.request.contextPath}를 사용합니다 --%>
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

        <%-- 서블릿의 doPost 주소(/auth/login.do)와 일치해야 합니다 --%>
        <form action="${pageContext.request.contextPath}/auth/login.do" method="post">
            <div class="input-group">
                <label class="input-label">아이디 <span class="required">*</span></label>
                <input type="text" name="username" class="input-box" placeholder="아이디" 
                       value="${not empty param.prevUser ? param.prevUser : ''}" required>
            </div>

            <div class="input-group">
                <label class="input-label">비밀번호 <span class="required">*</span></label>
                <input type="password" name="password" class="input-box" placeholder="비밀번호" required>
            </div>

            <%-- 서버(Servlet/Service)에서 넘어온 데이터 처리 --%>
            <% 
                // 서블릿(doGet)에서 request.setAttribute 한 값을 가져옴
                String msg = (String)request.getAttribute("msg");
                String adminPhone = (String)request.getAttribute("adminPhone");
                if (adminPhone == null || adminPhone.isEmpty()) adminPhone = "인사팀 문의";

                String failCount = "0";
                if (msg != null && msg.startsWith("login_fail_")) {
                    failCount = msg.substring(msg.lastIndexOf("_") + 1);
                }
            %>

            <div class="alert-container">
                <% if ("locked".equals(msg)) { %>
                    <%-- 5회 실패 시 즉시 잠김 상태 (사용자님 요청: 5/5 안 보여주고 바로 잠금) --%>
                    <div class="alert-box alert-danger" style="background-color: #fff5f5; border: 1px solid #feb2b2; padding: 12px; border-radius: 6px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-lock" style="color: #e53e3e;"></i>
                        <p style="color: #c53030; font-size: 13px; margin: 0; line-height: 1.4; text-align: left;">
                            <strong>계정 잠김:</strong> 보안을 위해 차단되었습니다.<br>
                            담당자(<%= adminPhone %>)에게 문의하세요.
                        </p>
                    </div>

                <% } else if (msg != null && msg.startsWith("login_fail_")) { %>
                    <%-- 1~4회 실패 진행 중 --%>
                    <div class="alert-box alert-warning" style="background-color: #fffaf0; border: 1px solid #fbd38d; padding: 12px; border-radius: 6px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-circle-exclamation" style="color: #dd6b20;"></i>
                        <p style="color: #9c4221; font-size: 13px; margin: 0; text-align: left;">
                            비밀번호가 일치하지 않습니다.<br>
                            <strong>현재 실패 횟수: <%= failCount %> / 5회</strong>
                        </p>
                    </div>

                <% } else { %>
                    <%-- 초기 상태 --%>
                    <div class="alert-box alert-default" style="background-color: #ebf8ff; border: 1px solid #bee3f8; padding: 12px; border-radius: 6px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-circle-info" style="color: #3182ce;"></i>
                        <p style="color: #2a4365; font-size: 13px; margin: 0; text-align: left;">5회 연속 실패 시 보안을 위해 계정이 잠깁니다.</p>
                    </div>
                <% } %>
            </div>

            <button type="submit" class="login-btn">로그인</button>
        </form>

        <div class="footer-info" style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
            <span class="contact-title" style="display: block; font-size: 14px; color: #777; margin-bottom: 5px;">비밀번호 분실 및 계정 잠금 문의</span>
            <span class="phone-number" style="font-weight: bold; color: #34495e;">
                <i class="fa-solid fa-phone" style="margin-right: 5px;"></i> 담당자: <%= adminPhone %>
            </span>
        </div>
    </div>

<script>
window.onload = function() {
    // 1. URL에서 파라미터 직접 읽기 (새로고침 대응용)
    const url = new URL(window.location.href);
    const msgParam = url.searchParams.get('msg');
    
    // JSP 내장 객체 adminPhone 값을 JS 변수로 안전하게 전달
    const adminPhone = "<%= adminPhone %>";
    
    if (msgParam) {
        if (msgParam === 'locked') {
            alert("⚠️ 계정 잠김 경고\n비밀번호 5회 오류로 계정이 잠겼습니다.\n담당자(" + adminPhone + ")에게 문의하세요.");
        } else if (msgParam === 'pw_success') {
            alert("비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요.");
        }

        // 주소창 파라미터 제거
        url.searchParams.delete('msg');
        url.searchParams.delete('prevUser');
        window.history.replaceState({}, document.title, url.pathname);
    }
};
</script>
</body>
</html>