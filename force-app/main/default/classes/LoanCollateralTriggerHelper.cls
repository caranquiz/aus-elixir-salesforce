/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is the helper class of LoanCollateralTrigger.
Development Date : 14/02/2022
Last Modified By : Sayak Mukhopadhyay
Last Modified Date : 23/06/2022
****************************************************************************************************/
global with sharing class LoanCollateralTriggerHelper {
    global static void loanColletaralUpdation(List<Id> loanIdList,List<loan__Loan_Collateral__c> collateralList){
        try{
            List<loan__Loan_Collateral__c> loanCollList=new List<loan__Loan_Collateral__c>();
            List<loan__Loan_Collateral__c> allLoanCollList=new List<loan__Loan_Collateral__c>();
            List<loan__Loan_Account__c> loanAccountList = new List<loan__Loan_Account__c>();
            Map<Id,Integer> countMap=New Map<Id,Integer>();
            for(Id loanId:loanIdList){
                countMap.put(loanId,0);
            }
            loanAccountList = [SELECT id,
                                        Actual_Security_Value__c,
                                        All_Security_Addresses__c,
                                        (Select Id,
                                        loan__Loan__c,    
                                        Primary_Security__c,
                                        Current_Value__c,
                                        Full_Address__c,
                                        Security_Status__c
                                        FROM loan__Loan_Collateral__r)
                                        FROM loan__Loan_Account__c
                                        WHERE id in: loanIdList];
            for(loan__Loan_Account__c loanAccount : loanAccountList){
                Double totalCurrentValue = 0;
                loanAccount.All_Security_Addresses__c = '';
                Integer i = 0;
                for (loan__Loan_Collateral__c collateral : loanAccount.loan__Loan_Collateral__r){                                           
                    if(collateral.Current_Value__c != null){
                        totalCurrentValue += collateral.Current_Value__c;
                    }                
                    if(!String.isBlank(collateral.Primary_Security__c) && collateral.Primary_Security__c == ConstantValues.YES_TAG){                                        
                        countMap.put(collateral.loan__Loan__c,countMap.get(collateral.loan__Loan__c)+1);                                    
                    }
                    if(collateral.Full_Address__c != NULL && collateral.Security_Status__c != 'Discharged'){
                        if(i == 0){
                            loanAccount.All_Security_Addresses__c = collateral.Full_Address__c;
                            i++;
                        }
                        else{
                            loanAccount.All_Security_Addresses__c = loanAccount.All_Security_Addresses__c+' and '+collateral.Full_Address__c;
                            i++;
                        }
                    }             
                }                
                loanAccount.Actual_Security_Value__c = totalCurrentValue;                                 
            }
            for (loan__Loan_Collateral__c collateral:collateralList){
                if(countMap.containsKey(collateral.loan__Loan__c) 
                        && countMap.get(collateral.loan__Loan__c)>1 && collateral.Primary_Security__c==ConstantValues.YES_TAG){
                    collateral.addError(ConstantValues.ERROR_MSG_LOANCOLLATERAL);
                }
            }
            if(loanAccountList.size()>0){
                Database.update(loanAccountList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LoanCollateralTriggerHelper',exe);
        }
    }
}