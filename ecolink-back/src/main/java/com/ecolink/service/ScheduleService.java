package com.ecolink.service;

import com.ecolink.model.Schedule;
import com.ecolink.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;


@Service
public class ScheduleService {

    @Autowired
    private ScheduleRepository scheduleRepository;


    public Schedule create(Schedule schedule) {
        return scheduleRepository.save(schedule);
    }


    public Optional<Schedule> getById(Long id) {
        return scheduleRepository.findById(id);
    }


    public List<Schedule> getByUserId(Long userId) {
        return scheduleRepository.findByUserId(userId);
    }


    public List<Schedule> getByStatus(Schedule.ScheduleStatus status) {
        return scheduleRepository.findByStatus(status);
    }

    public Schedule update(Long id, Schedule schedule) {
        Optional<Schedule> existing = scheduleRepository.findById(id);
        if (existing.isPresent()) {
            Schedule s = existing.get();
            s.setWasteType(schedule.getWasteType());
            s.setAddress(schedule.getAddress());
            s.setLatitude(schedule.getLatitude());
            s.setLongitude(schedule.getLongitude());
            s.setScheduledDate(schedule.getScheduledDate());
            s.setDescription(schedule.getDescription());
            s.setStatus(schedule.getStatus());
            return scheduleRepository.save(s);
        }
        throw new RuntimeException("Schedule not found");
    }

    public Schedule cancel(Long id) {
        Optional<Schedule> existing = scheduleRepository.findById(id);
        if (existing.isPresent()) {
            Schedule s = existing.get();
            s.setStatus(Schedule.ScheduleStatus.CANCELLED);
            return scheduleRepository.save(s);
        }
        throw new RuntimeException("Schedule not found");
    }
}
