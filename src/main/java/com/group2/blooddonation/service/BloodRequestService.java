package com.group2.blooddonation.service;

import com.group2.blooddonation.dto.BloodRequestForm;
import com.group2.blooddonation.model.BloodRequest;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.repository.BloodRequestRepository;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Service managing blood requirement requests submitted by users and fulfilled/reviewed by admins.
 */
@Service
@Transactional(readOnly = true)
public class BloodRequestService {

    private final BloodRequestRepository bloodRequestRepository;

    public BloodRequestService(BloodRequestRepository bloodRequestRepository) {
        this.bloodRequestRepository = bloodRequestRepository;
    }

    @Transactional
    public BloodRequest createRequest(User user, BloodRequestForm form) {
        BloodRequest req = new BloodRequest();
        req.setUser(user);
        req.setPatientName(form.getPatientName());
        req.setBloodGroup(form.getBloodGroup());
        req.setUnitsNeeded(form.getUnitsNeeded() != null ? form.getUnitsNeeded() : 1);
        req.setHospitalName(form.getHospitalName());
        req.setHospitalAddress(form.getHospitalAddress());
        req.setCity(form.getCity());
        req.setContactName(form.getContactName());
        req.setContactPhone(form.getContactPhone());
        req.setRequiredDate(form.getRequiredDate());
        req.setUrgency(form.getUrgency());
        req.setNotes(form.getNotes());
        req.setStatus(RequestStatus.PENDING);
        return bloodRequestRepository.save(req);
    }

    public List<BloodRequest> getRequestsForUser(User user) {
        return bloodRequestRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public List<BloodRequest> getAllRequests(RequestStatus statusFilter) {
        if (statusFilter == null) {
            return bloodRequestRepository.findAllByOrderByCreatedAtDesc();
        }
        return bloodRequestRepository.findByStatusOrderByCreatedAtDesc(statusFilter);
    }

    public BloodRequest getById(Long id) {
        return bloodRequestRepository.findById(id).orElse(null);
    }

    @Transactional
    public BloodRequest updateStatus(Long id, RequestStatus status, String adminNotes) {
        BloodRequest req = getById(id);
        if (req != null) {
            req.setStatus(status);
            if (adminNotes != null && !adminNotes.isBlank()) {
                req.setAdminNotes(adminNotes.trim());
            }
            return bloodRequestRepository.save(req);
        }
        return null;
    }

    @Transactional
    public boolean cancelRequest(Long id, User user) {
        BloodRequest req = getById(id);
        if (req != null && req.getUser() != null && req.getUser().getId().equals(user.getId())) {
            if (req.getStatus() == RequestStatus.PENDING) {
                req.setStatus(RequestStatus.CANCELLED);
                bloodRequestRepository.save(req);
                return true;
            }
        }
        return false;
    }

    public long countPending() {
        return bloodRequestRepository.countByStatus(RequestStatus.PENDING);
    }
}
