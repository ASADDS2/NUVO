package com.nuvo.transaction.infrastructure.repositories;

import com.nuvo.transaction.infrastructure.entities.TransactionEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JpaTransactionRepository extends JpaRepository<TransactionEntity, Long> {
    List<TransactionEntity> findBySourceUserIdOrTargetUserId(Integer sourceUserId, Integer targetUserId);
}
