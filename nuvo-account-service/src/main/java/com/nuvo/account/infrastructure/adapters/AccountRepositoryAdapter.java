package com.nuvo.account.infrastructure.adapters;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import com.nuvo.account.infrastructure.entities.AccountEntity;
import com.nuvo.account.infrastructure.repositories.JpaAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class AccountRepositoryAdapter implements AccountRepositoryPort {

    private final JpaAccountRepository repository;

    @Override
    public Account save(Account account) {
        AccountEntity entity = toEntity(account);
        AccountEntity saved = repository.save(entity);
        return toDomain(saved);
    }

    @Override
    public Optional<Account> findByUserId(Integer userId) {
        return repository.findByUserId(userId).map(this::toDomain);
    }

    @Override
    public List<Account> findAll() {
        return repository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private AccountEntity toEntity(Account domain) {
        if (domain == null)
            return null;
        return AccountEntity.builder()
                .id(domain.getId())
                .userId(domain.getUserId())
                .accountNumber(domain.getAccountNumber())
                .balance(domain.getBalance())
                .createdAt(domain.getCreatedAt())
                .build();
    }

    private Account toDomain(AccountEntity entity) {
        if (entity == null)
            return null;
        return Account.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .accountNumber(entity.getAccountNumber())
                .balance(entity.getBalance())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
