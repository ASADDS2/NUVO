package com.nuvo.loan.service;

import com.nuvo.loan.client.AccountClient;
import com.nuvo.loan.dto.InvestRequest;
import com.nuvo.loan.dto.PoolStats;
import com.nuvo.loan.entity.Investment;
import com.nuvo.loan.entity.InvestmentStatus;
import com.nuvo.loan.entity.Pool;
import com.nuvo.loan.repository.InvestmentRepository;
import com.nuvo.loan.repository.PoolRepository;
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
    private final PoolRepository poolRepository;
    private final AccountClient accountClient;

    // Tasa de interés por defecto si el pool no tiene configurada (legacy)
    private static final double DEFAULT_INTEREST_RATE_PER_DAY = 0.01; // 1% por día

    @Transactional
    public Investment invest(InvestRequest request) {
        if (request.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("El monto debe ser positivo");
        }

        Pool pool = null;
        if (request.getPoolId() != null) {
            // Validar que el pool existe y está activo
            pool = poolRepository.findById(request.getPoolId())
                    .orElseThrow(() -> new RuntimeException("Pool no encontrado"));

            if (!pool.getActive()) {
                throw new RuntimeException("El pool está inactivo");
            }

            // Validar que el pool no esté lleno
            if (pool.isFull()) {
                throw new RuntimeException("Pool lleno. Máximo de participantes: " + pool.getMaxParticipants());
            }

            // Verificar si el usuario ya tiene una inversión activa en este pool
            boolean alreadyInvested = repository.existsByUserIdAndPoolIdAndStatus(
                    request.getUserId(),
                    pool.getId(),
                    InvestmentStatus.ACTIVE);

            if (alreadyInvested) {
                throw new RuntimeException("Ya tienes una inversión activa en este pool");
            }
        }

        // 1. Retirar dinero de la cuenta del usuario (Monto negativo)
        accountClient.updateBalance(request.getUserId(), request.getAmount().negate());

        // 2. Crear inversión
        Investment investment = Investment.builder()
                .userId(request.getUserId())
                .investedAmount(request.getAmount())
                .pool(pool)
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

    // Lógica de Interés Compuesto diario (con fracciones de día para tiempo real)
    private BigDecimal calculateCurrentValue(Investment inv) {
        // Determinar tasa de interés: usar la del pool si existe, sino usar tasa por
        // defecto
        double interestRate = DEFAULT_INTEREST_RATE_PER_DAY;
        if (inv.getPool() != null && inv.getPool().getInterestRatePerDay() != null) {
            interestRate = inv.getPool().getInterestRatePerDay();
        }

        // Calcular tiempo transcurrido en SEGUNDOS y convertir a días decimales
        long secondsElapsed = Duration.between(inv.getInvestedAt(), LocalDateTime.now()).getSeconds();
        if (secondsElapsed < 0) {
            secondsElapsed = 0;
        }

        // Convertir segundos a días (con fracciones)
        // 1 día = 86400 segundos
        double daysElapsed = secondsElapsed / 86400.0;

        // Formula: Monto * (1 + tasa)^días
        double multiplier = Math.pow(1 + interestRate, daysElapsed);

        return inv.getInvestedAmount().multiply(BigDecimal.valueOf(multiplier));
    }

    public List<Investment> getAllInvestments() {
        return repository.findAll();
    }
}