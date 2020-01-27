(function(skuid){
skuid.snippet.register('CreditScoreSimpleView',function(args) {var params = arguments[0],
        $ = skuid.$;

    var simpleView = {
        render: function(item) {
            item.element.html('<div class="credit-score-row"><span class="credit-score-value">'+item.row.genesis__Score__c+'</span><span class="credit-score-type">'+item.row.ints__ModelNameType__c+'</span>');
        }
    };

    return simpleView;
});
skuid.snippet.register('LaunchCreditReportView',function(args) {var params = arguments[0],
        $ = skuid.$;

    var party = skuid.model.getModel('NGParty');
    var url = party.getFirstRow().genesis__Credit_Report__r.ints__Credit_Report_Attachment__c;
    var reportId = url.substring(url.lastIndexOf('/')+1);
    var title = 'Credit Report';
    var iframeUrl = '/servlet/servlet.FileDownload?file=' + reportId;

    openTopLevelDialog({
        title: title,
        iframeUrl: iframeUrl
    });
});
skuid.snippet.register('DisplayDefaultZero',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

value = value === null ? 0 : value;
var renderer = skuid.ui.fieldRenderers[field.metadata.displaytype];
renderer.readonly(field, value);
});
skuid.snippet.register('generateMessageCreditPullConfirmation',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];

var contactModel = skuid.model.getModel('PartiesContact');
var contact = contactModel.data[0];

var appId = party.genesis__Application__c;
var partyId = contact.Id;
var partyName = party.clcommon__Account__r.Name;

var title = 'Get Credit Report of ' + partyName;
var message = '<p>Are you sure you want to get the credit report of <strong>'
                + partyName + '</strong>?</p>';
var cancelText = "No, do not get it.";
var okText = "Yes, Continue.";
var okAction = {
    func: 'getCreditReport',
    parameters: [appId, partyId, partyName]
};

openTopLevelConfirmation({
    title: title,
    message: message,
    cancelText: cancelText,
    okText: okText,
    okAction: okAction
});
});
skuid.snippet.register('LaunchCreditHistoryView',function(args) {var params = arguments[0],
    $ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;
var title = 'Credit Report History of ' + partyName;
var skuidPage = 'CreditHistoryPage';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchEditPartyDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;
var title = 'Edit ' + partyName;
var skuidPage = 'EditBorrowingStructure';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('RenderColumnWIthExternalLink',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var url = '/' + field.row.Id;
field.element.html('<a href="' + url + '" target="_blank">' + value + '</a>');
});
skuid.snippet.register('RenderAccountStatusColumn',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var message = value ? 'Active' : 'Not Active';

field.element.text(message);
});
skuid.snippet.register('LaunchCovenants',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyRow = skuid.model.getModel('NGParty').data[0];
var partyId = partyRow.Id;
var title = 'Active Covenants for ' + partyRow.clcommon__Account__r.Name;
var skuidPage = 'RelationshipCovenant';

var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCopyPartyDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyRow = skuid.model.getModel('NGParty').getFirstRow();
var title = 'Copy ';
if(partyRow.clcommon__Account__r && partyRow.clcommon__Account__r.Name){
    title = title + partyRow.clcommon__Account__r.Name + ' to Applications';
}
var skuidPage = 'CopyParty';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + partyRow.Id;
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('deletePartyConfirmation',function(args) {var params = arguments[0],
    $ = skuid.$;

var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var partyId = party.Id;
var title = 'Delete Party '
if(party.clcommon__Account__r && party.clcommon__Account__r.Name){
    title = title + party.clcommon__Account__r.Name;
}
if(party.clcommon__Type__r && party.clcommon__Type__r.Name){
    title = title + ' ' + party.clcommon__Type__r.Name;
}
var message = '<p><strong>Are you sure you want to delete this party</strong>?</p>';
var cancelText = "Cancel";
var okText = "Yes, Continue";
var okAction = {
    func: 'deleteParty',
    parameters: [partyId]
};

openTopLevelConfirmation({
    title: title,
    message: message,
    cancelText: cancelText,
    okText: okText,
    okAction: okAction
});
});
skuid.snippet.register('LaunchFinancialAccounts',function(args) {var params = arguments[0],
  $ = skuid.$;
var appId = skuid.page.params.id;
var title = 'Financial Accounts';
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var skuidPage = 'FinancialAccounts';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchLoanOpportunity',function(args) {var params = arguments[0],
  $ = skuid.$;
var appId = skuid.page.params.id;
var title = 'Loan Opportunities';
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var skuidPage = 'LoanOpportunities';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCreditAnalysis',function(args) {var params = arguments[0],
  $ = skuid.$;
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var appId = skuid.page.params.id;
var title = 'Credit Analysis';
var skuidPage = 'CreditAnalysis';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('PRD_LaunchFinancialStatementAnalysis',function(args) {var $ = skuid.$;

var party = skuid.model.getModel('NGParty').data[0];
if(party.clcommon__Account__c){
    var title = 'Financial Analysis - ' + party.clcommon__Account__r.Name;
    var skuidPage = 'AccountStatements';

    // get template id
    var templateRecord = skuid.model.getModel('PRD_ApplicableFinancialStatementTemplate').data[0];
    if(templateRecord !== undefined){
    var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&accountid=' + party.clcommon__Account__c + '&templateid=' + templateRecord.Id;

    openTopLevelDialog({
        title: title,
        iframeUrl: iframeUrl
    });
    } else {
        alert('No financial templates found!');
    }
}
});
skuid.snippet.register('LaunchRelationshipGraph',function(args) {var params = arguments[0],
  $ = skuid.$;
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var appId = skuid.page.params.id;
var title = 'Relationship Graph';
var skuidPage = 'RelationshipGraph';
console.debug(appId);
console.debug(party);
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + party.clcommon__Account__c;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchEmploymentAndIncome',function(args) {var params = arguments[0],
  $ = skuid.$;
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var title = 'Employment and Income';
var skuidPage = 'EmploymentAndIncome';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&Id=' + party.clcommon__Contact__c+ '&appId=' + party.genesis__Application__c;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchAssetsAndLiabilities',function(args) {var params = arguments[0],
  $ = skuid.$;
var partyModel = skuid.model.getModel('NGParty');
var party = partyModel.data[0];
var title = 'Assets and Liabilities';
var skuidPage = 'AssetsAndLiabilities';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&Id=' + party.clcommon__Contact__c+ '&appId=' + party.genesis__Application__c;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('addNewParty',function(args) {var params = arguments[0],
    $ = skuid.$;

var app = skuid.model.getModel('ApplicationParty');
var appModel = app.data[0];
var appId = appModel.Id;
console.log('ID'+appId);
var title = 'Party';
var skuidPage = 'CustomBorrowingStructure3';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
//window.location.reload();
});
skuid.snippet.register('SaveAssetsAndLiabilities',function(args) {var params = arguments[0],
	$ = skuid.$;
	var appModel = skuid.model.getModel('CommonApplicationModel');
	var appRow = appModel.data[0];
	var i=0,k=0;
	var assetModel = skuid.model.getModel('Assets');
    for(var eachAsset in assetModel){
        var assetData = eachAsset.data[i];
        assetData.Application__c = appRow.Id;
        i++;
    }
var LiabilityModel = skuid.model.getModel('Liabilities');
for(var eachLiability in LiabilityModel){
    var liabilityData = eachLiability.data[k];
    liabilityData.Application__c = appRow.Id;
    k++;
}
});
skuid.snippet.register('SavePartyRelationship',function(args) {var params = arguments[0],
	$ = skuid.$;
	var partyModel = skuid.model.getModel('NGParty');
	var partyRow = partyModel.data[0];
	var partyRelModel = skuid.model.getModel('PartyRelationship');
	var partyRelRow = partyRelModel.data[0];
	partyRelRow.Party__c = partyRow.Id;
});
skuid.snippet.register('PageReload1',function(args) {var params = arguments[0],
	$ = skuid.$;
location.reload();
});
skuid.snippet.register('FieldRenderer',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('ABN Company Check',function(args) {var params = arguments[0],
	$ = skuid.$;
var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){
        return item.row;
    });
    console.log(records);
    console.log(arguments[0].list);
    if ( !records[0]  || records.length < 1) {
        alert("Please select at least one Company Name");
        location.reload();
        closeTopLevelDialogAndRefresh({window:true});
    }else if(records  && records.length > 1){
        alert("Please select at only one Company Name");
        location.reload();
        closeTopLevelDialogAndRefresh({window:true});
    } else{
        var result = sforce.apex.execute('ABNNameCallout','makeABNSkuidCallout',
        {  
            sfId : records[0].Id,
            typeIndicator : 'E'
         });
        //alert(result);
        }
});
skuid.snippet.register('ABNCheck',function(args) {var params = arguments[0],
    $ = skuid.$;
    //var partyModel = skuid.model.getModel('Party');
    //var partyRow = partyModel.data[0];
    //var ABNCompanyModel = skuid.model.getModel('ABN_ComapnyName_Model');
    //var ABNCompanyRow = ABNCompanyModel.data[0];
    var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){
        return item.row;
    });
    console.log(records);
    console.log(arguments[0].list);
    if ( !records[0]  || records.length < 1) {
        alert("Please select at least one Company");
    }else if(records  && records.length > 1){
        alert("Please select at only one Company");
    } else{
        var result = sforce.apex.execute('ABNAPICallout','makeABNCompanySkuidCallout',
        {  
            companyId : records[0].Id
         });
                alert(result);
                window.location.reload();
    }
});
skuid.snippet.register('fullDocument',function(args) {var params = arguments[0],
$ = skuid.$;
var SelfModel = skuid.model.getModel('SelfEmploymentDetails');
console.log(SelfModel.getRows()) ;
var flag = false ;
$.each(SelfModel.getRows(),function(i,row){
    console.log(row.Document_Type__c) ;
    if(row.Document_Type__c === 'Full'){
        flag = true ;
    } 
});
return flag ;
});
(function(skuid){
	var $ = skuid.$;
	//console.log('inside---');
	$(document.body).one('pageload',function(){
		var empModel = skuid.model.getModel('SelfEmploymentDetails');
		var returntype= 'true';
        var title = 'BusinessIncomeFull';
        var skuidPage = 'BusinessIncomeFull';
		var found = false;
    	found = $.each(empModel.getRows(),function(i,row){
           if(row.Document_Type__c === 'Full'){
               //console.log('true');
               return true;
           }
        });
        if(found === true){
            var url = '/apex/skuid__ui?page=' + skuidPage + '&id=' + empModel.data[0].genesis__Application__c +'&full=' +returntype +'&alt=' +returntype;
                    
            window.open(url, '_blank');
        }
	});
})(skuid);;
skuid.snippet.register('PreviousEmploymentRender',function(args) {var params = arguments[0],
$ = skuid.$;
var paygModel = skuid.model.getModel('PayGEmploymentDetails');
console.log(paygModel.getRows()) ;
var flag = false ;
$.each(paygModel.getRows(),function(i,row){
    console.log(row.Employment_Duration__c) ;
    if(row.Employment_Duration__c < 24){
        flag = true ;
    } 
});
return flag ;
});
skuid.snippet.register('reload',function(args) {var params = arguments[0],
$ = skuid.$;

var appRow = skuid.model.getModel('ApplicationParty').data[0] ;
console.log(appRow.Id) ;

$.blockUI({
    onBlock: function() {
        window.location.reload() ;
        //window.location = '/' + appRow.Id ;
    }
});
});
skuid.snippet.register('AltDocument',function(args) {var params = arguments[0],
$ = skuid.$;
var SelfModel = skuid.model.getModel('SelfEmploymentDetails');
console.log(SelfModel.getRows()) ;
var flag = false ;
$.each(SelfModel.getRows(),function(i,row){
    console.log(row.Document_Type__c) ;
    if(row.Document_Type__c === 'Alt'){
        flag = true ;
    } 
});
return flag ;
});
skuid.snippet.register('IncomeSummary',function(args) {var params = arguments[0],
	$ = skuid.$;
var partyRow    = skuid.model.getModel('NGParty').data[0];
console.log('==appId=='+partyRow.genesis__Application__c) ;
var ret;
            $.blockUI({
                message: 'Please wait! ',
                onBlock: function(){
                        ret = sforce.apex.execute('IncomeSummary','IncomeSummarySkuidCallout',
                    {
                        appId : partyRow.genesis__Application__c
                    });
                    if(ret=='SUCCESS'){
                        $.unblockUI();
                        window.location.reload();
                    }else{
                        console.log(ret+'==HERE==');
                        alert(ret);
                        $.unblockUI();
                        window.location.reload();
                    }
                },
                
            });
});
}(window.skuid));