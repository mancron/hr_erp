package com.hrms.emp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/emp/list")
public class empListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//Service를 호출해 DB 데이터를 가져올 예정
		//List<EmpDTO> list = service.selectAll();
		//request.setAttribute("empList", list);
		
		// emp/list.jsp로 이동
		request.getRequestDispatcher("/WEB-INF/jsp/emp/list.jsp").forward(request, response);
	}

}
