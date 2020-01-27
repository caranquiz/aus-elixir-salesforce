(function(skuid){
skuid.snippet.register('validateIdentificationInput',function(args) {var params = arguments[0],
	$ = skuid.$;

var pageTitle = null;
var documentCategoryModel = skuid.model.getModel('DocumentCategory');
var documentCategoryRow = documentCategoryModel.data[0];

if(documentCategoryRow.clcommon__Document_Definition__r!==undefined){
    var identificationInformationModel = null;
    if(documentCategoryRow.clcommon__Document_Definition__r.Name==='Primary Identification')
    {
        identificationInformationModel = skuid.model.getModel('PrimaryIdentificationInformation');
        pageTitle = $('#primaryIdentificationEditor');
    }
    else if(documentCategoryRow.clcommon__Document_Definition__r.Name==='Secondary Identification')
    {
        identificationInformationModel = skuid.model.getModel('SecondaryIdentificationInformation');
        pageTitle = $('#secondaryIdentificationEditor');
    }
    else return true
    
    var identificationInformationRow = identificationInformationModel.data[0];
    let expDate = identificationInformationRow.genesis__Expiration_Date__c;
    let issuanceDate = identificationInformationRow.genesis__Date_of_Issuance__c;
    let today = $.datepicker.formatDate('yy-mm-dd', new Date());
    
    
    var editor = pageTitle.data('object').editor;
    
    if (issuanceDate === '' || issuanceDate === null || issuanceDate === undefined || issuanceDate>today ) {
        editor.handleMessages( 
            
            [{
               
                message: 'Please Enter vaild Date of issuance', 
                severity: 'ERROR'
            }]
        );
    
        return false;
    }
    
    if (expDate === '' || expDate === null || expDate === undefined || expDate<=today ) {
        editor.handleMessages( 
            
            [{
               
                message: 'Expiration date should be future date', 
                severity: 'ERROR'
            }]
        );
    
        return false;
    }
}
return true;
});
}(window.skuid));