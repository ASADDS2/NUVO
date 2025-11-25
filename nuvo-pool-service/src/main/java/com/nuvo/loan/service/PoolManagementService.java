package com.nuvo.loan.service;

import com.nuvo.loan.dto.CreatePoolRequest;
import com.nuvo.loan.dto.PoolWithStatsDTO;
import com.nuvo.loan.dto.UpdatePoolRequest;
import com.nuvo.loan.entity.Investment;
import com.nuvo.loan.entity.InvestmentStatus;
import com.nuvo.loan.entity.Pool;
import com.nuvo.loan.repository.InvestmentRepository;
import com.nuvo.loan.repository.PoolRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PoolManagementService {

    private final PoolRepository poolRepository;
    private final InvestmentRepository investmentRepository;
    private final PoolService poolService;

    /**
     * Crear una nueva piscina de inversión
     */
    @Transactional
    public Pool createPool(CreatePoolRequest request) {
        // Validar nombre único
        if (poolRepository.existsByName(request.getName())) {
            throw new RuntimeException("Ya existe un pool con ese nombre");
        }

        // Validaciones
        if (request.getMaxParticipants() == null || request.getMaxParticipants() <= 0) {
            throw new RuntimeException("El límite de participantes debe ser mayor a 0");
        }

        if (request.getInterestRatePerDay() == null || request.getInterestRatePerDay() < 0) {
            throw new RuntimeException("La tasa de interés debe ser mayor o igual a 0");
        }

        Pool pool = Pool.builder()
                .name(request.getName())
                .description(request.getDescription())
                .interestRatePerDay(request.getInterestRatePerDay())
                .maxParticipants(request.getMaxParticipants())
                .build();

        return poolRepository.save(pool);
    }

    /**
     * Listar todos los pools con estadísticas
     */
    public List<PoolWithStatsDTO> getAllPools() {
        List<Pool> pools = poolRepository.findAll();

        return pools.stream()
                .map(this::buildPoolWithStats)
                .collect(Collectors.toList());
    }

    /**
     * Listar solo pools activos
     */
    public List<Pool> getActivePools() {
        return poolRepository.findByActiveTrue();
    }

    /**
     * Obtener pool por ID
     */
    public Pool getPoolById(Long id) {
        return poolRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pool no encontrado"));
    }

    /**
     * Actualizar un pool existente
     */
    @Transactional
    public Pool updatePool(Long id, UpdatePoolRequest request) {
        Pool pool = getPoolById(id);

        // Actualizar nombre si se proporciona y es diferente
        if (request.getName() != null && !request.getName().equals(pool.getName())) {
            if (poolRepository.existsByName(request.getName())) {
                throw new RuntimeException("Ya existe un pool con ese nombre");
            }
            pool.setName(request.getName());
        }

        // Actualizar descripción
        if (request.getDescription() != null) {
            pool.setDescription(request.getDescription());
        }

        // Actualizar límite de participantes
        if (request.getMaxParticipants() != null) {
            int currentInvestors = pool.getCurrentParticipantsCount();
            if (request.getMaxParticipants() < currentInvestors) {
                throw new RuntimeException(
                        "No se puede reducir el límite a " + request.getMaxParticipants() +
                                " porque ya hay " + currentInvestors + " inversores activos");
            }
            pool.setMaxParticipants(request.getMaxParticipants());
        }

        // Actualizar estado
        if (request.getActive() != null) {
            pool.setActive(request.getActive());
        }

        return poolRepository.save(pool);
    }

    /**
     * Eliminar un pool
     * Opción C: Forzar retiro automático de todas las inversiones
     */
    @Transactional
    public void deletePool(Long id) {
        Pool pool = getPoolById(id);

        // Obtener todas las inversiones activas del pool
        List<Investment> activeInvestments = investmentRepository.findByPoolIdAndStatus(
                id,
                InvestmentStatus.ACTIVE);

        // Forzar retiro de todas las inversiones activas
        for (Investment investment : activeInvestments) {
            poolService.withdraw(investment.getId());
        }

        // Eliminar el pool
        poolRepository.delete(pool);
    }

    /**
     * Obtener estadísticas de un pool específico
     */
    public PoolWithStatsDTO getPoolStats(Long poolId) {
        Pool pool = getPoolById(poolId);
        return buildPoolWithStats(pool);
    }

    /**
     * Construir DTO con estadísticas del pool
     */
    private PoolWithStatsDTO buildPoolWithStats(Pool pool) {
        List<Investment> activeInvestments = investmentRepository.findByPoolIdAndStatus(
                pool.getId(),
                InvestmentStatus.ACTIVE);

        int currentInvestors = (int) activeInvestments.stream()
                .map(Investment::getUserId)
                .distinct()
                .count();

        BigDecimal totalInvested = activeInvestments.stream()
                .map(Investment::getInvestedAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalCurrentValue = activeInvestments.stream()
                .map(this::calculateCurrentValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return PoolWithStatsDTO.builder()
                .pool(pool)
                .currentInvestors(currentInvestors)
                .availableSlots(pool.getMaxParticipants() - currentInvestors)
                .totalInvested(totalInvested)
                .totalCurrentValue(totalCurrentValue)
                .build();
    }

    /**
     * Calcular valor actual de una inversión con interés diario
     * Calcula días con fracciones (horas, minutos, segundos) para incremento en
     * tiempo real
     */
    private BigDecimal calculateCurrentValue(Investment inv) {
        if (inv.getPool() == null) {
            return inv.getInvestedAmount();
        }

        // Calcular tiempo transcurrido en SEGUNDOS y convertir a días decimales
        long secondsElapsed = Duration.between(inv.getInvestedAt(), LocalDateTime.now()).getSeconds();
        if (secondsElapsed < 0) {
            secondsElapsed = 0;
        }

        // Convertir segundos a días (con fracciones)
        // 1 día = 86400 segundos
        double daysElapsed = secondsElapsed / 86400.0;

        // Formula: Monto * (1 + tasa)^días
        double multiplier = Math.pow(1 + inv.getPool().getInterestRatePerDay(), daysElapsed);

        return inv.getInvestedAmount().multiply(BigDecimal.valueOf(multiplier));
    }
}
