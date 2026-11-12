<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="Blood Requirement Request" activeNav="request-blood">
<div class="form-page">

    <a class="back-link" href="<c:url value='/user/dashboard'/>">&larr; Back to Dashboard</a>

    <div class="card">
        <header class="form-header">
            <h1 class="page-title">Send Blood Requirement Request</h1>
            <p class="page-subtitle">Submit a request for blood units needed for a patient. The administrator will coordinate blood supply.</p>
        </header>

        <form:form modelAttribute="requirementForm" action="${pageContext.request.contextPath}/user/request-blood" method="post" cssClass="form">

            <fieldset class="form-section">
                <legend class="form-section-title">Patient & Blood Requirement</legend>

                <div class="field">
                    <form:label path="patientName" cssClass="label">Patient Name <span class="required">*</span></form:label>
                    <form:input path="patientName" cssClass="input" cssErrorClass="input input-error"
                                autocomplete="name" maxlength="100" required="required" placeholder="e.g. Ramesh Patel"/>
                    <form:errors path="patientName" cssClass="field-error" element="p"/>
                </div>

                <div class="field-row">
                    <div class="field">
                        <form:label path="bloodGroup" cssClass="label">Blood Group Needed <span class="required">*</span></form:label>
                        <form:select path="bloodGroup" cssClass="input" cssErrorClass="input input-error" required="required">
                            <form:option value="">Select blood group</form:option>
                            <form:options items="${bloodGroups}" itemLabel="label"/>
                        </form:select>
                        <form:errors path="bloodGroup" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="unitsNeeded" cssClass="label">Units Needed <span class="required">*</span></form:label>
                        <form:input path="unitsNeeded" type="number" min="1" max="20" inputmode="numeric"
                                    cssClass="input" cssErrorClass="input input-error" required="required" value="1"/>
                        <p class="hint">Units of blood / packed red cells</p>
                        <form:errors path="unitsNeeded" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <div class="field-row">
                    <div class="field">
                        <form:label path="requiredDate" cssClass="label">Needed By Date <span class="required">*</span></form:label>
                        <form:input path="requiredDate" type="date" cssClass="input" cssErrorClass="input input-error" required="required"/>
                        <form:errors path="requiredDate" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="urgency" cssClass="label">Urgency Level <span class="required">*</span></form:label>
                        <form:select path="urgency" cssClass="input" cssErrorClass="input input-error" required="required">
                            <c:forEach items="${urgencyLevels}" var="lvl">
                                <form:option value="${lvl}">${lvl.label}</form:option>
                            </c:forEach>
                        </form:select>
                        <form:errors path="urgency" cssClass="field-error" element="p"/>
                    </div>
                </div>
            </fieldset>

            <fieldset class="form-section">
                <legend class="form-section-title">Hospital & Contact Details</legend>

                <div class="field-row">
                    <div class="field">
                        <form:label path="hospitalName" cssClass="label">Hospital Name <span class="required">*</span></form:label>
                        <form:input path="hospitalName" cssClass="input" cssErrorClass="input input-error"
                                    maxlength="150" required="required" placeholder="e.g. Apollo Hospital / Lilavati Hospital"/>
                        <form:errors path="hospitalName" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="city" cssClass="label">City <span class="required">*</span></form:label>
                        <form:input path="city" autocomplete="address-level2" maxlength="60"
                                    cssClass="input" cssErrorClass="input input-error" required="required" placeholder="e.g. Mumbai"/>
                        <form:errors path="city" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <div class="field">
                    <form:label path="hospitalAddress" cssClass="label">Hospital Address</form:label>
                    <form:input path="hospitalAddress" maxlength="255" cssClass="input" cssErrorClass="input input-error"
                                placeholder="Hospital branch, ward number or address"/>
                    <form:errors path="hospitalAddress" cssClass="field-error" element="p"/>
                </div>

                <div class="field-row">
                    <div class="field">
                        <form:label path="contactName" cssClass="label">Contact Person Name <span class="required">*</span></form:label>
                        <form:input path="contactName" cssClass="input" cssErrorClass="input input-error"
                                    maxlength="100" required="required" placeholder="Name of family member or guardian"/>
                        <form:errors path="contactName" cssClass="field-error" element="p"/>
                    </div>

                    <div class="field">
                        <form:label path="contactPhone" cssClass="label">Contact Mobile Number <span class="required">*</span></form:label>
                        <form:input path="contactPhone" type="tel" inputmode="numeric" autocomplete="tel-national"
                                    placeholder="98765 43210" maxlength="16"
                                    cssClass="input" cssErrorClass="input input-error" required="required"/>
                        <form:errors path="contactPhone" cssClass="field-error" element="p"/>
                    </div>
                </div>

                <div class="field">
                    <form:label path="notes" cssClass="label">Diagnosis / Additional Notes</form:label>
                    <form:textarea path="notes" rows="3" cssClass="input" cssErrorClass="input input-error"
                                   placeholder="Reason for blood requirement (e.g. elective surgery, accident, anemia, dengue)"/>
                    <form:errors path="notes" cssClass="field-error" element="p"/>
                </div>
            </fieldset>

            <div class="form-actions">
                <button class="btn btn-primary" type="submit">Submit Blood Requirement</button>
                <a class="btn btn-secondary" href="<c:url value='/user/dashboard'/>">Cancel</a>
            </div>
        </form:form>
    </div>

</div>
</ui:page>
