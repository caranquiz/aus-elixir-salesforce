(function(skuid){
skuid.snippet.register('SaveApplication',function(args) {var newAppParams = {};

var applicationModel = skuid.model.getModel('ApplicationNew');
var appRow = applicationModel.data[0];

var contactModel = skuid.model.getModel('ContactNew');
var contactRow = contactModel.data[0];

var actionModel = skuid.model.getModel('TempNew');
var tempRow = actionModel.data[0];

var accountModel = skuid.model.getModel('AccountNew');
var accRow = accountModel.data[0];

var productModel = skuid.model.getModel('ProductNew');
var productRow = productModel.data[0];

var businessModel = skuid.model.getModel('BusinessInfoNew');
var businessRow = businessModel.data[0];

var pmtstreamModel = skuid.model.getModel('PaymentStreamNew');
var pmtstreamRow = pmtstreamModel.data[0];

appRow.RecordTypeId = skuid.page.params.RecordType;
if(!appRow.Term__c){
    appRow.Term__c = 0;
}
if(!appRow.Interest_Rate__c){
    appRow.Interest_Rate__c = 0;
}
if(!appRow.Loan_Amount__c){
    appRow.Loan_Amount__c = 0;
}

newAppParams.applicationM = applicationModel;
newAppParams.businessM = businessModel;
newAppParams.pmtstreamM = pmtstreamModel;

if(accRow.Name){
    newAppParams.accountM = accountModel;
}else{
    newAppParams.accountM = null;
}

if(contactRow.LastName){
    newAppParams.contactM = contactModel;
}else{
    newAppParams.contactM = null;
}

var editorWrapper = $('#first-editor');
var editor = editorWrapper.data('object').editor;

var result = saveNGApplication(newAppParams);
var resultJSON = $.parseJSON(result[0]);
    
if (resultJSON.status === 'ERROR') {
    editor.handleMessages(
        [
          {
              message: resultJSON.errorMessage,
              severity: 'ERROR'
          },
        ]
    );
} else {
    window.location = '/' + resultJSON.content[0].Id;
}
});
skuid.snippet.register('AddTooltip',function(args) {var params = arguments[0],
	$ = skuid.$;

$('.nx-page').one('pageload', function() {
    addTooltipGlobalHeader();    
});
});
}(window.skuid));