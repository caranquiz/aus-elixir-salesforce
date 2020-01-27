(function(skuid){
(function(skuid){
    var $ = skuid.$;
    $('.nx-page').one('pageload',function(){

        $('#submitToNxtDept').attr('title', 'Submit To Next Department');
        $('#createExceptionTsk').attr('title', 'Create Exception Task');

       var appRow = skuid.model.getModel('LDApplication').getFirstRow();
       var appId = appRow.Id;

        /* Query for Loan Approval */
        var queryForTaskOutstanding = "SELECT id from Task where Status != 'Completed' and genesis__Completion_Mandatory__c = true and (genesis__party__r.genesis__Application__c= \'"+appId+"\' or genesis__Application__c = \'"+ appId 
                                            +"\' or genesis__application_collateral__r.genesis__Application__c= \'"+appId+"\')";
        var queryForTaskPloicyException = "SELECT count() from genesis__Policy_Exception__c where genesis__Application__c = \'" +appId + "\' and  genesis__Status__c = 'Exception'";
        var queryForMandatoryTask = "SELECT count() from Task where genesis__Completion_Mandatory__c = true and (genesis__party__r.genesis__Application__c= \'"+appId+"\' or genesis__Application__c = \'"+ appId 
                                            +"\' or genesis__application_collateral__r.genesis__Application__c= \'"+appId+"\')";
        var queryForDocumentException = "SELECT count() from clcommon__Document_Category__c where genesis__Application__c = \'" +appId + "\' and clcommon__Required__c = true and clcommon__Status__c = 'OPEN'";
        
        var taskOutCount = sforce.connection.query(queryForTaskOutstanding);
        var policyExcpCount = sforce.connection.query(queryForTaskPloicyException);
        var mandatoryTaskCount = sforce.connection.query(queryForMandatoryTask);
        var docExceptionCount = sforce.connection.query(queryForDocumentException);

        $('.square.lochmara').attr('execVal',docExceptionCount.size);
        $('.square.treeP').attr('execVal',policyExcpCount.size);
        $('.square.limedS').attr('execVal',mandatoryTaskCount.size);
        $('.square.tskOutstanding').attr('execVal',taskOutCount.size);


        var iframeHeight = window.innerHeight - 65;
      $('iframe').height(iframeHeight);

        if(appRow.genesis__Overall_Status__c){
            console.log(appRow.genesis__Overall_Status__c);
            appRow.genesis__Overall_Status__c = appRow.genesis__Overall_Status__c.replace('Being Processed By', '');
            appRow.genesis__Overall_Status__c = appRow.genesis__Overall_Status__c.replace('Waiting for', '');
        }

        var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','showSubmitToNxtDeptBtn',
            {
                    applicationId : appRow.Id
            });

        if(showSubmitButton == 'true'){
            $('#submitToNxtDept').button('enable');
        }else{
            $('#submitToNxtDept').button('disable');
        }
    });
})(skuid);;
skuid.snippet.register('submitToNextDepartmentJs',function(args) {var appModels = skuid.model.getModel('LDApplication');
var appRow = appModels.data[0];

var showSubmitButton = sforce.apex.execute('genesis.LoanDashBoard','submitToNextDepartment',
{
        applicationId : appRow.Id
});

toTopLevelAndRefresh({iframeIds: ['task-list-popover']});

var title = 'Submit To Next Department';
var content = '<p>' + showSubmitButton + '</p>';
var type = 'alert';
openTopLevelDialog({
    type : type,
  title: title,
  prefixHtml: content
});
});
skuid.snippet.register('LaunchTaskCreationDialog',function(args) {var params = arguments[0],
  $ = skuid.$;

var appId = params.row.Id;
var title = 'Add Exception Task';
var skuidPage = 'NewTaskCreation';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));