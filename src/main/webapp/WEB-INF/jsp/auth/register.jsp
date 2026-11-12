<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="User Registration" activeNav="register">
<div class="form-page">

    <a class="back-link" href="<c:url value='/login'/>">&larr; Back to Login</a>

    <div class="card">
        <header class="form-header">
            <h1 class="page-title">Create User Account</h1>
            <p class="page-subtitle">Register to send blood donation requests or request blood for patients.</p>
        </header>

        <form:form modelAttribute="registerForm" action="${pageContext.request.contextPath}/register" method="post" cssClass="form">

            <fieldset class="form-section">
                <legend class="form-section-title">Account Credentials</legend>

                <div class="field-row">
                    <div class="field">
                        <form:label path="username" cssClass="label">Username <span class="required">*</span></form:label>
                        <form:input path="username" cssClass="input" cssErrorClass="input input-error"
                                    autocomplete="username" maxlength="50" required="required" placeholder="e.g. aditi_rao"/>
                        <form:errors path="username" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="password" cssClass="label">Password <span class="required">*</span></form:label>
                        <form:input path="password" type="password" cssClass="input" cssErrorClass="input input-error"
                                    autocomplete="new-password" minlength="6" maxlength="50" required="required" placeholder="At least 6 characters"/>
                        <form:errors path="password" cssClass="field-error" element="p"/>
                    </div>
                </div>
            </fieldset>

            <fieldset class="form-section">
                <legend class="form-section-title">Personal Information</legend>

                <div class="field">
                    <form:label path="fullName" cssClass="label">Full Name <span class="required">*</span></form:label>
                    <form:input path="fullName" cssClass="input" cssErrorClass="input input-error"
                                autocomplete="name" maxlength="100" required="required" placeholder="e.g. Aditi Rao"/>
                    <form:errors path="fullName" cssClass="field-error" element="p"/>
                </div>

                <div class="field-row">
                    <div class="field">
                        <form:label path="bloodGroup" cssClass="label">Your Blood Group <span class="required">*</span></form:label>
                        <form:select path="bloodGroup" cssClass="input" cssErrorClass="input input-error" required="required">
                            <form:option value="">Select blood group</form:option>
                            <form:options items="${bloodGroups}" itemLabel="label"/>
                        </form:select>
                        <form:errors path="bloodGroup" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="age" cssClass="label">Age <span class="required">*</span></form:label>
                        <form:input path="age" type="number" min="18" max="65" inputmode="numeric"
                                    cssClass="input" cssErrorClass="input input-error" required="required" placeholder="18 - 65"/>
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
                <legend class="form-section-title">Contact Details</legend>

                <div class="field-row">
                    <div class="field">
                        <form:label path="phone" cssClass="label">Mobile Number <span class="required">*</span></form:label>
                        <form:input path="phone" type="tel" inputmode="numeric" autocomplete="tel-national"
                                    placeholder="98765 43210" maxlength="16"
                                    cssClass="input" cssErrorClass="input input-error" required="required"/>
                        <form:errors path="phone" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="email" cssClass="label">Email Address <span class="required">*</span></form:label>
                        <form:input path="email" type="email" autocomplete="email" maxlength="120"
                                    cssClass="input" cssErrorClass="input input-error" required="required" placeholder="aditi@example.com"/>
                        <form:errors path="email" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <div class="field">
                    <form:label path="city" cssClass="label">City <span class="required">*</span></form:label>
                    <form:input path="city" autocomplete="address-level2" maxlength="60"
                                cssClass="input" cssErrorClass="input input-error" required="required" placeholder="e.g. Mumbai"/>
                    <form:errors path="city" cssClass="field-error" element="p"/>
                </div>
            </fieldset>

            <div class="form-actions">
                <button class="btn btn-primary" type="submit">Complete Registration</button>
                <a class="btn btn-secondary" href="<c:url value='/login'/>">Already have an account? Login</a>
            </div>
        </form:form>
    </div>

</div>
</ui:page>
