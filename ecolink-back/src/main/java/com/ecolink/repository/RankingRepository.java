package com.ecolink.repository;

import com.ecolink.model.Ranking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RankingRepository extends JpaRepository<Ranking, Long> {
    Optional<Ranking> findByUserId(Long userId);
    List<Ranking> findAllByOrderByTotalPointsDesc();
}
