package com.ecolink.service;

import com.ecolink.model.Ranking;
import com.ecolink.repository.RankingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;


@Service
public class RankingService {

    @Autowired
    private RankingRepository rankingRepository;


    public Ranking create(Ranking ranking) {
        return rankingRepository.save(ranking);
    }


    public Optional<Ranking> getById(Long id) {
        return rankingRepository.findById(id);
    }


    public Optional<Ranking> getByUserId(Long userId) {
        return rankingRepository.findByUserId(userId);
    }


    public List<Ranking> getTopRankings() {
        return rankingRepository.findAllByOrderByTotalPointsDesc();
    }


    public Ranking updatePoints(Long userId, Integer points) {
        Optional<Ranking> existing = rankingRepository.findByUserId(userId);
        if (existing.isPresent()) {
            Ranking r = existing.get();
            r.setTotalPoints(r.getTotalPoints() + points);
            return rankingRepository.save(r);
        }
        throw new RuntimeException("Ranking not found");
    }
}
