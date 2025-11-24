package com.nuvo.transaction.repository;

import com.nuvo.transaction.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    // Buscar transacciones donde el usuario sea origen O destino
    List<Transaction> findBySourceUserIdOrTargetUserIdOrderByTimestampDesc(Integer source, Integer target);
}