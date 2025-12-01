package com.nuvo.pool.application.services;

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

    private Double interestRatePerDay;
}
