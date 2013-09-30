<%
    ui.decorateWith("appui", "standardEmrPage")
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("dispensing.app.label") }", link: "${ ui.pageLink("dispensing", "findPatient") }" },
        { label: "${ ui.format(patient.patient.familyName) }, ${ ui.format(patient.patient.givenName) }" , link: '${ui.pageLink("coreapps", "patientdashboard/patientDashboard", [patientId: patient.id])}'},
    ];
</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient.patient ]) }

<script type="text/javascript">
    jq(function() {
        jq('#actions .cancel').click(function() {
            emr.navigateTo({
                provider: "dispensing",
                page: "findPatient"
            });
        });
        jq('#actions .confirm').click(function() {
            emr.navigateTo({
                provider: "htmlformentryui",
                page: "htmlform/enterHtmlFormWithStandardUi",
                query: {
                    patientId: "${ patient.id }",
                    visitId: "${ visit?.id }",
                    definitionUiResource: "dispensing:htmlforms/dispensing.xml",
                    returnUrl: "${ ui.escapeJs(ui.pageLink("dispensing", "findPatient")) }",
                    breadcrumbOverride: "${ ui.escapeJs(breadcrumbOverride) }"
                }
            });
        });
        jq('#actions button').first().focus();
    });
</script>
<style>
#existing-encounters {
    margin-top: 2em;
}
</style>

<% if (emrContext.activeVisit) { %>

<div class="container half-width">

    <h1>${ ui.message("coreapps.vitals.confirmPatientQuestion") }</h1>

    <div id="actions">
        <button class="confirm big right">
            <i class="icon-arrow-right"></i>
            ${ ui.message("dispensing.findpatient.confirm.yes") }
        </button>

        <button class="cancel big">
            <i class="icon-arrow-left"></i>
            ${ ui.message("coreapps.vitals.confirm.no") }
        </button>
    </div>

    <div id="existing-encounters">
        <h3>${ ui.message("dispensing.medication.duringThisVisit") }</h3>
        <table>
            <thead>
            <tr>
                <th>${ ui.message("coreapps.vitals.when") }</th>
                <th>${ ui.message("coreapps.vitals.where") }</th>
                <th>${ ui.message("coreapps.vitals.enteredBy") }</th>
            </tr>
            </thead>
            <tbody>
            <% if (existingEncounters.size() == 0) { %>
            <tr>
                <td colspan="3">${ ui.message("coreapps.none") }</td>
            </tr>
            <% } %>
            <% existingEncounters.each { enc ->
                def minutesAgo = (long) ((System.currentTimeMillis() - enc.encounterDatetime.time) / 1000 / 60)
            %>
            <tr>
                <td>${ ui.message("coreapps.vitals.minutesAgo", minutesAgo) }</td>
                <td>${ ui.format(enc.location) }</td>
                <td>${ ui.format(enc.creator) }</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<% } else { %>

<h1>
    ${ ui.message("coreapps.noActiveVisit") }
</h1>

<div id="actions">
    <button class="cancel big">
        <i class="icon-arrow-left"></i>
        ${ ui.message("mirebalias.outpatientVitals.noVisit.findAnotherPatient") }
    </button>
</div>

<% } %>