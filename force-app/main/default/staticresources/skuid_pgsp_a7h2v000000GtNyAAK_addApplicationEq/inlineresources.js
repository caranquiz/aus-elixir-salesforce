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

$('#equipmentMasterId').removeClass('selected-btn');
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

$('#equipmentMasterId').removeClass('selected-btn');
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
skuid.snippet.register('typeValidation',function(args) {var params = arguments[0],
$ = skuid.$;

var valid_collaterals =[];

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
var existCollateral = skuid.model.getModel('ApplicationCollateralClone');
    existCollateral = existCollateral.data[0];
var equipmentMaster = skuid.model.getModel('EquipmentMasterUIOnly');
var equipmentMasterRow = equipmentMaster.data[0];
if(!newCollateralCloneRow.ExistingCollateral && !newCollateralCloneRow.NewCollateral){
    if(!equipmentMasterRow.equipmentId) {
        return displayMessage('Select a Equipment Master Id ', 'ERROR');
    }

} else if(newCollateralCloneRow.ExistingCollateral){
    if (!existCollateral.genesis__Collateral__c) {
        return displayMessage('Select a collateral ', 'ERROR');
    }
   // newCollateralRow.clcommon__Collateral_Type__c =  newCollateralRow.EquipmentPickList;
    var sql = "SELECT Id, Name FROM genesis__Application_Collateral__c  where genesis__Collateral__c  = '"+existCollateral.genesis__Collateral__c+"'";
    console.log('sql is: '+sql);
    result = sforce.connection.query(sql);
    console.log('result: '+result);
    var recordsArr = result.getArray('records');
    console.log('recordsArr: '+recordsArr);
    
    var sqlColl = "SELECT Id, clcommon__Book_Value__c FROM clcommon__Collateral__c where ID = '"+existCollateral.genesis__Collateral__c+"'"; 
    value = sforce.connection.query(sqlColl);
    console.log('value: '+value);
    var recordsArrColl = value.getArray('records');
    console.log('recordsArrColl: '+recordsArrColl);
    


    if(recordsArrColl[0].clcommon__Book_Value__c) {
        existCollateral.genesis__Estimated_Selling_Price__c = recordsArrColl[0].clcommon__Book_Value__c;
    }
    existCollateral.genesis__Collateral__c =  existCollateral.genesis__Collateral__c;
    var ESFParentId =  newCollateralModel.getConditionByName('updateData');
    newCollateralModel.setCondition(ESFParentId,existCollateral.genesis__Collateral__c);
    
    skuid.model.updateData([newCollateralModel],function(){
       console.log('update data complete!');
    });

}else{

     if (!newCollateralRow.clcommon__Collateral_Type__c) {
        return displayMessage('Select a Collateral Type ', 'ERROR');

    }
}
currentStep.navigate('step3');
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


                }

            }
        });
    });
    if(collValRow !== undefined) {
        /* update remianing value = Appraisaed_Value -Sum(Pledge_Amount across other loan application) */
        collValModel.updateRow(collValRow,{
             RemainingValue: collValRow.clcommon__Appraised_Value__c - total_pladge_amt
        });
    }
}
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
skuid.snippet.register('equipmentMaster',function(args) {var params = arguments[0],
$ = skuid.$;

$('#equipmentMasterId').addClass('selected-btn');
$('#newcollateralid').removeClass('selected-btn');
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
                        { NewCollateral : false ,
                          ExistingCollateral : false });

}
});
skuid.snippet.register('saveAppColNew',function(args) {var params = arguments[0],
$ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral');
newCollateralModel = newCollateralModel.data[0];
var newEquipmentDetails = skuid.model.getModel('ApplicationCollateralClone');
newEquipmentDetails = newEquipmentDetails.data[0];

var quickQuote = skuid.model.getModel('Application');
quickQuote = quickQuote.data[0];
var CollateralCatTypeAssio = skuid.model.getModel('CollateralCategoryTypeAssociation');
newCollateralModel.clcommon__Collateral_Type__c = CollateralCatTypeAssio.data[0].clcommon__Collateral_Type__r.Id;
newCollateralModel.clcommon__Collateral_Category__c = CollateralCatTypeAssio.data[0].clcommon__Collateral_Category__r.Id;

for(var key in newCollateralModel) {
    if(key.indexOf("__c", key.length - 3) === -1) {
       delete newCollateralModel[key];
    }
}

for(var key in newEquipmentDetails) {
    if(key.indexOf("__c", key.length - 3) === -1) {

       delete newEquipmentDetails[key];
    }
}
    
    var result = sforce.apex.execute('genesis.AppCollSaveAndUpdateActions','saveOrUpdateAppCollateral',{
             collParams : JSON.stringify(newCollateralModel),
             appCollParams : JSON.stringify(newEquipmentDetails),
             appId : quickQuote.Id
        });


    try {
        var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', {
            applicationId : quickQuote.Id
        }
    );

   } catch (err) {
    console.log('Error getting pricing: ' + err.description);
 }

