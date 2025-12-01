package com.nuvo.pool.domain.ports.out;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.InvestmentStatus;
import java.util.List;

public interface InvestmentRepositoryPort {
    Investment save(Investment investment);

    List<Investment> findByUserIdAndStatus(Integer userId, InvestmentStatus status);

    boolean existsByUserIdAndPoolIdAndStatus(Integer userId, Long poolId, InvestmentStatus status);

    List<Investment> findByPoolIdAndStatus(Long poolId, InvestmentStatus status);

    List<Investment> findAll();
}
