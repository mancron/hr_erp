## 📌 개요
- 
- 

## 🔗 관련 이슈
- Issue: #

---

## ✅ 구현 검증 항목

### 1. DAO (Data Access Object)
- [ ] 모든 쿼리에 `PreparedStatement`를 사용하였는가?
- [ ] `?` 플레이스홀더를 통해 파라미터 바인딩을 처리했는가?
- [ ] 발생한 예외를 `DAOException`으로 래핑하여 던졌는가?

### 2. Service Layer
- [ ] 비즈니스 로직 시작 전 입력값 검증(Validation)을 수행했는가?
- [ ] `try-with-resources` 또는 `finally`를 통해 자원을 확실히 해제했는가?
- [ ] 트랜잭션 관리(Commit/Rollback) 로직이 포함되었는가?
- [ ] 발생한 예외를 `ServiceException`으로 래핑했는가?

### 3. Controller (Servlet)
- [ ] 요청 파라미터(`request.getParameter`)의 null 체크를 수행했는가?
- [ ] 라이브러리 없이 순수 Java 서블릿만 사용했는가?
- [ ] 비즈니스 로직을 직접 구현하지 않고 Service로 위임했는가?
- [ ] JSP에 데이터를 전달할 때 DTO(또는 List<DTO>) 형태로 포장했는가?

### 4. View (JSP)
- [ ] 스크립틀릿(`<% %>`)을 완전히 제거했는가?
- [ ] XSS 방지를 위해 모든 출력에 `<c:out>` 또는 EL을 사용했는가?
- [ ] JSP 내에 비즈니스 로직이 없는가? (JSTL + EL만 사용)

---

## 📸 스크린샷 (선택)
## 💬 리뷰어에게