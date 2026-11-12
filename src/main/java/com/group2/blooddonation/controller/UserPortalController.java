package com.group2.blooddonation.controller;

import com.group2.blooddonation.dto.BloodRequestForm;
import com.group2.blooddonation.dto.DonationRequestForm;
import com.group2.blooddonation.model.BloodGroup;
import com.group2.blooddonation.model.BloodRequest;
import com.group2.blooddonation.model.DonationRequest;
import com.group2.blooddonation.model.Gender;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.UrgencyLevel;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.service.BloodRequestService;
import com.group2.blooddonation.service.DonationRequestService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * User portal: dashboard, donating blood, requesting blood, and viewing my requests.
 */
@Controller
@RequestMapping("/user")
public class UserPortalController {

    private final DonationRequestService donationRequestService;
    private final BloodRequestService bloodRequestService;

    public UserPortalController(DonationRequestService donationRequestService,
                                BloodRequestService bloodRequestService) {
        this.donationRequestService = donationRequestService;
        this.bloodRequestService = bloodRequestService;
    }

    @ModelAttribute("bloodGroups")
    public BloodGroup[] bloodGroups() {
        return BloodGroup.values();
    }

    @ModelAttribute("genders")
    public Gender[] genders() {
        return Gender.values();
    }

    @ModelAttribute("urgencyLevels")
    public UrgencyLevel[] urgencyLevels() {
        return UrgencyLevel.values();
    }

    private User getLoggedInUser(HttpSession session) {
        Object userObj = session.getAttribute("currentUser");
        if (userObj instanceof User user) {
            return user;
        }
        return null;
    }

    // ----- User Dashboard -----

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model, RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirect.addFlashAttribute("errorMessage", "Please log in to view your dashboard.");
            return "redirect:/login?redirect=/user/dashboard";
        }

        List<DonationRequest> donationRequests = donationRequestService.getRequestsForUser(user);
        List<BloodRequest> bloodRequests = bloodRequestService.getRequestsForUser(user);

        long pendingDonations = donationRequests.stream().filter(r -> r.getStatus() == RequestStatus.PENDING).count();
        long approvedDonations = donationRequests.stream().filter(r -> r.getStatus() == RequestStatus.APPROVED || r.getStatus() == RequestStatus.COMPLETED).count();

        long pendingRequirements = bloodRequests.stream().filter(r -> r.getStatus() == RequestStatus.PENDING).count();
        long fulfilledRequirements = bloodRequests.stream().filter(r -> r.getStatus() == RequestStatus.FULFILLED).count();

        model.addAttribute("user", user);
        model.addAttribute("donationRequests", donationRequests);
        model.addAttribute("bloodRequests", bloodRequests);
        model.addAttribute("pendingDonations", pendingDonations);
        model.addAttribute("approvedDonations", approvedDonations);
        model.addAttribute("pendingRequirements", pendingRequirements);
        model.addAttribute("fulfilledRequirements", fulfilledRequirements);

        return "user/dashboard";
    }

    // ----- Donate Blood (New Donor Request) -----

    @GetMapping("/donate")
    public String showDonateForm(HttpSession session, Model model, RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirect.addFlashAttribute("errorMessage", "Please log in to send a blood donation request.");
            return "redirect:/login?redirect=/user/donate";
        }

        if (!model.containsAttribute("donationForm")) {
            model.addAttribute("donationForm", DonationRequestForm.prefill(user));
        }
        return "user/donate";
    }

    @PostMapping("/donate")
    public String submitDonateRequest(@Valid @ModelAttribute("donationForm") DonationRequestForm form,
                                     BindingResult result,
                                     HttpSession session,
                                     RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirect.addFlashAttribute("errorMessage", "Session expired. Please log in again.");
            return "redirect:/login?redirect=/user/donate";
        }

        if (result.hasErrors()) {
            return "user/donate";
        }

        DonationRequest request = donationRequestService.createRequest(user, form);
        redirect.addFlashAttribute("successMessage",
                "Your blood donation request has been submitted successfully! The admin team will review it shortly.");
        return "redirect:/user/my-requests";
    }

    // ----- Request Blood (Blood Requirement Request) -----

    @GetMapping("/request-blood")
    public String showBloodRequirementForm(HttpSession session, Model model, RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirect.addFlashAttribute("errorMessage", "Please log in to submit a blood requirement request.");
            return "redirect:/login?redirect=/user/request-blood";
        }

        if (!model.containsAttribute("requirementForm")) {
            model.addAttribute("requirementForm", BloodRequestForm.prefill(user));
        }
        return "user/request-blood";
    }

    @PostMapping("/request-blood")
    public String submitBloodRequirement(@Valid @ModelAttribute("requirementForm") BloodRequestForm form,
                                        BindingResult result,
                                        HttpSession session,
                                        RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirect.addFlashAttribute("errorMessage", "Session expired. Please log in again.");
            return "redirect:/login?redirect=/user/request-blood";
        }

        if (result.hasErrors()) {
            return "user/request-blood";
        }

        BloodRequest request = bloodRequestService.createRequest(user, form);
        redirect.addFlashAttribute("successMessage",
                "Your blood requirement request for " + form.getPatientName() + " (" + form.getBloodGroup().getLabel() + ") has been submitted!");
        return "redirect:/user/my-requests";
    }

    // ----- My Requests -----

    @GetMapping("/my-requests")
    public String viewMyRequests(HttpSession session, Model model, RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            redirect.addFlashAttribute("errorMessage", "Please log in to view your requests.");
            return "redirect:/login?redirect=/user/my-requests";
        }

        model.addAttribute("donationRequests", donationRequestService.getRequestsForUser(user));
        model.addAttribute("bloodRequests", bloodRequestService.getRequestsForUser(user));
        return "user/my-requests";
    }

    // ----- Cancel Requests -----

    @PostMapping("/requests/donation/{id}/cancel")
    public String cancelDonationRequest(@PathVariable Long id, HttpSession session, RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        boolean cancelled = donationRequestService.cancelRequest(id, user);
        if (cancelled) {
            redirect.addFlashAttribute("successMessage", "Donation request #" + id + " was cancelled.");
        } else {
            redirect.addFlashAttribute("errorMessage", "Could not cancel request. It may already be processed.");
        }
        return "redirect:/user/my-requests";
    }

    @PostMapping("/requests/blood/{id}/cancel")
    public String cancelBloodRequest(@PathVariable Long id, HttpSession session, RedirectAttributes redirect) {
        User user = getLoggedInUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        boolean cancelled = bloodRequestService.cancelRequest(id, user);
        if (cancelled) {
            redirect.addFlashAttribute("successMessage", "Blood requirement request #" + id + " was cancelled.");
        } else {
            redirect.addFlashAttribute("errorMessage", "Could not cancel request. It may already be processed.");
        }
        return "redirect:/user/my-requests";
    }
}
