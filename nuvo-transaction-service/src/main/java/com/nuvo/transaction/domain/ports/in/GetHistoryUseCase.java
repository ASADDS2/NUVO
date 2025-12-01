package com.nuvo.transaction.domain.ports.in;

import com.nuvo.transaction.domain.model.Transaction;
import java.util.List;

public interface GetHistoryUseCase {
    List<Transaction> getHistory(Integer userId);
}
