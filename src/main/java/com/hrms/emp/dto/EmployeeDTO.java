package com.hrms.emp.dto;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * 직원 테이블(employee) DTO
 * 모든 직원의 기본 정보 및 인사 상태를 관리합니다.
 */
public class EmployeeDTO {
    private int empId;              // 직원 ID (PK)
    private String empName;         // 직원명
    private String empNo;           // 사번 (EMP001 형식)
    private int deptId;             // 소속 부서 ID (FK)
    private int positionId;         // 직급 ID (FK)
    private Date hireDate;          // 입사일
    private Date resignDate;        // 퇴사일 (null 허용)
    private String empType;         // 정규직/계약직/파트타임
    private String status;          // 재직/휴직/퇴직
    private int baseSalary;         // 개인 기본급
    private Date birthDate;         // 생년월일
    private String gender;          // 성별 (M/F)
    private String address;         // 주소
    private String emergencyContact; // 긴급 연락처
    private String bankAccount;     // 급여 이체 계좌번호
    private String email;           // 회사 이메일
    private String phone;           // 연락처
    private Timestamp createdAt;    // 생성일시
    
    private String deptName; // 부서명 (조인 결과용)
    // 기본 생성자
    public EmployeeDTO() {}

    // Getter & Setter
    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }

    public String getEmpName() { return empName; }
    public void setEmpName(String empName) { this.empName = empName; }

    public String getEmpNo() { return empNo; }
    public void setEmpNo(String empNo) { this.empNo = empNo; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }

    public Date getHireDate() { return hireDate; }
    public void setHireDate(Date hireDate) { this.hireDate = hireDate; }

    public Date getResignDate() { return resignDate; }
    public void setResignDate(Date resignDate) { this.resignDate = resignDate; }

    public String getEmpType() { return empType; }
    public void setEmpType(String empType) { this.empType = empType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getBaseSalary() { return baseSalary; }
    public void setBaseSalary(int baseSalary) { this.baseSalary = baseSalary; }

    public Date getBirthDate() { return birthDate; }
    public void setBirthDate(Date birthDate) { this.birthDate = birthDate; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmergencyContact() { return emergencyContact; }
    public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getDeptName() {return deptName;}
    public void setDeptName(String deptName) {this.deptName = deptName;}
}