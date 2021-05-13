/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 13/05/2021
Last Modified By : Rameswari Barman
Last Modified Date : 13/05/2021
Description : This class helps in assigning the Date_of_Most_Recent_Credit_Event__c value in party object record
***********************************************************************************************************************************************************/
global with sharing class CalculateCreditHistoryValues {
    Webservice static String calculateValues(Id partyId) {
        if(String.isBlank(partyId) == true){
            return ConstantValues.GENERAL_ERROR;
        }
        Date mostRecentDate = null;
        try {
            List <clcommon__Party__c> partyRecord = [SELECT Id,
                                                        Legal_Entity_Type__c,
                                                        Date_of_Most_Recent_Credit_Event__c 
                                                        FROM clcommon__Party__c 
                                                        WHERE Id =: partyId
                                                        limit 1
                                                    ];
            if(partyRecord.size() != 1){
                return ConstantValues.GENERAL_ERROR;
            }
            if(partyRecord[0].Legal_Entity_Type__c == ConstantValues.indType){
                List <Payment_Default__c> paymentDefaults = [SELECT Id,
                                                            Status_Date__c
                                                            FROM Payment_Default__c
                                                            WHERE Credit_Account__r.Party__c =: partyId 
                                                            AND Credit_Account__r.Credit_Account_Type__c 
                                                            IN (:ConstantValues.CONSUMER,:ConstantValues.COMMERCIAL)
                                                            AND Original_Default_Amount__c > 1000
                                                            AND Status_Date__c != NULL
                                                            ORDER BY Status_Date__c DESC
                                                            LIMIT 1];
            
                List <Credit_Account__c> creditAccountList = [SELECT Id,
                                                                    Default_Date__c
                                                                    FROM Credit_Account__c 
                                                                    WHERE Party__c =: partyId 
                                                                    AND ((Credit_Account_Type__c IN (
                                                                        :ConstantValues.DEFAULT_JUDGEMENTS,
                                                                        :ConstantValues.OTHER_COURT_ACTIONS)
                                                                    AND Current_Default_Amount__c > 1000)
                                                                    OR Credit_Account_Type__c IN (
                                                                        :ConstantValues.PERSONAL_INSOLVENCIES))
                                                                    AND Default_Date__c != NULL
                                                                    ORDER BY Default_Date__c DESC
                                                                    LIMIT 1];

                if(paymentDefaults.size() == 1 
                    && creditAccountList.size() == 1 
                    && paymentDefaults[0].Status_Date__c >= creditAccountList[0].Default_Date__c){
                        mostRecentDate = paymentDefaults[0].Status_Date__c;
                }
                else if(paymentDefaults.size() == 1 
                    && creditAccountList.size() == 1 
                    && paymentDefaults[0].Status_Date__c <= creditAccountList[0].Default_Date__c){
                        mostRecentDate = creditAccountList[0].Default_Date__c;

                }
                else if(paymentDefaults.size() == 1 
                    && creditAccountList.size() == 0){
                        mostRecentDate = paymentDefaults[0].Status_Date__c;
                }
                else if(paymentDefaults.size() == 0 
                    && creditAccountList.size() == 1){
                        mostRecentDate = creditAccountList[0].Default_Date__c;
                }
            }
            else{
                List <Credit_Account__c> creditAccountList = [SELECT Id,
                                                                    Default_Date__c
                                                                    FROM Credit_Account__c 
                                                                    WHERE Party__c =: partyId
                                                                    AND Original_Default_Amount__c > 1000
                                                                    AND Default_Date__c != NULL
                                                                    ORDER BY Default_Date__c DESC
                                                                    LIMIT 1];
                if(creditAccountList.size() == 1){
                    mostRecentDate = creditAccountList[0].Default_Date__c;
                }                                                    
            }
            partyRecord[0].Date_of_Most_Recent_Credit_Event__c = mostRecentDate;
            //null value will be updated if there are no records in the child objects
            update partyRecord;
            return ConstantValues.SUCCESS;
        }
        catch (Exception ex) {
            GenericUtility.insertLog('CalculateCreditHistoryValues.calculateValues', ex);
            return ConstantValues.GENERAL_ERROR;
        }
    }
}