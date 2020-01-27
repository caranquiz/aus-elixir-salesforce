(function(skuid){
skuid.snippet.register('UpdateDebtIncomePage',function(args) {var params = arguments[0],
  $ = skuid.$;

var partyData = skuid.model.getModel('PartyQueueModel').data[0]
partyData.appID = params.row.genesis__Application__c;
partyData.contactID = params.row.clcommon__Contact__c;
partyData.partyID = params.row.Id;
});
}(window.skuid));