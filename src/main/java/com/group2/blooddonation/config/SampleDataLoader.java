package com.group2.blooddonation.config;

import com.group2.blooddonation.model.BloodGroup;
import com.group2.blooddonation.model.BloodRequest;
import com.group2.blooddonation.model.DonationRequest;
import com.group2.blooddonation.model.Donor;
import com.group2.blooddonation.model.Gender;
import com.group2.blooddonation.model.RequestStatus;
import com.group2.blooddonation.model.UrgencyLevel;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.model.UserRole;
import com.group2.blooddonation.repository.BloodRequestRepository;
import com.group2.blooddonation.repository.DonationRequestRepository;
import com.group2.blooddonation.repository.DonorRepository;
import com.group2.blooddonation.repository.UserRepository;
import java.time.LocalDate;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBooleanProperty;
import org.springframework.stereotype.Component;

/**
 * Adds made-up donors, users, and requests when the app starts with an empty database, so every page
 * has something to show. On by default only on your laptop
 * ({@code app.sample-data.enabled} in application-local.properties).
 */
@Component
@ConditionalOnBooleanProperty("app.sample-data.enabled")
public class SampleDataLoader implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(SampleDataLoader.class);

    private final DonorRepository donorRepository;
    private final UserRepository userRepository;
    private final DonationRequestRepository donationRequestRepository;
    private final BloodRequestRepository bloodRequestRepository;

    public SampleDataLoader(DonorRepository donorRepository,
                            UserRepository userRepository,
                            DonationRequestRepository donationRequestRepository,
                            BloodRequestRepository bloodRequestRepository) {
        this.donorRepository = donorRepository;
        this.userRepository = userRepository;
        this.donationRequestRepository = donationRequestRepository;
        this.bloodRequestRepository = bloodRequestRepository;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (donorRepository.count() == 0) {
            List<Donor> donors = List.of(
                    donor("Aarav Sharma", 28, Gender.MALE, BloodGroup.O_POSITIVE, "9876500001", "Mumbai", 200, true),
                    donor("Priya Patel", 24, Gender.FEMALE, BloodGroup.A_POSITIVE, "9876500002", "Pune", 150, true),
                    donor("Rohan Mehta", 35, Gender.MALE, BloodGroup.B_POSITIVE, "9876500003", "Mumbai", 30, true),
                    donor("Sneha Iyer", 31, Gender.FEMALE, BloodGroup.AB_POSITIVE, "9876500004", "Chennai", null, true),
                    donor("Vikram Singh", 42, Gender.MALE, BloodGroup.O_NEGATIVE, "9876500005", "Delhi", 120, true),
                    donor("Ananya Gupta", 22, Gender.FEMALE, BloodGroup.A_NEGATIVE, "9876500006", "Mumbai", 60, true),
                    donor("Karan Joshi", 29, Gender.MALE, BloodGroup.B_NEGATIVE, "9876500007", "Pune", 100, false),
                    donor("Fatima Khan", 27, Gender.FEMALE, BloodGroup.O_POSITIVE, "9876500008", "Hyderabad", 400, true),
                    donor("Arjun Nair", 38, Gender.MALE, BloodGroup.AB_NEGATIVE, "9876500009", "Bengaluru", 95, true),
                    donor("Meera Reddy", 33, Gender.FEMALE, BloodGroup.B_POSITIVE, "9876500010", "Hyderabad", null, true),
                    donor("Rahul Verma", 45, Gender.MALE, BloodGroup.A_POSITIVE, "9876500011", "Delhi", 10, true),
                    donor("Neha Kulkarni", 26, Gender.FEMALE, BloodGroup.O_NEGATIVE, "9876500012", "Mumbai", 130, true));
            donorRepository.saveAll(donors);
            log.info("Added {} sample donors", donors.size());
        }

        // Seed sample regular user if not already present
        User sampleUser = userRepository.findByUsername("user").orElse(null);
        if (sampleUser == null) {
            sampleUser = new User();
            sampleUser.setUsername("user");
            sampleUser.setPassword("user123");
            sampleUser.setFullName("Aditi Rao");
            sampleUser.setEmail("aditi@example.com");
            sampleUser.setPhone("9876512345");
            sampleUser.setRole(UserRole.USER);
            sampleUser.setBloodGroup(BloodGroup.O_POSITIVE);
            sampleUser.setGender(Gender.FEMALE);
            sampleUser.setAge(26);
            sampleUser.setCity("Mumbai");
            sampleUser = userRepository.save(sampleUser);
            log.info("Added sample regular user: user / user123");
        }

        // Seed sample donation requests if empty
        if (donationRequestRepository.count() == 0) {
            DonationRequest req1 = new DonationRequest();
            req1.setUser(sampleUser);
            req1.setFullName("Aditi Rao");
            req1.setPhone("9876512345");
            req1.setEmail("aditi@example.com");
            req1.setBloodGroup(BloodGroup.O_POSITIVE);
            req1.setGender(Gender.FEMALE);
            req1.setAge(26);
            req1.setCity("Mumbai");
            req1.setPreferredDate(LocalDate.now().plusDays(2));
            req1.setMedicalDetails("Healthy, regular donor. Available Saturday morning.");
            req1.setStatus(RequestStatus.PENDING);
            donationRequestRepository.save(req1);

            DonationRequest req2 = new DonationRequest();
            req2.setUser(sampleUser);
            req2.setFullName("Sameer Deshmukh");
            req2.setPhone("9876511122");
            req2.setEmail("sameer@example.com");
            req2.setBloodGroup(BloodGroup.B_POSITIVE);
            req2.setGender(Gender.MALE);
            req2.setAge(31);
            req2.setCity("Pune");
            req2.setPreferredDate(LocalDate.now().plusDays(1));
            req2.setMedicalDetails("First time donor, eligible and eager to donate.");
            req2.setStatus(RequestStatus.APPROVED);
            req2.setAdminNotes("Approved. Blood collection center slot scheduled.");
            donationRequestRepository.save(req2);
            log.info("Added sample donation requests");
        }

        // Seed sample blood requirement requests if empty
        if (bloodRequestRepository.count() == 0) {
            BloodRequest req1 = new BloodRequest();
            req1.setUser(sampleUser);
            req1.setPatientName("Rajesh Kumar");
            req1.setBloodGroup(BloodGroup.O_NEGATIVE);
            req1.setUnitsNeeded(2);
            req1.setHospitalName("Lilavati Hospital");
            req1.setHospitalAddress("Bandra West, Mumbai");
            req1.setCity("Mumbai");
            req1.setContactName("Aditi Rao");
            req1.setContactPhone("9876512345");
            req1.setRequiredDate(LocalDate.now().plusDays(1));
            req1.setUrgency(UrgencyLevel.CRITICAL);
            req1.setNotes("Emergency bypass surgery scheduled for tomorrow morning.");
            req1.setStatus(RequestStatus.PENDING);
            bloodRequestRepository.save(req1);

            BloodRequest req2 = new BloodRequest();
            req2.setUser(sampleUser);
            req2.setPatientName("Sunita Devi");
            req2.setBloodGroup(BloodGroup.A_POSITIVE);
            req2.setUnitsNeeded(1);
            req2.setHospitalName("Ruby Hall Clinic");
            req2.setHospitalAddress("Pune");
            req2.setCity("Pune");
            req2.setContactName("Aditi Rao");
            req2.setContactPhone("9876512345");
            req2.setRequiredDate(LocalDate.now().minusDays(1));
            req2.setUrgency(UrgencyLevel.URGENT);
            req2.setNotes("Dengue platelet support needed.");
            req2.setStatus(RequestStatus.FULFILLED);
            req2.setAdminNotes("Fulfilled 1 unit from blood bank reserves.");
            bloodRequestRepository.save(req2);
            log.info("Added sample blood requirement requests");
        }
    }

    /** {@code daysSinceDonation} null means the donor has never donated. */
    private static Donor donor(String name, int age, Gender gender, BloodGroup bloodGroup, String phone,
                               String city, Integer daysSinceDonation, boolean available) {
        Donor donor = new Donor();
        donor.setFullName(name);
        donor.setAge(age);
        donor.setGender(gender);
        donor.setBloodGroup(bloodGroup);
        donor.setPhone(phone);
        donor.setCity(city);
        donor.setLastDonationDate(daysSinceDonation == null ? null : LocalDate.now().minusDays(daysSinceDonation));
        donor.setAvailable(available);
        return donor;
    }
}
