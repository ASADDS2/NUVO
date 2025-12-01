package com.nuvo.pool.domain.ports.out;

import java.math.BigDecimal;

public interface AccountPort {
    void updateBalance(Integer userId, BigDecimal amount);
}
