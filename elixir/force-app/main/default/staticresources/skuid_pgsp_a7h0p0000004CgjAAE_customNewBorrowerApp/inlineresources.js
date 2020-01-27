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
            //var rtIdCondition = applicationRTModel.getConditionByName('Id');
            //applicationRTModel.setCondition(rtIdCondition,'0122v000001taq4AAA');
            
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
skuid.snippet.register('fieldRenderMode1',function(args) {var field = arguments[0],
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
            console.log("AccountData=>>>>>",newPSRow);
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
        console.log("AccountData=>>>>>",newPSRow);
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
  $xml = skuid.utils.makeXMLDoc;
	var context = {};
  console.log('check 1<========');
var newAppParams = {};
var editorWrapper = $('#AppTitleHeader'); 
if(skuid.page.params.id){
    editorWrapper = $('#AppDetailTitleHeader'); 
}
var error=function(errorMessage){
    $.unblockUI();
    var popupXMLString = '<popup width="40%" font-size="26px" title="Required Fields Missing">'
        popupXMLString += '<components>'
            popupXMLString += '<pagetitle model="CommonApplicationModel">'
                popupXMLString += '<maintitle>'+errorMessage+'</maintitle>'
            popupXMLString +='</pagetitle>'
        popupXMLString += '</components>'
    popupXMLString += '</popup>';
    
    var popupXML = $xml(popupXMLString);
    var popup = skuid.utils.createPopupFromPopupXML(popupXML,context);
}
//********************************************************
var editor = editorWrapper.data('object').editor;
var fetchIncludedPageData = skuid.snippet.getSnippet('getIncludedPageData');
var result = fetchIncludedPageData();
if(!result){
    $.unblockUI();
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
//var applicationModel = skuid.model.getModel('CommonApplicationModel');
var applicationModel = result['genesis__Applications__c'];
var appRow = applicationModel.data[0];
if(skuid.page.params.RecordType){
    appRow.RecordTypeId = skuid.page.params.RecordType;    
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
var branchModel = skuid.model.getModel('SystemBranch');
var branchRow = branchModel.data[0];

var businessModel = skuid.model.getModel('CommonBusinessInforModel');
var businessRow = businessModel.data[0];
if(applicationModel.Legal_Entity__c===undefined || applicationModel.Legal_Entity__c===''){
     var appRow1 = applicationModel.getFirstRow();
     applicationModel.updateRow(appRow1,{Legal_Entity__c:skuid.model.getModel('CommonApplicationModel').data[0].Legal_Entity__c});
}
if(!appRow.genesis__Term__c){
    appRow.genesis__Term__c = 0;
}
if(!appRow.genesis__Interest_Only_Period__c){
    appRow.genesis__Interest_Only_Period__c	= 0;
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
if(!appRow.genesis__Initial_Advance__c){
    appRow.genesis__Initial_Advance__c = 0;
}
/*if(!appRow.genesis__Product_Type__c){
    appRow.genesis__Product_Type__c = 'LOAN';
}
if(!appRow.genesis__Product_Sub_Type__c){
    appRow.genesis__Product_Sub_Type__c = 'UNDEFINED';
}
/*
if(!appRow.genesis__Pricing_Method__c){
    appRow.genesis__Pricing_Method__c = 'RATE CARD';
}
if(!appRow.genesis__Sales_Division__c){
    appRow.genesis__Sales_Division__c = 'DEALER';
}
*/

if(!appRow.genesis__Other_Financed_fees__c){
    appRow.genesis__Other_Financed_fees__c = 0;
}
if(!appRow.genesis__Expected_Start_Date__c){
    appRow.genesis__Expected_Start_Date__c = branchRow.loan__Current_System_Date__c;
}
if(!appRow.genesis__Expected_First_Payment_Date__c){
    var dt = new Date(branchRow.loan__Current_System_Date__c);
    appRow.genesis__Expected_First_Payment_Date__c = dt.setMonth(dt.getMonth() + 1);
}
if(selectedProductRow.clcommon__Product_Name__c == 'Construction Development'){
    appRow.genesis__Interest_Calculation_Method__c = 'Flat';
}
newAppParams.applicationM = applicationModel;
newAppParams.pmtstreamM = null;
newAppParams.businessM = businessModel;
console.log("Application=>>>>>>",newAppParams);
if(accRow.Name){
    var accRow1 = accountModel.getFirstRow();
    accountModel.updateRow(accRow1,{clcommon__Legal_Entity_Type__c:skuid.model.getModel('CommonApplicationModel').data[0].Legal_Entity__c});
    //************************************************************************
    if(!accountModel.data[0]['clcommon__Legal_Entity_Type__c']){
        $.unblockUI();
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
    console.log("Existing Account ",newAppParams.accountM);
}else{
    newAppParams.accountM = null;
}

if(contactRow && contactRow.LastName && !accRow.Name){
    var conRow1 = contactModel.getFirstRow();
    try{
    contactModel.updateRow(conRow1,{clcommon__Legal_Entity_Type__c:skuid.model.getModel('CommonApplicationModel').data[0].Legal_Entity__c});    
    }
    catch(err){
        alert(''+err.message);
    }
    //*******assign legal entity type for contact****
    if(!contactModel.data[0].clcommon__Legal_Entity_Type__c){
        $.unblockUI();
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
    newAppParams.contactM = contactModel;
    console.log("Existing Contact ",newAppParams.contactM);
}else{
    newAppParams.contactM = null;
}
var skuidApplicationId = appRow.Id;
//block ui and call save app function

$.blockUI({
    onBlock: function() {
        var result=saveNGApplication(newAppParams);
        console.log(result);
        var resultJSON = $.parseJSON(result[0]);
        if(resultJSON.errorMessage){
            $.unblockUI();
            error(resultJSON.errorMessage);
            return;
        }
        
        
        console.log(resultJSON.content[0].genesis__Account__c);
        console.log(resultJSON.content[0].clcommon__Legal_Entity_Type__c);
        
        var legalEntityId = accountModel.data[0]['clcommon__Legal_Entity_Type__c'];
        var myquery = "SELECT Name FROM clcommon__Legal_Entity__c WHERE id = '"+applicationModel.data[0].Legal_Entity__c+"'"; 
        console.log(myquery);
        var resultQuery;
        resultQuery = sforce.connection.query(myquery); 
        records = resultQuery.getArray("records"); 
        
        //Query party type individual for contact person details.
        var individualPartyId = "SELECT Id FROM clcommon__Legal_Entity__c WHERE Name = 'Individual'"; 
        var companyPartyId = "SELECT Id FROM clcommon__Legal_Entity__c WHERE Name = 'Company'";
        console.log(individualPartyId);
        var resultIndPartyQuery;
        resultIndPartyQuery = sforce.connection.query(companyPartyId); 
        
        records1 = resultIndPartyQuery.getArray("records");
        if(records[0].Name  === 'Company' || records[0].Name === 'Trust' || records[0].Name === 'SMSF'){
            contactModel.updateRow(contactModel.getFirstRow,
                {
                    AccountId : resultJSON.content[0].genesis__Account__c,
                    clcommon__Legal_Entity_Type__c:records1[0].Id
                }
            );
            //changed
            contactModel.save({callback : function(saveContact){
                console.log(saveContact);
            }})
        } else if(records[0].Name === 'Individual'){
            if(contactRow.FirstName && contactRow.MiddleName && contactRow.LastName){
                var fullName=contactRow.FirstName+' '+contactRow.MiddleName+' '+contactRow.LastName;
                var accObj= new sforce.SObject("Account");
                accObj.Name=fullName;
                accObj.Id=resultJSON.content[0].genesis__Account__c;
                var updateAccResult = sforce.connection.update([accObj]);
                
                console.log(updateAccResult);
               if(updateAccResult[0].getBoolean("success")){
               }else{
                   alert(updateAccResult);
               }
            }
        }
        if (resultJSON.status === 'ERROR') {
            $.unblockUI();
            editor.handleMessages(
                [
                  {
                      message: resultJSON.errorMessage.slice(47,500),
                      severity: 'ERROR'
                  },
                ]
            );
        }else {
            if(skuidApplicationId == resultJSON.content[0].Id){
                closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe','loan-details-iframe','deal-dashboard-iframe,document-iframe']});
            }else{
                 window.location = '/' + resultJSON.content[0].Id;   
            }
        }
    //*******************finish on block 
    },
    message: 'The changes are being recorded!'
});
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
skuid.snippet.register('getIncludedPageData',function(args) {var params = arguments[0],
	$ = skuid.$;
var productRow = skuid.model.getModel('GeneralLoanCLProduct').getFirstRow();
var applicationModel = skuid.model.getModel('CommonApplicationModel');
if(applicationModel && applicationModel.data && applicationModel.data[0] && productRow){
    applicationModel.data[0].genesis__CL_Product__c = productRow.Id;
}
var result = {
    'genesis__Applications__c' : applicationModel,
};

return result;
});
}(window.skuid));