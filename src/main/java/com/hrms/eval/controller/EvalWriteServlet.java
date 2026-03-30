package com.hrms.eval.controller;

import com.hrms.eval.dao.EvaluationDAO;
import com.hrms.eval.dto.EvaluationDTO;
import com.hrms.eval.dto.EvaluationItemDTO;
import com.hrms.eval.service.EvaluationService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/eval/write")
public class EvalWriteServlet extends HttpServlet {
    private EvaluationService evalService = new EvaluationService();
    private EvaluationDAO evalDao = new EvaluationDAO();

    /**
     * [GET] 평가 작성 페이지 출력 (신규 작성 및 수정 모드)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. 공통 데이터 준비 (사원 목록, 평가 항목명)
        Vector<Map<String, Object>> targetList = evalService.getEmployeeList();
        Vector<String> itemNames = evalService.getEvaluationItemNames();

        // 2. 연도 드롭다운 (현재 기준 최근 3년)
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        List<Integer> yearList = new ArrayList<>();
        for (int i = 0; i < 3; i++) yearList.add(currentYear - i);

        request.setAttribute("targetList", targetList);
        request.setAttribute("itemNames", itemNames);
        request.setAttribute("yearList", yearList);

        // 3. 수정 모드 처리: URL에 ?id=숫자 파라미터가 있는 경우
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int evalId = Integer.parseInt(idParam);

                // 기존 평가 메인 정보 조회 (DAO에서 Map으로 반환하도록 구현됨)
                Map<String, Object> evalData = evalDao.getEvaluationById(evalId);
                
                // 기존 상세 점수 조회 (항목명 리스트 순서에 맞춰서 점수 리스트 반환)
                List<BigDecimal> itemScores = evalDao.getItemScoresByEvalId(evalId, itemNames);

                if (evalData != null) {
                    request.setAttribute("evalData", evalData);
                    request.setAttribute("itemScores", itemScores);
                    request.setAttribute("isUpdate", true); // 수정 모드 플래그
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 4. 레이아웃 페이지로 포워딩
        request.setAttribute("viewPage", "/WEB-INF/jsp/eval/write.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    /**
     * [POST] 평가 데이터 저장 및 수정 실행
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // [체크] 세션에서 로그인한 사원의 번호(empId)를 가져옴
        Integer loginEmpId = (Integer) session.getAttribute("empId");

        // 세션이 만료되었거나 로그인이 안 된 경우 처리
        if (loginEmpId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=session_expired");
            return;
        }

        try {
            // [STEP 1] 기본 정보 DTO 세팅
            EvaluationDTO eval = new EvaluationDTO();
            eval.setEmpId(Integer.parseInt(request.getParameter("empId")));
            eval.setEvalYear(Integer.parseInt(request.getParameter("evalYear")));
            eval.setEvalPeriod(request.getParameter("evalPeriod"));
            eval.setEvalType(request.getParameter("evalType"));
            eval.setEvalComment(request.getParameter("evalComment"));
            
            // 화면에서 '작성중' 또는 '최종확정' 문자열을 받음
            String status = request.getParameter("status"); 
            eval.setEvalStatus(status);

            // 최종 확정 시에만 평가자(본인) ID를 기록
            if ("최종확정".equals(status)) {
                eval.setEvaluatorId(loginEmpId);
            }

            // [STEP 2] 상세 항목 점수 수집
            String[] names = request.getParameterValues("itemNames");
            String[] scores = request.getParameterValues("scores");
            Vector<EvaluationItemDTO> itemList = new Vector<>();

            if (names != null && scores != null) {
                for (int i = 0; i < names.length; i++) {
                    EvaluationItemDTO item = new EvaluationItemDTO();
                    item.setItemName(names[i]);
                    item.setScore(new BigDecimal(scores[i]));
                    itemList.add(item);
                }
            }

            // [STEP 3] 서비스 호출 (평균 계산, 등급 판정 후 DB 저장)
            // DAO에서 ON DUPLICATE KEY UPDATE를 사용하므로 신규/수정 구분 없이 호출 가능
            boolean isSuccess = evalService.submitEvaluation(eval, itemList);

            if (isSuccess) {
                // 성공 시 현황 대시보드로 이동
                response.sendRedirect(request.getContextPath() + "/eval/status");
            } else {
                response.sendRedirect(request.getContextPath() + "/eval/write?error=save_fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/eval/write?error=invalid_input");
        }
    }
}