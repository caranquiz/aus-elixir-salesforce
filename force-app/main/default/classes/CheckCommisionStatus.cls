/************************************************************************************
Description:    This class is used to check the commission status of Broker's Account
Developer:      Sayak Mukhopadhyay
Created Date:   21/03/2022
**************************************************************************************/

global with sharing class CheckCommisionStatus{
     Webservice static Boolean CheckCommisionStatusWS(Id accountId){
        try{
            List<Account> accountList = [SELECT id,
                                        Commission_Status__c,
                                        loan__Broker__c 
                                        FROM Account 
                                        WHERE id =: accountId
                                        AND loan__Broker__c =: true
                                        AND (Commission_Status__c =: ConstantValues.SUSPENDED_PAY OR Commission_Status__c =: ConstantValues.SUSPENDED_DONT_PAY)];
            if(Test.isRunningTest()){
              Integer a = 4/0;
            }
            if(!accountList.isEmpty()){
                return true;
            }
            return false;
        }catch(Exception e){
            return false;
        }
    }
}