package com.nuvo.pool.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Pool {
    private Long id;
    private String name;
    private String description;
    private Double interestRatePerDay;
    private Integer maxParticipants;
    private Boolean active;
    private LocalDateTime createdAt;
    private List<Investment> investments;

    public int getCurrentParticipantsCount() {
        if (investments == null) {
            return 0;
        }
        return (int) investments.stream()
                .filter(inv -> inv.getStatus() == InvestmentStatus.ACTIVE)
                .map(Investment::getUserId)
                .distinct()
                .count();
    }

    public boolean isFull() {
        return getCurrentParticipantsCount() >= maxParticipants;
    }

    public boolean canAcceptNewInvestor() {
        return Boolean.TRUE.equals(active) && !isFull();
    }
}
