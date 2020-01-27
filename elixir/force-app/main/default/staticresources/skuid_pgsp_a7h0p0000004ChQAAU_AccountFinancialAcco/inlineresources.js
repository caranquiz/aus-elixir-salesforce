(function(skuid){
skuid.snippet.register('Renew',function(args) {var params = arguments[0],    
contextRow = params.item ? params.item.row : params.row,
contextModel = params.model,
$ = skuid.$;
var contextContractId = contextModel.getFieldValue(contextRow, 'staging__Interface_Contract__c', true);
var contextContractProdType = contextModel.getFieldValue(contextRow, 'staging__Interface_Contract__r.staging__Contract_Type__c', true);
var result = sforce.apex.execute('genesis.SkuidRenewalCtrl','renewContract',
{   
        contractId : contextContractId,
        productType : contextContractProdType
});
var resObj = JSON.parse(result);
if(resObj.status == 'SUCCESS'){
var appName = resObj.content[0].Name;
alert('Application '+ appName + ' successfully created.');
}else{
alert(resObj.errorMessage);
}

window.location.reload();
});
skuid.snippet.register('AnnualReview',function(args) {var params = arguments[0],    
contextRow = params.item ? params.item.row : params.row,
contextModel = params.model,
$ = skuid.$;
var contextContractId = contextModel.getFieldValue(contextRow, 'staging__Interface_Contract__c', true);
var contextContractProdType = contextModel.getFieldValue(contextRow, 'staging__Interface_Contract__r.staging__Contract_Type__c', true);
var result = sforce.apex.execute('genesis.SkuidRenewalCtrl','doAnnualReview',
{   
        contractId : contextContractId,
        productType : contextContractProdType
});
var resObj = JSON.parse(result);
if(resObj.status == 'SUCCESS'){
var appName = resObj.content[0].Name;
alert('Application '+ appName + ' successfully created.');
}else{
alert(resObj.errorMessage);
}
window.location.reload();
});
}(window.skuid));