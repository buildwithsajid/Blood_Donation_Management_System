package com.group2.blooddonation.controller;

import com.group2.blooddonation.dto.DashboardStats;
import com.group2.blooddonation.model.BloodRequest;
import com.group2.blooddonation.model.DonationRequest;
import com.group2.blooddonation.model.Donor;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.service.BloodRequestService;
import com.group2.blooddonation.service.DonationRequestService;
import com.group2.blooddonation.service.DonorService;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Controller for administrator actions on New Donor Requests and Blood Requirement Requests.
 */
@Controller
@RequestMapping("/admin")
public class AdminRequestController {

    private final DonationRequestService donationRequestService;
    private final BloodRequestService bloodRequestService;
    private final DonorService donorService;

    public AdminRequestController(DonationRequestService donationRequestService,
                                  BloodRequestService bloodRequestService,
                                  DonorService donorService) {
        this.donationRequestService = donationRequestService;
        this.bloodRequestService = bloodRequestService;
        this.donorService = donorService;
    }

    private boolean checkAdmin(HttpSession session, RedirectAttributes redirect) {
        Object role = session.getAttribute("userRole");
        if (!"ADMIN".equals(role)) {
            redirect.addFlashAttribute("errorMessage", "Administrator login required to access this page.");
            return false;
        }
        return true;
    }

    // ----- Admin Dashboard -----

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model, RedirectAttributes redirect) {
        if (!checkAdmin(session, redirect)) {
            return "redirect:/admin/login?redirect=/admin/dashboard";
        }

        DashboardStats donorStats = donorService.getDashboardStats();
        long pendingDonationRequests = donationRequestService.countPending();
        long pendingBloodRequests = bloodRequestService.countPending();
        List<DonationRequest> recentDonationRequests = donationRequestService.getAllRequests(null).stream().limit(5).toList();
        List<BloodRequest> recentBloodRequests = bloodRequestService.getAllRequests(null).stream().limit(5).toList();

        model.addAttribute("donorStats", donorStats);
        model.addAttribute("pendingDonationRequests", pendingDonationRequests);
        model.addAttribute("pendingBloodRequests", pendingBloodRequests);
        model.addAttribute("recentDonationRequests", recentDonationRequests);
        model.addAttribute("recentBloodRequests", recentBloodRequests);

        return "admin/dashboard";
    }

    // ----- New Donor Requests -----

    @GetMapping("/donor-requests")
    public String donorRequests(@RequestParam(required = false) RequestStatus status,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirect) {
        if (!checkAdmin(session, redirect)) {
            return "redirect:/admin/login?redirect=/admin/donor-requests";
        }

        List<DonationRequest> requests = donationRequestService.getAllRequests(status);
        model.addAttribute("requests", requests);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("statuses", RequestStatus.values());
        model.addAttribute("pendingCount", donationRequestService.countPending());

        return "admin/donor-requests";
    }

    @PostMapping("/donor-requests/{id}/status")
    public String updateDonorRequestStatus(@PathVariable Long id,
                                          @RequestParam RequestStatus status,
                                          @RequestParam(required = false) String adminNotes,
                                          HttpSession session,
                                          RedirectAttributes redirect) {
        if (!checkAdmin(session, redirect)) {
            return "redirect:/admin/login";
        }

        DonationRequest req = donationRequestService.updateStatus(id, status, adminNotes);
        if (req != null) {
            redirect.addFlashAttribute("successMessage",
                    "Donor request #" + id + " from " + req.getFullName() + " marked as " + status.getLabel() + ".");
        }
        return "redirect:/admin/donor-requests";
    }

    @PostMapping("/donor-requests/{id}/approve-and-add")
    public String approveAndAddDonor(@PathVariable Long id,
                                     @RequestParam(required = false) String adminNotes,
                                     HttpSession session,
                                     RedirectAttributes redirect) {
        if (!checkAdmin(session, redirect)) {
            return "redirect:/admin/login";
        }

        Donor donor = donationRequestService.approveAndAddToDonors(id, adminNotes);
        if (donor != null) {
            redirect.addFlashAttribute("successMessage",
                    "Request approved! " + donor.getFullName() + " has been added to the Donors Registry.");
        }
        return "redirect:/admin/donor-requests";
    }

    // ----- Blood Requirement Requests -----

    @GetMapping("/blood-requests")
    public String bloodRequests(@RequestParam(required = false) RequestStatus status,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirect) {
        if (!checkAdmin(session, redirect)) {
            return "redirect:/admin/login?redirect=/admin/blood-requests";
        }

        List<BloodRequest> requests = bloodRequestService.getAllRequests(status);
        model.addAttribute("requests", requests);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("statuses", RequestStatus.values());
        model.addAttribute("pendingCount", bloodRequestService.countPending());

        return "admin/blood-requests";
    }

    @PostMapping("/blood-requests/{id}/status")
    public String updateBloodRequestStatus(@PathVariable Long id,
                                          @RequestParam RequestStatus status,
                                          @RequestParam(required = false) String adminNotes,
                                          HttpSession session,
                                          RedirectAttributes redirect) {
        if (!checkAdmin(session, redirect)) {
            return "redirect:/admin/login";
        }

        BloodRequest req = bloodRequestService.updateStatus(id, status, adminNotes);
        if (req != null) {
            redirect.addFlashAttribute("successMessage",
                    "Blood request #" + id + " for " + req.getPatientName() + " (" + req.getBloodGroup().getLabel() + ") marked as " + status.getLabel() + ".");
        }
        return "redirect:/admin/blood-requests";
    }
}
