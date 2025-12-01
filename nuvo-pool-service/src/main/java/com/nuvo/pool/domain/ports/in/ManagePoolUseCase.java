package com.nuvo.pool.domain.ports.in;

import com.nuvo.pool.application.services.CreatePoolRequest;
import com.nuvo.pool.application.services.PoolWithStatsDTO;
import com.nuvo.pool.application.services.UpdatePoolRequest;
import com.nuvo.pool.domain.model.Pool;
import java.util.List;

public interface ManagePoolUseCase {
    Pool createPool(CreatePoolRequest request);

    List<PoolWithStatsDTO> getAllPools();

    List<Pool> getActivePools();

    Pool getPoolById(Long id);

    Pool updatePool(Long id, UpdatePoolRequest request);

    void deletePool(Long id);

    PoolWithStatsDTO getPoolStats(Long poolId);
}
