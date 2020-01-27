(function(skuid){
skuid.snippet.register('LaunchCopyPartyDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var partyRow = skuid.model.getModel('Party').getFirstRow();
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
skuid.snippet.register('ViewParty',function(args) {var params = arguments[0],
	$ = skuid.$;
var partyModel = skuid.model.getModel('Party');
var message = {
	type: 'action-dashboard-tab-switch',
	partyId: partyModel.data[0].Id
}
window.parent.postMessage(message, '*');
});
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		showIconicBtnLabelAsTooltip();
	});
})(skuid);;
}(window.skuid));