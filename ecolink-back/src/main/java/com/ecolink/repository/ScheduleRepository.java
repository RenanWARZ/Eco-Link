package com.ecolink.repository;

import com.ecolink.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    List<Schedule> findByUserId(Long userId);
    List<Schedule> findByStatus(Schedule.ScheduleStatus status);
}
