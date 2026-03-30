package com.hrms.emp.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import com.hrms.emp.dao.EmpDAO;
import com.hrms.emp.dto.EmpDTO;
import com.hrms.common.db.DatabaseConnection;

public class EmpService {

    private EmpDAO empDao;

    public EmpService() {
        empDao = new EmpDAO();
    }

    /**
     * 직원 목록 조회 (필터 검색 포함)
     * Connection을 Service에서 열고 닫습니다.
     */
    public Vector<EmpDTO> getEmployeeList(String keyword,
                                          String deptIdStr,
                                          String positionIdStr,
                                          String status) {
        Connection con = null;
        Vector<EmpDTO> list = new Vector<>();

        try {
            // String → int 변환 (비어있거나 "all"이면 0, 즉 필터 안 함)
            int deptId = parseId(deptIdStr);
            int positionId = parseId(positionIdStr);

            con = DatabaseConnection.getConnection();
            list = empDao.searchEmpList(con, keyword, deptId, positionId, status);

        } catch (Exception e) {
            System.err.println("[EmpService] getEmployeeList 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeConnection(con);
        }

        return list;
    }

    /**
     * 직원 상세 조회
     */
    public EmpDTO getEmployeeDetail(String empNo) {
        Connection con = null;
        EmpDTO dto = null;

        try {
            con = DatabaseConnection.getConnection();
            dto = empDao.getEmpDetail(con, empNo);

        } catch (Exception e) {
            System.err.println("[EmpService] getEmployeeDetail 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeConnection(con);
        }

        return dto;
    }

    // ── private 헬퍼 ───────────────────────────────────────────

    /** "all", null, 빈 문자열 → 0 / 그 외 → 정수 변환 */
    private int parseId(String value) {
        if (value == null || value.isEmpty() || value.equals("all")) {
            return 0;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void closeConnection(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}