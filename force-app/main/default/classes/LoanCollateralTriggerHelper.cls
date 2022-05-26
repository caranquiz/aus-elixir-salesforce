/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is the helper class of LoanCollateralTrigger.
Development Date : 14/02/2022
Last Modified Date : 24/02/2022
****************************************************************************************************/
global with sharing class LoanCollateralTriggerHelper {
    global static void loanColletaralUpdation(List<Id> loanIdList,List<loan__Loan_Collateral__c> collateralList){
        try{
            List<loan__Loan_Collateral__c> loanCollList=new List<loan__Loan_Collateral__c>();
            Map<Id,Integer> countMap=New Map<Id,Integer>();
            for(Id loanId:loanIdList){
                countMap.put(loanId,0);
            }
            loanCollList=[SELECT id,
                                loan__Loan__c,
                                loan__Loan__r.id,
                                Primary_Security__c 
                            FROM loan__Loan_Collateral__c 
                            WHERE loan__Loan__c in: loanIdList 
                            AND Primary_Security__c=:ConstantValues.YES_TAG];
            for (loan__Loan_Collateral__c collateral:loanCollList){
                countMap.put(collateral.loan__Loan__c,countMap.get(collateral.loan__Loan__c)+1);
            }
            for (loan__Loan_Collateral__c collateral:collateralList){
                if(countMap.containsKey(collateral.loan__Loan__c) 
                        && countMap.get(collateral.loan__Loan__c)>1 && collateral.Primary_Security__c==ConstantValues.YES_TAG){
                    collateral.addError(ConstantValues.ERROR_MSG_LOANCOLLATERAL);
                }
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LoanCollateralTriggerHelper',exe);
        }
    }
}