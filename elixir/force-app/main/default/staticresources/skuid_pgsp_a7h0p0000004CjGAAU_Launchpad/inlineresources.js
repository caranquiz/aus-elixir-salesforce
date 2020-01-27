(function(skuid){
(function(skuid){
    var $ = skuid.$;
    $(document.body).one('pageload',function(){
        showIconicBtnLabelAsTooltip();

        var getdeleteAppsSnippet = skuid.snippet.getSnippet('disableAppsWithoutPermission');
        getdeleteAppsSnippet();

        var getdisplayVfTempSnippet = skuid.snippet.getSnippet('searchIncludePanel');
        var res = getdisplayVfTempSnippet();
        if(res === true) {
            skuid.component.getById('vfpage-iframeid-template').element.hide();
        } else {
            skuid.component.getById('vfpage-iframeid-template').element.show();
        }


        var launchpadAppSubModel = skuid.model.getModel('Launchpad_Apps_Subscription');
        var launchpadAppSubRow = launchpadAppSubModel.data;
        var appSubscribedLength = launchpadAppSubRow.length;

        var ammortizedWidth = appSubscribedLength*14;
        if(ammortizedWidth >= 100 || appSubscribedLength >= 7) {
            ammortizedWidth =100;
        }

        $("#launchpadDeckQueue").width(ammortizedWidth+'%');

        var proportionateSizeOfEachAppContainer;
        var actualWidthOfEachAppContainer;
        var actualWidthOfEachAppContainerRounded;

        if(ammortizedWidth === 100) {
            proportionateSizeOfEachAppContainer = ammortizedWidth/(appSubscribedLength);
            actualWidthOfEachAppContainer = proportionateSizeOfEachAppContainer - 2;
            actualWidthOfEachAppContainerRounded = parseFloat(actualWidthOfEachAppContainer).toFixed(1);

            $('#launchpadDeckQueue .nx-item.sk-grid-division.sk-card').css({
                'width': actualWidthOfEachAppContainerRounded+'%',
                'height': 'auto',
                'margin-right': '10px'
            });

        } else {
            proportionateSizeOfEachAppContainer = ammortizedWidth/(appSubscribedLength-1);
            actualWidthOfEachAppContainer = proportionateSizeOfEachAppContainer - 2;
            actualWidthOfEachAppContainerRounded = parseFloat(actualWidthOfEachAppContainer).toFixed(1);

            $('#launchpadDeckQueue .nx-item.sk-grid-division.sk-card').css({
                'width': actualWidthOfEachAppContainerRounded+'%',
                'height': 'auto',
                'margin-right': '20px'
            });
        }
    });
})(skuid);;
skuid.snippet.register('disableAppsWithoutPermission',function(args) {var params = arguments[0],
	$ = skuid.$;

var launchpadAppUser = skuid.model.getModel('Launchpad_User');
var launchpadAppUserRow = launchpadAppUser.data[0];

	      
var profileName;
var profileId;
var userRoleName;
var userRoleId;

if(launchpadAppUserRow !== undefined) {
    if(launchpadAppUserRow.UserRoleId !== undefined) {
        userRoleId = launchpadAppUserRow.UserRoleId;
    }
    if(launchpadAppUserRow.UserRole !== undefined) {
        userRoleId = launchpadAppUserRow.UserRole.Name;
    }
    if(launchpadAppUserRow.Profile !== undefined) {
        profileName = launchpadAppUserRow.Profile.Name;
        profileId = launchpadAppUserRow.Profile.Id;
    }
}

var launchpadAppSubModel = skuid.model.getModel('Launchpad_Apps_Subscription');
var launchpadAppSubRows = launchpadAppSubModel.data;

deleteIds = [];
$.each(launchpadAppSubRows,function( i, item ){
    $.each(item,function(fieldId,val) {
        if(fieldId == 'clcommon__Launchpad_App__r') {
            if(val.clcommon__Profile__c === undefined && val.clcommon__Role__c === undefined) {
                $("#launchpadDeckQueue .nx-item.sk-grid-division.sk-card:nth-child(" + (i+1) + ")").css("display", "none");
                deleteIds.push(item.Id);
            } else { /* start: else */
                var found = false;
                $.each(val, function(f,v){
                    if(f == 'clcommon__Profile__c'  && v !== undefined) {
                        if(v.indexOf(profileName) !== -1){
                            found = true;
                        }
                    }

                    if(f == 'clcommon__Role__c' && v !== undefined) {
                        if(v.indexOf(userRoleId) !== -1){
                            found = true;
                        }
                    }
                })
                if(found === false) {
                    $("#launchpadDeckQueue .nx-item.sk-grid-division.sk-card:nth-child(" + (i+1) + ")").css("display", "none");
                    deleteIds.push(item.Id);
                }
            } /* end: else */
        }
    })
})

if(deleteIds.length > 0) {
	sforce.connection.deleteIds(deleteIds);
}
});
skuid.snippet.register('handleAppQueueTrigger',function(args) {var params = arguments[0],
    $ = skuid.$;

var editor;

// Handle error messages
var displayMessage = function (message, severity) {
    editor = $('#Launchpad_errorPanel').data('object').editor;
    // editor.messages.empty();
    editor.handleMessages([
        {
            message: message,
            severity: severity.toUpperCase()
        }
    ]);

    // return false;
};


var LoanRecordType = skuid.model.getModel('Launchpad_RecordType');
var LoanRecordTypeRow = LoanRecordType.data[0];

var launchpadAppModel = skuid.model.getModel('Launchpad_Apps');
var laCondition = launchpadAppModel.getConditionByName('Launchpad_App_Id');
launchpadAppModel.setCondition(laCondition, params.row.clcommon__Launchpad_App__c);
launchpadAppModel.activateCondition(laCondition);

skuid.model.updateData([launchpadAppModel],function(){
    var rowUpdates = launchpadAppModel.data[0];

    /* assign names to variables */
    var sourceName = rowUpdates.clcommon__Content_Source__c;
    var sourceType = rowUpdates.clcommon__Content_Source_Type__c;
    var behaviour = rowUpdates.clcommon__Behavior__c;

    var pageInclude = skuid.$('#dynamicPageInclude').data('object');

    /* check source type to append url prefix to pages*/
    if(sourceType !== undefined) {
        switch (sourceType) {
            case 'Skuid Page'      : loadSkuidPage(sourceName, pageInclude, behaviour);
                                     break;
            case 'Visualforce Page': loadVisualforcePage(sourceName, behaviour);
                                     break;
            case 'Salesforce Url'  : loadSalesforceUrl(sourceName, behaviour);
                                     break;
            default                :
                                    var err = 'Source type is not suppotred. Pl. select source type from available picklist';
                                    throwError(err);
        }
    }

});

function loadSkuidPage(sourceName, pageInclude, behaviour) {

    if(sourceName !== undefined && sourceName !== null && sourceName !== '') {
        try {

            switch (behaviour) {
                case 'Display in launchpad detail view'      : /* load  in pageInclude and hide iframe if open */
                                                    skuid.component.getById('dynamicPageInclude').element.show();
                                                    skuid.component.getById('vfpage-iframeid-template').element.hide();
                                                    pageInclude.pagename = sourceName;
                                                    if(sourceName === 'CreateNewApplication') {
                                                        var err = 'Create New Loan Application is not supported in launchpad detail view. Select other behavior from available picklist';
                                                        throwError(err);
                                                        return false;
                                                        // pageInclude.querystring = '?mode=edit&RecordType=edit';
                                                    }
                                                    pageInclude.load(function(){
                                                    });
                                                    break;
                case 'Display in new tab'           :
                                                    if(sourceName === 'CreateNewApplication') {
                                                        var urlTab = "/apex/skuid__ui?page=" +sourceName + '&RecordType=' + LoanRecordTypeRow.Id + '&mode=edit';
                                                    } else {
                                                        var urlTab = "/apex/skuid__ui?page=" +sourceName;

                                                    }
                                                    window.open(urlTab, '_blank');

                                                    break;
                case 'Display in new window'        :
                                                    if(sourceName === 'CreateNewApplication') {
                                                        var urlTab = "/apex/skuid__ui?page=" +sourceName + '&RecordType=' + LoanRecordTypeRow.Id + '&mode=edit';;
                                                    } else {
                                                        var urlWin = "/apex/skuid__ui?page=" +sourceName;
                                                    }

                                                    window.open(urlWin, '_blank', 'width=' + screen.width + ',height=' + screen.height);
                                                    break;
                default                           :
                                                    var err = 'Source type ' + behaviour +' is not supported. Select source type from available picklist';
                                                    throwError(err);
            }
        } catch(err) {
            /* err.message */
            throwError(err.message);
        }


    } else {
        /*throw error page name missing */
        throwError('Source Name is empty. Provide a non-empty valid source name');
    }


}

function loadVisualforcePage(sourceName, behaviour) {

    if(sourceName !== undefined && sourceName !== null && sourceName !== '') {
        try {

            switch (behaviour) {
                case 'Display in launchpad detail view'      : /* display in iframe and hide pageinclude if open */
                                                    // var userRecord = skuid.model.getModel('Launchpad_User');
                                                    // var model = userRecord.getFirstRow();
                                                    // var userId = model.Id;
                                                    skuid.component.getById('vfpage-iframeid-template').element.show();
                                                    skuid.component.getById('dynamicPageInclude').element.hide();
                                                    var height = $('#launchpad-visulaforce-iframe').attr('height');
                                                    height = '100%';
                                                    var url = $('#launchpad-visulaforce-iframe').attr('src');
                                                    url = '';
                                                    url += '/apex/'+sourceName + '?isdtp=nv';  //mn + '&id=' + userId;
                                                    $('#launchpad-visulaforce-iframe').attr('src', url);
                                                    $('#launchpad-visulaforce-iframe').attr('height', height);
                                                    $('#launchpad-visulaforce-iframe').hide();

                                                    $('#launchpad-visulaforce-iframe').on('load', function() {
                                                        $("#launchpad-visulaforce-iframe").show();
                                                    });
                                                    break;
                case 'Display in new tab'                    : var urlTab = "/apex/"+sourceName;
                                                    window.open(urlTab, '_blank');
                                                    break;
                case 'Display in new window'                 : var urlWin = "/apex/"+sourceName;
                                                    window.open(urlWin, '_blank', 'width=' + screen.width + ',height=' + screen.height);
                                                    break;
                default                           :
                                                    var err = 'Source type ' + behaviour +' is not supported. Select source type from available picklist';
                                                    throwError(err);
            }
        } catch(err) {
            /* err.message */
            throwError(err.message);
        }


    } else {
        /*throw error page name missing */
        throwError('Source Name is empty. Provide a non-empty valid source name');
    }

}

function loadSalesforceUrl(sourceName, behaviour) {

    if(sourceName !== undefined && sourceName !== null && sourceName !== '') {
        try {

            switch (behaviour) {
                case 'Display in launchpad detail view'      : /* display in iframe and hide pageinclude if open */
                                                    var err = 'Source type is not suppotred for URLs. Select "open in new tab/ new window" as source type from available picklist for this app';
                                                    throwError(err);
                                                    break;
                case 'Display in new tab'                    : var urlTab = "/"+sourceName;
                                                    window.open(urlTab, '_blank');
                                                    break;
                case 'Display in new window'                 : var urlWin = "/"+sourceName;
                                                    window.open(urlWin, '_blank', 'width=' + screen.width + ',height=' + screen.height);
                                                    break;
                default                           :
                                                    var err = 'Source type ' + behaviour +' is not supported. Select source type from available picklist';
                                                    throwError(err);
            }
        } catch(err) {
            /* err.message */
            throwError(err.message);
        }


    } else {
        /*throw error page name missing */
        throwError('Source Name is empty. Provide a non-empty valid source name');
    }
}

function throwError(err) {
    /* call error handler */
    return displayMessage(err,'ERROR');
}
});
skuid.snippet.register('checkIfMoreThanZeroApps',function(args) {var params = arguments[0],
    $ = skuid.$;

var launchpadAppSubModel = skuid.model.getModel('Launchpad_Apps_Subscription');
var launchpadAppSubRow = launchpadAppSubModel.data;

if(launchpadAppSubRow.length >= 1) {

    skuid.component.getById('add-new-app-wrapper').element.hide();
    return false;
} else {
    skuid.component.getById('add-new-app-wrapper').element.show();
    return true;
}
});
skuid.snippet.register('handleCreateNewApp',function(args) {var params = arguments[0],
    $ = skuid.$;


/* get the name from param and open in the same tab the page include*/
var pageInclude = skuid.$('#dynamicPageInclude').data('object');
pageInclude.pagename = 'LaunchPadAppSubscription';
pageInclude.load(function(){
});
});
skuid.snippet.register('showCustomizeLaunchpad',function(args) {var params = arguments[0],
    $ = skuid.$;
skuid.component.getById('dynamicPageInclude').element.show();
var pageInclude = skuid.$('#dynamicPageInclude').data('object');
pageInclude.pagename = 'LaunchPadAppSubscription';

if($('#vfpage-iframeid-template:visible').length !== 0) {
    // #vfpage-iframeid-template is visible
    skuid.component.getById('vfpage-iframeid-template').element.hide();
}

skuid.component.getById('dynamicPageInclude').element.show();

pageInclude.load(function(){
});
});
skuid.snippet.register('searchIncludePanel',function(args) {var params = arguments[0],
	$ = skuid.$;

if($("#dynamicPageInclude").css("visibility") === "hidden") {
    return false;
} else {
    return true;   // #dynamicPageInclude is visible
}
});
}(window.skuid));