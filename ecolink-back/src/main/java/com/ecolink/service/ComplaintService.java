package com.ecolink.service;

import com.ecolink.model.Complaint;
import com.ecolink.repository.ComplaintRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;


@Service
public class ComplaintService {

    @Autowired
    private ComplaintRepository complaintRepository;


    public Complaint create(Complaint complaint) {
        return complaintRepository.save(complaint);
    }


    public Optional<Complaint> getById(Long id) {
        return complaintRepository.findById(id);
    }


    public List<Complaint> getByUserId(Long userId) {
        return complaintRepository.findByUserId(userId);
    }


    public List<Complaint> getByStatus(Complaint.ComplaintStatus status) {
        return complaintRepository.findByStatus(status);
    }


    public List<Complaint> getByPriority(Complaint.Priority priority) {
        return complaintRepository.findByPriority(priority);
    }


    public Complaint update(Long id, Complaint complaint) {
        Optional<Complaint> existing = complaintRepository.findById(id);
        if (existing.isPresent()) {
            Complaint c = existing.get();
            c.setTitle(complaint.getTitle());
            c.setDescription(complaint.getDescription());
            c.setLatitude(complaint.getLatitude());
            c.setLongitude(complaint.getLongitude());
            c.setPriority(complaint.getPriority());
            c.setStatus(complaint.getStatus());
            c.setImageUrl(complaint.getImageUrl());
            return complaintRepository.save(c);
        }
        throw new RuntimeException("Complaint not found");
    }


    public Complaint updateStatus(Long id, Complaint.ComplaintStatus status) {
        Optional<Complaint> existing = complaintRepository.findById(id);
        if (existing.isPresent()) {
            Complaint c = existing.get();
            c.setStatus(status);
            return complaintRepository.save(c);
        }
        throw new RuntimeException("Complaint not found");
    }
}
