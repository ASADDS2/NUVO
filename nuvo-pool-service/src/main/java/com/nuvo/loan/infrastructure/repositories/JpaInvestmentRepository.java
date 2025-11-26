package com.nuvo.loan.infrastructure.repositories;

import com.nuvo.loan.domain.model.InvestmentStatus;
import com.nuvo.loan.infrastructure.entities.InvestmentEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JpaInvestmentRepository extends JpaRepository<InvestmentEntity, Long> {
    List<InvestmentEntity> findByUserIdAndStatus(Integer userId, InvestmentStatus status);

    boolean existsByUserIdAndPoolIdAndStatus(Integer userId, Long poolId, InvestmentStatus status);

    List<InvestmentEntity> findByPoolIdAndStatus(Long poolId, InvestmentStatus status);
}
