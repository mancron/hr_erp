package com.hrms.auth.service;

import com.hrms.auth.dao.AccountDAO;
import com.hrms.auth.dto.AccountDTO;
import org.mindrot.jbcrypt.BCrypt;

public class AuthService {
    private AccountDAO accountDAO = new AccountDAO();

    public AccountDTO login(String username, String password) throws Exception {
        AccountDTO account = accountDAO.getAccountByUsername(username);

        // 1. 계정이 없는 경우
        if (account == null) {
            throw new Exception("invalid_user");
        }

        // 2. 이미 잠긴 계정인 경우
        if (account.getIsActive() == 0) {
            throw new Exception("locked_account");
        }

        // 3. 비밀번호 검증
        if (BCrypt.checkpw(password, account.getPasswordHash())) {
            accountDAO.handleLoginSuccess(username);
            return account;
        } else {
            // 1. 실패 횟수 1 증가 (DB)
            accountDAO.handleLoginFailure(username);
            
            // 2. 최신 상태 다시 가져오기
            AccountDTO updated = accountDAO.getAccountByUsername(username);
            int currentAttempts = (updated != null) ? updated.getLoginAttempts() : 1;

            // 3. [수정] 5번까지는 실패 메시지(숫자 포함)를 던지고, 
            // 실제 is_active가 0이 된 상태에서 시도할 때만 locked를 던짐
            if (updated != null && updated.getIsActive() == 0) {
                throw new Exception("locked");
            }
            
            // 5회 실패 시에도 "login_fail_5"를 던져서 JSP가 5/5를 그리게 함
            throw new Exception("login_fail_" + currentAttempts);
        }
    }
    
    public boolean changePassword(String userId, String currentPw, String newPw) {
        // 기존 AccountDAO의 메서드명을 getAccountByUsername으로 통일했으므로 수정
        AccountDTO account = accountDAO.getAccountByUsername(userId);

        if (account != null && account.getPasswordHash() != null) {
            // 현재 비밀번호 일치 확인
            if (BCrypt.checkpw(currentPw, account.getPasswordHash())) {
                // 새 비밀번호 해싱 후 업데이트
                String newHashedPw = BCrypt.hashpw(newPw, BCrypt.gensalt());
                return accountDAO.updatePassword(userId, newHashedPw);
            }
        }
        return false;
    }
}