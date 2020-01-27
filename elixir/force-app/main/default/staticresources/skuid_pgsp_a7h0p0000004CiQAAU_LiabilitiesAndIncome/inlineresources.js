(function(skuid){
skuid.snippet.register('validateLiabilitiesAndIncome',function(args) {var params = arguments[0],
      $ = skuid.$;

var partyID = skuid.page.params.partyId;

var dfd = new $.Deferred();

var employmentInformationModel = skuid.model.getModel('EmploymentInformationModel');

$.each(employmentInformationModel.data,function(i,row){

    let startDate = row.genesis__Start_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (startDate === '' || startDate === null || startDate === undefined || startDate>today ) {

        dfd.reject({
            message: 'Current employment start date cannot be future date or blank.',
            severity: 'ERROR'
        });
        return dfd.resolve();
    }
});

var liabilityInfo = skuid.model.getModel('Liabilities');

$.each(liabilityInfo.data,function(i,row){

    let includeForDTI = row.genesis__Include_for_DTI__c;
    let amountOwing = row.genesis__Amount_Owing__c;
    let liabilityType = row.genesis__Liability_Type__c;
    let paymentFrequency = row.genesis__Payment_Frequency__c;

    if (includeForDTI) {
        if (amountOwing === null || amountOwing === '' || amountOwing === undefined) {
           dfd.reject({
                message: 'Please provide Amount Owing when Include for DTI is checked for a liability record.',
                severity: 'ERROR'
            });
            return dfd.resolve();
        }
        if (liabilityType === null || liabilityType === '' || liabilityType === undefined) {
            dfd.reject({
                message: 'Please provide Liability Type when Include for DTI is checked for a liability record.',
                severity: 'ERROR'
            });
            return dfd.resolve();
        }
        if (paymentFrequency === null || paymentFrequency === '' || paymentFrequency === undefined) {
            dfd.reject({
                message: 'Payment Frequency must be provided when Include for DTI is checked for a liability record.',
                severity: 'ERROR'
            });
            return dfd.resolve();
        }
    }

});

var otherIncomeModel = skuid.model.getModel('OtherIncomeModel');

$.each(otherIncomeModel.data,function(i,row){

    let name = row.Name;

    if (name === '' || name === null || name === undefined ) {

        dfd.reject({
            message: 'Income Name can not be blank.',
            severity: 'ERROR'
        });
        return dfd.resolve();
    }
});

dfd.resolve();
return dfd.promise();
});
skuid.snippet.register('CalculateDTIForParty',function(args) {var params = arguments[0],
	$ = skuid.$;

var partyID = skuid.model.getModel('PageParamsModel').data[0].partyId;

var returnMsg = sforce.apex.execute('genesis.ComputeDebtToIncomeRatio', 'computeDebtToIncomeRatio', { objectID : partyID });
if (returnMsg[0].includes("success")) {
    skuid.component.getById('includePartyDTIDashboard').load();
}
else {
    alert(returnMsg);
    skuid.component.getById('includePartyDTIDashboard').load();
}
});
}(window.skuid));