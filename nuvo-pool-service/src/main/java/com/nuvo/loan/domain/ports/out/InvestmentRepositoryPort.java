package com.nuvo.loan.domain.ports.out;

import com.nuvo.loan.domain.model.Investment;
import com.nuvo.loan.domain.model.InvestmentStatus;
import java.util.List;

public interface InvestmentRepositoryPort {
    Investment save(Investment investment);

    List<Investment> findByUserIdAndStatus(Integer userId, InvestmentStatus status);

    boolean existsByUserIdAndPoolIdAndStatus(Integer userId, Long poolId, InvestmentStatus status);

    List<Investment> findByPoolIdAndStatus(Long poolId, InvestmentStatus status);

    List<Investment> findAll();
}
