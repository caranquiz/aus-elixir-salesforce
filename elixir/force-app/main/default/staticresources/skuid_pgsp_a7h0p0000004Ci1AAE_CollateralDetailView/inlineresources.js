(function(skuid){
skuid.snippet.register('deleteApplicationCollateral',function(args) {var params = arguments[0],
    $ = skuid.$;

var appCollModel = skuid.model.getModel('AppCollateralAssociation');
var appCollRow = appCollModel.data[0];
var appCollId = appCollRow.Id;
var delResult = sforce.connection.deleteIds([appCollId]);
skuid.$('#collateral-tab').data('object').load();
});
skuid.snippet.register('LaunchEditCollateral',function(args) {var params = arguments[0],
    $ = skuid.$;
var applicationCollateral = skuid.model.getModel('AppCollateralAssociation').getFirstRow();
var title = 'Edit ' + applicationCollateral.genesis__Collateral__r.Name;
var skuidPage = 'CollateralDetails';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + applicationCollateral.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('validatePledgeAmount',function(args) {var params = arguments[0],
    $ = skuid.$;

// Handle error messages
var displayMessage = function (message, severity) {
    var editor = $('#pledge-collateral-title-id ').data('object').editor;
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var appColRowForPledgeAmt = skuid.model.getModel('AppCollateralAssociation').getFirstRow();
var appColRowForRemainingVal = skuid.model.getModel('CollateralDetailView_CollateralValuation').getFirstRow();
var appColRowForPreviousPledgeAmt = skuid.model.getModel('CollateralDetailView_ApplicationCollateralForPreviousPledgeAmount').getFirstRow();



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
        return true;
    }
}

return true;
});
skuid.snippet.register('CreateAppraisalBids',function(args) {var params = arguments[0],
	$ = skuid.$;

var appBid = skuid.model.getModel('AppraisalBid');
var appReq = skuid.model.getModel('AppraisalRequest');
var appCol = skuid.model.getModel('AppCollateralAssociation');
var appAssocn = skuid.model.getModel('AppraisalAssociation') ;

var req = appReq.getFirstRow();
var col = appCol.getFirstRow();


$.each(appAssocn.getRows(),function(i,row){
if(row.genesis__Collateral_Category__r.Name == col.genesis__Collateral__r.clcommon__Collateral_Category__r.Name)
    var bid = appBid.createRow({
         additionalConditions: [
        { field: 'genesis__Appraisal_Request__c', value: appReq.getFieldValue(req,'Id') },
        { field: 'genesis__Status__c', value: 'Pending'},
        { field: 'genesis__Authorized_Appraiser__c', value: row.genesis__Appraiser__c},
         ]
    });


});

var dfd = new $.Deferred();

    $.when(appBid.save())
        .done(function(){
           dfd.resolve();
        })
        .fail(function(){
           dfd.reject();
        });

    return dfd.promise();
});
skuid.snippet.register('ExistingAppraisalRequest',function(args) {var params = arguments[0],
	$ = skuid.$;
var appReq = skuid.model.getModel('AppraisalRequest');
var appColAssocn = skuid.model.getModel('AppCollateralAssociation');
var col = appColAssocn.data[0];
var existingAppraisal = false;

$.each(appReq.getRows(),function(i,row){
    if(row.genesis__Application_Collateral__c !== undefined && row.genesis__Application_Collateral__r.genesis__Collateral__c == col.genesis__Collateral__c){
        existingAppraisal = true;
    }

    else if((row.genesis__Status__c == 'Expired') || (row.genesis__Status__c == 'Closed')){
        existingAppraisal = false;
    }
});

return existingAppraisal;
});
skuid.snippet.register('NewAppraisalRequest',function(args) {var params = arguments[0],
	$ = skuid.$;
var appReq = skuid.model.getModel('AppraisalRequest');
var appColAssocn = skuid.model.getModel('AppCollateralAssociation');
var col = appColAssocn.data[0];
var newAppraisal = true;

$.each(appReq.getRows(),function(i,row){

    if(row.genesis__Application_Collateral__c !== undefined && row.genesis__Application_Collateral__r.genesis__Collateral__c == col.genesis__Collateral__c){
        newAppraisal = false;
    } else if((row.genesis__Status__c == 'Expired') || (row.genesis__Status__c == 'Closed')){
       newAppraisal = true;
    }

});

return newAppraisal;
});
skuid.snippet.register('AppraisalAdminExists',function(args) {var params = arguments[0],
	$ = skuid.$;

// Handle error messages
var displayMessage = function (message, severity) {
    var editor = $('#collNameTitlePanel ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var colType = skuid.model.getModel('CollateralCategory');
var appColAssocn = skuid.model.getModel('AppCollateralAssociation');
var col = appColAssocn.getFirstRow();
var AppraisalAdmin = true;

$.each(colType.getRows(),function(i,row){

    if(col.genesis__Collateral__r.clcommon__Collateral_Category__c === undefined){
        return displayMessage('No Collateral Category Associated.', 'ERROR');
    }

    if((row.Name == col.genesis__Collateral__r.clcommon__Collateral_Category__r.Name) && (row.genesis__AppraisalAdmin__c == null )){
        AppraisalAdmin = false;
    }
});

return AppraisalAdmin;
});
skuid.snippet.register('NoAppraisalAdmin',function(args) {var params = arguments[0],
	$ = skuid.$;

// Handle error messages
var displayMessage = function (message, severity) {
    var editor = $('#collNameTitlePanel ').data('object').editor;
    editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    return false;
};


var colType = skuid.model.getModel('CollateralCategory');
var appColAssocn = skuid.model.getModel('AppCollateralAssociation');
var col = appColAssocn.getFirstRow();
var AppraisalAdmin = false;

$.each(colType.getRows(),function(i,row){
    if(col.genesis__Collateral__r.clcommon__Collateral_Category__c === undefined){
        return displayMessage('No Collateral Category Associated.', 'ERROR');
    }

    if((row.Name == col.genesis__Collateral__r.clcommon__Collateral_Category__r.Name) && (row.genesis__AppraisalAdmin__c == null )){
        AppraisalAdmin = true;
    }
});

return AppraisalAdmin;
});
skuid.snippet.register('updateAppReqRecord',function(args) {var params = arguments[0],
	$ = skuid.$;

var appReq = skuid.model.getModel('AppraisalRequest');
var appReqRow = appReq.data[0];
var appColAssocn = skuid.model.getModel('AppCollateralAssociation');
var appColAssocnRow = appColAssocn.data[0];

if(!appReqRow){
    var appReqRow = appReq.createRow({
        additionalConditions: [
            { field: 'genesis__Status__c', value:'Pending' },
            { field: 'genesis__Application_Collateral__c', value: appColAssocnRow.Id },
        ]
    });

}else{
    appReq.updateRow(appReqRow ,
                        { genesis__Status__c : 'Pending' ,
                          genesis__Application_Collateral__c : appColAssocnRow.Id });

}

var dfd = new $.Deferred();

    $.when(appReq.save())
        .done(function(){
           dfd.resolve();
        })
        .fail(function(){
           dfd.reject();
        });

    return dfd.promise();
});
skuid.snippet.register('updateRemainingValue',function(args) {var params = arguments[0],
	$ = skuid.$;


var collValModel = skuid.model.getModel('CollateralDetailView_CollateralValuation');
var collValRow = collValModel.getFirstRow();

var allAppForCollateralModel = skuid.model.getModel('CollateralDetailView_ApplicationCollateral');
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
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    showIconicBtnLabelAsTooltip();
		var getUpdateRemainingAmtSnippet = skuid.snippet.getSnippet('updateRemainingValue');
        getUpdateRemainingAmtSnippet();


	});
})(skuid);;
skuid.snippet.register('savePledgeAmount',function(args) {var params = arguments[0],
	$ = skuid.$;

var dfd = new $.Deferred();
var appColRowForPledgeAmt = skuid.model.getModel('AppCollateralAssociation');
var row = appColRowForPledgeAmt.data[0];

$.when(appColRowForPledgeAmt.save())
    .done(function(){

        skuid.$('#collateral-tab').data('object').load();

        dfd.resolve();
    })
    .fail(function(){
       dfd.reject();
    });

return dfd.promise();
});
skuid.snippet.register('reloadIframe',function(args) {var params = arguments[0],
	$ = skuid.$;


closeTopLevelDialogAndRefresh({iframeIds: ['collateral-details-iframe']});
});
skuid.snippet.register('createCategoryAttachmentAssn',function(args) {var params = arguments[0],
	$ = skuid.$;

var attch = skuid.model.getModel('Attachment');
var attRow = attch.data[0];

var row = params.row;

var attch = catAttchAssocn.createRow({
         additionalConditions: [
        { field: 'clcommon__Attachment_Id__c', value: attRow.Id },
        { field: 'clcommon__Document_Category__c', value: row.Id}
         ]
    });
    
var dfd = new $.Deferred();

    $.when(attch.save())
        .done(function(){
           dfd.resolve();
        })
        .fail(function(){
           dfd.reject();
        });

return dfd.promise();
});
}(window.skuid));