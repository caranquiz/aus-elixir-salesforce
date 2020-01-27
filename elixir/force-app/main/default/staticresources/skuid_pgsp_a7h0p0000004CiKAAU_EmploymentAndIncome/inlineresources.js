(function(skuid){
skuid.snippet.register('validateEmploymentAndIncome',function(args) {var params = arguments[0],
    $ = skuid.$;

var dfd = new $.Deferred();
var employmentInformationModel = skuid.model.getModel('EmploymentInformationModel');

$.each(employmentInformationModel.data,function(i,row){
    
    let startDate = row.genesis__Start_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (startDate === '' || startDate === null || startDate === undefined || startDate>today ) {
        
        dfd.reject({
            message: 'Current employment start date cannot be future date or blank.', 
            severity: 'ERROR'
        });
        return  dfd.resolve();
    }
});

var previousEmploymentInfoModel = skuid.model.getModel('PreviousEmploymentInfoModel');

$.each(previousEmploymentInfoModel.data,function(i,row){
    
    let startDate = row.genesis__Start_Date__c;
    let endDate = row.genesis__End_Date__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());

    if (startDate === '' || startDate === null || startDate === undefined || startDate>today ) {
        dfd.reject({
            message: 'Previous employment start date cannot be future date or blank.', 
            severity: 'ERROR'
        });
        return  dfd.resolve();
    }
    
    if (endDate === '' || endDate === null || endDate === undefined || endDate>today ) {
        dfd.reject({
            message: 'Previous employment start date cannot be future date or blank.', 
            severity: 'ERROR'
        });
        return  dfd.resolve();
    }
    
    if (startDate>endDate ) {
                dfd.reject({
            message: 'Previous employment end date needs to be greater than start date.', 
            severity: 'ERROR'
        });
        return  dfd.resolve();
    }
});

var otherIncomeModel = skuid.model.getModel('OtherIncomeModel');

$.each(otherIncomeModel.data,function(i,row){
    
    let name = row.Name;

    if (name === '' || name === null || name === undefined ) {
        
        dfd.reject({
            message: 'Income Name can not be blank.', 
            severity: 'ERROR'
        });
        return  dfd.resolve();
    }
});
dfd.resolve();

return dfd.promise();
});
}(window.skuid));