package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.application.services.CreatePoolRequest;
import com.nuvo.loan.application.services.PoolWithStatsDTO;
import com.nuvo.loan.application.services.UpdatePoolRequest;
import com.nuvo.loan.domain.model.Pool;
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
