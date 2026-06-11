package com.ecolink.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "users", indexes = {
    @Index(name = "idx_openId", columnList = "openId"),
    @Index(name = "idx_role", columnList = "role")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 64)
    private String openId;

    @Column(length = 255)
    private String name;

    @Column(length = 320)
    private String email;

    @Column(length = 64)
    private String loginMethod;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role;

    @Column(nullable = false)
    private Integer points;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Column
    private Double latitude;

    @Column
    private Double longitude;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @Column(nullable = false)
    private LocalDateTime lastSignedIn;

    public enum UserRole {
        CITIZEN,
        ADMIN
    }

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        if (this.createdAt == null)    this.createdAt    = now;
        if (this.updatedAt == null)    this.updatedAt    = now;
        if (this.lastSignedIn == null) this.lastSignedIn = now;
        if (this.role == null)         this.role         = UserRole.CITIZEN;
        if (this.points == null)       this.points       = 0;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
