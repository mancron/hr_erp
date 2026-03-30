package com.hrms.auth.controller;

import com.hrms.auth.dao.AccountDAO; // 추가
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/auth/login")
public class LoginViewServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO(); // 추가

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. LoginServlet이 보낸 msg와 prevUser를 읽어옴
        String msg = request.getParameter("msg");
        String prevUser = request.getParameter("prevUser");

        // 2. [핵심] 관리자 번호 조회 로직 추가
        String adminPhone = accountDAO.getAdminContact();

        // 3. JSP에서 사용할 수 있도록 request에 저장 (이름을 msg로 통일!)
        request.setAttribute("msg", msg);
        request.setAttribute("prevUser", prevUser);
        request.setAttribute("adminPhone", adminPhone);

        // 4. JSP로 포워딩
        request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(request, response);
    }
}