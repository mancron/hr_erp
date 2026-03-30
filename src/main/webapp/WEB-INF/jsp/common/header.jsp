<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hrms.emp.dto.EmpDTO" %>
<%@ page import="com.hrms.org.dao.DeptDAO" %>
<%@ page import="com.hrms.org.dao.PosDAO" %> <%-- 1. PosDAO 임포트 추가 --%>
<%
    // 브라우저 캐시 방지
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 1. 세션에서 정보 가져오기
    String userRole = (String) session.getAttribute("userRole");
    EmpDTO loginUser = (EmpDTO) session.getAttribute("loginUser");
    
    // 2. 표시할 데이터 결정
    String displayRealName = (loginUser != null) ? loginUser.getEmp_name() : (String)session.getAttribute("userName");
    if (displayRealName == null) displayRealName = "Guest";

    // 부서명 및 직급명 처리
    String displayDept = "소속 미지정";
    String displayPos = ""; 

    if (loginUser != null) {
        // 부서명 로직
        if (loginUser.getDept_name() != null && !loginUser.getDept_name().isEmpty()) {
            displayDept = loginUser.getDept_name();
        } else if (loginUser.getDept_id() > 0) {
            DeptDAO deptDao = new DeptDAO();
            displayDept = deptDao.getDeptNameById(loginUser.getDept_id());
        }

        // 직급명 로직 (추가된 부분)
        if (loginUser.getPosition_name() != null && !loginUser.getPosition_name().isEmpty()) {
            displayPos = loginUser.getPosition_name();
        } else if (loginUser.getPosition_id() > 0) {
            PosDAO posDao = new PosDAO();
            displayPos = posDao.getPositionNameById(loginUser.getPosition_id());
        }
    }

    // 화면에 최종적으로 뿌릴 텍스트 결정 (직급이 없으면 권한 표시)
    String roleDisplayText = (displayPos != null && !displayPos.isEmpty()) ? displayPos : (userRole != null ? userRole : "USER");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <header class="app-header" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 20px; border-bottom: 1px solid #eee; background: #fff;">
      
      <div style="font-size: 13px; color: #64748b;">
          메인 / <strong style="color:#1e293b;">대시보드</strong>
      </div>

      <div style="display: flex; align-items: center; gap: 15px;">
          
          <div class="notification-wrap" style="position: relative; cursor: pointer;">
              <i class="fa-regular fa-bell" style="font-size: 18px; color: #64748b;"></i>
              <span style="position: absolute; top: -5px; right: -5px; background: #E74C3C; color: white; font-size: 10px; padding: 2px 5px; border-radius: 10px;">3</span>
          </div>

          <div class="user-profile" style="display: flex; align-items: center; background: #f8f9fa; padding: 5px 15px; border-radius: 30px; border: 1px solid #eee;">
              <div class="avatar" style="width: 32px; height: 32px; background: #2151A2; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; margin-right: 10px; font-weight: bold;">
                  <%= displayRealName.substring(0, 1) %>
              </div>
              
              <div style="text-align: left; line-height: 1.2; margin-right: 10px;">
                  <div style="font-size: 13px; font-weight: bold; color: #333;"><%= displayRealName %></div>
                  <%-- 수정된 부분: 부서명 · 직급(또는 권한) --%>
                  <div style="font-size: 11px; color: #888;"><%= displayDept %> · <%= roleDisplayText %></div>
              </div>
          </div>

          <a href="${pageContext.request.contextPath}/auth/logout" 
   			style="font-size: 12px; padding: 6px 12px; border: 1px solid #d1d8e0; border-radius: 4px; color: #555; text-decoration: none; background: white; font-weight: 500;">
   			로그아웃
		  </a>

      </div>
    </header>
</body>
</html>