package com.nuvo.loan.repository;

import com.nuvo.loan.entity.Pool;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PoolRepository extends JpaRepository<Pool, Long> {

    /**
     * Encuentra todos los pools activos
     */
    List<Pool> findByActiveTrue();

    /**
     * Busca un pool por nombre
     */
    Optional<Pool> findByName(String name);

    /**
     * Verifica si existe un pool con ese nombre
     */
    boolean existsByName(String name);

    /**
     * Obtiene pools con su conteo de inversores
     */
    @Query("SELECT p FROM Pool p LEFT JOIN FETCH p.investments i " +
            "WHERE i.status = 'ACTIVE' OR i IS NULL")
    List<Pool> findAllWithActiveInvestments();
}
