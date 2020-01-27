(function(skuid){
skuid.snippet.register('changeBidStatus',function(args) {var params = arguments[0],
	$ = skuid.$;


var myModel = skuid.model.getModel('AppraisalAdminBidsDetails_AppraisalAdminBids');
var row = myModel.data[0];

myModel.updateRow(row, { genesis__Status__c : 'Accepted' });

var dfd = new $.Deferred();
    
$.when(myModel.save())
    .done(function(){
        dfd.resolve();
    })
    .fail(function(){
       dfd.reject();
       console.log('save failed');
    });

return dfd.promise();
});
skuid.snippet.register('reportViewUnSet',function(args) {var params = arguments[0],
	$ = skuid.$;

var newBidsModel = skuid.model.getModel('AppraisalAdminBidsDetails_AppraisalAdminBids');
var newBidsRow = newBidsModel.data[0];

if(!newBidsRow){
    var newBidsRow = newBidsModel.createRow({
        additionalConditions: [
            { field: 'IsViewReport', value:false }
        ]
    });

}else{
    newBidsModel.updateRow(newBidsRow ,
                        { IsViewReport : false });

}
});
skuid.snippet.register('setViewReport',function(args) {var params = arguments[0],
	$ = skuid.$;

var newBidsModel = skuid.model.getModel('AppraisalAdminBidsDetails_AppraisalAdminBids');
var newBidsRow = newBidsModel.data[0];

if(!newBidsRow){
    var newBidsRow = newBidsModel.createRow({
        additionalConditions: [
            { field: 'IsViewReport', value:true }
        ]
    });

}else{
    newBidsModel.updateRow(newBidsRow ,
                        { IsViewReport : true });

}
});
skuid.snippet.register('rejectOtherBids',function(args) {var params = arguments[0],
	$ = skuid.$;

/* Updating other bids status to rejected */

var myModel = skuid.model.getModel('AppraisalAdminBidsDetails_AppraisalAdminBids');
var row = myModel.data[0];

var allBidsForAppraisalRequestModel = skuid.model.getModel('AppraisalAdminBidsDetails_AllBidsForAppraisalRequest');
var allBidsCondition = allBidsForAppraisalRequestModel.getConditionByName('app_reqId');

allBidsForAppraisalRequestModel.setCondition(allBidsCondition, row.genesis__Appraisal_Request__c);
allBidsForAppraisalRequestModel.activateCondition(allBidsCondition);

skuid.model.updateData([allBidsForAppraisalRequestModel],function(){
     $.each(allBidsForAppraisalRequestModel.data,function(fieldId,bidsRow) {
        $.each(bidsRow,function(fieldName,val) {
            if((fieldName != 'attributes') && (fieldName === 'genesis__Status__c')) {  
                if(val !== 'Accepted') {
                    allBidsForAppraisalRequestModel.updateRow(bidsRow,{
                         genesis__Status__c: 'Rejected'
                    });
                }
            }
        });
    });
    
    var dfd = new $.Deferred();
    
    $.when(allBidsForAppraisalRequestModel.save())
        .done(function(){
            var appReqAdmin = skuid.model.getModel('AppraisalAdmin_AppraisalRequest');
            var appReqAdminRow = appReqAdmin.data[0];
            appReqAdmin.updateRow(appReqAdminRow,{
                         genesis__Status__c: 'Accepted'
                    });
            dfd.resolve();
        })
        .fail(function(){
           dfd.reject();
           console.log('save failed');
        });

    return dfd.promise();
    
});
});
skuid.snippet.register('approveAppraisalBid',function(args) {var params = arguments[0],
	$ = skuid.$;

var myModel = skuid.model.getModel('AppraisalAdminBidsDetails_AppraisalAdminBids');
var row = myModel.data[0];

myModel.updateRow(row, { genesis__Status__c : 'Approved' });

var dfd = new $.Deferred();
    
$.when(myModel.save())
    .done(function(){
        var appReqAdmin = skuid.model.getModel('AppraisalAdmin_AppraisalRequest');
        var appReqAdminRow = appReqAdmin.data[0];
        appReqAdmin.updateRow(appReqAdminRow,{
                     genesis__Status__c: 'Approved'
                });
        dfd.resolve();
    })
    .fail(function(){
       dfd.reject();
       console.log('save failed');
    });

return dfd.promise();
});
}(window.skuid));