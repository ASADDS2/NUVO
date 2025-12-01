package com.nuvo.pool.domain.ports.in;

import com.nuvo.pool.application.services.InvestRequest;
import com.nuvo.pool.domain.model.Investment;

public interface InvestUseCase {
    Investment invest(InvestRequest request);
}
