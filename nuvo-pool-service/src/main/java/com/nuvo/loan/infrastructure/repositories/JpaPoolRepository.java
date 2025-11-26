package com.nuvo.loan.infrastructure.repositories;

import com.nuvo.loan.infrastructure.entities.PoolEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

public interface JpaPoolRepository extends JpaRepository<PoolEntity, Long> {
    List<PoolEntity> findByActiveTrue();

    Optional<PoolEntity> findByName(String name);

    boolean existsByName(String name);

    @Query("SELECT p FROM PoolEntity p LEFT JOIN FETCH p.investments i " +
            "WHERE i.status = 'ACTIVE' OR i IS NULL")
    List<PoolEntity> findAllWithActiveInvestments();
}
