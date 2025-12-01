package com.nuvo.pool.infrastructure.adapters;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.InvestmentStatus;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.out.InvestmentRepositoryPort;
import com.nuvo.pool.infrastructure.entities.InvestmentEntity;
import com.nuvo.pool.infrastructure.entities.PoolEntity;
import com.nuvo.pool.infrastructure.repositories.JpaInvestmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class InvestmentRepositoryAdapter implements InvestmentRepositoryPort {

    private final JpaInvestmentRepository jpaInvestmentRepository;

    @Override
    public Investment save(Investment investment) {
        InvestmentEntity entity = toEntity(investment);
        InvestmentEntity savedEntity = jpaInvestmentRepository.save(entity);
        return toDomain(savedEntity);
    }

    @Override
    public List<Investment> findByUserIdAndStatus(Integer userId, InvestmentStatus status) {
        return jpaInvestmentRepository.findByUserIdAndStatus(userId, status).stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByUserIdAndPoolIdAndStatus(Integer userId, Long poolId, InvestmentStatus status) {
        return jpaInvestmentRepository.existsByUserIdAndPoolIdAndStatus(userId, poolId, status);
    }

    @Override
    public List<Investment> findByPoolIdAndStatus(Long poolId, InvestmentStatus status) {
        return jpaInvestmentRepository.findByPoolIdAndStatus(poolId, status).stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Investment> findAll() {
        return jpaInvestmentRepository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private InvestmentEntity toEntity(Investment investment) {
        if (investment == null)
            return null;
        return InvestmentEntity.builder()
                .id(investment.getId())
                .userId(investment.getUserId())
                .investedAmount(investment.getInvestedAmount())
                .investedAt(investment.getInvestedAt())
                .status(investment.getStatus())
                .pool(toEntityPool(investment.getPool()))
                .build();
    }

    private PoolEntity toEntityPool(Pool pool) {
        if (pool == null)
            return null;
        return PoolEntity.builder()
                .id(pool.getId())
                .build();
    }

    private Investment toDomain(InvestmentEntity entity) {
        if (entity == null)
            return null;
        return Investment.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .investedAmount(entity.getInvestedAmount())
                .investedAt(entity.getInvestedAt())
                .status(entity.getStatus())
                .pool(toDomainPool(entity.getPool()))
                .build();
    }

    private Pool toDomainPool(PoolEntity entity) {
        if (entity == null)
            return null;
        return Pool.builder()
                .id(entity.getId())
                .name(entity.getName())
                .description(entity.getDescription())
                .interestRatePerDay(entity.getInterestRatePerDay())
                .maxParticipants(entity.getMaxParticipants())
                .active(entity.getActive())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
