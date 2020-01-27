(function(skuid){
(function(skuid){
  var $ = skuid.$;
  $('head').append(
      $('<base target="_blank">')
  );
  $(document.body).one('pageload',function(){
      var personAccount = skuid.model.getModel('PersonAccount');
      try{
        var isPersonAccount = false;
        var records =  skuid.utils.getAPIDescribeSObject('Account');
        records.recordTypeInfos.forEach(function(value) {
            // Check default record type and person account
            if(value.defaultRecordTypeMapping==="true")
            {
               var recordTypeId = value.recordTypeId
               var queryForPersonAccount = "select IsPersonType from RecordType where SobjectType='Account' and Id= \'"+recordTypeId+"\' and IsPersonType=true"
               var recordCount = sforce.connection.query(queryForPersonAccount);
               if(recordCount.size==1)
                isPersonAccount = true;
            }
        });

        if(personAccount.data.length!==0)
        {
            personAccount.data[0].Enabled=isPersonAccount;
        }
      }
      catch(ex){
        if(personAccount.data.length!==0)
        {
            personAccount.data[0].Enabled=false;
        }
      }
      var paramId = skuid.page.params.id;
      var orgParamRow = skuid.model.getModel('OrgParameter').getFirstRow();
      var applicationModel = skuid.model.getModel('CommonApplicationModel');
      applicationModel.emptyData();
      if(paramId){
            var appIdCondition = applicationModel.getConditionByName('AppId');
            applicationModel.setCondition(appIdCondition,paramId);
            skuid.model.updateData([applicationModel],function(){
                // record type
                var appRecType = applicationModel.data[0].RecordTypeId;
                var applicationRTModel = skuid.model.getModel('ApplicationRecordType');
                var rtIdCondition = applicationRTModel.getConditionByName('Id');
                applicationRTModel.setCondition(rtIdCondition,appRecType);

                var productModel = skuid.model.getModel('SelectedProduct');
                var prodIdCondition = productModel.getConditionByName('Id');
                productModel.setCondition(prodIdCondition, applicationModel.data[0].genesis__CL_Product__c);
                skuid.model.updateData([productModel,applicationRTModel],function(){
                    skuid.snippet.getSnippet('fetchAccountData')();
                    skuid.snippet.getSnippet('fetchContactData')();
                });
            });
      }else{
          // fetch record type info
          var appRecType = skuid.page.params.RecordType;
          var appProType = skuid.page.params.ProductId;
            var applicationRTModel = skuid.model.getModel('ApplicationRecordType');
            var rtIdCondition = applicationRTModel.getConditionByName('Id');
            applicationRTModel.setCondition(rtIdCondition,appRecType);

          if(appProType){
              skuid.model.updateData([applicationRTModel],function(){
              var newRow = applicationModel.createRow({
                    additionalConditions: [
                        { field: 'NewBorrower', value:false },
                        { field: 'RecordType', value:applicationRTModel.getFirstRow() },
                        { field: 'RecordTypeId', value:applicationRTModel.getFirstRow().Id },
                        { field: 'genesis__Account__c', value:skuid.page.params.AccountId },
                        { field: 'genesis__CL_Product__c', value:appProType },
                    ]
                });
            });
          }else{
              skuid.model.updateData([applicationRTModel],function(){
                  var newRow = applicationModel.createRow({
                        additionalConditions: [
                            { field: 'NewBorrower', value:false },
                            { field: 'RecordType', value:applicationRTModel.getFirstRow() },
                            { field: 'RecordTypeId', value:applicationRTModel.getFirstRow().Id },
                        ]
                    });
            });
         }
      }
  });
})(skuid);;
skuid.snippet.register('fieldRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('fetchAccountData',function(args) {var params = arguments[0],
  $ = skuid.$;

var applicationRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var commonAccountModel = skuid.model.getModel('CommonAccountModel');
var biModel = skuid.model.getModel('CommonBusinessInforModel');

commonAccountModel.emptyData();
biModel.emptyData();

if(applicationRowData && applicationRowData.genesis__Account__c){
    var accountIdCondition = commonAccountModel.getConditionByName('CommonAccId');
    commonAccountModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
    skuid.model.updateData([commonAccountModel],function(){
        if(!(commonAccountModel.data && commonAccountModel.data.length > 0)){
            var newPSRow = commonAccountModel.createRow({ });
        }else{
            if(commonAccountModel.data[0].genesis__Business_Information__c){
                // fetch business info
                var bIdCondition = biModel.getConditionByName('BusinessInfoId');
                biModel.setCondition(bIdCondition,commonAccountModel.data[0].genesis__Business_Information__c);
                skuid.model.updateData([biModel],function(){});
            }else{
                var newBIRow = biModel.createRow({ });
            }
        }
    });
}else{
    if(!(commonAccountModel.data && commonAccountModel.data.length > 0)){
        var newPSRow = commonAccountModel.createRow({ });
        var newBIRow = biModel.createRow({ });
    }
}
});
skuid.snippet.register('fetchContactData',function(args) {var params = arguments[0],
  $ = skuid.$;

var applicationRowData = skuid.model.getModel('CommonApplicationModel').data[0];
var commonContactModel = skuid.model.getModel('CommonContactModel');
commonContactModel.emptyData();
if(applicationRowData && applicationRowData.Name){
    if(applicationRowData.genesis__Contact__c){
        var contactIdCondition = commonContactModel.getConditionByName('CommonContactId');
        commonContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });
    }

    if(applicationRowData.genesis__Account__c && applicationRowData.genesis__Account__r &&
        applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__c &&
        (applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__r.Name.toUpperCase() == 'INDIVIDUAL' ||
            applicationRowData.genesis__Account__r.clcommon__Legal_Entity_Type__r.Name.toUpperCase() == 'SOLE PROPRIETORSHIP')){
        var accountIdCondition = commonContactModel.getConditionByName('AccountId');
        commonContactModel.setCondition(accountIdCondition,applicationRowData.genesis__Account__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });
    }
}else{
    if(applicationRowData && applicationRowData.genesis__Contact__c){
        var contactIdCondition = commonContactModel.getConditionByName('CommonContactId');
        commonContactModel.setCondition(contactIdCondition,applicationRowData.genesis__Contact__c);
        skuid.model.updateData([commonContactModel],function(){
            if(!(commonContactModel.data && commonContactModel.data.length > 0)){
                var newPSRow = commonContactModel.createRow({ });
            }
        });
    }else{
        if(!(commonContactModel.data && commonContactModel.data.length > 0)){
            var newPSRow = commonContactModel.createRow({ });
        }
    }
}
});
skuid.snippet.register('saveApplication',function(args) {var params = arguments[0],
  $ = skuid.$;

var newAppParams = {};
var editorWrapper = $('#AppTitleHeader');
if(skuid.page.params.id){
    editorWrapper = $('#AppDetailTitleHeader');
}

var editor = editorWrapper.data('object').editor;
var fetchIncludedPageData = skuid.snippet.getSnippet('getIncludedPageData');
var result = fetchIncludedPageData();
if(!result){
    editor.handleMessages(
        [
          {
              message: 'Unable to save Application data.',
              severity: 'ERROR'
          },
        ]
    );
    return;
}
var applicationModel = result['genesis__Applications__c'];
var appRow = applicationModel.data[0];
appRecType = skuid.page.params.RecordType
if(appRecType && appRecType.length <= 14){
    appRow.RecordTypeId = appRecType;
}else{
    var found = (skuid.model.getModel('GetRecordTypeId').data).find(function(element) {
        return (element.Name == skuid.model.getModel('ApplicationRecordType').data[0].Name);
    });
    appRow.RecordTypeId = found.Id15;
}
if(skuid.page.params.parentId){
    appRow.genesis__Parent_Application__c = skuid.page.params.parentId;
}
var selectedProductModel = skuid.model.getModel('SelectedProduct');
var selectedProductRow = selectedProductModel.data[0];
if(selectedProductRow.Id && selectedProductRow.Id.length > 14){
    appRow.genesis__CL_Product__c = selectedProductRow.Id;
}
var contactModel = skuid.model.getModel('CommonContactModel');
var contactRow = contactModel.data[0];

var accountModel = skuid.model.getModel('CommonAccountModel');
var accRow = accountModel.data[0];

var businessModel = skuid.model.getModel('CommonBusinessInforModel');
var businessRow = businessModel.data[0];

if(!appRow.genesis__Term__c){
    appRow.genesis__Term__c = 0;
}
if(!appRow.genesis__Interest_Rate__c){
    appRow.genesis__Interest_Rate__c = 0;
}
if(!appRow.genesis__Loan_Amount__c){
    appRow.genesis__Loan_Amount__c = 0;
}
if(!appRow.genesis__Credit_Limit__c){
    appRow.genesis__Credit_Limit__c = 0;
}
if(!appRow.genesis__Financed_Amount__c){
    appRow.genesis__Financed_Amount__c = 0;
}
if(!appRow.genesis__Draw_Term__c){
    appRow.genesis__Draw_Term__c = 0;
}
newAppParams.applicationM = applicationModel;
newAppParams.pmtstreamM = null;
newAppParams.businessM = businessModel;

var accExist = false;
try{
    if(accRow.Name || accRow.LastName)
    {
       accExist=true;
    }
}
catch(ex){
    if(accRow.Name)
    {
       accExist=true;
    }
}

if(accExist){
    if(!accountModel.data[0]['clcommon__Legal_Entity_Type__c']){
        editor.handleMessages(
            [
              {
                  message: 'Legal Entity Type is missing',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
    newAppParams.accountM = accountModel;
}else{
    newAppParams.accountM = null;
}

if(contactRow && contactRow.LastName){
    if(!contactModel.data[0].clcommon__Legal_Entity_Type__c){
        editor.handleMessages(
            [
              {
                  message: 'Legal Entity Type is missing',
                  severity: 'ERROR'
              },
            ]
        );
        return;
    }
    let birthDate = contactRow.Birthdate;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (birthDate === '' || birthDate === null || birthDate === undefined || birthDate>today ) {
        editor.handleMessages(

             [{
                message: 'BirthDate cannot be future date or blank.',
                severity: 'ERROR'
            }]
        );

        return;
    }

    if((contactRow.clcommon__Years_At_Current_Address__c === undefined||contactRow.clcommon__Years_At_Current_Address__c<1)||(contactRow.clcommon__Years_At_Current_Address__c==1&&(contactRow.clcommon__Months_at_current_address__c<=0||contactRow.clcommon__Months_at_current_address__c===undefined )))
    {
        if(!(contactRow.OtherStreet&&contactRow.OtherCity&&contactRow.OtherState&&contactRow.OtherPostalCode&&contactRow.OtherCountry))
        {
            editor.handleMessages(
                [
                  {
                      message: 'Previous address cannot be blank',
                      severity: 'ERROR'
                  },
                ]
            );
            return;
        }
    }
    newAppParams.contactM = contactModel;
}else{
    newAppParams.contactM = null;
}
if(!selectedProductModel.data[0]['clcommon__Asset_Class__c']){
        editor.handleMessages(
            [
              {
                  message: 'Asset Class on CL Product is missing, please correct the Product Configuration.',
                  severity: 'ERROR'
              },
            ]
        );
     return;
}
var skuidApplicationId = appRow.Id;
var result = saveNGApplication(newAppParams);
var resultJSON = $.parseJSON(result[0]);
if (resultJSON.status === 'ERROR') {
    editor.handleMessages(
        [
          {
              message: resultJSON.errorMessage,
              severity: 'ERROR'
          },
        ]
    );
} else {
    if(skuidApplicationId == resultJSON.content[0].Id){
        closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe','deal-dashboard-iframe,document-iframe']});
    }else{
         window.location = '/' + resultJSON.content[0].Id;
    }
}
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;

//closeTopLevelDialogAndRefresh({iframeIds: ['loan-details-iframe']});
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe']});
});
skuid.snippet.register('IsReadModeDisabled',function(args) {var params = arguments[0],
  $ = skuid.$;

var readMode = false;
if(skuid.page.params.mode && skuid.page.params.mode == 'read'){
    readMode = true;
}

return !readMode;
});
}(window.skuid));