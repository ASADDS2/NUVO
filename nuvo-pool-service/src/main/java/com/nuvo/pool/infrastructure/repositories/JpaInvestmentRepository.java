package com.nuvo.pool.infrastructure.repositories;

import com.nuvo.pool.domain.model.InvestmentStatus;
import com.nuvo.pool.infrastructure.entities.InvestmentEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JpaInvestmentRepository extends JpaRepository<InvestmentEntity, Long> {
    List<InvestmentEntity> findByUserIdAndStatus(Integer userId, InvestmentStatus status);

    boolean existsByUserIdAndPoolIdAndStatus(Integer userId, Long poolId, InvestmentStatus status);

    List<InvestmentEntity> findByPoolIdAndStatus(Long poolId, InvestmentStatus status);
}
