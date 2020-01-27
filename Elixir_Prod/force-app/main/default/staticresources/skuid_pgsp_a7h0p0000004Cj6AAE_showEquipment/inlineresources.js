(function(skuid){
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
* @author virendra Parihar
* @version 1.0
* @since   06-18-2016
*/


var params = arguments[0],
$ = skuid.$;

$('#equipmentMasterId').removeClass('selected-btn');
$('#newcollateralid').removeClass('selected-btn');
$('#existingCollateralId').addClass('selected-btn');

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

var valid_collaterals = [];

var wizard = $('.nx-wizard').data('object');
var currentStep = wizard.steps[wizard.currentstep];

var editor = $('#PanelForAll ').data('object').editor;
editor.clearMessages();

// Handle error messages
var displayMessage = function(message, severity) {

    editor.handleMessages([{
        message: message,
        severity: severity.toUpperCase()
    }]);

    return false;
};

var newCollateralCloneModel = skuid.model.getModel('CollateralClone');
var newCollateralCloneRow = newCollateralCloneModel.data[0];

var newCollateralModel = skuid.model.getModel('Collateral');
var newCollateralRow = newCollateralModel.data[0];
var existCollateral = skuid.model.getModel('QQEquipmentModelNew');
existCollateral = existCollateral.data[0];
var equipmentMaster = skuid.model.getModel('EquipmentMasterUIOnly');
var equipmentMasterRow = equipmentMaster.data[0];
if (!newCollateralCloneRow.ExistingCollateral && !newCollateralCloneRow.NewCollateral) {
    if(!equipmentMasterRow.equipmentId) {
		return displayMessage('Select a Equipment Master Id ', 'ERROR');
	}
} else if (newCollateralCloneRow.ExistingCollateral) {
    if (!existCollateral.genesis__Collateral__c) {
        return displayMessage('Select a Collateral ', 'ERROR');
    }
    // newCollateralRow.clcommon__Collateral_Type__c =  newCollateralRow.EquipmentPickList;
    var sql = "SELECT Id, Name FROM genesis__Quick_Quote_Equipment__c  where genesis__Collateral__c  = '" + existCollateral.genesis__Collateral__c + "'";
    result = sforce.connection.query(sql);
    var recordsArr = result.getArray('records');
    existCollateral.genesis__Collateral__c = existCollateral.genesis__Collateral__c;
    var ESFParentId = newCollateralModel.getConditionByName('updateData');
    newCollateralModel.setCondition(ESFParentId, existCollateral.genesis__Collateral__c);

    var quickQuoteModel = skuid.model.getModel('QQEquipmentModelExisting');
    var quickQuoteCollateralId = quickQuoteModel.getConditionByName('genesis__Collateral__c');
    quickQuoteModel.setCondition(quickQuoteCollateralId, recordsArr[0].Id);

    skuid.model.updateData([quickQuoteModel, newCollateralModel], function() {
        console.log('update data complete!');
    });

} else {

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
skuid.snippet.register('buttonHighlight',function(args) {var params = arguments[0],
    $ = skuid.$;
$('#newcollateralid').addClass('selected-btn');
$('#existingCollateralId').removeClass('selected-btn');
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
skuid.snippet.register('SaveEquipment',function(args) {var params = arguments[0],
	$ = skuid.$;

var newCollateralModel = skuid.model.getModel('Collateral');
newCollateralModel = newCollateralModel.data[0];

var newEquipmentDetails = skuid.model.getModel('QQEquipmentModelNew');
newEquipmentDetails = newEquipmentDetails.data[0];

var quickQuote = skuid.model.getModel('QuickQuote');
quickQuote = quickQuote.data[0];
var CollateralCatTypeAssio = skuid.model.getModel('CollateralCategoryTypeAssociation');
newCollateralModel.clcommon__Collateral_Type__c = newCollateralModel.clcommon__Collateral_Type__r.Id;
newCollateralModel.clcommon__Collateral_Category__c = CollateralCatTypeAssio.data[0].clcommon__Collateral_Category__r.Id;
// Note: cache should not be re-used by repeated calls to JSON.stringify.
var cache = [];
for(var key in newCollateralModel) {
    if(key.indexOf("__c", key.length - 3) === -1) {
       delete newCollateralModel[key];  
    }
}    

for(var key in newEquipmentDetails) {
    if(key.indexOf("__c", key.length - 3) === -1) {
       //alert('key : ' + key);
       delete newEquipmentDetails[key];
    }    
}

var result = sforce.apex.execute('genesis.CollateralSaveAndUpdateActions','saveOrUpdateCollateral',{
             collParams : JSON.stringify(newCollateralModel),
             qqEquipmentParams : JSON.stringify(newEquipmentDetails),
             quickQuoteId : quickQuote.Id
        });
        
skuid.snippet.getSnippet('CalcAmtsOnQQ')();
alert(result);
skuid.$('.ui-dialog-content').last().dialog('close');
skuid.$C('EquipmentData').render();
});
skuid.snippet.register('SaveExistingEquipment',function(args) {var params = arguments[0],
	$ = skuid.$;


var newCollateralModel = skuid.model.getModel('Collateral');
newCollateralModel = newCollateralModel.data[0];

var newEquipmentDetails = skuid.model.getModel('QQEquipmentModelExisting');
newEquipmentDetails = newEquipmentDetails.data[0];
var quickQuote = skuid.model.getModel('QuickQuote');
quickQuote = quickQuote.data[0];

var CollateralCatTypeAssio = skuid.model.getModel('CollateralCategoryTypeAssociation');
newCollateralModel.clcommon__Collateral_Type__c = newCollateralModel.clcommon__Collateral_Type__r.Id;
newCollateralModel.clcommon__Collateral_Category__c = CollateralCatTypeAssio.data[0].clcommon__Collateral_Category__r.Id;
for(var key in newCollateralModel) {
    if(key.indexOf("__c", key.length - 3) === -1 && !(key.toUpperCase() === "ID15" || key.toUpperCase() === "ID")) {
       delete newCollateralModel[key];
    }    
}

for(var key in newEquipmentDetails) {
    if(key.indexOf("__c", key.length - 3) === -1 && !(key.toUpperCase() === "ID15" || key.toUpperCase() === "ID")) {
       //alert('key : ' + key);
       delete newEquipmentDetails[key];
    }    
}

var result = sforce.apex.execute('genesis.CollateralSaveAndUpdateActions','saveOrUpdateCollateral',{
collParams : JSON.stringify(newCollateralModel),
qqEquipmentParams : JSON.stringify(newEquipmentDetails),
quickQuoteId : quickQuote.Id
});

skuid.snippet.getSnippet('CalcAmtsOnQQ')();
alert(result)
skuid.$('.ui-dialog-content').last().dialog('close');
skuid.$C('EquipmentData').render();
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
skuid.snippet.register('SaveEquipmentMaster',function(args) {var params = arguments[0],
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
    var quickQuote = skuid.model.getModel('QuickQuote');
quickQuote = quickQuote.data[0];
var documentNotification = sforce.apex.execute('genesis.CollateralSaveAndUpdateActions','saveOrUpdateCollateralBulkData',{
             equipmentMasterId : equipmentMasterRow.equipmentId,
             noOfEquipments : equipmentMasterRow.NumberOfEquipment,
             quickQuoteId : quickQuote.Id
        });

skuid.snippet.getSnippet('CalcAmtsOnQQ')();
skuid.$('.ui-dialog-content').last().dialog('close');
skuid.$C('EquipmentData').render();
}
});
skuid.snippet.register('CalcAmtsOnQQ',function(args) {var qqModel = skuid.$M('QuickQuote'); 
                // Get reference to the first row
                var qqRow = qqModel.data[0];
                var $ = skuid.$;
                var pageTitle = $('#errorPanelEquipment'); //$('#errorPanelEquipment'); // $('#sk-1USljW-640');
                var editor = pageTitle.data('object').editor;
                console.log('editor ',editor);
                var quickQuoteObjEq = new sforce.SObject("genesis__Quick_Quotes__c");
                for(var key in qqRow) {
                   if(key.includes('__c') || key === 'Id') {
                       quickQuoteObjEq[key] = qqRow[key];
                   }    
                }
                var result = sforce.apex.execute(
                        'genesis.SkuidQQPricingCtrl',
                        'generatePricingForQQ', { 
                            quickQuote :  quickQuoteObjEq,
                            queryQuickQuote : true,
                            isEquipmentBeingAdded : true
                        }
                    );
                
                var resObj = JSON.parse(result);
                console.log('resObj ',resObj);
                if(resObj.status != 'ERROR') {
                    editor.handleMessages(
                        [
                          {
                              message: 'Equipment Saved!',
                              severity: 'INFO'
                          }
                        ]
                    );
                } else {
                    editor.handleMessages(
                        [
                          {
                              message: resObj.errorMessage,
                              severity: 'ERROR'
                          }
                        ]
                    );
                    return false;
                
                }
                window.location.reload();
});
}(window.skuid));