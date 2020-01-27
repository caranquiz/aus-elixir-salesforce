(function(skuid){
skuid.snippet.register('statusView',function(args) {var $ = skuid.$,
        field = arguments[0],
        value = arguments[1];

        if(value===undefined){
        return;
        }

        var cellElem = field.element;
        var innerIconText =  $('<span>').addClass('ui-button-text').text(value)
        var iconElem =
        $( '<div>' ) // create the icon container
        .addClass('ui-button ui-state-default') // mark the container as a silk icon container
        .append(
        innerIconText
        )
        .appendTo( cellElem ); // add the container to the cell

        switch( value )
        {
        case 'Hot':
        // apply the red flag icon to the container
        iconElem.addClass('ui-silk-flag-red');
        break;
        case 'Warm':
        // apply the orange flag icon to the container
        iconElem.addClass('ui-silk-flag-orange');
        break;
        case 'Cold':
        // apply the blue flag icon to the container
        iconElem.addClass('ui-silk-flag-blue');
        break;
        default:
        // apply the 8 ball icon to the container
        // iconElem.addClass('ui-silk-sport-8ball');
        break;
        }
});
skuid.snippet.register('covenant-status-label',function(args) {var $ = skuid.$,
    field = arguments[0],
    value = arguments[1];

if(field){
    var row = field.row
    var cellElem = field.element.addClass('status-label');
    if (row.clcommon__Covenant_Evaluations__r) { // there's at least one evaluation record
        var evaluationRecord = row.clcommon__Covenant_Evaluations__r.records[0];
        var evaluationStatus = evaluationRecord.clcommon__Status__c
        if(evaluationStatus){
            wrapperLabel(evaluationStatus, cellElem)
        }
    }
}

function wrapperLabel(evaluationStatus, cellElem){

    var innerIconText =  $('<span>').text(evaluationStatus);
    var labelElem = innerIconText.appendTo( cellElem ); // add the container to the cell
    switch (evaluationStatus){
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
skuid.snippet.register('lastEvaluationDate',function(args) {// formatting the datetime value

        var $ = skuid.$,
        field = arguments[0],
        value = arguments[1];

        if(field){
        var row = field.row
        if(row.clcommon__Covenant_Evaluations__r){
        var childRow = row.clcommon__Covenant_Evaluations__r.records[0]
        var value = new Date(childRow.CreatedDate);
        value = value.toLocaleDateString("en-US")
        var cellElem = field.element
        cellElem.text(value)
        }
        }
});
skuid.snippet.register('launchEvaluationPopup',function(args) {var params = arguments[0],
    $ = skuid.$;

var title = 'Covenant History';
var skuidPage = 'AccountBasedCovenantEvaluationHistory';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + params.row.Id;
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));