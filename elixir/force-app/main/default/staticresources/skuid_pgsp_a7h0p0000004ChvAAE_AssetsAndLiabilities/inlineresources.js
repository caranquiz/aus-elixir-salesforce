(function(skuid){
skuid.snippet.register('validateAssetsAndLiabilities',function(args) {var params = arguments[0],
    $ = skuid.$;

var dfd = new $.Deferred();

var assetInformationModel = skuid.model.getModel('AssetInformationModel');

$.each(assetInformationModel.data,function(i,row){
    
    let acquisitionDate = row.genesis__Date_of_Acquisition__c;
    let marketValueDate = row.genesis__Market_Value_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (acquisitionDate === '' || acquisitionDate === null || acquisitionDate === undefined || acquisitionDate>today ) {
        
        dfd.reject({
            message: 'Date of Acquisition cannot be future date or blank.', 
            severity: 'ERROR'
        });
        return dfd.resolve();
    }
    
    if (marketValueDate === '' || marketValueDate === null || marketValueDate === undefined || marketValueDate>today ) {
        
        dfd.reject({
            message: 'Market Value Date cannot be future date or blank.', 
            severity: 'ERROR'
        });
        return dfd.resolve();
    }
    
    let name = row.Name
    if (name === '' || name === null || name === undefined ) {
        
        dfd.reject({
            message: 'Asset description can not be blank.', 
            severity: 'ERROR'
        });
        return dfd.resolve();
    }
});

var liabilityInformationModel = skuid.model.getModel('LiabilityInformationModel');

$.each(liabilityInformationModel.data,function(i,row){
    let paymentAmount = row.genesis__Payment_Amount__c;
    let amountOwing = row.genesis__Amount_Owing__c;
    
    if (paymentAmount>amountOwing) {
        dfd.reject({
                message: 'Payment amount cannot be greater than amount owing.', 
                severity: 'ERROR'
        });
        return dfd.resolve();
    }

});

dfd.resolve();

return dfd.promise();
});
skuid.snippet.register('refreshThePage',function(args) {var params = arguments[0],
	$ = skuid.$;
skuid.$M('NetWorth').evaluateFormulaFields();
});
}(window.skuid));