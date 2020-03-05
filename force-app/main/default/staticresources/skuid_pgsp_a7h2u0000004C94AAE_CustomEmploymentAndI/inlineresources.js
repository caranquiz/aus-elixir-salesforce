(function(skuid){
skuid.snippet.register('DisplayDefaultZero',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

value = value === null ? 0 : value;
var renderer = skuid.ui.fieldRenderers[field.metadata.displaytype];
renderer.readonly(field, value);
});
skuid.snippet.register('ABN Company Check',function(args) {var params = arguments[0],
    $ = skuid.$;
console.log('*1');
var appModel = skuid.model.getModel('OriginalApplication');
var appRow = appModel.data[0];
var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){
        return item.row;
    });
    if ( !records[0]  || records.length < 1) {
        alert("Please select at least one Company Name");
    }else if(records  && records.length > 1){
        alert("Please select at only one Company Name");
    } else{
        //if(records[0].Company_Name__c !== ''){
        console.log(records[0].Party__c+'Party Id');
        var del = sforce.apex.execute('ABNNameCallout','deleteCompanyList',
                {
                    sfId : records[0].Party__c,
                    typeIndicator : 'E'
                   
        });
        console.log('*3');
        var ret = sforce.apex.execute('ABNNameCallout','makeABNSkuidCallout',
        {  
            sfId : records[0].Id,
            typeIndicator : 'E'
         });
        if(ret != 'SUCCESS'){
            console.log('*2');
            console.log(ret);
            alert('Kindly provide a valid name search for ABN search.');
            var apptyObj = new sforce.SObject("genesis__applications__c");
            apptyObj.Id = appRow.Id;
            apptyObj.Button_disable__c = 'False';
            var result = sforce.connection.update([apptyObj]);
            appModel.updateData();
            console.log('*4');
            return false;
        }
        else if(!ret){
            alert('Error');
            var apptyObj = new sforce.SObject("genesis__applications__c");
            apptyObj.Id = appRow.Id;
            apptyObj.Button_disable__c = 'False';
            var result = sforce.connection.update([apptyObj]);
            var appModel = skuid.model.getModel('OriginalApplication');
            appModel.updateData();
            console.log('*5');
            return false;
        }
        else{
                console.log('*6');
                return true;
            }
        /*}
        else{
            alert('Kindly provide a valid name search for ABN search.');
        }*/
    }
});
skuid.snippet.register('ABNCheck',function(args) {var params = arguments[0],
    $ = skuid.$;
    //var partyModel = skuid.model.getModel('Party');
    //var partyRow = partyModel.data[0];
    //var ABNCompanyModel = skuid.model.getModel('ABN_ComapnyName_Model');
    //var ABNCompanyRow = ABNCompanyModel.data[0];
    var records = skuid.$.map(arguments[0].list.getSelectedItems(),function(item){
        return item.row;
    });
    //console.log(records);
    //console.log(arguments[0].list);
    if ( !records[0]  || records.length < 1) {
        alert("Please select at least one Company");
    }else if(records  && records.length > 1){
        alert("Please select at only one Company");
    } else{
        var result = sforce.apex.execute('ABNAPICallout','makeABNCompanySkuidCallout',
        {  
            companyId : records[0].Id
         });
                alert(result);
                //window.location.reload();
    }
});
skuid.snippet.register('fullDocument',function(args) {var params = arguments[0],
$ = skuid.$;
var SelfModel = skuid.model.getModel('SelfEmploymentDetails');
//console.log(SelfModel.getRows()) ;
var flag = false ;
$.each(SelfModel.getRows(),function(i,row){
    //console.log(row.Document_Type__c) ;
    if(row.Document_Type__c === 'Full'){
        flag = true ;
    } 
});
return flag ;
});
skuid.snippet.register('PreviousEmploymentRender',function(args) {var params = arguments[0],
$ = skuid.$;
var paygModel = skuid.model.getModel('PayGEmploymentDetails');
var flag = false ;
$.each(paygModel.getRows(),function(i,row){
    if(row.Employment_Duration__c < 24){
        flag = true ;
    } 
});
return flag ;
});
skuid.snippet.register('AltDocument',function(args) {var params = arguments[0],
$ = skuid.$;
var SelfModel = skuid.model.getModel('SelfEmploymentDetails');
var flag = false ;
$.each(SelfModel.getRows(),function(i,row){
    //console.log(row.Document_Type__c) ;
    if(row.Document_Type__c === 'Alt'){
        flag = true ;
    } 
});
return flag ;
});
skuid.snippet.register('IncomeSummary',function(args) {var params = arguments[0],
    $ = skuid.$;
var partyRow    = skuid.model.getModel('NGParty').data[0];
var ret;
            $.blockUI({
                message: 'Please wait! ',
                onBlock: function(){
                        ret = sforce.apex.execute('IncomeSummary','IncomeSummarySkuidCallout',
                    {
                        appId : partyRow.genesis__Application__c
                    });
                    if(ret=='SUCCESS'){
                        $.unblockUI();
                        //window.location.reload();
                    }else{
                        //console.log(ret+'==HERE==');
                        alert(ret);
                        $.unblockUI();
                        //window.location.reload();
                    }
                },
                
            });
});
skuid.snippet.register('DeleteUnwantedSelfEmployment',function(args) {var abnCompanyNameModel = skuid.model.getModel('ABNCompanyListModel');
var delIds = [],i=0;
$.each(abnCompanyNameModel.data,function(i,row){
    delIds[i] = row.Id;
    i=i+1;
});
try {
    var delResult = sforce.connection.deleteIds([delIds]);
}
catch (err){
    alert('Too many search results have been obtained! Please enter more specific details.');
    return false;
}
});
skuid.snippet.register('ServicingIncomeApplicationReload',function(args) {var params = arguments[0],
	$ = skuid.$;
	var appModel = skuid.model.getModel('ServicingIncomeApplication');
    appModel.updateData();
});
skuid.snippet.register('IncomeSummaryEmpModelReload',function(args) {var params = arguments[0],
	$ = skuid.$;
	var appModel = skuid.model.getModel('IncomeSummaryEmpModel');
    appModel.updateData();
    var payGModel = skuid.model.getModel('PayGEmploymentDetails');
    payGModel.updateData();
});
}(window.skuid));