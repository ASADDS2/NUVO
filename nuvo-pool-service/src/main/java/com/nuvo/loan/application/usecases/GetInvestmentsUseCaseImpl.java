package com.nuvo.loan.application.usecases;

import com.nuvo.loan.application.services.PoolStats;
import com.nuvo.loan.domain.model.Investment;
import com.nuvo.loan.domain.model.InvestmentStatus;
import com.nuvo.loan.domain.ports.in.GetInvestmentsUseCase;
import com.nuvo.loan.domain.ports.out.InvestmentRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class GetInvestmentsUseCaseImpl implements GetInvestmentsUseCase {

    private final InvestmentRepositoryPort investmentRepository;

    private static final double DEFAULT_INTEREST_RATE_PER_DAY = 0.01;

    @Override
    public List<Investment> getMyInvestments(Integer userId) {
        return investmentRepository.findByUserIdAndStatus(userId, InvestmentStatus.ACTIVE);
    }

    @Override
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

    @Override
    public List<Investment> getAllInvestments() {
        return investmentRepository.findAll();
    }

    private BigDecimal calculateCurrentValue(Investment inv) {
        double interestRate = DEFAULT_INTEREST_RATE_PER_DAY;
        if (inv.getPool() != null && inv.getPool().getInterestRatePerDay() != null) {
            interestRate = inv.getPool().getInterestRatePerDay();
        }

        long secondsElapsed = Duration.between(inv.getInvestedAt(), LocalDateTime.now()).getSeconds();
        if (secondsElapsed < 0) {
            secondsElapsed = 0;
        }

        double daysElapsed = secondsElapsed / 86400.0;
        double multiplier = Math.pow(1 + interestRate, daysElapsed);

        return inv.getInvestedAmount().multiply(BigDecimal.valueOf(multiplier));
    }
}
