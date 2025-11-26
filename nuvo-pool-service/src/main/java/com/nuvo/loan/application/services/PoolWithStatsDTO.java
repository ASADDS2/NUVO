package com.nuvo.loan.application.services;

import com.nuvo.loan.domain.model.Pool;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PoolWithStatsDTO {

    private Pool pool;

    private Integer currentInvestors; // Número actual de inversores

    private Integer availableSlots; // Cupos disponibles

    private BigDecimal totalInvested; // Monto total invertido en el pool

    private BigDecimal totalCurrentValue; // Valor actual total (con ganancias)
}
