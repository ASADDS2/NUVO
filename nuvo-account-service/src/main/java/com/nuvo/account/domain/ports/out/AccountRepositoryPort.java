package com.nuvo.account.domain.ports.out;

import com.nuvo.account.domain.model.Account;
import java.util.List;
import java.util.Optional;

public interface AccountRepositoryPort {
    Account save(Account account);

    Optional<Account> findByUserId(Integer userId);

    List<Account> findAll();
}
