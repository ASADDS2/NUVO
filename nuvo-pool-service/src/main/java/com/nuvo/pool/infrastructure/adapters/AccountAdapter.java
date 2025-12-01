package com.nuvo.pool.infrastructure.adapters;

import com.nuvo.pool.infrastructure.client.AccountClient;
import com.nuvo.pool.domain.ports.out.AccountPort; 
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
public class AccountAdapter implements AccountPort {
    private final AccountClient accountClient;

    @Override
    public void updateBalance(Integer userId, BigDecimal amount) {
        accountClient.updateBalance(userId, amount);
    }
}
