(function(skuid){
skuid.snippet.register('fieldValidation',function(args) {/**
*  Purpose: Used for validating required fields in step 3 of wizard .Displays error message accordingly on violation
*  Where: step 3 Next button click snippet
*
* @name  Fieldvalidation.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/

//params will contail all the info about the context of call like which record data calles it,what condition,etc
var params = arguments[0],
    $ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var newCollateralTypeCatModel = skuid.model.getModel('PledgeCollaterals_CollateralTypeCategoryAssoc');
var collCatCatModelCondition = newCollateralTypeCatModel.getConditionByName('collTypeName');
newCollateralTypeCatModel.setCondition(collCatCatModelCondition, newCollateralRow.clcommon__Collateral_Type__r.Name);
newCollateralTypeCatModel.activateCondition(collCatCatModelCondition);

skuid.model.updateData([newCollateralTypeCatModel],function(){
    var catRow = newCollateralTypeCatModel.data[0];

    newCollateralModel.updateRow(newCollateralRow ,
                        { clcommon__Collateral_Category__c : catRow.clcommon__Collateral_Category__c });


});


//fetch the wizard object
var wizard = $('.nx-wizard').data('object');
//fetch wizard current step
var currentStep = wizard.steps[wizard.currentstep];

// Handle error messages
var displayMessage = function (message, severity) {

    var editor = $('#detailsPage ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

var ApplicationCollateralNewModel = skuid.model.getModel('ApplicationCollateralNew');
var ApplicationCollateralNewRow = ApplicationCollateralNewModel.data[0];

if(!newAppCollRow){
    var newAppCollRow = newAppCollModel.createRow();
}

//validation condition
if(newCollateralRow.NewCollateral){

    if(newCollateralRow.clcommon__Collateral_Name__c && newCollateralRow.clcommon__Collateral_Code__c ){
        /* update pledge amount to 0 */
        ApplicationCollateralNewModel.updateRow(ApplicationCollateralNewRow, {'genesis__Pledge_Amount__c':0});

        //navigate to step 4 in wizard
        currentStep.navigate('step4');
    }
    else{
         return displayMessage('Fill all the fields marked in red ', 'ERROR');
    }

}
else{
    var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
    var newAppCollRow = newAppCollModel.data[0];

    var collValModel = skuid.model.getModel('PledgeCollaterals_CollateralValuation');
    var colValRow = collValModel.data[0];

    if(colValRow === undefined) {
        /* update pledge amount to 0 */
        newAppCollModel.updateRow(newAppCollRow, {'genesis__Pledge_Amount__c':0});
    }

    //navigate to step 4 in wizard
    currentStep.navigate('step4');
}
});
skuid.snippet.register('newCollateral',function(args) {/**
*  Purpose: Used for creating new collateral in the system.Sets values for UI only fields for rendering
*  Where: step 1 new collateral button
*
* @name  newCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


var params = arguments[0],
$ = skuid.$;

$('#newcollateralid').addClass('selected-btn');
$('#existingCollateralId').removeClass('selected-btn');

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

//add values to UI only fields which will be used for rendering
if(!newCollateralCloneRow){
    var newCollateralCloneRow = newCollateralCloneModel.createRow({
        additionalConditions: [
            { field: 'NewCollateral', value:true },
            { field: 'ExistingCollateral', value: false },
        ]
    });

}else{
    newCollateralCloneModel.updateRow(newCollateralCloneRow ,
                        { NewCollateral : true ,
                          ExistingCollateral : false });

}
});
skuid.snippet.register('existingCollateral',function(args) {/**
*  Purpose: Used for updating existing collateral in the system.Sets values for UI only fields for rendering
*  Where: step 1 existing collateral button
*
* @name  existingCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


var params = arguments[0],
$ = skuid.$;

$('#newcollateralid').removeClass('selected-btn');
$('#existingCollateralId').addClass('selected-btn');

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

//add values to UI only fields which will be used for rendering
if(!newCollateralCloneRow){
    var newCollateralCloneRow = newCollateralCloneModel.createRow({
        additionalConditions: [
            { field: 'NewCollateral', value:false },
            { field: 'ExistingCollateral', value: true },
        ]
    });

}else{
    newCollateralCloneModel.updateRow(newCollateralCloneRow ,
                        { NewCollateral : false ,
                          ExistingCollateral : true });

}
});
skuid.snippet.register('validatePledgeAmountCollateral',function(args) {/**
*  Purpose: validation of pledge amount
*
* @name  saveCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/

var params = arguments[0],
$ = skuid.$;

// Handle error messages
var displayMessage = function (message, severity) {
    var editor = $('#errorMessagePledgeAmountId ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var editor = $('#errorMessagePledgeAmountId ').data('object').editor;

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

var ApplicationCollateralNewModel = skuid.model.getModel('ApplicationCollateralNew');
var ApplicationCollateralNewRow = ApplicationCollateralNewModel.data[0];

var isNewCollateral = newCollateralCloneRow.NewCollateral;

if(isNewCollateral === true) {
    if(!ApplicationCollateralNewRow.genesis__Pledge_Amount__c ){
        return displayMessage('Please specify the pledge amount.', 'ERROR');
    }
    editor.messages.empty();
    if(ApplicationCollateralNewRow.genesis__Pledge_Amount__c && ApplicationCollateralNewRow.genesis__Pledge_Amount__c===0){
        return displayMessage('The pledge amount must be greater than zero.', 'ERROR');
    }

} else {
    if(!newAppCollRow.genesis__Pledge_Amount__c ){
        return displayMessage('Please specify the pledge amount.', 'ERROR');
    }
    editor.messages.empty();
    if(newAppCollRow.genesis__Pledge_Amount__c && newAppCollRow.genesis__Pledge_Amount__c===0){
        return displayMessage('The pledge amount must be greater than zero.', 'ERROR');
    }
    //newAppCollModel.updateRow(newAppCollRow, {'genesis__Application__c':skuid.page.params.id});

}
});
skuid.snippet.register('typeValidation',function(args) {/**
*  Purpose: Used for validation of whether user has selected any collateral type/collateral or not based on what he has chosen a
*  step before.Only allows users to goto next step if passed.
*  Where: step 2 next button
*
* @name  typeValidation.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/



var params = arguments[0],
$ = skuid.$;

var newCollateralTypeModel = skuid.model.getModel('CollateralTypeModel');
var newCollateralTypeRow = newCollateralTypeModel.data;

var valid_collaterals =[];

$.each( newCollateralTypeRow,function( i, item ){

    valid_collaterals.push(item.Name);

});

var wizard = $('.nx-wizard').data('object');
var currentStep = wizard.steps[wizard.currentstep];

var editor = $('#PanelForAll ').data('object').editor;
editor.clearMessages();

// Handle error messages
var displayMessage = function (message, severity) {

    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var newAppCollateralCloneModel = skuid.model.getModel('ApplicationCollateralClone');
var newAppCollateralCloneRow = newAppCollateralCloneModel.data[0];


if(newCollateralCloneRow.ExistingCollateral){
    if (!newAppCollateralCloneRow.genesis__Collateral__c) {
        return displayMessage('Select a collateral ', 'ERROR');
    }
    var newAppCollCloneModel = skuid.model.getModel('ApplicationCollateralClone');
    var newAppCollCloneRow = newAppCollCloneModel.data[0];

    if(newAppCollCloneRow.genesis__Collateral__r.clcommon__Collateral_Type__c) {
         if(valid_collaterals.indexOf(newAppCollCloneRow.genesis__Collateral__r.clcommon__Collateral_Type__r.Name) < 0){
             return displayMessage('Selected collateral does not have a valid type associated ', 'ERROR');
         }
    } else {
        return displayMessage('Selected Collateral Does Not Have a Valid Type Associated . ', 'ERROR');
    }
    newAppCollCloneModel.updateRow(newAppCollCloneRow,'genesis__justForCheck__c','true');

    // skuid.$C('commonEditor').render();

    // if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Aircraft') {
    //     skuid.$C('aircraftEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Mobile Home' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Equipment') {
    //     skuid.$C('mobileHomeEquEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Pleasure Boat' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receivables') {
    //     skuid.$C('pleaseureBotReceivablesEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Ship') {
    //     skuid.$C('shipEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Trailer') {
    //     skuid.$C('trailerEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Titled') {
    //     skuid.$C('otherTitledEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Note/Instrument') {
    //     skuid.$C('noteinstrumentEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Securities') {
    //     skuid.$C('securitiesEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Savings/CD\'s') {
    //     skuid.$C('savingcdEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Letter of Credit') {
    //     skuid.$C('letterofcreditEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receipts/Bills') {
    //     skuid.$C('receiptbillsEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Life Insurance') {
    //     skuid.$C('lifeinsuranceEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Government Contracts') {
    //     skuid.$C('govtContractEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == '1-4 Family' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Construction' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Multi-Family' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Lot' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Land' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Farm Land' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Office' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Warehouse'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Retail'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Oil and Gas' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other RE' ) {
    //     skuid.$C('mixedReEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Possessory') {
    //     skuid.$C('otherprocesseryEditor').render();
    // }

    currentStep.navigate('step3');

}else{
    if (!newCollateralRow.clcommon__Collateral_Type__c) {
        return displayMessage('Select a Collateral Type ', 'ERROR');

    }
    if(newCollateralRow.clcommon__Collateral_Type__c && newCollateralRow.clcommon__Collateral_Type__r.Name){
         if(valid_collaterals.indexOf(newCollateralRow.clcommon__Collateral_Type__r.Name) < 0){
             return displayMessage('Selected Collateral Type Is Not Supported ', 'ERROR');
         }
    }else{
        return displayMessage('Selected Collateral Type Is Not Supported . ', 'ERROR');
    }

    // skuid.$C('commonEditor').render();

    // if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Aircraft') {
    //     skuid.$C('aircraftEditor').render();
    // }
    // else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Mobile Home' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Equipment') {
    //     skuid.$C('mobileHomeEquEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Pleasure Boat' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receivables') {
    //     skuid.$C('pleaseureBotReceivablesEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Ship') {
    //     skuid.$C('shipEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Trailer') {
    //     skuid.$C('trailerEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Titled') {
    //     skuid.$C('otherTitledEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Note/Instrument') {
    //     skuid.$C('noteinstrumentEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Securities') {
    //     skuid.$C('securitiesEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Savings/CD\'s') {
    //     skuid.$C('savingcdEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Letter of Credit') {
    //     skuid.$C('letterofcreditEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Receipts/Bills') {
    //     skuid.$C('receiptbillsEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Life Insurance') {
    //     skuid.$C('lifeinsuranceEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Government Contracts') {
    //     skuid.$C('govtContractEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == '1-4 Family' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'All Real Estate Types' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Construction' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Multi-Family' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Lot' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Land' || newCollateralRow.clcommon__Collateral_Type__r.Name == 'Farm Land' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Office' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Warehouse'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Retail'  ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Oil and Gas' ||  newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other RE' ) {
    //     skuid.$C('mixedReEditor').render();
    // } else if(newCollateralRow.clcommon__Collateral_Type__r.Name == 'Other Possessory') {
    //     skuid.$C('otherprocesseryEditor').render();
    // }

    currentStep.navigate('step3');

}
});
skuid.snippet.register('step2PrevButton',function(args) {/**
*  Purpose: Used for refreshing the error panel when user move back to  previous step in step 3
*  Where: step 3 back button
*
* @name  step2PrevButton.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//params will contail all the info about the context of call like which record data calles it,what condition,etc
var params = arguments[0],
    $ = skuid.$;

//fetch the wizard object
var wizard = $('.nx-wizard').data('object');
//fetch wizard current step
var currentStep = wizard.steps[wizard.currentstep];

var editor = $('#PanelForAll ').data('object').editor;
editor.clearMessages();
//navigate to step 1 in wizard
currentStep.navigate('step1');
});
skuid.snippet.register('ApplicationCollateralUpdate',function(args) {/**
*  Purpose: Used for updating application and collateral junction object applicationCollateral with appId and collateralId and pledge amount
*  Where: step 4 next button
*
* @name  applicationCollateral.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/



var params = arguments[0],
    $ = skuid.$;

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];
newAppCollModel.cancel();

//get filterable off id
var appCollCondition = newAppCollModel.getConditionByName('genesis__Application__c_fil');

//setting condition value
newAppCollModel.setCondition(appCollCondition, skuid.page.params.id);

newAppCollModel.activateCondition(appCollCondition);

//updating model
newAppCollModel.updateData();
});
skuid.snippet.register('CloseCollateralDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

closeTopLevelDialogAndRefresh({divIds: ['deal-dashboard-iframe,collateral-tab','deal-dashboard-iframe,document-iframe']});
});
skuid.snippet.register('buttonHighlight',function(args) {var params = arguments[0],
    $ = skuid.$;
$('#newcollateralid').addClass('selected-btn');
$('#existingCollateralId').removeClass('selected-btn');
});
skuid.snippet.register('saveApplicationColl',function(args) {var params = arguments[0],
    $ = skuid.$;

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var ApplicationCollateralNewModel = skuid.model.getModel('ApplicationCollateralNew');
var ApplicationCollateralNewRow = ApplicationCollateralNewModel.data[0];

var newAppModel = skuid.model.getModel('Application');
var newAppRow = newAppModel.data[0];

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var orgParamModel = skuid.model.getModel('PledgeCollaterals_OrgParams');
var orgParamRow = orgParamModel.data[0];
var useAppraisalMgmt = orgParamRow.genesis__Use_Appraisal_Management__c;

var isNewCollateral = newCollateralCloneRow.NewCollateral;
var isMulticurrency = skuid.utils.isMultiCurrencyOrganization;

if(useAppraisalMgmt === true) {

    if(isNewCollateral === true) {

        if(isMulticurrency) {
            ApplicationCollateralNewModel.updateRow(ApplicationCollateralNewRow ,
                                            { 'genesis__Application__c' : skuid.page.params.id ,
                                              'genesis__Collateral__c' : newCollateralRow.Id,
                                              'CurrencyIsoCode':newAppRow.CurrencyIsoCode,
                                              'genesis__Pledge_Amount__c' : 0

                                            });
        } else {
            ApplicationCollateralNewModel.updateRow(ApplicationCollateralNewRow ,
                                            { 'genesis__Application__c' : skuid.page.params.id ,
                                              'genesis__Collateral__c' : newCollateralRow.Id,
                                              'genesis__Pledge_Amount__c' : 0

                                            });
        }



        var dfd = new $.Deferred();

        $.when(ApplicationCollateralNewModel.save())
            .done(function(){
               dfd.resolve();
            })
            .fail(function(){
               dfd.reject();
            });

        return dfd.promise();

    } else {

        var collValuationExistSnippet = skuid.snippet.getSnippet('collateralValuationExists');
        var res = collValuationExistSnippet();

        if(res === true) {
            /* if collateral valuation exist then pledge amount edit panel will be displayed . check if undefined and set to 0*/
            if(newAppCollRow.genesis__Pledge_Amount__c === undefined || newAppCollRow.genesis__Pledge_Amount__c < 0 ) {
                newAppCollModel.updateRow(newAppCollRow ,
                                            { 'genesis__Pledge_Amount__c' : 0
                                            });
            }
        } else {
            /* if collateral valuation dosen't exist -- send for appraisal and set pledge amount to 0 */
            newAppCollModel.updateRow(newAppCollRow ,
                                            { 'genesis__Pledge_Amount__c' : 0
                                            });
        }
        //if(newAppCollRow.clicked)
        newAppCollModel.updateRow(newAppCollRow ,
                                            { 'clicked' : true
                                            });

        var dfd = new $.Deferred();
        $.when(newAppCollModel.save())
            .done(function(){
               dfd.resolve();
            })
            .fail(function(){
               dfd.reject();
            });

        return dfd.promise();


    }

} else {
    /* If not using appraisal management then flow is as before */

    if(isNewCollateral === true) {

        if(isMulticurrency) {
            ApplicationCollateralNewModel.updateRow(ApplicationCollateralNewRow ,
                                            { 'genesis__Application__c' : skuid.page.params.id ,
                                              'genesis__Collateral__c' : newCollateralRow.Id,
                                              'CurrencyIsoCode':newAppRow.CurrencyIsoCode

                                            });
        } else {
            ApplicationCollateralNewModel.updateRow(ApplicationCollateralNewRow ,
                                            { 'genesis__Application__c' : skuid.page.params.id ,
                                              'genesis__Collateral__c' : newCollateralRow.Id

                                            });
        }



        var dfd = new $.Deferred();

        $.when(ApplicationCollateralNewModel.save())
            .done(function(){
               dfd.resolve();
            })
            .fail(function(){
               dfd.reject();
            });

        return dfd.promise();

    } else {
        var dfd = new $.Deferred();

        $.when(newAppCollModel.save())
            .done(function(){
               dfd.resolve();
            })
            .fail(function(){
               dfd.reject();
            });

        return dfd.promise();


    }

}
});
skuid.snippet.register('set-create-new-appraisal',function(args) {var params = arguments[0],
$ = skuid.$;

$('#set-yes-create-appraisal').addClass('selected-btn');
$('#set-no-create-appraisal').removeClass('selected-btn');

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

newCollateralModel.updateRow(newCollateralRow ,
                    { create_appraisal_request : true  });
});
skuid.snippet.register('unset-create-new-appraisal',function(args) {var params = arguments[0],
$ = skuid.$;

$('#set-no-create-appraisal').addClass('selected-btn');
$('#set-yes-create-appraisal').removeClass('selected-btn');

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

newCollateralModel.updateRow(newCollateralRow ,
                    { create_appraisal_request : false  });
});
skuid.snippet.register('isAppraisalRequestExist',function(args) {var params = arguments[0],
$ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var orgParamModel = skuid.model.getModel('PledgeCollaterals_OrgParams');
var orgParamRow = orgParamModel.data[0];
var useAppraisalMgmt = orgParamRow.genesis__Use_Appraisal_Management__c;


/* if new */
var result = sforce.apex.execute('genesis.AppraisalManagementWebService', 'isAppraisalIdExistForCollateral',
                                            { collateralId: newCollateralRow.Id

                                            });
if(result !== null && result != null && result != undefined && result != '') {
    /* set and activate condition*/
    var appReq = skuid.model.getModel('PledgeCollaterals_AppraisalRequestFetched');

    var appReqCondition = appReq.getConditionByName('appReqFetchedId');
    var resp = result.toString();
    var res = JSON.stringify(result).replace('/"["/g', '').replace(/"]"/g, '');
    appReq.setCondition(appReqCondition,resp);
    skuid.model.updateData([appReq],function(){

    });
    return true;

} else {
return false;
}
});
skuid.snippet.register('IsAppraisalRequestNotExist',function(args) {var params = arguments[0],
$ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];

var orgParamModel = skuid.model.getModel('PledgeCollaterals_OrgParams');
var orgParamRow = orgParamModel.data[0];
var useAppraisalMgmt = orgParamRow.genesis__Use_Appraisal_Management__c;


/* if new */
var result = sforce.apex.execute('genesis.AppraisalManagementWebService', 'isAppraisalIdExistForCollateral',
                                            { collateralId: newCollateralRow.Id

                                            });
if(result === null || result == null || result == undefined || result == '') {
    return true;
} else{
    return false;
}
});
skuid.snippet.register('checkAndCreateAppraisalRequest',function(args) {var params = arguments[0],
$ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral'); /* This fetches the newly created collateral for appraisal request */
var newCollateralRow = newCollateralModel.data[0];

var appColAssocn = skuid.model.getModel('ApplicationCollateralNew');
var appColAssocnRow = appColAssocn.data[0];

var newAppCollModel = skuid.model.getModel('ApplicationCollateral');
var newAppCollRow = newAppCollModel.data[0];

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var isNewCollateral = newCollateralCloneRow.NewCollateral;

// Handle error messages
var displayMessage = function (message, severity) {
    editor = $('#error-panel-pledge-collateral-id').data('object').editor;
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);
};

function throwError(err) {
    /* call error handler */
    return displayMessage(err,'ERROR');
}

if(newCollateralRow.create_appraisal_request !== undefined && newCollateralRow.create_appraisal_request !== null) {
    if(newCollateralRow.create_appraisal_request === true) {
        /* create appraisal request for the collateral*/

        var appReqModel = skuid.model.getModel('PledgeCollaterals_AppraisalRequest');
        var appReqRow = appReqModel.data[0];


        if(appReqRow.genesis__Due_Date__c === undefined) {
            throwError('Due date is required for creating appraisal request');
            return false;
        }

        var dateParts = appReqRow.genesis__Due_Date__c.split('-');
        var dueDate = dateParts[1] + '/' + dateParts[2] + '/' + dateParts[0];

        if(isNewCollateral === true) {

            var result = sforce.apex.execute('genesis.AppraisalManagementWebService', 'createAppraisalRequest',
                                            { applicationCollateralId: appColAssocnRow.Id,
                                              appraisalDueDate:dueDate

                                            });
            if(result != 'SUCCESS') {
                var err = 'Unable to create appraisal request: '+result;
                alert(err);
            } else {
                alert(result);
            }

        } else {
            var result = sforce.apex.execute('genesis.AppraisalManagementWebService', 'createAppraisalRequest',
                                            { applicationCollateralId: newAppCollRow.Id,
                                              appraisalDueDate:dueDate

                                            });
            if(result != 'SUCCESS') {
                var err = 'Unable to create appraisal request: '+result;
                alert(err);
            } else {
                alert(result);
            }
        }

    } else {
        /* Do not create appraisal request for the collateral*/
    }
}
});
skuid.snippet.register('collateralValuationDoseNotExists',function(args) {var params = arguments[0],
$ = skuid.$;

var collValModel = skuid.model.getModel('PledgeCollaterals_CollateralValuation');
var colValRow = collValModel.data[0];


if(colValRow !== undefined) {
    return false;
}

return true;
});
skuid.snippet.register('updateRemainingValue',function(args) {var params = arguments[0],
$ = skuid.$;

var collValModel = skuid.model.getModel('PledgeCollaterals_CollateralValuation');
var collValRow = collValModel.getFirstRow();

var allAppForCollateralModel = skuid.model.getModel('PledgeCollaterals_ApplicationsForCollateral');
var allAppForCollateralList = allAppForCollateralModel.data;

var total_pladge_amt = 0;

if(allAppForCollateralList !== undefined) {
    /* sum all pledge amount across all application for this collateral */
    $.each(allAppForCollateralList, function(fieldId,appColRow) {
        $.each(appColRow,function(fieldName,val) {
            if ((fieldName != 'attributes') && (fieldName === 'genesis__Pledge_Amount__c')) {
                if(val !== undefined && val !== null) {
                    total_pladge_amt = total_pladge_amt + val;
                    console.log('Am I here?1');

                }

            }
        });
    });
    if(collValRow !== undefined) {
        /* update remianing value = Appraisaed_Value -Sum(Pledge_Amount across other loan application) */
        collValModel.updateRow(collValRow,{
             RemainingValue: collValRow.clcommon__Appraised_Value__c - total_pladge_amt
        });
        console.log('Am I here?2');
    }
}
console.log('Am I here?3');
});
skuid.snippet.register('validatePledgeAmount',function(args) {var params = arguments[0],
    $ = skuid.$;

// Handle error messages
var displayMessage = function (message, severity) {
    var editor = $('#error-panel-pledge-collateral-id').data('object').editor;
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var appColRowForPledgeAmt = skuid.model.getModel('ApplicationCollateral').getFirstRow();
var appColRowForRemainingVal = skuid.model.getModel('PledgeCollaterals_CollateralValuation').getFirstRow();

var appColRowForPreviousPledgeAmt = skuid.model.getModel('PledgeCollaterals_ApplicationCollateralForPreviousPledgeAmount').getFirstRow();

var pledgeAmt;
var remainingAmt;
var previousPledgeAmt;

if(appColRowForPledgeAmt !== undefined) {
    pledgeAmt = appColRowForPledgeAmt.genesis__Pledge_Amount__c;

}

if(appColRowForPreviousPledgeAmt !== undefined) {
    previousPledgeAmt = appColRowForPreviousPledgeAmt.genesis__Pledge_Amount__c;
}
if(previousPledgeAmt === undefined) {
    previousPledgeAmt = 0;
}
console.log('Am I here?4');
if(appColRowForRemainingVal !== undefined) {
    remainingAmt = appColRowForRemainingVal.RemainingValue;
    if(isNaN(Number.parseFloat(pledgeAmt))) {
        return displayMessage('The collateral pledge amount should be a number ', 'ERROR');
    }else if(pledgeAmt < 0) {
        return displayMessage('The collateral pledge amount cannot be less than 0 ', 'ERROR');
    } else if(pledgeAmt - previousPledgeAmt > 0 && pledgeAmt - previousPledgeAmt > remainingAmt) {
        /* throw error message; return false */
        return displayMessage('The collateral pledge amount cannot exceed the available appraised value remaining for the collateral ', 'ERROR');
    } else {
        /* return true;*/
        console.log('Am I here?5');
        return true;
    }
}
console.log('Am I here?6');
return true;
});
skuid.snippet.register('collateralValuationExists',function(args) {var params = arguments[0],
$ = skuid.$;

var collValModel = skuid.model.getModel('PledgeCollaterals_CollateralValuation');
var colValRow = collValModel.data[0];

if(colValRow !== undefined) {
    return true;
}

return false;
});
skuid.snippet.register('fetchData',function(args) {var params = arguments[0],
    $ = skuid.$;

var newColOwner = skuid.model.getModel('CollateralOwner');
var newColOwnerRow = newColOwner.data[0];
newColOwner.cancel();

var collateralModel = skuid.model.getModel('Collateral');
var colRow = collateralModel.data[0];

//get filterable off id
var colOwnerCondition = newColOwner.getConditionByName('clcommon__Collateral__c__fil');

//setting condition value
newColOwner.setCondition(colOwnerCondition, colRow.Id);

newColOwner.activateCondition(colOwnerCondition);

//updating model
newColOwner.updateData();
});
skuid.snippet.register('ownershipValidation',function(args) {var params = arguments[0],
$ = skuid.$;

var collOwner = skuid.model.getModel('CollateralOwner');

var collateral = skuid.model.getModel('Collateral');
var colRow = collateral.data[0];
var percentageSum = 0;
var percentExceeded = false;
var zeroOwnership = false;

$.each(collOwner.getRows(),function(i,row){
    if(row.clcommon__Collateral__c == colRow.Id){
        percentageSum = percentageSum + row.clcommon__Ownership__c ;
        if(row.clcommon__Ownership__c === 0){
          zeroOwnership = true;  
        }
    }
});
console.log('Test 1');

if(percentageSum > 100){
    percentExceeded = true;
    collOwner.cancel();
    alert('Ownership percentage cannot exceed 100%!');
}
//console.log('Test 2');
 
 else if(zeroOwnership === true){
    collOwner.cancel();
    alert('Ownership percentage cannot be 0%!'); 
 }
 else
 collOwner.save();
 //console.log('Test 3');
 
 var dfd = new $.Deferred();

    $.when(collOwner.save())
        .done(function(){
           dfd.resolve();
        })
        .fail(function(){
           dfd.reject();
        });
        console.log('Test 4');

    return dfd.promise();
});
skuid.snippet.register('highlightRow',function(args) {var collateralClone = skuid.model.getModel('CollateralClone');
var collateralCloneRow = collateralClone.data[0];
if(collateralCloneRow.ExistingCollateral === true){
var parties = skuid.model.getModel('ApplicationParty');
var partyList = new Array();
$.each(parties.getRows(),function(i,row){
   if(row.clcommon__Account__c !== undefined){
       partyList.push(row.clcommon__Account__c);
   }
});

var field = arguments[0], 
value = skuid.utils.decodeHTML(arguments[1]); 
var externalOwner = false;

skuid.ui.fieldRenderers[field.metadata.displaytype][field.mode](field,value); 

if (!partyList.includes(value)){ 
        externalOwner = true;
        field.item.element.addClass("Highlighted-row");
    }

return externalOwner;
}
});
skuid.snippet.register('SaveSecAddressAsSecName',function(args) {var colModel = skuid.model.getModel('Collateral');
var colRow = colModel.data[0];
var address = (((colRow.Unit_No__c === undefined || colRow.Unit_No__c === null || colRow.Unit_No__c.length <= 0) ? '' : (colRow.Unit_No__c+' '))+((colRow.Street_No__c === undefined || colRow.Street_No__c === null || colRow.Street_No__c.length <= 0) ? '' : (colRow.Street_No__c+' '))+((colRow.Street_Name__c === undefined || colRow.Street_Name__c === null || colRow.Street_Name__c.length <= 0) ? '' : (colRow.Street_Name__c+' '))+((colRow.Street_Type__c === undefined || colRow.Street_Type__c === null || colRow.Street_Type__c.length <= 0) ? '' : (colRow.Street_Type__c+' '))+((colRow.clcommon__City__c === undefined || colRow.clcommon__City__c === null || colRow.clcommon__City__c.length <= 0) ? '' : (colRow.clcommon__City__c+' '))+((colRow.clcommon__State__c === undefined || colRow.clcommon__State__c === null || colRow.clcommon__State__c.length <= 0) ? '' : (colRow.clcommon__State__c+' '))+((colRow.Country__c === undefined || colRow.Country__c === null || colRow.Country__c.length <= 0) ? '' : (colRow.Country__c+' '))+((colRow.clcommon__Postal_Code__c === undefined || colRow.clcommon__Postal_Code__c === null || colRow.clcommon__Postal_Code__c.length <= 0) ? '' : (colRow.clcommon__Postal_Code__c+' ')));
colModel.updateRow(colRow,'clcommon__Collateral_Name__c',address);
//skuid.model.save([
//   colModel
//]) ;
});
}(window.skuid));