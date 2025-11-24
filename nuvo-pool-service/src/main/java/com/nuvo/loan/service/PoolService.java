package com.nuvo.loan.service;

import com.nuvo.loan.client.AccountClient;
import com.nuvo.loan.dto.InvestRequest;
import com.nuvo.loan.dto.PoolStats;
import com.nuvo.loan.entity.Investment;
import com.nuvo.loan.entity.InvestmentStatus;
import com.nuvo.loan.repository.InvestmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PoolService {

    private final InvestmentRepository repository;
    private final AccountClient accountClient;

    // Tasa de interés simulada: 1% por MINUTO para demo
    private static final double INTEREST_RATE_PER_MINUTE = 0.01;

    @Transactional
    public Investment invest(InvestRequest request) {
        if (request.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("El monto debe ser positivo");
        }

        // 1. Retirar dinero de la cuenta del usuario (Monto negativo)
        accountClient.updateBalance(request.getUserId(), request.getAmount().negate());

        // 2. Crear inversión
        Investment investment = Investment.builder()
                .userId(request.getUserId())
                .investedAmount(request.getAmount())
                .build();

        return repository.save(investment);
    }

    @Transactional
    public void withdraw(Long investmentId) {
        Investment investment = repository.findById(investmentId)
                .orElseThrow(() -> new RuntimeException("Inversión no encontrada"));

        if (investment.getStatus() == InvestmentStatus.WITHDRAWN) {
            throw new RuntimeException("Ya fue retirada");
        }

        // 1. Calcular ganancia
        BigDecimal currentVal = calculateCurrentValue(investment);

        // 2. Depositar capital + ganancia al usuario
        accountClient.updateBalance(investment.getUserId(), currentVal);

        // 3. Cerrar inversión
        investment.setStatus(InvestmentStatus.WITHDRAWN);
        repository.save(investment);
    }

    public List<Investment> getMyInvestments(Integer userId) {
        return repository.findByUserIdAndStatus(userId, InvestmentStatus.ACTIVE);
    }

    public PoolStats getStats(Integer userId) {
        List<Investment> active = getMyInvestments(userId);

        BigDecimal totalInvested = active.stream()
                .map(Investment::getInvestedAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalCurrent = active.stream()
                .map(this::calculateCurrentValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return PoolStats.builder()
                .totalInvested(totalInvested)
                .totalProjected(totalCurrent)
                .currentProfit(totalCurrent.subtract(totalInvested))
                .build();
    }

    // Lógica simple de Interés Compuesto simulado
    private BigDecimal calculateCurrentValue(Investment inv) {
        long minutesElapsed = Duration.between(inv.getInvestedAt(), LocalDateTime.now()).toMinutes();
        // Mínimo 0 minutos
        if (minutesElapsed < 0)
            minutesElapsed = 0;

        // Formula: Monto * (1 + tasa)^minutos
        double multiplier = Math.pow(1 + INTEREST_RATE_PER_MINUTE, minutesElapsed);

        return inv.getInvestedAmount().multiply(BigDecimal.valueOf(multiplier));
    }

    public List<Investment> getAllInvestments() {
        return repository.findAll();
    }
}