package com.nuvo.account.domain.ports.in;

import com.nuvo.account.application.services.CreateAccountRequest;
import com.nuvo.account.domain.model.Account;

public interface CreateAccountUseCase {
    Account createAccount(CreateAccountRequest request);
}
