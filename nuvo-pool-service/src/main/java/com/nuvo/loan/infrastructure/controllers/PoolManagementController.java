package com.nuvo.loan.infrastructure.controllers;

import com.nuvo.loan.application.services.CreatePoolRequest;
import com.nuvo.loan.application.services.PoolWithStatsDTO;
import com.nuvo.loan.application.services.UpdatePoolRequest;
import com.nuvo.loan.domain.model.Pool;
import com.nuvo.loan.domain.ports.in.ManagePoolUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/pools")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PoolManagementController {

    private final ManagePoolUseCase managePoolUseCase;

    @PostMapping
    public ResponseEntity<Pool> createPool(@RequestBody CreatePoolRequest request) {
        return ResponseEntity.ok(managePoolUseCase.createPool(request));
    }

    @GetMapping
    public ResponseEntity<List<PoolWithStatsDTO>> getAllPools() {
        return ResponseEntity.ok(managePoolUseCase.getAllPools());
    }

    @GetMapping("/active")
    public ResponseEntity<List<Pool>> getActivePools() {
        return ResponseEntity.ok(managePoolUseCase.getActivePools());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pool> getPoolById(@PathVariable Long id) {
        return ResponseEntity.ok(managePoolUseCase.getPoolById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Pool> updatePool(@PathVariable Long id,
            @RequestBody UpdatePoolRequest request) {
        return ResponseEntity.ok(managePoolUseCase.updatePool(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePool(@PathVariable Long id) {
        managePoolUseCase.deletePool(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}/stats")
    public ResponseEntity<PoolWithStatsDTO> getPoolStats(@PathVariable Long id) {
        return ResponseEntity.ok(managePoolUseCase.getPoolStats(id));
    }
}
