package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.application.services.InvestRequest;
import com.nuvo.loan.domain.model.Investment;

public interface InvestUseCase {
    Investment invest(InvestRequest request);
}
