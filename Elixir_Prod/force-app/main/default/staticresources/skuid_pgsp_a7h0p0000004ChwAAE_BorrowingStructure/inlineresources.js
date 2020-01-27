(function(skuid){
skuid.snippet.register('fieldRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('NewRelationship',function(args) {var params = arguments[0],
  $ = skuid.$;

$('#newRelation').addClass('selected-btn');
$('#existingRelation').removeClass('selected-btn');

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
if(!newPartyRow){
    var newRow = newPartyModel.createRow({
        additionalConditions: [
            { field: 'NewRelationship', value:true },
            { field: 'ExistingRelationship', value: false },
        ]
    });
}else{
    newPartyModel.updateRow(newPartyRow ,{
                            NewRelationship : true ,
                            ExistingRelationship : false,
                            BusinessRelationship : false ,
                            IndividualRelationship : false,
                            clcommon__Account__c : null
                        }
    );
}
});
skuid.snippet.register('ExistingRelationship',function(args) {var params = arguments[0],
  $ = skuid.$;

$('#newRelation').removeClass('selected-btn');
$('#existingRelation').addClass('selected-btn');
var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
if(!newPartyRow){
    var newRow = newPartyModel.createRow({
        additionalConditions: [
            { field: 'NewRelationship', value:false },
            { field: 'ExistingRelationship', value: true },
        ]
    });
}else{
    var rowUpdates = {};
    rowUpdates['NewRelationship'] = false;
    rowUpdates['ExistingRelationship'] = true;
    rowUpdates['BusinessRelationship'] = false;
    rowUpdates['IndividualRelationship'] = false;
    rowUpdates['clcommon__Account__c'] = null;
    newPartyModel.updateRow( newPartyRow , rowUpdates);
}
});
skuid.snippet.register('moveToStep2',function(args) {var params = arguments[0],
    $ = skuid.$;

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
if(!(newPartyRow && (newPartyRow.NewRelationship || newPartyRow.ExistingRelationship))){
    $('#newRelation').addClass('selected-btn');
    $('#existingRelation').removeClass('selected-btn');
    var newRow = newPartyModel.createRow({
        additionalConditions: [
            { field: 'NewRelationship', value:true },
            { field: 'ExistingRelationship', value: false },
        ]
    });
}
});
skuid.snippet.register('selectBusinessRelation',function(args) {var params = arguments[0],
  $ = skuid.$;

$('#businessRelation').addClass('selected-btn');
$('#indiividualRelation').removeClass('selected-btn');
$('#sk-89WOF-144>div>table>tr>td:nth-child(5)').addClass('hide-stepbar');
$('#sk-89WOF-144>div>table>tr>td:nth-child(6)').addClass('hide-stepbar');
var newPartyModel = skuid.model.getModel('NewPartyModel');
newPartyModel.updateRow(newPartyModel.data[0] ,{
                            BusinessRelationship : true ,
                            IndividualRelationship : false,
                            clcommon__Account__c : null}
);
});
skuid.snippet.register('queryAccount',function(args) {var params = arguments[0],
  step = params.step,
    stepEditor = step.editor,
    $ = skuid.$;

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
// if nothing is selected and user moves forward
if(newPartyRow.NewRelationship && (!(newPartyRow.BusinessRelationship || newPartyRow.IndividualRelationship))){
    $('#businessRelation').addClass('selected-btn');
    $('#indiividualRelation').removeClass('selected-btn');
    newPartyRow.BusinessRelationship = true;
    newPartyRow.clcommon__Account__c = null;
}

//fetch model and cancel any changes
var newAccountModel = skuid.model.getModel('NewAccountModel');
newAccountModel.cancel();

var newCollateralOwnersModel = skuid.model.getModel('CollateralOwnerModel');
newCollateralOwnersModel.cancel();

var newBIModel = skuid.model.getModel('NewBusinessInfoModel');
newBIModel.cancel();

var newPartyModelClone = skuid.model.getModel('NewPartyModelClone');
newPartyModelClone.cancel();

var newContactModelForExistingRel = skuid.model.getModel('NewContactModelForExistingRel');
newContactModelForExistingRel.cancel();

var newContactModel = skuid.model.getModel('NewContactModel');
newContactModel.cancel();

// validate
if(newPartyRow.ExistingRelationship){
    if(!newPartyRow.clcommon__Account__c){
        var pageTitle = $('#errorTitle2');
        var editor = pageTitle.data('object').editor;
        editor.clearMessages();
        editor.handleMessages(
            [
              {
                  message: 'Please select an existing account',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
    if(newPartyRow.IndividualRelationship) {
        var sql = "select name from contact where AccountId= '"+newPartyRow.clcommon__Account__c+"'";
        result = sforce.connection.query(sql);
        if(result.size==0){
          var pageTitle = $('#errorTitle2');
          var editor = pageTitle.data('object').editor;
          editor.handleMessages(
            [
              {
                  message: 'No contact is associated with account, please associate a contact to this account to proceed further.',
                  severity: 'ERROR'
              },
            ]
          );
          return;
     }
    }

}

//fetch conditions
var accountIdCondition = newAccountModel.getConditionByName('Id');
var partyAccountIdCondition = newPartyModelClone.getConditionByName('clcommon__Account__c');
var coAccountIdCondition = newCollateralOwnersModel.getConditionByName('clcommon__Account__c');
var biIdCondition = newBIModel.getConditionByName('Id');
var newContactModelIdCondition = newContactModel.getConditionByName('AccountId');

// set and activate condtions
if(newPartyRow.clcommon__Account__c){
    newAccountModel.setCondition(accountIdCondition,newPartyRow.clcommon__Account__c);
    newPartyModelClone.setCondition(partyAccountIdCondition,newPartyRow.clcommon__Account__c);
    newCollateralOwnersModel.setCondition(coAccountIdCondition,newPartyRow.clcommon__Account__c);
    newContactModel.setCondition(newContactModelIdCondition,newPartyRow.clcommon__Account__c);
}else{
    newAccountModel.setCondition(accountIdCondition,'');
    newPartyModelClone.setCondition(partyAccountIdCondition,'');
    newCollateralOwnersModel.setCondition(coAccountIdCondition,'');
    newContactModel.setCondition(newContactModelIdCondition,'');
}

//query models
skuid.model.updateData([newAccountModel, newCollateralOwnersModel, newPartyModelClone, newContactModelForExistingRel, newContactModel],function(){
    createNewAccountRow(newAccountModel);
    createNewCORow(newCollateralOwnersModel);
    createNewContactRow(newContactModel);
    if(!newPartyRow.NewRelationship && newPartyModelClone.data && newPartyModelClone.data.length == 1){

    }else{
        newPartyModel.updateRow(newPartyRow,{
                                    clcommon__Type__c: null,
                                    clcommon__Signer_Capacity__c : null,
                                    clcommon__Signing_on_Behalf_of__c : null,
                                });
    }

    //query bi for account
    if(newAccountModel.data && newAccountModel.data.length > 0 && newAccountModel.data[0].genesis__Business_Information__c){
        newBIModel.setCondition(biIdCondition,newAccountModel.data[0].genesis__Business_Information__c);
    }else{
        newBIModel.setCondition(biIdCondition,'');
    }

    skuid.model.updateData([newBIModel],function(){
        createNewBIRow(newBIModel);
        moveToNextStepPls();
    });
});

function createNewAccountRow(newAccountModel){
    if(newAccountModel.data && newAccountModel.data.length < 1){
        var newRow = newAccountModel.createRow({
            additionalConditions: [
                { field: 'BusinessRelationship', value:true },
                { field: 'IndividualRelationship', value:false },
                //{ field: 'Name', value:'Set Account Name' },
            ]
        });
    }
}

function createNewContactRow(newContactModel){
    if(newContactModel.data && newContactModel.data.length < 1){
        var newRow = newContactModel.createRow({
            additionalConditions: [
                { field: 'BusinessRelationship', value:false },
                { field: 'IndividualRelationship', value:true }

            ]
        });
    }
}

function createNewCORow(newCollateralOwnersModel){
    if(newCollateralOwnersModel.data && newCollateralOwnersModel.data.length < 1){
        var newRow = newCollateralOwnersModel.createRow({
            additionalConditions: [
                { field: 'clcommon__Ownership__c', value: 100 },
                { field: 'clcommon__Collateral__c', value: null},
            ]
        });
    }
}

function createNewBIRow(newBIModel){
    if(newBIModel.data && newBIModel.data.length < 1){
        var newRow = newBIModel.createRow({
            additionalConditions: [
                //{ field: 'genesis__Business_Legal_Name__c', value:'Set Business Info' },
            ]
        });
    }
}

function moveToNextStepPls(){
    var wizard = $('.nx-wizard').data('object');
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step3');
}
});
skuid.snippet.register('selectIndividualRelation',function(args) {var params = arguments[0],
  $ = skuid.$;
$('#businessRelation').removeClass('selected-btn');
$('#indiividualRelation').addClass('selected-btn');
$('#sk-89WOF-144>div>table>tr>td:nth-child(5)').removeClass('hide-stepbar');
$('#sk-89WOF-144>div>table>tr>td:nth-child(6)').removeClass('hide-stepbar');
var newPartyModel = skuid.model.getModel('NewPartyModel');
newPartyModel.updateRow(newPartyModel.data[0] ,{
                            BusinessRelationship : false ,
                            IndividualRelationship : true,
                            clcommon__Account__c : null
                        }
    );
});
skuid.snippet.register('moveToStep4',function(args) {var params = arguments[0],
  step = params.step,
    stepEditor = step.editor,
    $ = skuid.$;
stepEditor.clearMessages();
var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
var models;

var pageTitle = $('#errorTitle3');
var editor = pageTitle.data('object').editor;
editor.clearMessages();
if(newPartyRow.BusinessRelationship){
    models = [
        skuid.model.getModel("NewAccountModel"),
        skuid.model.getModel("NewBusinessInfoModel")
    ];
}else{
    models = [
        skuid.model.getModel("NewContactModel"),
        skuid.model.getModel("NewBusinessInfoModel")
    ];
}
var contactMdl = skuid.model.getModel("NewContactModel");
contactRow = contactMdl.data[0];
let moveToNextStep = true;
if(contactRow&&newPartyRow.IndividualRelationship){
    let birthDate = contactRow.Birthdate;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());
    
    if (birthDate === '' || birthDate === null || birthDate === undefined || birthDate>today ) {
        stepEditor.handleMessages( 
    
             [{
                message: 'BirthDate cannot be future date or blank.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }
    
    if((contactRow.clcommon__Years_At_Current_Address__c === undefined||contactRow.clcommon__Years_At_Current_Address__c<1)||(contactRow.clcommon__Years_At_Current_Address__c==1&&(contactRow.clcommon__Months_at_current_address__c<=0||contactRow.clcommon__Months_at_current_address__c===undefined )))
    {
        if(!(contactRow.OtherStreet&&contactRow.OtherCity&&contactRow.OtherState&&contactRow.OtherPostalCode&&contactRow.OtherCountry))
        {
            stepEditor.handleMessages(
                [
                  {
                      message: 'Previous address cannot be blank',
                      severity: 'ERROR'
                  },
                ]
            );
            moveToNextStep = false;
            return false;
        }
    }
    if(!contactRow.Email || contactRow.Email ==="")
    {
        stepEditor.handleMessages(
            [
               {
                  message: 'Please capture e-mail ID of the customer',
                  severity: 'ERROR'
               },
            ]
        );
        moveToNextStep = false;
        return false;
    }
}

if(!moveToNextStep)
    return false;

if(contactMdl.data[0]){
    if(contactMdl.data[0].Email  || skuid.model.getModel("NewBusinessInfoModel").data[0].Email){
        $("#consentTitle .nx-error").hide();
    }else{
        $("#consentTitle .nx-error").show();
    }
}
var vres = validateAllRequiredFields($,editor,models);
if(!vres){
    return vres;
}
});
skuid.snippet.register('saveUpdateParty',function(args) {var params = arguments[0],
$ = skuid.$;

skuid.$('.nx-wizard-step .ui-button:visible').has('.ui-button-text:contains(Save)').button('disable');

var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];

var newAccountModel = skuid.model.getModel('NewAccountModel');
var newAccountRow = newAccountModel.data[0];
console.log('newAccountRow ##',newAccountRow);

var newContactModel = skuid.model.getModel('NewContactModel');
var newContactRow = newContactModel.data[0];
console.log('newContactRow ## ',newContactRow);

var businessInfoModel = skuid.model.getModel('NewBusinessInfoModel');
var businessInfoRow = businessInfoModel.data[0];

var collateralOwnerModel = skuid.model.getModel('CollateralOwnerModel');
var collData = [];
collateralOwnerModel.data.forEach(function (colDataObj){
    if(!collateralOwnerModel.isRowMarkedForDeletion(colDataObj) && colDataObj.clcommon__Collateral__c){
        collData.push(colDataObj);
    }
});
collateralOwnerModel.data = collData;

var consentPage = $('#consentTitle');
var editorNew = consentPage.data('object').editor;
editorNew.clearMessages();

if(!newPartyRow.clcommon__Electronic_Consent__c){
    editorNew.handleMessages(
        [
           {
              message: 'Please sign electronic consent',
              severity: 'ERROR'
           },
        ]
    );
    skuid.$('.nx-wizard-step .ui-button:visible').has('.ui-button-text:contains(Save)').button('enable');
    return false;
}

if(newPartyRow.clcommon__Electronic_Consent__c && (!newContactRow.Email || newContactRow.Email ==="")&&newPartyRow.IndividualRelationship){
    editorNew.handleMessages(
        [
           {
              message: 'Please capture e-mail ID of the customer',
              severity: 'ERROR'
           },
        ]
    );
    skuid.$('.nx-wizard-step .ui-button:visible').has('.ui-button-text:contains(Save)').button('enable');
    return false;
}
var partyArgs = {};

if(newPartyRow.NewRelationship) {
    if(newPartyRow.IndividualRelationship){
        partyArgs[0] = newContactModel;
        partyArgs[1] = null;
    } else {
        partyArgs[0] = null;
        partyArgs[1] = newAccountModel;
    }
} else {
    if(newPartyRow.IndividualRelationship){
        partyArgs[0] = newContactModel;
        partyArgs[1] = null;
    } else {
        partyArgs[0] = null;
        partyArgs[1] = newAccountModel;
    }
}
// if(newPartyRow.IndividualRelationship){
//     partyArgs[0] = newContactModel;
//     partyArgs[1] = null;
// }
// if(newPartyRow.BusinessRelationship || newPartyRow.ExistingRelationship){
//     partyArgs[0] = null;
//     partyArgs[1] = newAccountModel;
// }

var bModel = businessInfoModel;
if (Object.keys(businessInfoModel.data[0]).length <= 2){
    bModel = null;
}

var res = saveParty(newPartyModel,partyArgs[0],partyArgs[1],bModel,collateralOwnerModel);
var resObj = JSON.parse(res);

if(resObj.status == 'SUCCESS'){
    if(newPartyRow.IndividualRelationship){
        var contactId = resObj.content[0].clcommon__Contact__r.Id;
        newContactModel.updateRow(newContactRow, {
            Id: contactId
        });
        
        newPartyRow.SaveParty = false;
        $("#PartySaveButton").button('enable');
    }
    return true;
}else{
    $("#PartySaveButton").button('enable');
    editorNew.handleMessages(
        [
          {
              message: resObj.errorMessage,
              severity: 'ERROR'
          },
        ]
    );
    return false;
}
});
skuid.snippet.register('moveToStep5',function(args) {var params = arguments[0],
step = params.step,
stepEditor = step.editor,
$ = skuid.$;
stepEditor.clearMessages();
var newPartyModel = skuid.model.getModel('NewPartyModel');
var newPartyRow = newPartyModel.data[0];
var models;

var pageTitle = $('#errorStep4');
var editor = pageTitle.data('object').editor;
editor.clearMessages();

if(!newPartyRow.clcommon__Type__c){
    editor.handleMessages(
        [
           {
              message: 'Select Party Type for Party.',
              severity: 'ERROR'
           },
        ]
    );
    return false;
}

return true;
});
skuid.snippet.register('closeDialogs',function(args) {var params = arguments[0],
	$ = skuid.$;
closeTopLevelDialogAndRefresh({iframeIds: ['document-iframe', 'party-iframe', 'deal-dashboard-iframe,document-iframe', 'deal-dashboard-iframe,party-iframe']});
});
skuid.snippet.register('validateEmployementAndIncome',function(args) {var params = arguments[0],
    step = params.step,
    stepEditor = step.editor,
    $ = skuid.$;

stepEditor.clearMessages();

let moveToNextStep = true;

var employmentInformationModel = skuid.model.getModel('EmploymentInformationModel');

$.each(employmentInformationModel.data,function(i,row){
    
    let startDate = row.genesis__Start_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (startDate === '' || startDate === null || startDate === undefined || startDate>today ) {
        stepEditor.handleMessages( 
    
             [{
    
                 message: 'Current employment start date cannot be future date or blank.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }

});

var previousEmploymentInfoModel = skuid.model.getModel('PreviousEmploymentInfoModel');

$.each(previousEmploymentInfoModel.data,function(i,row){
    
    let startDate = row.genesis__Start_Date__c;
    let endDate = row.genesis__End_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (startDate === '' || startDate === null || startDate === undefined || startDate>today ) {
        stepEditor.handleMessages( 
    
             [{
    
                 message: 'Previous employment start date cannot be future date or blank.', 
                severity: 'ERROR'
            }]
        );
        moveToNextStep = false;
        return false;
    }
    
    if (endDate === '' || endDate === null || endDate === undefined || endDate>today ) {
        stepEditor.handleMessages( 
    
             [{
    
                 message: 'Previous employment end date cannot be future date or blank.', 
                severity: 'ERROR'
            }]
        );
        moveToNextStep = false;
        return false;
    }
    
    if (startDate>endDate ) {
        stepEditor.handleMessages( 
    
             [{
    
                 message: 'Previous employment end date needs to be greater than start date.', 
                severity: 'ERROR'
            }]
        );
        moveToNextStep = false;
        return false;
    }

});

var otherIncomeModel = skuid.model.getModel('OtherIncomeModel');

$.each(otherIncomeModel.data,function(i,row){
    
    let name = row.Name;
    if (name === '' || name === null || name === undefined ) {
        stepEditor.handleMessages( 
    
             [{
    
                 message: 'Income name can not be blank.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }

});


if(moveToNextStep)
{
    var wizard = $('.nx-wizard').data('object');
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step6');
}
});
skuid.snippet.register('validateAssetsAndLiabilities',function(args) {var params = arguments[0],
    step = params.step,
    stepEditor = step.editor,
    $ = skuid.$;

stepEditor.clearMessages();

let moveToNextStep = true;

var assetInformationModel = skuid.model.getModel('AssetInformationModel');

$.each(assetInformationModel.data,function(i,row){
    
    let acquisitionDate = row.genesis__Date_of_Acquisition__c;
    let marketValueDate = row.genesis__Market_Value_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (acquisitionDate === '' || acquisitionDate === null || acquisitionDate === undefined || acquisitionDate>today ) {
        stepEditor.handleMessages( 
    
             [{
    
                message: 'Date of Acquisition cannot be future date or blank.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }
    
    if (marketValueDate === '' || marketValueDate === null || marketValueDate === undefined || marketValueDate>today ) {
        stepEditor.handleMessages( 
    
             [{
    
                message: 'Market Value Date cannot be future date or blank.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }
    
    let name = row.Name;
    if (name === '' || name === null || name === undefined ) {
        stepEditor.handleMessages( 
    
             [{
    
                message: 'Asset description can not be blank.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }

});

var liabilityInformationModel = skuid.model.getModel('LiabilityInformationModel');

$.each(liabilityInformationModel.data,function(i,row){
    let paymentAmount = row.genesis__Payment_Amount__c;
    let amountOwing = row.genesis__Amount_Owing__c;
    
    if (paymentAmount>amountOwing) {
        stepEditor.handleMessages( 
    
             [{
    
                message: 'Payment amount cannot be greater than amount owing.', 
                severity: 'ERROR'
            }]
        );
        
        moveToNextStep = false;
        return false;
    }

});



if(moveToNextStep)
{
    var wizard = $('.nx-wizard').data('object');
    var currentStep = wizard.steps[wizard.currentstep];
    currentStep.navigate('step7');
}
});
skuid.snippet.register('successMessage',function(args) {var params = arguments[0],
	$ = skuid.$;
var consentPage = $('#consentTitle');
var editorNew = consentPage.data('object').editor;
editorNew.clearMessages();

editorNew.handleMessages(
[
  {
      message: 'Record saved successfully!',
      severity: 'INFO'
  },
]);
});
}(window.skuid));