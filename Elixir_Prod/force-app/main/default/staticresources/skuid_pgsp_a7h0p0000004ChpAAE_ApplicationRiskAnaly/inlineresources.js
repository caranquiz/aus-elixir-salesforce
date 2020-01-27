(function(skuid){
skuid.snippet.register('RenderColumnWIthExternalLink',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var url = '/' + field.row.Id;
field.element.html('<a href="' + url + '" target="_blank">' + value + '</a>');
});
skuid.snippet.register('RenderAccountStatusColumn',function(args) {var field = arguments[0],
    value = arguments[1],
    $ = skuid.$;

var message = value ? 'Active' : 'Not Active';

field.element.text(message);
});
skuid.snippet.register('GenerateScorecards',function(args) {var scModels = skuid.model.getModel('Application');
var scRow = scModels.data[0]; 
var result = sforce.apex.execute('genesis.ScorecardAPI','generateScorecard',
{   
    applicationId : scRow.Id
});
alert(result);
window.location.reload();
});
skuid.snippet.register('ApplyPricing',function(args) {var params = arguments[0],
contextRow = params.item ? params.item.row : params.row,
contextModel = params.model,
	$ = skuid.$;
//console.log('--Param--'+params.data);
console.log('--contextModel--'+contextModel);
console.log('--contextRow--'+contextRow);
var contextId = contextModel.getFieldValue(contextRow, 'Id', true);
console.log('--contextId--'+contextId);

var scModels = skuid.model.getModel('PricingDetails');
var scRow = scModels.data[0]; 

var selectedPricingId;
var selectedCount = 0;
$.each(scModels.data,function(i,row) {
    if(scModels.getFieldValue(row,'genesis__Selected__c')){
        selectedCount ++;
        selectedPricingId = scModels.getFieldValue(row,'Id');
        console.log('--Selected Pricing Id--'+selectedPricingId);
    }
});
if(selectedCount > 1){
    var pageTitle = $('#LoanInformation');
    var editor = pageTitle.data('object').editor;
    editor.handleMessages(
    [
      {
          message: 'More than 1 pricing is seleted. Please select only one pricing.',
          severity: 'ERROR'
      },
    ]
    );
    return;
    //alert('More than 1 pricing is seleted. Please select only one pricing.');
}
//scModels.save();
var result = sforce.apex.execute('genesis.SelectPricingOnApplication','selectPricingOption',
{   
    pricingId : selectedPricingId
});

window.location.reload();
});
}(window.skuid));