(function(skuid){
skuid.snippet.register('applicationRedirect',function(args) {var params = arguments[0],
	$ = skuid.$;
var url = document.referrer;
var productId = params.row.__skuid_record__.__id;
var recordTypeId = params.row.RecordTypeId;
var accountId = skuid.page.params.id
if(recordTypeId==undefined || recordTypeId == null ){
    alert("Record Type is not defined for the selected Product");
}else{
    var developerName = sforce.connection.query("select DeveloperName from recordtype where id = '"+recordTypeId+"'");
    var sql = "select id,Name,sobjectType,DeveloperName from RecordType where sobjecttype='genesis__Applications__c' and developername='"+developerName.records.DeveloperName+"'";
    var result = sforce.connection.query(sql);
    if(result.records.Id){
    var urls = url+"apex/NewApplication?RecordType="+result.records.Id+"&AccountId="+accountId +"&ProductId="+productId;
    window.open(urls, '_blank')
    }else{
        alert("Record Type is not found: "+developerName.records.DeveloperName)
    }
}
});
}(window.skuid));