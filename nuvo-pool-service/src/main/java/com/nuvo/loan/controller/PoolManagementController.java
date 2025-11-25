package com.nuvo.loan.controller;

import com.nuvo.loan.dto.CreatePoolRequest;
import com.nuvo.loan.dto.PoolWithStatsDTO;
import com.nuvo.loan.dto.UpdatePoolRequest;
import com.nuvo.loan.entity.Pool;
import com.nuvo.loan.service.PoolManagementService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/pools")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PoolManagementController {

    private final PoolManagementService service;

    /**
     * Crear un nuevo pool de inversión
     */
    @PostMapping
    public ResponseEntity<Pool> createPool(@RequestBody CreatePoolRequest request) {
        return ResponseEntity.ok(service.createPool(request));
    }

    /**
     * Listar todos los pools con estadísticas
     */
    @GetMapping
    public ResponseEntity<List<PoolWithStatsDTO>> getAllPools() {
        return ResponseEntity.ok(service.getAllPools());
    }

    /**
     * Listar solo pools activos
     */
    @GetMapping("/active")
    public ResponseEntity<List<Pool>> getActivePools() {
        return ResponseEntity.ok(service.getActivePools());
    }

    /**
     * Obtener un pool por ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<Pool> getPoolById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getPoolById(id));
    }

    /**
     * Actualizar un pool existente
     */
    @PutMapping("/{id}")
    public ResponseEntity<Pool> updatePool(@PathVariable Long id,
            @RequestBody UpdatePoolRequest request) {
        return ResponseEntity.ok(service.updatePool(id, request));
    }

    /**
     * Eliminar un pool (forzará retiro automático de inversiones activas)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePool(@PathVariable Long id) {
        service.deletePool(id);
        return ResponseEntity.ok().build();
    }

    /**
     * Obtener estadísticas de un pool específico
     */
    @GetMapping("/{id}/stats")
    public ResponseEntity<PoolWithStatsDTO> getPoolStats(@PathVariable Long id) {
        return ResponseEntity.ok(service.getPoolStats(id));
    }
}
