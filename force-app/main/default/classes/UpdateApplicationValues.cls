/*
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description: This class is used to update the total no of available securities,Previously Bankrupt and Bankrupt Discharged Date in application
Development Date: 30/03/2021
Last Modified Date - 05/04/2021
*/
global with sharing class UpdateApplicationValues {
    //This method is used to update total no of securities in application
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
    //This method is used to update Previously Bankrupt and Bankrupt Discharged Date in application
    //according to the mechanism/rule defined by customer
    @InvocableMethod(
        label='Update Bankrupt Values'
        description='Updates Previously Bankrupt and Bankrupt discharged date value on Application'
    )
    public static void updateBankruptInfo(List<Id> appIdList){
        try{
            List <genesis__Applications__c> appList = [SELECT Id,
                                                            Previously_Bankrupt__c,
                                                            Bankrupt_Date__c
                                                        FROM genesis__Applications__c
                                                        WHERE Id IN : appIdList];
            
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        Bankrupt_Date__c,
                                                        Applicant_ever_declared_banckrupt__c,
                                                        genesis__Application__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c IN : appIdList
                                                        AND Applicant_ever_declared_banckrupt__c != NULL
                                                        ORDER BY Bankrupt_Date__c ASC NULLS FIRST];
            if(partyList.size() > 0){
                for(genesis__Applications__c eachApp : appList){
                    eachApp.Previously_Bankrupt__c = ConstantValues.NO_TAG;
                    eachApp.Bankrupt_Date__c = NULL;
                    for(clcommon__Party__c eachParty : partyList){
                        if(eachParty.genesis__Application__c == eachApp.id && eachParty.Applicant_ever_declared_banckrupt__c == ConstantValues.YES_TAG){
                            eachApp.Previously_Bankrupt__c = ConstantValues.YES_TAG;
                            if(eachParty.Bankrupt_Date__c != NULL){
                                eachApp.Bankrupt_Date__c = eachParty.Bankrupt_Date__c;
                            }
                        }
                    }
                }
                Database.update(appList,false);
            }
        }
        catch (Exception e) {
            GenericUtility.insertLog('UpdateApplicationValues.updateBankruptInfo', e);
        }
    }
}