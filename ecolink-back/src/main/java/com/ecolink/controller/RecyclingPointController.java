package com.ecolink.controller;

import com.ecolink.model.RecyclingPoint;
import com.ecolink.service.RecyclingPointService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/recycling-points")
public class RecyclingPointController {

    @Autowired
    private RecyclingPointService recyclingPointService;


    @GetMapping
    public ResponseEntity<List<RecyclingPoint>> getAllActive() {
        List<RecyclingPoint> points = recyclingPointService.getAllActive();
        return ResponseEntity.ok(points);
    }


    @GetMapping("/{id}")
    public ResponseEntity<RecyclingPoint> getById(@PathVariable Long id) {
        Optional<RecyclingPoint> point = recyclingPointService.getById(id);
        return point.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @PostMapping
    public ResponseEntity<RecyclingPoint> create(@RequestBody RecyclingPoint point) {
        RecyclingPoint created = recyclingPointService.create(point);
        return ResponseEntity.ok(created);
    }


    @PutMapping("/{id}")
    public ResponseEntity<RecyclingPoint> update(@PathVariable Long id, @RequestBody RecyclingPoint point) {
        RecyclingPoint updated = recyclingPointService.update(id, point);
        return ResponseEntity.ok(updated);
    }


    @GetMapping("/nearby")
    public ResponseEntity<List<RecyclingPoint>> getNearby(
            @RequestParam Double latitude,
            @RequestParam Double longitude,
            @RequestParam(defaultValue = "5.0") Double radiusKm) {
        List<RecyclingPoint> points = recyclingPointService.getNearby(latitude, longitude, radiusKm);
        return ResponseEntity.ok(points);
    }
}
