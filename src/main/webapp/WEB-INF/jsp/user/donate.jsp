<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="Donate Blood Request" activeNav="donate">
<div class="form-page">

    <a class="back-link" href="<c:url value='/user/dashboard'/>">&larr; Back to Dashboard</a>

    <div class="card">
        <header class="form-header">
            <h1 class="page-title">Send Blood Donation Request</h1>
            <p class="page-subtitle">Fill in your details to notify the administrator that you wish to donate blood.</p>
        </header>

        <form:form modelAttribute="donationForm" action="${pageContext.request.contextPath}/user/donate" method="post" cssClass="form">

            <fieldset class="form-section">
                <legend class="form-section-title">Donor Information</legend>

                <div class="field">
                    <form:label path="fullName" cssClass="label">Full Name <span class="required">*</span></form:label>
                    <form:input path="fullName" cssClass="input" cssErrorClass="input input-error"
                                autocomplete="name" maxlength="100" required="required"/>
                    <form:errors path="fullName" cssClass="field-error" element="p"/>
                </div>

                <div class="field-row">
                    <div class="field">
                        <form:label path="bloodGroup" cssClass="label">Blood Group <span class="required">*</span></form:label>
                        <form:select path="bloodGroup" cssClass="input" cssErrorClass="input input-error" required="required">
                            <form:option value="">Select blood group</form:option>
                            <form:options items="${bloodGroups}" itemLabel="label"/>
                        </form:select>
                        <form:errors path="bloodGroup" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="age" cssClass="label">Age <span class="required">*</span></form:label>
                        <form:input path="age" type="number" min="18" max="65" inputmode="numeric"
                                    cssClass="input" cssErrorClass="input input-error" required="required"/>
                        <p class="hint">18 to 65 years</p>
                        <form:errors path="age" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <fieldset class="field">
                    <legend class="label">Gender <span class="required">*</span></legend>
                    <div class="radio-group">
                        <c:forEach items="${genders}" var="option">
                            <label class="radio">
                                <form:radiobutton path="gender" value="${option}" required="required"/>
                                <span>${option.label}</span>
                            </label>
                        </c:forEach>
                    </div>
                    <form:errors path="gender" cssClass="field-error" element="p"/>
                </fieldset>
            </fieldset>

            <fieldset class="form-section">
                <legend class="form-section-title">Contact & Preferred Date</legend>

                <div class="field-row">
                    <div class="field">
                        <form:label path="phone" cssClass="label">Mobile Number <span class="required">*</span></form:label>
                        <form:input path="phone" type="tel" inputmode="numeric" autocomplete="tel-national"
                                    placeholder="98765 43210" maxlength="16"
                                    cssClass="input" cssErrorClass="input input-error" required="required"/>
                        <form:errors path="phone" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="email" cssClass="label">Email Address</form:label>
                        <form:input path="email" type="email" autocomplete="email" maxlength="120"
                                    cssClass="input" cssErrorClass="input input-error"/>
                        <form:errors path="email" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <div class="field-row">
                    <div class="field">
                        <form:label path="city" cssClass="label">City <span class="required">*</span></form:label>
                        <form:input path="city" autocomplete="address-level2" maxlength="60"
                                    cssClass="input" cssErrorClass="input input-error" required="required"/>
                        <form:errors path="city" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="preferredDate" cssClass="label">Preferred Donation Date</form:label>
                        <form:input path="preferredDate" type="date" cssClass="input" cssErrorClass="input input-error"/>
                        <p class="hint">When would you like to donate?</p>
                        <form:errors path="preferredDate" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <div class="field">
                    <form:label path="medicalDetails" cssClass="label">Medical History / Additional Notes</form:label>
                    <form:textarea path="medicalDetails" rows="3" cssClass="input" cssErrorClass="input input-error"
                                   placeholder="e.g. Any recent medications, previous donations, or preferred time of day (morning/afternoon)"/>
                    <form:errors path="medicalDetails" cssClass="field-error" element="p"/>
                </div>
            </fieldset>

            <div class="form-actions">
                <button class="btn btn-primary" type="submit">Submit Donation Request</button>
                <a class="btn btn-secondary" href="<c:url value='/user/dashboard'/>">Cancel</a>
            </div>
        </form:form>
    </div>

</div>
</ui:page>
