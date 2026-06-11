package com.ecolink.service;

import com.ecolink.model.RecyclingPoint;
import com.ecolink.repository.RecyclingPointRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RecyclingPointService {

    @Autowired
    private RecyclingPointRepository recyclingPointRepository;

    public List<RecyclingPoint> getAllActive() {
        return recyclingPointRepository.findByIsActiveTrue();
    }

    public Optional<RecyclingPoint> getById(Long id) {
        return recyclingPointRepository.findById(id);
    }

    public RecyclingPoint create(RecyclingPoint point) {
        return recyclingPointRepository.save(point);
    }

    public RecyclingPoint update(Long id, RecyclingPoint point) {
        Optional<RecyclingPoint> existing = recyclingPointRepository.findById(id);
        if (existing.isPresent()) {
            RecyclingPoint p = existing.get();
            p.setName(point.getName());
            p.setAddress(point.getAddress());
            p.setLatitude(point.getLatitude());
            p.setLongitude(point.getLongitude());
            p.setTypes(point.getTypes());
            p.setCapacity(point.getCapacity());
            p.setCurrentLoad(point.getCurrentLoad());
            p.setIsActive(point.getIsActive());
            return recyclingPointRepository.save(p);
        }
        throw new RuntimeException("RecyclingPoint not found");
    }

    public List<RecyclingPoint> getNearby(Double latitude, Double longitude, Double radiusKm) {
        List<RecyclingPoint> points = getAllActive();
        return points.stream()
                .filter(p -> calculateDistance(latitude, longitude, p.getLatitude(), p.getLongitude()) <= radiusKm)
                .toList();
    }

    private Double calculateDistance(Double lat1, Double lon1, Double lat2, Double lon2) {
        double R = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}
