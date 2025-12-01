package com.nuvo.pool.application.usecases;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.InvestmentStatus;
import com.nuvo.pool.domain.ports.in.WithdrawUseCase;
import com.nuvo.pool.domain.ports.out.AccountPort;
import com.nuvo.pool.domain.ports.out.InvestmentRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class WithdrawUseCaseImpl implements WithdrawUseCase {

    private final InvestmentRepositoryPort investmentRepository;
    private final AccountPort accountPort;

    private static final double DEFAULT_INTEREST_RATE_PER_DAY = 0.01;

    @Transactional
    @Override
    public void withdraw(Long investmentId) {
        Investment investment = investmentRepository.findAll().stream()
                .filter(inv -> inv.getId().equals(investmentId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Inversión no encontrada"));

        if (investment.getStatus() == InvestmentStatus.WITHDRAWN) {
            throw new RuntimeException("Ya fue retirada");
        }

        BigDecimal currentVal = calculateCurrentValue(investment);

        accountPort.updateBalance(investment.getUserId(), currentVal);

        investment.setStatus(InvestmentStatus.WITHDRAWN);
        investmentRepository.save(investment);
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
