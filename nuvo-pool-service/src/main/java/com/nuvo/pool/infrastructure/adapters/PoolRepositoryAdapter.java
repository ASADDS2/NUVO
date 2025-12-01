package com.nuvo.pool.infrastructure.adapters;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.out.PoolRepositoryPort;
import com.nuvo.pool.infrastructure.entities.InvestmentEntity;
import com.nuvo.pool.infrastructure.entities.PoolEntity;
import com.nuvo.pool.infrastructure.repositories.JpaPoolRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class PoolRepositoryAdapter implements PoolRepositoryPort {

    private final JpaPoolRepository jpaPoolRepository;

    @Override
    public Pool save(Pool pool) {
        PoolEntity entity = toEntity(pool);
        PoolEntity savedEntity = jpaPoolRepository.save(entity);
        return toDomain(savedEntity);
    }

    @Override
    public Optional<Pool> findById(Long id) {
        return jpaPoolRepository.findById(id).map(this::toDomain);
    }

    @Override
    public List<Pool> findByActiveTrue() {
        return jpaPoolRepository.findByActiveTrue().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Pool> findByName(String name) {
        return jpaPoolRepository.findByName(name).map(this::toDomain);
    }

    @Override
    public boolean existsByName(String name) {
        return jpaPoolRepository.existsByName(name);
    }

    @Override
    public List<Pool> findAllWithActiveInvestments() {
        return jpaPoolRepository.findAllWithActiveInvestments().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private PoolEntity toEntity(Pool pool) {
        if (pool == null)
            return null;
        return PoolEntity.builder()
                .id(pool.getId())
                .name(pool.getName())
                .description(pool.getDescription())
                .interestRatePerDay(pool.getInterestRatePerDay())
                .maxParticipants(pool.getMaxParticipants())
                .active(pool.getActive())
                .createdAt(pool.getCreatedAt())
                .build();
    }

    private Pool toDomain(PoolEntity entity) {
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
                .investments(toDomainInvestments(entity.getInvestments()))
                .build();
    }

    private List<Investment> toDomainInvestments(List<InvestmentEntity> entities) {
        if (entities == null)
            return null;
        return entities.stream()
                .map(this::toDomainInvestment)
                .collect(Collectors.toList());
    }

    private Investment toDomainInvestment(InvestmentEntity entity) {
        if (entity == null)
            return null;
        return Investment.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .investedAmount(entity.getInvestedAmount())
                .investedAt(entity.getInvestedAt())
                .status(entity.getStatus())
                .build();
    }
}
