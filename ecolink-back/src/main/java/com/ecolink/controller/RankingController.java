package com.ecolink.controller;

import com.ecolink.model.Ranking;
import com.ecolink.service.RankingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/rankings")
public class RankingController {

    @Autowired
    private RankingService rankingService;


    @PostMapping
    public ResponseEntity<Ranking> create(@RequestBody Ranking ranking) {
        Ranking created = rankingService.create(ranking);
        return ResponseEntity.ok(created);
    }


    @GetMapping("/{id}")
    public ResponseEntity<Ranking> getById(@PathVariable Long id) {
        Optional<Ranking> ranking = rankingService.getById(id);
        return ranking.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping("/user/{userId}")
    public ResponseEntity<Ranking> getByUserId(@PathVariable Long userId) {
        Optional<Ranking> ranking = rankingService.getByUserId(userId);
        return ranking.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping
    public ResponseEntity<List<Ranking>> getTopRankings() {
        List<Ranking> rankings = rankingService.getTopRankings();
        return ResponseEntity.ok(rankings);
    }


    @PutMapping("/user/{userId}/points")
    public ResponseEntity<Ranking> updatePoints(@PathVariable Long userId, @RequestParam Integer points) {
        Ranking updated = rankingService.updatePoints(userId, points);
        return ResponseEntity.ok(updated);
    }
}
