package com.nuvo.transaction.infrastructure.adapters;

import com.nuvo.transaction.domain.model.Transaction;
import com.nuvo.transaction.domain.ports.out.TransactionRepositoryPort;
import com.nuvo.transaction.infrastructure.entities.TransactionEntity;
import com.nuvo.transaction.infrastructure.repositories.JpaTransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class TransactionRepositoryAdapter implements TransactionRepositoryPort {

    private final JpaTransactionRepository jpaTransactionRepository;

    @Override
    public Transaction save(Transaction transaction) {
        TransactionEntity entity = TransactionEntity.builder()
                .id(transaction.getId())
                .sourceUserId(transaction.getSourceUserId())
                .targetUserId(transaction.getTargetUserId())
                .amount(transaction.getAmount())
                .type(transaction.getType())
                .timestamp(transaction.getTimestamp())
                .build();

        TransactionEntity saved = jpaTransactionRepository.save(entity);
        return toDomain(saved);
    }

    @Override
    public List<Transaction> findBySourceUserIdOrTargetUserId(Integer userId) {
        return jpaTransactionRepository.findBySourceUserIdOrTargetUserId(userId, userId)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Transaction> findAll() {
        return jpaTransactionRepository.findAll()
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private Transaction toDomain(TransactionEntity entity) {
        return Transaction.builder()
                .id(entity.getId())
                .sourceUserId(entity.getSourceUserId())
                .targetUserId(entity.getTargetUserId())
                .amount(entity.getAmount())
                .type(entity.getType())
                .timestamp(entity.getTimestamp())
                .build();
    }
}
