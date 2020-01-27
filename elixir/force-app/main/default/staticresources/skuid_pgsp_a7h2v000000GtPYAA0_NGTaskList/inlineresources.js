(function(skuid){
skuid.snippet.register('submitToNextDepartmentJs',function(args) {var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0];
var showSubmitButton = sforce.apex.execute('LoanDashBoard','submitToNextDepartment',
{
        applicationId : appRow.Id
});

$('#task-details-iframe')[0].contentWindow.location.reload(true);
var message = {
       type: 'dialog-stage-progression',
       content : showSubmitButton,
       title : ''
};
window.parent.postMessage(message, '*');
});
(function(skuid){
    var $ = skuid.$;

    // Register a snippet to run
    skuid.snippet.registerSnippet('EnableDisableSubmitButton', function(){
        var appModels = skuid.model.getModel('LDApplication');
        var appRow = appModels.data[0];
        var showSubmitButton = sforce.apex.execute('LoanDashBoard','showSubmitToNxtDeptBtn',
            {
                    applicationId : appRow.Id
            });
        if(showSubmitButton == 'true'){
            $('#submitToNxtDept').button('enable');
        }else{
            $('#submitToNxtDept').button('disable');
        }

    });

    // Run the snippet initially on page load
    $('.nx-page').one('pageload',function(){
        skuid.snippet.getSnippet('EnableDisableSubmitButton')();
    });
})(skuid);;
skuid.snippet.register('LaunchTaskCreationDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = params.row.Id;

var message = {
    type: 'dialog-task-creation',
    applicationId: appId
};

window.parent.postMessage(message, '*');
});
}(window.skuid));