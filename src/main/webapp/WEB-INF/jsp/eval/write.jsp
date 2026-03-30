<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eval/evaluation.css">

<div class="eval-wrapper">
    <div class="eval-main">
        <%-- 수정 모드: 직원 이름 표시 / 신규 모드: "평가 작성" --%>
        <div class="section-title">
            <c:choose>
                <c:when test="${not empty evalData}">
                    ${evalData.empName} 평가 수정
                </c:when>
                <c:otherwise>평가 작성</c:otherwise>
            </c:choose>
        </div>

        <form action="${pageContext.request.contextPath}/eval/write" method="post" id="evalForm">
            <%-- 수정 모드일 때 evalId hidden 전송 --%>
            <c:if test="${not empty evalData}">
                <input type="hidden" name="evalId" value="${evalData.evalId}">
            </c:if>

            <div class="form-grid">
                <div class="form-group">
                    <label>평가 대상자 *</label>
                    <select name="empId" required>
                        <option value="">대상자를 선택하세요</option>
                        <c:forEach var="emp" items="${targetList}">
                            <%-- 수정 모드: 기존 직원 selected 처리 --%>
                            <option value="${emp.empId}"
                                ${not empty evalData && evalData.empId == emp.empId ? 'selected' : ''}>
                                ${emp.empName} (${emp.pos})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label>평가 연도 *</label>
                    <select name="evalYear">
                        <%-- 연도 동적 생성: yearList가 있으면 사용, 없으면 현재 연도 기준 3년 --%>
                        <c:choose>
                            <c:when test="${not empty yearList}">
                                <c:forEach var="y" items="${yearList}">
                                    <option value="${y}"
                                        ${not empty evalData && evalData.evalYear == y ? 'selected' : ''}>${y}년</option>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <jsp:useBean id="now" class="java.util.Date" />
                                <fmt:formatDate var="currentYear" value="${now}" pattern="yyyy"/>
                                <c:forEach var="i" begin="0" end="2">
                                    <fmt:parseNumber var="yr" value="${currentYear - i}" integerOnly="true"/>
                                    <option value="${yr}"
                                        ${not empty evalData && evalData.evalYear == yr ? 'selected' : ''}>${yr}년</option>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </select>
                </div>

                <div class="form-group">
                    <label>평가 기간 *</label>
                    <select name="evalPeriod">
                        <option value="상반기" ${not empty evalData && evalData.evalPeriod == '상반기' ? 'selected' : ''}>상반기</option>
                        <option value="하반기" ${not empty evalData && evalData.evalPeriod == '하반기' ? 'selected' : ''}>하반기</option>
                        <option value="연간"   ${not empty evalData && evalData.evalPeriod == '연간'   ? 'selected' : ''}>연간</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>평가 유형 *</label>
                    <select name="evalType">
                        <option value="자기평가" ${not empty evalData && evalData.evalType == '자기평가' ? 'selected' : ''}>자기평가</option>
                        <option value="상위평가" ${empty evalData || evalData.evalType == '상위평가' ? 'selected' : ''}>상위평가</option>
                        <option value="동료평가" ${not empty evalData && evalData.evalType == '동료평가' ? 'selected' : ''}>동료평가</option>
                    </select>
                </div>
            </div>

            <div style="font-weight: 700; margin-bottom: 20px;">📊 항목별 점수 (각 100점 만점)</div>

            <c:forEach var="itemName" items="${itemNames}" varStatus="loop">
                <div class="score-item">
                    <div class="score-info"><span>${itemName}</span></div>
                    <div class="slider-container">
                        <input type="hidden" name="itemNames" value="${itemName}">
                        <%-- 수정 모드: 기존 점수 복원 (itemScores: List<BigDecimal> 순서 일치) --%>
                        <input type="range" name="scores" min="0" max="100"
                            value="${not empty itemScores ? itemScores[loop.index] : 80}"
                            oninput="updateEval(this)">
                        <span class="current-val">${not empty itemScores ? itemScores[loop.index] : 80}</span>
                        <span class="max-val">/100</span>
                    </div>
                </div>
            </c:forEach>

            <div class="result-box">
                <div>
                    <div style="font-size: 14px; color: #64748b;">종합 점수 (평균)</div>
                    <div class="avg-value" id="avgScore">
                        <c:choose>
                            <c:when test="${not empty evalData && evalData.totalScore != null}">
                                <fmt:formatNumber value="${evalData.totalScore}" pattern="0.0"/>점
                            </c:when>
                            <c:otherwise>80.0점</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 14px; color: #64748b;">등급</div>
                    <div class="grade-badge" id="gradeBadge">${not empty evalData ? evalData.grade : 'A'}</div>
                </div>
            </div>

            <%-- 확정일시: 수정 모드에서만 표시 --%>
            <c:if test="${not empty evalData && not empty evalData.confirmedAt}">
                <div style="font-size: 13px; color: #94a3b8; margin-bottom: 16px;">
                    확정일시: <fmt:formatDate value="${evalData.confirmedAt}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
            </c:if>

            <label style="font-size: 13px; color: #64748b;">평가 코멘트</label>
            <textarea name="evalComment" placeholder="평가 의견을 입력하세요." required>${not empty evalData ? evalData.evalComment : ''}</textarea>

            <div class="btn-area">
                <button type="submit" name="status" value="작성중" class="btn btn-save">임시저장</button>
                <button type="submit" name="status" value="최종확정" class="btn btn-submit">최종 확정</button>
            </div>
        </form>
    </div>

    <div class="eval-side">
        <div class="section-title" style="font-size: 15px;">등급 기준표</div>
        <table class="grade-table">
            <thead>
                <tr><th>등급</th><th>점수 범위</th><th>의미</th></tr>
            </thead>
            <tbody>
                <tr class="row-s"><td><strong>S</strong></td><td>95점 이상</td><td>최우수</td></tr>
                <tr class="row-a"><td><strong>A</strong></td><td>85 ~ 94</td><td>우수</td></tr>
                <tr><td><strong>B</strong></td><td>75 ~ 84</td><td>양호</td></tr>
                <tr><td><strong>C</strong></td><td>60 ~ 74</td><td>보통</td></tr>
                <tr><td><strong>D</strong></td><td>60점 미만</td><td>미흡</td></tr>
            </tbody>
        </table>
        <div class="warning-box">
            ※ 최종 확정 후에는 수정이 제한될 수 있습니다.<br>
            신중하게 검토 후 제출해 주세요.
        </div>
    </div>
</div>

<script>
function updateEval(el) {
    if (el) {
        el.parentElement.querySelector('.current-val').innerText = el.value;
    }
    const sliders = document.querySelectorAll('input[type="range"]');
    let sum = 0;
    sliders.forEach(s => { sum += parseInt(s.value); });
    const avg = sum / (sliders.length || 1);
    document.getElementById('avgScore').innerText = avg.toFixed(1) + '점';

    // 실시간 등급 판정 — EvaluationService.calculateGrade() 기준과 동일
    let grade = 'D', color = '#94a3b8';
    if      (avg >= 95) { grade = 'S'; color = '#ef4444'; }
    else if (avg >= 85) { grade = 'A'; color = '#f59e0b'; }
    else if (avg >= 75) { grade = 'B'; color = '#3b82f6'; }
    else if (avg >= 60) { grade = 'C'; color = '#22c55e'; }

    const badge = document.getElementById('gradeBadge');
    badge.innerText = grade;
    badge.style.color = color;
}
window.onload = () => updateEval();
</script>
