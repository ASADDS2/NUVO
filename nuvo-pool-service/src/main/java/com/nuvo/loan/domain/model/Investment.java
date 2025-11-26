package com.nuvo.loan.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Investment {
    private Long id;
    private Integer userId;
    private BigDecimal investedAmount;
    private LocalDateTime investedAt;
    private InvestmentStatus status;

    @ToString.Exclude
    private Pool pool;
}
