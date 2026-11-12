package com.group2.blooddonation.controller;

import com.group2.blooddonation.model.User;
import com.group2.blooddonation.service.BloodRequestService;
import com.group2.blooddonation.service.DonationRequestService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Supplies authentication context and notification counts to every JSP page.
 */
@ControllerAdvice
public class GlobalModelAttributes {

    private final DonationRequestService donationRequestService;
    private final BloodRequestService bloodRequestService;

    public GlobalModelAttributes(DonationRequestService donationRequestService,
                                 BloodRequestService bloodRequestService) {
        this.donationRequestService = donationRequestService;
        this.bloodRequestService = bloodRequestService;
    }

    private HttpSession getSession(HttpServletRequest request) {
        return request != null ? request.getSession(false) : null;
    }

    @ModelAttribute("currentUser")
    public User currentUser(HttpServletRequest request) {
        HttpSession session = getSession(request);
        return session != null ? (User) session.getAttribute("currentUser") : null;
    }

    @ModelAttribute("userRole")
    public String userRole(HttpServletRequest request) {
        HttpSession session = getSession(request);
        return session != null ? (String) session.getAttribute("userRole") : null;
    }

    @ModelAttribute("isAdmin")
    public boolean isAdmin(HttpServletRequest request) {
        HttpSession session = getSession(request);
        return session != null && "ADMIN".equals(session.getAttribute("userRole"));
    }

    @ModelAttribute("isUser")
    public boolean isUser(HttpServletRequest request) {
        HttpSession session = getSession(request);
        return session != null && "USER".equals(session.getAttribute("userRole"));
    }

    @ModelAttribute("pendingDonorRequestsCount")
    public long pendingDonorRequestsCount(HttpServletRequest request) {
        HttpSession session = getSession(request);
        if (session != null && "ADMIN".equals(session.getAttribute("userRole"))) {
            return donationRequestService.countPending();
        }
        return 0;
    }

    @ModelAttribute("pendingBloodRequestsCount")
    public long pendingBloodRequestsCount(HttpServletRequest request) {
        HttpSession session = getSession(request);
        if (session != null && "ADMIN".equals(session.getAttribute("userRole"))) {
            return bloodRequestService.countPending();
        }
        return 0;
    }
}
