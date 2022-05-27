(function(skuid){
skuid.snippet.register('InstallProductConfig',function(args) {var params = arguments[0],
$ = skuid.$;
var header = skuid.model.getModel('DataLoaderHeader');
var result;
var field  = arguments[0];
value = arguments[1],
 row = params.row;
var arg = new Object();
arg.dataLoaderHeaderName = row.Name;
sforce.apex.execute('genesis.DataLoader','installDefaultData',arg);
var query = "SELECT Id,ints__Installed__c FROM ints__Data_Loader_Header__c WHERE Name =\'" + row.Name + "\'" + "LIMIT 1"; 
var records = sforce.connection.query(query);
var recordsArr = records.getArray('records');
if(recordsArr !== null){
var isInstalled = recordsArr[0].ints__Installed__c;
if(isInstalled == 'false'){
result = 'Installation failed. Please check logs for further details.';
} else {
result = 'Success';
}
}
alert(result);
});
}(window.skuid));