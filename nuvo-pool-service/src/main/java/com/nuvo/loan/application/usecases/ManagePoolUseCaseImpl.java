package com.nuvo.loan.application.usecases;

import com.nuvo.loan.application.services.CreatePoolRequest;
import com.nuvo.loan.application.services.PoolWithStatsDTO;
import com.nuvo.loan.application.services.UpdatePoolRequest;
import com.nuvo.loan.domain.model.Investment;
import com.nuvo.loan.domain.model.InvestmentStatus;
import com.nuvo.loan.domain.model.Pool;
import com.nuvo.loan.domain.ports.in.ManagePoolUseCase;
import com.nuvo.loan.domain.ports.in.WithdrawUseCase;
import com.nuvo.loan.domain.ports.out.InvestmentRepositoryPort;
import com.nuvo.loan.domain.ports.out.PoolRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ManagePoolUseCaseImpl implements ManagePoolUseCase {

    private final PoolRepositoryPort poolRepository;
    private final InvestmentRepositoryPort investmentRepository;
    private final WithdrawUseCase withdrawUseCase;

    @Transactional
    @Override
    public Pool createPool(CreatePoolRequest request) {
        if (poolRepository.existsByName(request.getName())) {
            throw new RuntimeException("Ya existe un pool con ese nombre");
        }

        if (request.getMaxParticipants() == null || request.getMaxParticipants() <= 0) {
            throw new RuntimeException("El límite de participantes debe ser mayor a 0");
        }

        if (request.getInterestRatePerDay() == null || request.getInterestRatePerDay() < 0) {
            throw new RuntimeException("La tasa de interés debe ser mayor o igual a 0");
        }

        Pool pool = Pool.builder()
                .name(request.getName())
                .description(request.getDescription())
                .interestRatePerDay(request.getInterestRatePerDay())
                .maxParticipants(request.getMaxParticipants())
                .active(true)
                .createdAt(LocalDateTime.now())
                .build();

        return poolRepository.save(pool);
    }

    @Override
    public List<PoolWithStatsDTO> getAllPools() {
        List<Pool> pools = poolRepository.findAllWithActiveInvestments();

        return pools.stream()
                .map(this::buildPoolWithStats)
                .collect(Collectors.toList());
    }

    @Override
    public List<Pool> getActivePools() {
        return poolRepository.findByActiveTrue();
    }

    @Override
    public Pool getPoolById(Long id) {
        return poolRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pool no encontrado"));
    }

    @Transactional
    @Override
    public Pool updatePool(Long id, UpdatePoolRequest request) {
        Pool pool = getPoolById(id);

        if (request.getName() != null && !request.getName().equals(pool.getName())) {
            if (poolRepository.existsByName(request.getName())) {
                throw new RuntimeException("Ya existe un pool con ese nombre");
            }
            pool.setName(request.getName());
        }

        if (request.getDescription() != null) {
            pool.setDescription(request.getDescription());
        }

        if (request.getMaxParticipants() != null) {
            int currentInvestors = pool.getCurrentParticipantsCount();
            if (request.getMaxParticipants() < currentInvestors) {
                throw new RuntimeException(
                        "No se puede reducir el límite a " + request.getMaxParticipants() +
                                " porque ya hay " + currentInvestors + " inversores activos");
            }
            pool.setMaxParticipants(request.getMaxParticipants());
        }

        if (request.getActive() != null) {
            pool.setActive(request.getActive());
        }

        if (request.getInterestRatePerDay() != null) {
            if (request.getInterestRatePerDay() < 0) {
                throw new RuntimeException("La tasa de interés debe ser mayor o igual a 0");
            }
            pool.setInterestRatePerDay(request.getInterestRatePerDay());
        }

        return poolRepository.save(pool);
    }

    @Transactional
    @Override
    public void deletePool(Long id) {
        Pool pool = getPoolById(id);

        List<Investment> activeInvestments = investmentRepository.findByPoolIdAndStatus(
                id,
                InvestmentStatus.ACTIVE);

        for (Investment investment : activeInvestments) {
            withdrawUseCase.withdraw(investment.getId());
        }

        // Note: We need to delete the pool - this will require a delete method in the
        // port
        // For now, we'll just mark it as inactive
        pool.setActive(false);
        poolRepository.save(pool);
    }

    @Override
    public PoolWithStatsDTO getPoolStats(Long poolId) {
        Pool pool = getPoolById(poolId);
        return buildPoolWithStats(pool);
    }

    private PoolWithStatsDTO buildPoolWithStats(Pool pool) {
        List<Investment> activeInvestments = investmentRepository.findByPoolIdAndStatus(
                pool.getId(),
                InvestmentStatus.ACTIVE);

        int currentInvestors = (int) activeInvestments.stream()
                .map(Investment::getUserId)
                .distinct()
                .count();

        BigDecimal totalInvested = activeInvestments.stream()
                .map(Investment::getInvestedAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalCurrentValue = activeInvestments.stream()
                .map(this::calculateCurrentValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return PoolWithStatsDTO.builder()
                .pool(pool)
                .currentInvestors(currentInvestors)
                .availableSlots(pool.getMaxParticipants() - currentInvestors)
                .totalInvested(totalInvested)
                .totalCurrentValue(totalCurrentValue)
                .build();
    }

    private BigDecimal calculateCurrentValue(Investment inv) {
        if (inv.getPool() == null) {
            return inv.getInvestedAmount();
        }

        long secondsElapsed = Duration.between(inv.getInvestedAt(), LocalDateTime.now()).getSeconds();
        if (secondsElapsed < 0) {
            secondsElapsed = 0;
        }

        double daysElapsed = secondsElapsed / 86400.0;
        double multiplier = Math.pow(1 + inv.getPool().getInterestRatePerDay(), daysElapsed);

        return inv.getInvestedAmount().multiply(BigDecimal.valueOf(multiplier));
    }
}
