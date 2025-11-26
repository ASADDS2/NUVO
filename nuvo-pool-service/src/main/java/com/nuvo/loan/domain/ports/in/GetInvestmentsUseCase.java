package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.application.services.PoolStats;
import com.nuvo.loan.domain.model.Investment;
import java.util.List;

public interface GetInvestmentsUseCase {
    List<Investment> getMyInvestments(Integer userId);

    PoolStats getStats(Integer userId);

    List<Investment> getAllInvestments();
}
