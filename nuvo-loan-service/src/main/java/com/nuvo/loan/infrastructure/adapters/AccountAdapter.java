package com.nuvo.loan.infrastructure.adapters;

import com.nuvo.loan.domain.ports.out.AccountPort;
import com.nuvo.loan.infrastructure.client.AccountClient;
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
