package com.ecolink.controller;

import com.ecolink.model.Schedule;
import com.ecolink.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/schedules")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;


    @PostMapping
    public ResponseEntity<Schedule> create(@RequestBody Schedule schedule) {
        Schedule created = scheduleService.create(schedule);
        return ResponseEntity.ok(created);
    }


    @GetMapping("/{id}")
    public ResponseEntity<Schedule> getById(@PathVariable Long id) {
        Optional<Schedule> schedule = scheduleService.getById(id);
        return schedule.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Schedule>> getByUserId(@PathVariable Long userId) {
        List<Schedule> schedules = scheduleService.getByUserId(userId);
        return ResponseEntity.ok(schedules);
    }


    @GetMapping("/status/{status}")
    public ResponseEntity<List<Schedule>> getByStatus(@PathVariable String status) {
        Schedule.ScheduleStatus scheduleStatus = Schedule.ScheduleStatus.valueOf(status);
        List<Schedule> schedules = scheduleService.getByStatus(scheduleStatus);
        return ResponseEntity.ok(schedules);
    }


    @PutMapping("/{id}")
    public ResponseEntity<Schedule> update(@PathVariable Long id, @RequestBody Schedule schedule) {
        Schedule updated = scheduleService.update(id, schedule);
        return ResponseEntity.ok(updated);
    }


    @PutMapping("/{id}/cancel")
    public ResponseEntity<Schedule> cancel(@PathVariable Long id) {
        Schedule cancelled = scheduleService.cancel(id);
        return ResponseEntity.ok(cancelled);
    }
}
