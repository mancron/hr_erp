package com.hrms.emp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Vector;

import com.hrms.emp.dto.EmpDTO;
import com.hrms.emp.service.EmpService;
import com.hrms.org.dto.DeptDTO;
import com.hrms.org.dto.PosDTO;
import com.hrms.org.dao.DeptDAO;
import com.hrms.org.dao.PosDAO;

@WebServlet("/emp/list")
public class EmpListServlet extends HttpServlet {   // ← 클래스명 PascalCase 수정
    private static final long serialVersionUID = 1L;

    private final EmpService empService = new EmpService();
    private final DeptDAO deptDao = new DeptDAO();
    private final PosDAO posDao   = new PosDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 검색 파라미터 수신
        String keyword    = request.getParameter("keyword");
        String deptId     = request.getParameter("dept_id");
        String positionId = request.getParameter("position_id");
        String status     = request.getParameter("status");
        String selStatus = (status != null) ? status : "재직";

        // 2. 드롭다운 데이터 조회
        Vector<DeptDTO> deptList = deptDao.deptList();
        Vector<PosDTO>  posList  = posDao.posList();

        // 3. 직원 목록 조회 (필터 적용)
        Vector<EmpDTO> empList = empService.getEmployeeList(keyword, deptId, positionId, selStatus);

        // 4. JSP로 전달
        request.setAttribute("deptList", deptList);
        request.setAttribute("posList",  posList);
        request.setAttribute("empList",  empList);

        // 검색값을 JSP에서 다시 쓸 수 있도록 유지
        // (param.* EL로도 접근 가능하지만 명시적으로 설정해두면 안전)
        request.setAttribute("selDeptId",  deptId     != null ? deptId     : "all");
        request.setAttribute("selPosId",   positionId != null ? positionId : "all");
        request.setAttribute("selStatus", selStatus);

        request.getRequestDispatcher("/WEB-INF/jsp/emp/list.jsp")
               .forward(request, response);
    }
}