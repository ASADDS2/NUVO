package com.nuvo.transaction.domain.ports.in;

import java.math.BigDecimal;

public interface DepositUseCase {
    void deposit(Integer userId, BigDecimal amount);
}
