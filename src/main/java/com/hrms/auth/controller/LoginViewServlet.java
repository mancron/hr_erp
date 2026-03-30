package com.hrms.auth.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/auth/login")
public class LoginViewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. URL에 포함된 error와 prevUser 파라미터를 읽어옵니다.
        String error = request.getParameter("error");
        String prevUser = request.getParameter("prevUser");

        // 2. 읽어온 값을 다시 request 객체에 담습니다. (JSP에서 쓸 수 있게)
        request.setAttribute("error", error);
        request.setAttribute("prevUser", prevUser);

        // 3. 실제 login.jsp 파일로 포워딩합니다.
        request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(request, response);
    }
}