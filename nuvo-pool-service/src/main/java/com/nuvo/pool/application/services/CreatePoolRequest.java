package com.nuvo.pool.application.services;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreatePoolRequest {

    private String name;

    private String description;

    private Double interestRatePerDay; // Tasa de interés diaria (ej: 0.01 = 1%)

    private Integer maxParticipants; // Límite de inversores
}
