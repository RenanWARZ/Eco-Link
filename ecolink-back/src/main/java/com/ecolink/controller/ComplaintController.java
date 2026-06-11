package com.ecolink.controller;

import com.ecolink.model.Complaint;
import com.ecolink.service.ComplaintService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/complaints")
public class ComplaintController {

    @Autowired
    private ComplaintService complaintService;


    @PostMapping
    public ResponseEntity<Complaint> create(@RequestBody Complaint complaint) {
        Complaint created = complaintService.create(complaint);
        return ResponseEntity.ok(created);
    }


    @GetMapping("/{id}")
    public ResponseEntity<Complaint> getById(@PathVariable Long id) {
        Optional<Complaint> complaint = complaintService.getById(id);
        return complaint.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Complaint>> getByUserId(@PathVariable Long userId) {
        List<Complaint> complaints = complaintService.getByUserId(userId);
        return ResponseEntity.ok(complaints);
    }


    @GetMapping("/status/{status}")
    public ResponseEntity<List<Complaint>> getByStatus(@PathVariable String status) {
        Complaint.ComplaintStatus complaintStatus = Complaint.ComplaintStatus.valueOf(status);
        List<Complaint> complaints = complaintService.getByStatus(complaintStatus);
        return ResponseEntity.ok(complaints);
    }


    @GetMapping("/priority/{priority}")
    public ResponseEntity<List<Complaint>> getByPriority(@PathVariable String priority) {
        Complaint.Priority complaintPriority = Complaint.Priority.valueOf(priority);
        List<Complaint> complaints = complaintService.getByPriority(complaintPriority);
        return ResponseEntity.ok(complaints);
    }


    @PutMapping("/{id}")
    public ResponseEntity<Complaint> update(@PathVariable Long id, @RequestBody Complaint complaint) {
        Complaint updated = complaintService.update(id, complaint);
        return ResponseEntity.ok(updated);
    }


    @PutMapping("/{id}/status")
    public ResponseEntity<Complaint> updateStatus(@PathVariable Long id, @RequestParam String status) {
        Complaint.ComplaintStatus complaintStatus = Complaint.ComplaintStatus.valueOf(status);
        Complaint updated = complaintService.updateStatus(id, complaintStatus);
        return ResponseEntity.ok(updated);
    }
}
