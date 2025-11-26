package com.nuvo.loan.application.services;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdatePoolRequest {

    private String name;

    private String description;

    private Integer maxParticipants;

    private Boolean active;

    // Nota: No permitimos cambiar la tasa de interés de un pool existente
    // para mantener la integridad de las inversiones activas
}
