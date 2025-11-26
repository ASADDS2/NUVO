package com.nuvo.account.application.usecases;

import com.nuvo.account.application.services.CreateAccountRequest;
import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.CreateAccountUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CreateAccountUseCaseImpl implements CreateAccountUseCase {

    private final AccountRepositoryPort accountRepository;

    @Override
    public Account createAccount(CreateAccountRequest request) {
        // Simple mapping from DTO to domain model
        Account account = Account.builder()
                .userId(request.getUserId())
                .balance(null) // will be set to zero by domain defaults if needed
                .build();
        return accountRepository.save(account);
    }
}
