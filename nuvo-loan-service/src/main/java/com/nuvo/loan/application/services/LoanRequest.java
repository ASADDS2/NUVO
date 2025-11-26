package com.nuvo.loan.application.services;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class LoanRequest {
    private Integer userId;
    private BigDecimal amount;
    private Integer termMonths;
}
