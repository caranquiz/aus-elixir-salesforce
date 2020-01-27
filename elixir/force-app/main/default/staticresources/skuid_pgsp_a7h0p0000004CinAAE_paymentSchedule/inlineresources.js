(function(skuid){
skuid.snippet.register('generateSchedule',function(args) {var scModels = skuid.model.getModel('SchAppModel');
var scRow = scModels.data[0];
var result = sforce.apex.execute('genesis.SkuidNewApplication','generateSchedule',
{
        applicationId : scRow.Id
});
alert(result);
window.location.reload();
});
skuid.snippet.register('DeleteRow',function(args) {var param=skuid.model.getModel('Holiday_Schedule').getFirstRow().Id;
skuid.model.getModel('Holiday_Schedule').deleteRow({Id:param});
skuid.model.getModel('Holiday_Schedule').save();
});
skuid.snippet.register('validateRepaymentPlan',function(args) {var repayModels = skuid.model.getModel('Flexible_Repayment');
var scModels = skuid.model.getModel('SchAppModel');
var scRow = scModels.data[0];
var expectedPayStart = scRow.genesis__Expected_First_Payment_Date__c;
var repayRow = repayModels.data[0];
console.log(scRow);
//console.log(repayRow);
var showAlert = true;
if(repayModels.data.length === 0){
    showAlert = false;
}
repayModels.data.forEach(function(element) {
    if(element.clcommon__Payment_Start_Date__c === expectedPayStart || repayModels.data.length === 0){
        showAlert = false;
    }
});

if(showAlert){
    alert("Atleast one repayment plan start date should be equal to the contract start date to generate schedule");
}
});
skuid.snippet.register('generateApr',function(args) {var scModels = skuid.model.getModel('SchAppModel');
var scRow = scModels.data[0];
var result = sforce.apex.execute('genesis.SkuidNewApplication','calculateApr',
{
        applicationId : scRow.Id
});
alert(result);
window.location.reload();
});
}(window.skuid));