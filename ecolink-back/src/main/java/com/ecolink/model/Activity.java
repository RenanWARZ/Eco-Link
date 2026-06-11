package com.ecolink.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "activities", indexes = {
    @Index(name = "idx_activity_userId", columnList = "user_id"),
    @Index(name = "idx_activity_createdAt", columnList = "createdAt")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Activity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ActivityType type;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Integer pointsEarned;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public enum ActivityType {
        SCHEDULE, COMPLAINT, RECYCLING, ACHIEVEMENT
    }

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null)   this.createdAt   = LocalDateTime.now();
        if (this.pointsEarned == null) this.pointsEarned = 0;
    }
}
