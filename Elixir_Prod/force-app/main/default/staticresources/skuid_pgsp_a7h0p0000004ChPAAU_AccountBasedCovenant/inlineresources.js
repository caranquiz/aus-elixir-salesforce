(function(skuid){
skuid.snippet.register('updateDefaultValues',function(args) {var selectRowParam = arguments[0],
	$ = skuid.$;
var newCEData = skuid.model.getModel('NewEvaluationRecord');
if(selectRowParam.rows && selectRowParam.rows[0]){
    var newRow = newCEData.createRow({
            additionalConditions: [
                { field: 'clcommon__Covenant__c', value:selectRowParam.rows[0].clcommon__Covenant__c },
                { field: 'clcommon__Covenant__r', value:selectRowParam.rows[0].clcommon__Covenant__r },
                { field: 'clcommon__Evaluate_By_Date__c', value:selectRowParam.rows[0].clcommon__Evaluate_By_Date__c },
                { field: 'clcommon__Created_Date__c', value:new Date() },
            ]
        });
}
});
skuid.snippet.register('statusCustomLabel',function(args) {var $ = skuid.$,
    field = arguments[0],
    value = arguments[1];

if (value) {
    var cellElem = field.element.addClass('status-label');
    var spanText = $('<span>').text(value)
    applyStyle(value, cellElem);
    spanText.appendTo(cellElem); // add the container to the cell
}

function applyStyle(value, cellElem){
    switch (value) {
        case 'Pending':
            cellElem.addClass('pending');
            break;
        case 'Clear':
            cellElem.addClass('clear');
            break;
        case 'Expired':
            cellElem.addClass('expired');
            break;
        case 'Accepted':
            cellElem.addClass('accepted');
            break;
        case 'Exception':
            cellElem.addClass('exception');
            break;
        default:
            cellElem.addClass('accepted');
            break;
    }
}
});
skuid.snippet.register('refreshParentPage',function(args) {var params = arguments[0],
	$ = skuid.$;
skuid.model.getModel('AccountBasedCovenants').load()
});
skuid.snippet.register('closeItSelf',function(args) {var params = arguments[0],
	$ = skuid.$;


closeTopLevelDialogAndRefresh();
});
}(window.skuid));