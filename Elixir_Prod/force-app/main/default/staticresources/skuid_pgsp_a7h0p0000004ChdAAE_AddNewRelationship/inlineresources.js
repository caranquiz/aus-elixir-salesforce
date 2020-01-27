(function(skuid){
skuid.snippet.register('SaveMembers',function(args) {var params = arguments[0],
	$ = skuid.$;

var modelsToSave = [];
var isDataValid = true;
var relModel1 = skuid.model.getModel('ANR_NewIndividualRelationship');
if(relModel1.getFirstRow().clcommon__Related__Entity__c || relModel1.getFirstRow().clcommon__Relationship__c){
    if(!relModel1.getFirstRow().clcommon__Related__Entity__c && !relModel1.getFirstRow().clcommon__Relationship__c){
        isDataValid = false;
        var editor = $('.individual-save-member-error-panel').data('object').editor;
        editor.handleMessages(
            [
              {
                  message: 'Both Related Entity and Role should be selected to add new individual member',
                  severity: 'ERROR'
              },
            ]
        );
    } else {
        modelsToSave.push(relModel1);
    }
}

var relModel2 = skuid.model.getModel('ANR_NewBusinessRelationship');
if(relModel2.getFirstRow().clcommon__Related__Entity__c || relModel2.getFirstRow().clcommon__Relationship__c){
    if(!relModel2.getFirstRow().clcommon__Related__Entity__c && !relModel2.getFirstRow().clcommon__Relationship__c){
        isDataValid = false;
        var editor = $('.business-save-member-error-panel').data('object').editor;
        editor.handleMessages(
            [
              {
                  message: 'Both Related Entity and Role should be selected to add new business member',
                  severity: 'ERROR'
              },
            ]
        );
    } else {
        modelsToSave.push(relModel2);
    }
}

if(isDataValid){
    skuid.model.save(modelsToSave, { callback: function(result){
        if (result.totalsuccess){
            var parentId = skuid.model.getModel('AccountRelationDashboardPage').getFirstRow().Id;
            if(parentId.length > 15){
                parentId = parentId.slice(0, 15);
            }
            var path = parentId + ',deal-dashboard-iframe';
            closeTopLevelDialogAndRefresh({iframeIds: [path]});
        } else {
            // do nothing
        }
    }});
}
});
}(window.skuid));