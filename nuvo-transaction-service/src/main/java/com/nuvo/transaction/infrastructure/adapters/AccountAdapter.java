package com.nuvo.transaction.infrastructure.adapters;

import com.nuvo.transaction.domain.ports.out.AccountPort;
import com.nuvo.transaction.infrastructure.client.AccountClient;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
public class AccountAdapter implements AccountPort {

    private final AccountClient accountClient;

    @Override
    public void deposit(Integer userId, BigDecimal amount) {
        accountClient.deposit(userId, amount);
    }
}
