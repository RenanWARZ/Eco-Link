package com.ecolink.service;

import com.ecolink.model.Activity;
import com.ecolink.repository.ActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;


@Service
public class ActivityService {

    @Autowired
    private ActivityRepository activityRepository;


    public Activity create(Activity activity) {
        return activityRepository.save(activity);
    }


    public Optional<Activity> getById(Long id) {
        return activityRepository.findById(id);
    }


    public List<Activity> getUserHistory(Long userId) {
        return activityRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }


    public List<Activity> getByUserId(Long userId) {
        return activityRepository.findByUserId(userId);
    }
}
