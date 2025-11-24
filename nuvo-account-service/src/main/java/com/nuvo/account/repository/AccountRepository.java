package com.nuvo.account.repository;

import com.nuvo.account.entity.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Long> {
    Optional<Account> findByUserId(Integer userId);
    Optional<Account> findByAccountNumber(String accountNumber);
}