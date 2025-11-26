package com.nuvo.account.infrastructure.repositories;

import com.nuvo.account.infrastructure.entities.AccountEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface JpaAccountRepository extends JpaRepository<AccountEntity, Long> {
    Optional<AccountEntity> findByUserId(Integer userId);

    Optional<AccountEntity> findByAccountNumber(String accountNumber);
}
