package com.group2.blooddonation.controller;

import com.group2.blooddonation.dto.LoginForm;
import com.group2.blooddonation.dto.RegisterForm;
import com.group2.blooddonation.model.BloodGroup;
import com.group2.blooddonation.model.Gender;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.model.UserRole;
import com.group2.blooddonation.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.util.Optional;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Handles authentication for both regular Users and Administrators.
 */
@Controller
public class AuthController {

    private static final String LOGIN_VIEW = "auth/login";
    private static final String ADMIN_LOGIN_VIEW = "auth/admin-login";
    private static final String REGISTER_VIEW = "auth/register";

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @ModelAttribute("bloodGroups")
    public BloodGroup[] bloodGroups() {
        return BloodGroup.values();
    }

    @ModelAttribute("genders")
    public Gender[] genders() {
        return Gender.values();
    }

    // ----- User Login -----

    @GetMapping("/login")
    public String showUserLoginForm(@RequestParam(required = false) String redirect, Model model) {
        if (!model.containsAttribute("loginForm")) {
            model.addAttribute("loginForm", new LoginForm());
        }
        model.addAttribute("redirectUrl", redirect);
        return LOGIN_VIEW;
    }

    @PostMapping("/login")
    public String processUserLogin(@Valid @ModelAttribute("loginForm") LoginForm form,
                                  BindingResult result,
                                  @RequestParam(required = false) String redirectUrl,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirect) {
        if (result.hasErrors()) {
            model.addAttribute("redirectUrl", redirectUrl);
            return LOGIN_VIEW;
        }

        Optional<User> userOpt = userService.authenticate(form.getUsernameOrEmail(), form.getPassword(), UserRole.USER);
        if (userOpt.isEmpty()) {
            result.reject("invalid.credentials", "Invalid username/email or password for User account.");
            model.addAttribute("redirectUrl", redirectUrl);
            return LOGIN_VIEW;
        }

        User user = userOpt.get();
        session.setAttribute("currentUser", user);
        session.setAttribute("userRole", "USER");

        redirect.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "!");
        if (redirectUrl != null && !redirectUrl.isBlank() && redirectUrl.startsWith("/")) {
            return "redirect:" + redirectUrl;
        }
        return "redirect:/user/dashboard";
    }

    // ----- Admin Login -----

    @GetMapping("/admin/login")
    public String showAdminLoginForm(@RequestParam(required = false) String redirect, Model model) {
        if (!model.containsAttribute("loginForm")) {
            LoginForm form = new LoginForm();
            form.setUsernameOrEmail("admin");
            model.addAttribute("loginForm", form);
        }
        model.addAttribute("redirectUrl", redirect);
        return ADMIN_LOGIN_VIEW;
    }

    @PostMapping("/admin/login")
    public String processAdminLogin(@Valid @ModelAttribute("loginForm") LoginForm form,
                                   BindingResult result,
                                   @RequestParam(required = false) String redirectUrl,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirect) {
        if (result.hasErrors()) {
            model.addAttribute("redirectUrl", redirectUrl);
            return ADMIN_LOGIN_VIEW;
        }

        Optional<User> adminOpt = userService.authenticate(form.getUsernameOrEmail(), form.getPassword(), UserRole.ADMIN);
        if (adminOpt.isEmpty()) {
            result.reject("invalid.admin.credentials", "Invalid administrator credentials.");
            model.addAttribute("redirectUrl", redirectUrl);
            return ADMIN_LOGIN_VIEW;
        }

        User admin = adminOpt.get();
        session.setAttribute("currentUser", admin);
        session.setAttribute("userRole", "ADMIN");

        redirect.addFlashAttribute("successMessage", "Logged in as Administrator (" + admin.getFullName() + ")");
        if (redirectUrl != null && !redirectUrl.isBlank() && redirectUrl.startsWith("/")) {
            return "redirect:" + redirectUrl;
        }
        return "redirect:/admin/dashboard";
    }

    // ----- User Registration -----

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        if (!model.containsAttribute("registerForm")) {
            model.addAttribute("registerForm", new RegisterForm());
        }
        return REGISTER_VIEW;
    }

    @PostMapping("/register")
    public String processRegistration(@Valid @ModelAttribute("registerForm") RegisterForm form,
                                      BindingResult result,
                                      HttpSession session,
                                      RedirectAttributes redirect) {
        if (userService.isUsernameTaken(form.getUsername())) {
            result.rejectValue("username", "duplicate", "This username is already taken");
        }
        if (userService.isEmailTaken(form.getEmail())) {
            result.rejectValue("email", "duplicate", "This email address is already registered");
        }

        if (result.hasErrors()) {
            return REGISTER_VIEW;
        }

        User user = userService.register(form);
        session.setAttribute("currentUser", user);
        session.setAttribute("userRole", "USER");

        redirect.addFlashAttribute("successMessage", "Account created successfully! Welcome, " + user.getFullName() + ".");
        return "redirect:/user/dashboard";
    }

    // ----- Logout -----

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirect) {
        session.invalidate();
        redirect.addFlashAttribute("successMessage", "You have been logged out successfully.");
        return "redirect:/";
    }
}
