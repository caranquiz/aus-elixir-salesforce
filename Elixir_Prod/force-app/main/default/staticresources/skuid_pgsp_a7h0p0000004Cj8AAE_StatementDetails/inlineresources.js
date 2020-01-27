(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    var beautifyTable = skuid.snippet.getSnippet('StatementDetails_BeautifyTable');
        var result = beautifyTable();
	});
})(skuid);;
skuid.snippet.register('StatementDetails_BeautifyTable',function(args) {var params = arguments[0],
	$ = skuid.$;

var statementDetailModel = skuid.model.getModel('StatementDetails');
$('.statement-detail-table').each(
    function(tableIndex, table) {
        $(table).find('table tbody tr').each(
            function(index, element) {
                if(statementDetailModel.data[index]){
                    var level = statementDetailModel.data[index].clcommon__Template_Detail__r.clcommon__Level__c;
                    if(level) {
                        $(element).attr('level', level.split('.').length);
                    } else {
                        $(element).attr('level', 0);    
                    }
                    $(element).attr('row-type', statementDetailModel.data[index].clcommon__Type__c);    
                }
            }
        );
    }
);
});
skuid.snippet.register('InputAmountFieldRender',function(args) {var field = arguments[0],
    value = arguments[1];
  
if(field.row && field.row.clcommon__Type__c == "INPUT") {
    skuid.ui.fieldRenderers[field.metadata.displaytype]['edit'](field,value);
} else {
    skuid.ui.fieldRenderers[field.metadata.displaytype]['read'](field,value); 
}
});
skuid.snippet.register('renderFieldAsPerMode',function(args) {var field = arguments[0],
    value = arguments[1];
    
if(skuid.page.params.editmode) {
    skuid.ui.fieldRenderers[field.metadata.displaytype]['edit'](field,value);
} else {
    skuid.ui.fieldRenderers[field.metadata.displaytype]['read'](field,value); 
}
});
skuid.snippet.register('StatementDetails_CalculateBalances',function(args) {var $ = skuid.$;
$.blockUI({
    message: 'Updating Statement...',
    onBlock:function(){
        var statementHeader = skuid.model.getModel('StatementHeader').data[0];
        calculateBalancesApex(statementHeader.Id)
        fetchDependentRecords(statementHeader.Id);
        $('.ui-dialog-content').last().dialog('close');
        var message = {
        	type: 'requery-statement-headers'
        };	
        window.parent.postMessage(message , '*')
    }
}); 

// fetch records with dependency as this record
function calculateBalancesApex(statementId){
    sforce.apex.execute('clcommon.CustomButtonAction', 'calculateBalances', {statementId: statementId});
}

function fetchDependentRecords(statementId){
    var result = sforce.connection.query(
        "Select Id,Name from clcommon__Financial_Statement__c where clcommon__Previous_Statement__c = '" + statementId + "'");
    records = result.getArray("records");
    for (var i = 0 ; i < records.length; i++) {
        var record = records[i]; 
        var res = calculateBalancesApex(record.Id);
        fetchDependentRecords(record.Id);
    }
}
});
skuid.snippet.register('StatementDetails_CloseEditDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
var message = {
	type: 'close-edit-statement-headers'
};	
window.parent.postMessage(message , '*')
});
}(window.skuid));