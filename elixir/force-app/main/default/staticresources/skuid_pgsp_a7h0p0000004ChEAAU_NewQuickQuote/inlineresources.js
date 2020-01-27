(function(skuid){
skuid.snippet.register('saveQuickQuote',function(args) {var qqModel = skuid.$M('QuickQuoteModel');
// Get reference to the first row
var qqRow = qqModel.data[0];
var quickQuoteObj = new sforce.SObject("genesis__Quick_Quotes__c");

var prodName = qqRow['genesis__CL_Product__c'];
var businessName = qqRow['genesis__Business_Name__c'];

console.log('Val3 : ' + qqRow['genesis__CL_Product__c']);
console.log('Val4 : ' + qqRow['genesis__Business_Name__c']);

if (prodName === undefined || businessName === undefined) {
    alert('Please enter required fields value');

} else {

    for (var key in qqRow) {
        console.log('key is: ' + key);
        if (key.includes('__c')) {
            quickQuoteObj[key] = qqRow[key];
        }

        if (key == 'genesis__CL_Product__c') {
            //console.log('Value is '+key.values());
        }

    }
    console.log(quickQuoteObj);
    var $ = skuid.$
    var pageTitle = $('#sk-1USljW-640');
    var editor = pageTitle.data('object').editor;
    var result = sforce.apex.execute(
        'genesis.SkuidQQPricingCtrl',
        'generatePricingForQQ', {
            quickQuote: quickQuoteObj,
            queryQuickQuote: false,
            isEquipmentBeingAdded: false
        }
    );


    var resObj = JSON.parse(result);
    if (resObj.status != 'ERROR') {
        editor.handleMessages(
            [{
                message: 'Quick Quote Saved!',
                severity: 'INFO'
            }]
        );
        var v = resObj['content'];
        var id = v["0"].Id;
        window.location = '/' + id;
    } else {
        editor.handleMessages(
            [{
                message: resObj.errorMessage,
                severity: 'ERROR'
            }]
        );

    }
}
});
}(window.skuid));