closeTopLevelDialogAndRefresh({divIds: ['deal-dashboard-iframe,eq-tab','deal-dashboard-iframe,document-iframe']});
});
skuid.snippet.register('saveAppColExisting',function(args) {var params = arguments[0],
	$ = skuid.$;


var newCollateralModel = skuid.model.getModel('Collateral');
newCollateralModel = newCollateralModel.data[0];

var newEquipmentDetails = skuid.model.getModel('ApplicationCollateralClone');
newEquipmentDetails = newEquipmentDetails.data[0];

var quickQuote = skuid.model.getModel('Application');
quickQuote = quickQuote.data[0];

var CollateralCatTypeAssio = skuid.model.getModel('CollateralCategoryTypeAssociation');
newCollateralModel.clcommon__Collateral_Type__c = CollateralCatTypeAssio.data[0].clcommon__Collateral_Type__r.Id;
newCollateralModel.clcommon__Collateral_Category__c = CollateralCatTypeAssio.data[0].clcommon__Collateral_Category__r.Id;
for(var key in newCollateralModel) {
    if(key.indexOf("__c", key.length - 3) === -1 && !(key.toUpperCase() === "ID15" || key.toUpperCase() === "ID")) {
       delete newCollateralModel[key];
    }
}

for(var key in newEquipmentDetails) {

    if(key.indexOf("__c", key.length - 3) === -1 ) {
       delete newEquipmentDetails[key];
    }
}

var result = sforce.apex.execute('genesis.AppCollSaveAndUpdateActions','saveOrUpdateAppCollateral',{
             collParams : JSON.stringify(newCollateralModel),
             appCollParams : JSON.stringify(newEquipmentDetails),
             appId : quickQuote.Id
        });


try {
    var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', {
            applicationId : quickQuote.Id
        }
    );

} catch (err) {
    console.log('Error getting pricing: ' + err.description);
}

closeTopLevelDialogAndRefresh({divIds: ['deal-dashboard-iframe,eq-tab','deal-dashboard-iframe,document-iframe']});
});
skuid.snippet.register('updatePricing',function(args) {var appModel = skuid.$M('ApplicationCollateralClone');
// Get reference to the first row
var appRow = appModel.getFirstRow();
alert('appRow : '+appRow);
alert('appId: '+appRow.genesis__Application__c);
try {
    var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', {
            applicationId : appRow.genesis__Application__c
        }
    );
    console.log(result);
} catch (err) {
    console.log('Error getting pricing: ' + err.description);
}
});
skuid.snippet.register('saveEquipmentMaster',function(args) {var params = arguments[0],
	$ = skuid.$;

var editor = $('#PanelForEq').data('object').editor;
editor.clearMessages();

 var displayMessage = function(message, severity) {

     editor.handleMessages([{
        message: message,
        severity: severity.toUpperCase()
    }]);

     return false;
};

var equipmentMaster = skuid.model.getModel('EquipmentMasterUIOnly');
var equipmentMasterRow = equipmentMaster.data[0];
if(!equipmentMasterRow.NumberOfEquipment) {
    return displayMessage('Select Number of Equipments ', 'ERROR');
} else {
    
    var quickQuote = skuid.model.getModel('Application');
    quickQuote = quickQuote.data[0];
    var documentNotification = sforce.apex.execute('genesis.AppCollSaveAndUpdateActions','saveOrUpdateCollateralBulkData',{
             equipmentMasterId : equipmentMasterRow.equipmentId,
             noOfEquipments : equipmentMasterRow.NumberOfEquipment,
             appId : quickQuote.Id
        });

    try {
        var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', {
            applicationId : quickQuote.Id
        }
    );

  } catch (err) {
    console.log('Error getting pricing: ' + err.description);
  }

closeTopLevelDialogAndRefresh({divIds: ['deal-dashboard-iframe,eq-tab,document-iframe','deal-dashboard-iframe,document-iframe']});
}
});
skuid.snippet.register('reLoad',function(args) {var params = arguments[0],
	$ = skuid.$;
window.location.reload(true);
});
}(window.skuid));