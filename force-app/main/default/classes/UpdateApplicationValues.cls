/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: 
Development Date: 30/03/2021
Last Modified Date - 30/03/2021
*/
global with sharing class UpdateApplicationValues {
    webService static String updateNoOfSecurities(Id applicationId){
        try{
            
            if (String.isBlank(applicationId)) {
                throw new CustomException(ConstantValues.APPLICATION_ID_NULL);
            }
            genesis__Applications__c application = new genesis__Applications__c(Id = applicationId);
            List <genesis__Application_Collateral__c> applicationCollateralList = [SELECT Id
                                                                                    FROM genesis__Application_Collateral__c
                                                                                    WHERE genesis__Application__c =: applicationId
                                                                                    AND genesis__Collateral__c != NULL];
            if(applicationCollateralList.size() > 0){
               application.Total_Number_of_Securities__c = applicationCollateralList.size();
            }
            else{
                application.Total_Number_of_Securities__c = 0;
            }
            update application;
            return ConstantValues.SUCCESS_STATUS;
        }
        catch (Exception e) {
            GenericUtility.insertLog('UpdateApplicationValues.updateNoOfSecurities', e);
        }
        return ConstantValues.GENERAL_ERROR;
    }
}