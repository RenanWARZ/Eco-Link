package com.ecolink.controller;

import com.ecolink.model.Activity;
import com.ecolink.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/activities")
public class ActivityController {

    @Autowired
    private ActivityService activityService;


    @PostMapping
    public ResponseEntity<Activity> create(@RequestBody Activity activity) {
        Activity created = activityService.create(activity);
        return ResponseEntity.ok(created);
    }


    @GetMapping("/{id}")
    public ResponseEntity<Activity> getById(@PathVariable Long id) {
        Optional<Activity> activity = activityService.getById(id);
        return activity.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping("/user/{userId}/history")
    public ResponseEntity<List<Activity>> getUserHistory(@PathVariable Long userId) {
        List<Activity> activities = activityService.getUserHistory(userId);
        return ResponseEntity.ok(activities);
    }


    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Activity>> getByUserId(@PathVariable Long userId) {
        List<Activity> activities = activityService.getByUserId(userId);
        return ResponseEntity.ok(activities);
    }
}
