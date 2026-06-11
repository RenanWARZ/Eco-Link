package com.ecolink.controller;

import com.ecolink.model.User;
import com.ecolink.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;


@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;


    @PostMapping
    public ResponseEntity<User> createOrUpdate(@RequestBody User user) {
        User created = userService.createOrUpdateUser(user);
        return ResponseEntity.ok(created);
    }


    @GetMapping("/{id}")
    public ResponseEntity<User> getById(@PathVariable Long id) {
        Optional<User> user = userService.getUserById(id);
        return user.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping("/openid/{openId}")
    public ResponseEntity<User> getByOpenId(@PathVariable String openId) {
        Optional<User> user = userService.getUserByOpenId(openId);
        return user.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @PutMapping("/{id}/points")
    public ResponseEntity<User> updatePoints(@PathVariable Long id, @RequestParam Integer points) {
        User updated = userService.updateUserPoints(id, points);
        return ResponseEntity.ok(updated);
    }
}
