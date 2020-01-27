(function(skuid){
skuid.snippet.register('CreditScoreSimpleView',function(args) {var params = arguments[0],
	$ = skuid.$;

var simpleView = {
    render: function(item) {
        item.element.html('<div class="credit-score-row"><span class="credit-score-value">'+item.row.Score__c+'</span><span class="credit-score-type">'+item.row.ints__ModelNameType__c+'</span>');
    }
};

return simpleView;
});
skuid.snippet.register('LaunchCreditReportView',function(args) {var params = arguments[0],
	$ = skuid.$;

var party = skuid.model.getModel('NGParty');
var url = party.getFirstRow().Credit_Report__r.ints__Credit_Report_Attachment__c;
var reportId = url.substring(url.lastIndexOf('/')+1);

var message = {
	type: 'dialog-document-preview',
	documentId: reportId,
	documentName: 'Credit Report'
};
window.parent.postMessage(message, '*');
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

var appId = party.Application__c;
var partyId = contact.Id;
var partyName = party.clcommon__Account__r.Name;

var message = {
    type: 'dialog-credit-pull',
    applicationId: appId,
    partyId: partyId,
    partyName: partyName
};

window.parent.postMessage(message, '*');
});
skuid.snippet.register('LaunchCreditHistoryView',function(args) {var params = arguments[0],
	$ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;

var message = {
	type: 'dialog-credit-history',
	partyId: partyId,
	partyName: partyName
};
window.parent.postMessage(message, '*');
});
skuid.snippet.register('LaunchEditPartyDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var party = skuid.model.getModel('NGParty');
var model = party.getFirstRow();
var partyId = model.Id;
var partyName = model.clcommon__Account__r.Name;

var message = {
	type: 'dialog-edit-party',
	partyId: partyId,
	partyName: partyName
};

window.parent.postMessage(message, '*');
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
}(window.skuid));