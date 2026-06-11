package com.ecolink.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "rankings", indexes = {
    @Index(name = "idx_ranking_points", columnList = "totalPoints"),
    @Index(name = "idx_ranking_rank", columnList = "rank")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ranking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private User user;

    @Column(nullable = false)
    private Integer totalPoints;

    @Column
    private Integer rank;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        if (this.updatedAt == null)    this.updatedAt    = LocalDateTime.now();
        if (this.totalPoints == null)  this.totalPoints  = 0;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
