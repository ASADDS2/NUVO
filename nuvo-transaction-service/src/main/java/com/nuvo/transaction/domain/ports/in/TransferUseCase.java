package com.nuvo.transaction.domain.ports.in;

import com.nuvo.transaction.application.services.TransferRequest;

public interface TransferUseCase {
    void transfer(TransferRequest request);
}
