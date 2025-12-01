package com.nuvo.pool.domain.ports.out;

import com.nuvo.pool.domain.model.Pool;
import java.util.List;
import java.util.Optional;

public interface PoolRepositoryPort {
    Pool save(Pool pool);

    Optional<Pool> findById(Long id);

    List<Pool> findByActiveTrue();

    Optional<Pool> findByName(String name);

    boolean existsByName(String name);

    List<Pool> findAllWithActiveInvestments();
}
