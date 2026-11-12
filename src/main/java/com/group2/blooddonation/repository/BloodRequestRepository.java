package com.group2.blooddonation.repository;

import com.group2.blooddonation.model.BloodRequest;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.User;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BloodRequestRepository extends JpaRepository<BloodRequest, Long> {

    List<BloodRequest> findByUserOrderByCreatedAtDesc(User user);

    List<BloodRequest> findAllByOrderByCreatedAtDesc();

    List<BloodRequest> findByStatusOrderByCreatedAtDesc(RequestStatus status);

    long countByStatus(RequestStatus status);
}
