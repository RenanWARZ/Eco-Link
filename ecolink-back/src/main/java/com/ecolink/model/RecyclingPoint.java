package com.ecolink.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "recycling_points", indexes = {
    @Index(name = "idx_rp_location", columnList = "latitude,longitude"),
    @Index(name = "idx_rp_active", columnList = "isActive")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecyclingPoint {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String address;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String types;

    @Column
    private Integer capacity;

    @Column(nullable = false)
    private Integer currentLoad;

    @Column(nullable = false)
    private Boolean isActive;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (this.createdAt == null)   this.createdAt   = now;
        if (this.updatedAt == null)   this.updatedAt   = now;
        if (this.currentLoad == null) this.currentLoad = 0;
        if (this.isActive == null)    this.isActive    = true;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public Double getOccupancyRate() {
        if (capacity == null || capacity == 0) return 0.0;
        return (currentLoad.doubleValue() / capacity) * 100;
    }

    public Boolean isFull() {
        return getOccupancyRate() >= 90.0;
    }
}
