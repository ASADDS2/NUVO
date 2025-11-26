package com.nuvo.loan.domain.ports.out;

import java.math.BigDecimal;

public interface AccountPort {
    void deposit(Integer userId, BigDecimal amount);
}
