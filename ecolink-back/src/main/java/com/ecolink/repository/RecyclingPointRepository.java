package com.ecolink.repository;

import com.ecolink.model.RecyclingPoint;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecyclingPointRepository extends JpaRepository<RecyclingPoint, Long> {
    List<RecyclingPoint> findByIsActiveTrue();
    
    @Query(value = "SELECT * FROM recycling_points WHERE is_active = true", nativeQuery = true)
    List<RecyclingPoint> findAllActive();
}
