package com.nuvo.transaction.domain.ports.out;

import com.nuvo.transaction.domain.model.Transaction;
import java.util.List;

public interface TransactionRepositoryPort {
    Transaction save(Transaction transaction);

    List<Transaction> findBySourceUserIdOrTargetUserId(Integer userId);

    List<Transaction> findAll();
}
