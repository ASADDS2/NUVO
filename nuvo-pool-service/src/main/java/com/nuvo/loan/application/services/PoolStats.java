package com.nuvo.loan.application.services;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;

@Data
@Builder
public class PoolStats {
    private BigDecimal totalInvested;
    private BigDecimal currentProfit;
    private BigDecimal totalProjected;
}