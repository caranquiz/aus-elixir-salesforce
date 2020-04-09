(function(skuid){
skuid.snippet.register('fieldRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];

var model = skuid.$M('SelectedApplicationCollateral');
var renderMode = model.conditions[1].value;
if(renderMode !== 'read') {
    renderMode = 'edit';
}
// var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

closeTopLevelDialogAndRefresh({divIds: ['deal-dashboard-iframe,collateral-tab']});
});
skuid.snippet.register('isReadMode',function(args) {var params = arguments[0],
	$ = skuid.$;
var model = skuid.$M('SelectedApplicationCollateral');
var renderMode = model.conditions[1].value;
return renderMode !== 'read';
});
skuid.snippet.register('DeleteSecurity',function(args) {var params = arguments[0],
    $ = skuid.$;

var appCollModel = skuid.model.getModel('SelectedApplicationCollateral');
var appCollRow = appCollModel.data[0];
var appCollId = appCollRow.Id;
var delResult = sforce.connection.deleteIds([appCollId]);
skuid.$('#collateral-tab').data('object').load();
});
skuid.snippet.register('newSnippet',function(args) {var params = arguments[0],
	$ = skuid.$;
var customSelect = skuid.ui.renderers.PICKLIST.edit({

    entries : initials,

    required : false,

    defaultValue : Purchase

})
});
skuid.snippet.register('populateSecAddressInSecName',function(args) {var colModel = skuid.model.getModel('SelectedCollateral');
var colRow = colModel.data[0];
var address = (((colRow.Unit_No__c === undefined || colRow.Unit_No__c === null || colRow.Unit_No__c.length <= 0) ? '' : (colRow.Unit_No__c+' '))+((colRow.Street_No__c === undefined || colRow.Street_No__c === null || colRow.Street_No__c.length <= 0) ? '' : (colRow.Street_No__c+' '))+((colRow.Street_Name__c === undefined || colRow.Street_Name__c === null || colRow.Street_Name__c.length <= 0) ? '' : (colRow.Street_Name__c+' '))+((colRow.Street_Type__c === undefined || colRow.Street_Type__c === null || colRow.Street_Type__c.length <= 0) ? '' : (colRow.Street_Type__c+' '))+((colRow.clcommon__City__c === undefined || colRow.clcommon__City__c === null || colRow.clcommon__City__c.length <= 0) ? '' : (colRow.clcommon__City__c+' '))+((colRow.clcommon__State__c === undefined || colRow.clcommon__State__c === null || colRow.clcommon__State__c.length <= 0) ? '' : (colRow.clcommon__State__c+' '))+((colRow.Country__c === undefined || colRow.Country__c === null || colRow.Country__c.length <= 0) ? '' : (colRow.Country__c+' '))+((colRow.clcommon__Postal_Code__c === undefined || colRow.clcommon__Postal_Code__c === null || colRow.clcommon__Postal_Code__c.length <= 0) ? '' : (colRow.clcommon__Postal_Code__c+' ')));
colModel.updateRow(colRow,'clcommon__Collateral_Name__c',address);
});
skuid.snippet.register('SummationOfValue',function(args) {var params = arguments[0],
	$ = skuid.$;
var allColModel = skuid.model.getModel('AllCollateral');
var colModel = skuid.model.getModel('SelectedCollateral');
var appModel = skuid.model.getModel('Application');
var appRow = appModel.data[0];
var totalValue=0;
$.each(allColModel.data,function(i,row){
    var val=0;
    //console.log(row);
    //console.log(row.clcommon__Value__c) ;
    val=(row.clcommon__Value__c!==undefined && row.clcommon__Value__c!==null && row.clcommon__Value__c!=='') ? row.clcommon__Value__c : 0
    totalValue = totalValue + val;
});
//console.log(totalValue);
appModel.updateRow(appRow,'Actual_Security_Value__c',totalValue);

//app model update
});
skuid.snippet.register('Reload',function(args) {var params = arguments[0],
	$ = skuid.$;
window.location.reload(true);
});
skuid.snippet.register('checkOwnershipPercentage',function(args) {var params = arguments[0],
	$ = skuid.$;
var colOwner = skuid.model.getModel('CollateralOwner');
var colRow = colOwner.data[0];

var pageTitle2 = $('#sk-2Ipz-2635'); // pagetitle unique id
var editor2 = pageTitle2.data('object').editor;

var sum =0;
$.each(colOwner.getRows(),function(i,row){
       sum = sum + row.clcommon__Ownership__c;
});

if(sum>100){
    alert('Total ownership should not exceed 100%');
    return false;
}
else{
    colOwner.save();
    return true;
}
});
}(window.skuid));