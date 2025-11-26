package com.nuvo.loan.application.services;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class InvestRequest {
    private Integer userId;
    private BigDecimal amount;
    private Long poolId; // ID del pool en el que se quiere invertir
}