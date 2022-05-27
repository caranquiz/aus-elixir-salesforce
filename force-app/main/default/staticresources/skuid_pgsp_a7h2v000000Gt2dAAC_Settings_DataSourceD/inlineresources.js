(function(skuid){
skuid.snippet.register('datasource__MicrosoftDynamics',function(args) {var args = arguments[0] || {},
    context = args.context || {},
    dataSourceRow = context.row || {},
    dataSourceName = dataSourceRow['Name'] || '',
    dataSourceUrl = dataSourceRow['skuid__URL__c'] || '',
    dataSourceProtocol = dataSourceUrl.split('//')[0]||'',
    dataSourceDomain = (dataSourceUrl.split('//')[1]||'').split('/')[0] || '',
    model = skuid.$M('msdynamics__DataSourceEditor'),
    prodVersion = 'crm_online',
    orgName = '<Your Organization\'s Name>',
    orgUrl = '<Your Organization\'s URL>';

if (!model) return;

if (dataSourceUrl.length > 0){
    if (dataSourceDomain.endsWith('crm.dynamics.com')){
        orgName = dataSourceDomain.slice(0,-17);
        orgUrl = dataSourceProtocol + '//' + dataSourceDomain;
    } else {
        prodVersion = 'crm_onpremise';
        orgName = null;
        orgUrl = dataSourceProtocol + '//' + dataSourceDomain;
    }
}

model.abandonAllRows();
model.adoptRows([{
    'DataSourceName': dataSourceName,
    'ProductVersion': prodVersion,
    'OrgName': orgName,
    'OrgUrl': orgUrl
}]);
});
skuid.snippet.register('datasource__MicrosoftDynamics_EditorModelUpdated',function(args) {var params = arguments[0],
  $ = skuid.$,
    url = params.row['ServiceEndpoint'],
    dataSourceName = params.row['DataSourceName'],
    dataSourceModel = skuid.$M('stng__ModelDataSources'),
    dataSourceRow = dataSourceModel && dataSourceModel.getRows([{field:'Name',value:dataSourceName}])[0];

if (!dataSourceRow) return;

dataSourceModel.updateRow(dataSourceRow,{
    'skuid__URL__c': url
});
});
skuid.snippet.register('datasource__MicrosoftOneDrive',function(args) {var args = arguments[0] || {},
  context = args.context || {},
  dataSourceRow = context.row || {},
  dataSourceName = dataSourceRow['Name'] || '',
  dataSourceUrl = dataSourceRow['skuid__URL__c'] || '',
  dataSourceProtocol = dataSourceUrl.split('//')[0]||'',
  dataSourceDomain = (dataSourceUrl.split('//')[1]||'').split('/')[0] || '',
  model = skuid.$M('msonedrive__DataSourceEditor'),
  orgName = '<Your Organization\'s Name>',
  orgUrl = '<Your Organization\'s URL>';

  if (!model) return;

  if (dataSourceUrl.length > 0){
    orgName = dataSourceDomain.slice(0,-17);
  console.log(orgName);
    orgUrl = dataSourceProtocol + '//' + dataSourceDomain;
  }

  model.abandonAllRows();
  model.adoptRows([{
    'DataSourceName': dataSourceName,
    'OrgName': orgName,
    'OrgUrl': orgUrl
  }]);
});
skuid.snippet.register('datasource__MicrosoftOneDrive_EditorModelUpdated',function(args) {var params = arguments[0],
    $ = skuid.$,
    url = params.row['OrgUrl'],
    dataSourceName = params.row['DataSourceName'],
    dataSourceModel = skuid.$M('stng__ModelDataSources'),
    dataSourceRow = dataSourceModel && dataSourceModel.getRows([{field:'Name',value:dataSourceName}])[0];

    if (!dataSourceRow) return;

    dataSourceModel.updateRow(dataSourceRow,{
    'skuid__URL__c': url
    });
});
skuid.snippet.register('datasource__SAPGateway',function(args) {var params = arguments[0],
  $ = skuid.$,
  context = params.context,
  model = context.model,
  row = context.row,
  isNewRecord = model.isRowNew(row);
if(isNewRecord) {
    model.updateRow(row, {
        skuid__Auth_Request_Headers__c: '{"X-CSRF-Token":"Fetch","Authorization":"Basic {{$Auth.BasicAuth}}"}',
        skuid__Auth_Request_Verb__c:'GET',
        skuid__Authentication_URL__c:'https://<SAP_DOMAIN>/sap/opu/odata/<PATH_TO_SERVICE>',
        skuid__Authentication__c:'separateurl',
        skuid__Credential_Source__c:'org',
        skuid__Request_Headers__c:'{"X-CSRF-Token":"{{$Auth.Response.Headers.x-csrf-token}}","Authorization":"Basic {{$Auth.BasicAuth}}"}',
        skuid__URL__c:'https://<SAP_DOMAIN>/sap/opu/odata/<PATH_TO_SERVICE>',
    });
}
});
skuid.snippet.register('datasource__OData',function(args) {var args = arguments[0] || {},
    context = args.context || {},
    model = context.model || {},
    row = context.row || {},
    customConfigJSON = row['skuid__Custom_Config__c'] || '',
    customConfig = {};
    
if (!model) return;

try {
    customConfig = JSON.parse(customConfigJSON);
} catch(e) {}

model.updateRow(row, { 'ODataVersion__ui': customConfig['odata-version'] || "4.0" });
        model.updateRow(row, { 'ODataSupportsBatch__ui': customConfig['supports-batch'] || "false" });
});
skuid.componentType.register('regionLoader',function(elem) {var elem = arguments[0];
var $ = skuid.$;
var snippet = skuid.snippet.get("ModelDataSourcePrepareAdvSettingsRegion");
snippet && snippet();
});
}(window.skuid));