package com.hrms.eval.service;

import com.hrms.eval.dao.EvaluationDAO;
import com.hrms.eval.dto.EvaluationDTO;
import com.hrms.eval.dto.EvaluationItemDTO;
import java.math.BigDecimal;
import java.util.Map;
import java.util.Vector;

public class EvaluationService {
    private EvaluationDAO evalDao = new EvaluationDAO();

    // 1. 사원 목록 조회 (DAO 호출)
    public Vector<Map<String, Object>> getEmployeeList() {
        return evalDao.getEmployeeList();
    }

    // 2. 평가 항목명 조회 (DAO 호출)
    public Vector<String> getEvaluationItemNames() {
        return evalDao.getEvaluationItemNames();
    }

    // 3. 평가 데이터 제출 및 로직 처리
    public boolean submitEvaluation(EvaluationDTO eval, Vector<EvaluationItemDTO> items) {
        if (items == null || items.isEmpty()) return false;

        // [비즈니스 로직 1] 총점 계산
        double sum = 0;
        for (EvaluationItemDTO item : items) {
            sum += item.getScore().doubleValue();
        }
        double avg = sum / items.size();
        eval.setTotalScore(new BigDecimal(avg));

        // [비즈니스 로직 2] 등급 판정 (S, A, B, C, D)
        eval.setGrade(calculateGrade(avg));

        // [DAO 호출] 최종 DB 저장
        return evalDao.insertEvaluation(eval, items);
    }

    // 등급 계산 편의 메서드
    public String calculateGrade(double avg) {
        if (avg >= 95) return "S";
        if (avg >= 85) return "A";
        if (avg >= 75) return "B";
        if (avg >= 60) return "C";
        return "D";
    }
}