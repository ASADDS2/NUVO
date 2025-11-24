package com.nuvo.loan.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class InvestRequest {
    private Integer userId;
    private BigDecimal amount;
}