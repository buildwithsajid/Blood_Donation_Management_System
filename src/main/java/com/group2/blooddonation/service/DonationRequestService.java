package com.group2.blooddonation.service;

import com.group2.blooddonation.dto.DonationRequestForm;
import com.group2.blooddonation.model.DonationRequest;
import com.group2.blooddonation.model.Donor;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.repository.DonationRequestRepository;
import com.group2.blooddonation.repository.DonorRepository;
import java.time.LocalDate;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Service managing blood donation requests submitted by users and reviewed by admins.
 */
@Service
@Transactional(readOnly = true)
public class DonationRequestService {

    private final DonationRequestRepository donationRequestRepository;
    private final DonorRepository donorRepository;

    public DonationRequestService(DonationRequestRepository donationRequestRepository,
                                  DonorRepository donorRepository) {
        this.donationRequestRepository = donationRequestRepository;
        this.donorRepository = donorRepository;
    }

    @Transactional
    public DonationRequest createRequest(User user, DonationRequestForm form) {
        DonationRequest req = new DonationRequest();
        req.setUser(user);
        req.setFullName(form.getFullName());
        req.setPhone(form.getPhone());
        req.setEmail(form.getEmail());
        req.setBloodGroup(form.getBloodGroup());
        req.setGender(form.getGender());
        req.setAge(form.getAge());
        req.setCity(form.getCity());
        req.setPreferredDate(form.getPreferredDate());
        req.setMedicalDetails(form.getMedicalDetails());
        req.setStatus(RequestStatus.PENDING);
        return donationRequestRepository.save(req);
    }

    public List<DonationRequest> getRequestsForUser(User user) {
        return donationRequestRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public List<DonationRequest> getAllRequests(RequestStatus statusFilter) {
        if (statusFilter == null) {
            return donationRequestRepository.findAllByOrderByCreatedAtDesc();
        }
        return donationRequestRepository.findByStatusOrderByCreatedAtDesc(statusFilter);
    }

    public DonationRequest getById(Long id) {
        return donationRequestRepository.findById(id).orElse(null);
    }

    @Transactional
    public DonationRequest updateStatus(Long id, RequestStatus status, String adminNotes) {
        DonationRequest req = getById(id);
        if (req != null) {
            req.setStatus(status);
            if (adminNotes != null && !adminNotes.isBlank()) {
                req.setAdminNotes(adminNotes.trim());
            }
            return donationRequestRepository.save(req);
        }
        return null;
    }

    /**
     * Approves the request AND automatically registers or updates the donor in the official donors registry.
     */
    @Transactional
    public Donor approveAndAddToDonors(Long requestId, String adminNotes) {
        DonationRequest req = getById(id(requestId));
        if (req == null) {
            return null;
        }

        req.setStatus(RequestStatus.APPROVED);
        if (adminNotes != null && !adminNotes.isBlank()) {
            req.setAdminNotes(adminNotes.trim());
        }
        donationRequestRepository.save(req);

        // Check if a donor with this phone already exists
        Donor donor = donorRepository.findAll().stream()
                .filter(d -> req.getPhone().equals(d.getPhone()))
                .findFirst()
                .orElse(null);

        if (donor == null) {
            donor = new Donor();
        }

        donor.setFullName(req.getFullName());
        donor.setPhone(req.getPhone());
        donor.setEmail(req.getEmail());
        donor.setBloodGroup(req.getBloodGroup());
        donor.setGender(req.getGender());
        donor.setAge(req.getAge());
        donor.setCity(req.getCity());
        donor.setAvailable(true);
        if (req.getStatus() == RequestStatus.COMPLETED) {
            donor.setLastDonationDate(LocalDate.now());
        }
        return donorRepository.save(donor);
    }

    @Transactional
    public boolean cancelRequest(Long id, User user) {
        DonationRequest req = getById(id);
        if (req != null && req.getUser() != null && req.getUser().getId().equals(user.getId())) {
            if (req.getStatus() == RequestStatus.PENDING) {
                req.setStatus(RequestStatus.CANCELLED);
                donationRequestRepository.save(req);
                return true;
            }
        }
        return false;
    }

    public long countPending() {
        return donationRequestRepository.countByStatus(RequestStatus.PENDING);
    }

    private Long id(Long id) {
        return id;
    }
}
