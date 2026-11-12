package com.group2.blooddonation.repository;

import com.group2.blooddonation.model.DonationRequest;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.User;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonationRequestRepository extends JpaRepository<DonationRequest, Long> {

    List<DonationRequest> findByUserOrderByCreatedAtDesc(User user);

    List<DonationRequest> findAllByOrderByCreatedAtDesc();

    List<DonationRequest> findByStatusOrderByCreatedAtDesc(RequestStatus status);

    long countByStatus(RequestStatus status);
}
