✅ 구현 검증 항목:

[ ] DAO
    [ ] 모든 쿼리에 PreparedStatement 사용
    [ ] ? 플레이스홀더로 파라미터 바인딩
    [ ] 예외를 DAOException으로 래핑
    
[ ] Service
    [ ] 입력값 검증 로직 포함
    [ ] try-catch-finally 또는 try-with-resources
    [ ] 트랜잭션 관리 (commit/rollback)
    [ ] 예외를 ServiceException으로 래핑
    
[ ] Controller
    [ ] 요청 파라미터 null 체크
    [ ] 서블릿만 사용 (순수 Java)
    [ ] Service 호출로 위임
    [ ] DTO만 JSP에 전달
    
[ ] JSP
    [ ] Scriptlet (<%  %>) 없음
    [ ] <c:out> 태그로 XSS 방지
    [ ] 비즈니스 로직 없음 (JSTL + EL만)
    [ ] DTO/List 포장 출력만