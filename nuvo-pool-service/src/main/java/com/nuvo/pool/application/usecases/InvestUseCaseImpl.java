package com.nuvo.pool.application.usecases;

import com.nuvo.pool.application.services.InvestRequest;
import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.InvestmentStatus;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.in.InvestUseCase;
import com.nuvo.pool.domain.ports.out.AccountPort;
import com.nuvo.pool.domain.ports.out.InvestmentRepositoryPort;
import com.nuvo.pool.domain.ports.out.PoolRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class InvestUseCaseImpl implements InvestUseCase {

    private final InvestmentRepositoryPort investmentRepository;
    private final PoolRepositoryPort poolRepository;
    private final AccountPort accountPort;

    @Transactional
    @Override
    public Investment invest(InvestRequest request) {
        if (request.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("El monto debe ser positivo");
        }

        Pool pool = null;
        if (request.getPoolId() != null) {
            pool = poolRepository.findById(request.getPoolId())
                    .orElseThrow(() -> new RuntimeException("Pool no encontrado"));

            if (!Boolean.TRUE.equals(pool.getActive())) {
                throw new RuntimeException("El pool está inactivo");
            }

            if (pool.isFull()) {
                throw new RuntimeException("Pool lleno. Máximo de participantes: " + pool.getMaxParticipants());
            }

            boolean alreadyInvested = investmentRepository.existsByUserIdAndPoolIdAndStatus(
                    request.getUserId(),
                    pool.getId(),
                    InvestmentStatus.ACTIVE);

            if (alreadyInvested) {
                throw new RuntimeException("Ya tienes una inversión activa en este pool");
            }
        }

        accountPort.updateBalance(request.getUserId(), request.getAmount().negate());

        Investment investment = Investment.builder()
                .userId(request.getUserId())
                .investedAmount(request.getAmount())
                .status(InvestmentStatus.ACTIVE)
                .pool(pool)
                .build();

        return investmentRepository.save(investment);
    }
}
