package com.hrms.auth.service;

import com.hrms.auth.dao.AccountDAO;
import com.hrms.auth.dto.AccountDTO;
import org.mindrot.jbcrypt.BCrypt;

public class AuthService {
    private AccountDAO accountDAO = new AccountDAO();

    public AccountDTO login(String username, String password) throws Exception {
        AccountDTO account = accountDAO.getAccountByUsername(username);

        if (account == null) throw new Exception("invalid_user");
        if (account.getIsActive() == 0) throw new Exception("locked");

        if (BCrypt.checkpw(password, account.getPasswordHash())) {
            accountDAO.handleLoginSuccess(username);
            return account;
        } else {
            accountDAO.handleLoginFailure(username);
            
            // 업데이트된 횟수 다시 읽기
            AccountDTO updated = accountDAO.getAccountByUsername(username);
            int currentAttempts = (updated != null) ? updated.getLoginAttempts() : 1;

            if (updated != null && updated.getIsActive() == 0) {
                throw new Exception("locked");
            }
            // 이 메시지가 JSP의 failCount가 됨
            throw new Exception("login_fail_" + currentAttempts);
        }
    }
    
    public boolean changePassword(String userId, String currentPw, String newPw) {
        AccountDTO account = accountDAO.getAccountByUsername(userId);
        if (account != null && BCrypt.checkpw(currentPw, account.getPasswordHash())) {
            String newHashedPw = BCrypt.hashpw(newPw, BCrypt.gensalt());
            return accountDAO.updatePassword(userId, newHashedPw);
        }
        return false;
    }
}