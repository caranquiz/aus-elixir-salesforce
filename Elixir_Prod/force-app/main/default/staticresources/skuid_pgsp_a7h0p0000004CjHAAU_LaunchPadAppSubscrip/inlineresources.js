(function(skuid){
skuid.snippet.register('saveSubscription',function(args) {var params = arguments[0],
    $ = skuid.$;


var userModel = skuid.model.getModel('LaunchPadAppSubscription_User');
var userRow = userModel.data[0];

var appSubscriptionModel = skuid.model.getModel('LaunchPadAppSubscription_LaunchpadUserAppSubscription');
var appSubsRow = appSubscriptionModel.data;

var appUserSubsList = [];
var appToRecordIdMap = {};
$.each(appSubsRow,function( i, row ){
    appUserSubsList.push(row.clcommon__Launchpad_App__c);
    appToRecordIdMap[row.clcommon__Launchpad_App__c] = row.Id;

});




var appModel = skuid.model.getModel('LaunchPadAppSubscription_LaunchpadApp');
var appRow = appModel.data;


$.each(appRow,function( i, row ){
    if (appModel.getFieldValue(row,'IsAppSubscribed')===true) {
        if(appUserSubsList.indexOf(row.Id) == -1) {
            appSubscriptionModel.createRow({
                additionalConditions: [
                    {field: 'clcommon__Launchpad_App__c', value: row.Id},
                    {field : 'clcommon__User__c', value: userRow.Id}
                ]
            });
        }
    } else {
        if(appUserSubsList.indexOf(row.Id) != -1) {
            appSubscriptionModel.deleteRow(appToRecordIdMap[row.Id]);
        }
    }

});

appSubscriptionModel.save();


window.location.reload();
});
(function(skuid){
    var $ = skuid.$;
    $(document.body).one('pageload',function(){
        var appSubscriptionModel = skuid.model.getModel('LaunchPadAppSubscription_LaunchpadUserAppSubscription');
        var appSubsRow = appSubscriptionModel.data;

        var appModel = skuid.model.getModel('LaunchPadAppSubscription_LaunchpadApp');
        var appRow = appModel.data;
        var appUserSubsList= [];
        $.each(appSubsRow,function( i, row ){
            appUserSubsList.push(row.clcommon__Launchpad_App__c);

        });

        $.each(appRow,function( i, row ){
            if(appUserSubsList.indexOf(row.Id) != -1) {
                 appModel.updateRow(row , { 'IsAppSubscribed' : true });
            }

        });


    });
})(skuid);;
skuid.snippet.register('cancelModelChanges',function(args) {var params = arguments[0],
    $ = skuid.$;
var appSubscriptionModel = skuid.model.getModel('LaunchPadAppSubscription_LaunchpadUserAppSubscription');
var appSubsRow = appSubscriptionModel.data;

var appModel = skuid.model.getModel('LaunchPadAppSubscription_LaunchpadApp');
appModel.cancel();
var appRow = appModel.data;
var appUserSubsList= [];
$.each(appSubsRow,function( i, row ){
    appUserSubsList.push(row.clcommon__Launchpad_App__c);

});

$.each(appRow,function( i, row ){
    if(appUserSubsList.indexOf(row.Id) != -1) {
         appModel.updateRow(row , { 'IsAppSubscribed' : true });
    }

});
});
skuid.snippet.register('findIncludePanel',function(args) {var params = arguments[0],
	$ = skuid.$;
var params = arguments[0],
	$ = skuid.$;



var x = document.getElementById("dynamicPageInclude");

if(x === null) {
    return true;  /* display header*/
} else if(x !== undefined) {
    return false; /* hide header*/
} else {
    return true;
}
});
}(window.skuid));