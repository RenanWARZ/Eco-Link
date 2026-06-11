package com.ecolink.service;

import com.ecolink.model.User;
import com.ecolink.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User createOrUpdateUser(User user) {
        Optional<User> existing = userRepository.findByOpenId(user.getOpenId());
        if (existing.isPresent()) {
            User existingUser = existing.get();
            existingUser.setLastSignedIn(java.time.LocalDateTime.now());
            return userRepository.save(existingUser);
        }
        return userRepository.save(user);
    }

    public Optional<User> getUserByOpenId(String openId) {
        return userRepository.findByOpenId(openId);
    }

    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    public User updateUserPoints(Long userId, Integer points) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            User u = user.get();
            u.setPoints(u.getPoints() + points);
            return userRepository.save(u);
        }
        throw new RuntimeException("User not found");
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}
