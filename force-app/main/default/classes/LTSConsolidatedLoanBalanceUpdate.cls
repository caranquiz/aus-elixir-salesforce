/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update the Consolidated Loan Balance of LTS.
Development Date : 12/09/2021
Last Modified Date : 1/12/2021
****************************************************************************************************/

public class LTSConsolidatedLoanBalanceUpdate {
@InvocableMethod(
    label='Update Consolidated Loan Balance of redraw LTS'
    description='Updates Consolidated Loan Balance of redraw LTS'
    )
     //Method used for updating the Consolidated Loan Balance of  LTS
    public static void updateConsolidatedLoanBalance(List<Id> lptIdList){
        try{
            
            loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
            Date endDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
            List<Id> loanIdList=new List<Id>();
            List<Date> dateList=new List<Date>();
            List<clcommon__Deposit__c> objDepositList=new List<clcommon__Deposit__c>();
            Map<id,Decimal> depositMap=new Map<id,Decimal>();
            List<id> idOtherLoanList=new List<id>();
            Map<Id,Decimal> redrawTransaction=new Map<Id,Decimal>();
            Integer j;

            List<loan__Loan_Payment_Transaction__c> lptList=[SELECT id,
                                                                loan__Loan_Account__c,
                                                                loan__Loan_Account__r.id,
                                                                loan__Transaction_Date__c 
                                                            FROM loan__Loan_Payment_Transaction__c 
                                                            WHERE id=:lptIdList];
            
            for(loan__Loan_Payment_Transaction__c loanPayment:lptList){
                loanIdList.add(loanPayment.loan__Loan_Account__r.id);
                dateList.add(loanPayment.loan__Transaction_Date__c);
            }
            List<loan__Loan_Transaction_Summary__c> objLTSList=[SELECT id,
                                                                        Name,
                                                                        loan__Other_Loan_Txn__c,
                                                                        loan__Loan_Account__c,
                                                                        loan__Loan_Account__r.loan__Loan_Balance__c,
                                                                        loan__Other_Loan_Txn__r.loan__Txn_Amt__c,
                                                                        loan__Other_Loan_Txn__r.id,
                                                                        loan__Transaction_Amount__c,
                                                                        loan__Current_Loan_Balance__c,
                                                                        loan__Transaction_Time__c,
                                                                        loan__Transaction_Date__c,
                                                                        Transaction_Type__c,
                                                                        loan__Loan_Payment_Txn__c,
                                                                        loan__Loan_Payment_Txn__r.loan__Deposit__c,
                                                                        loan__Consolidated_Loan_Balance__c 
                                                                    FROM loan__Loan_Transaction_Summary__c
                                                                    WHERE loan__Loan_Account__c in: loanIdList
                                                                    AND loan__Transaction_Date__c>=: dateList 
                                                                    AND loan__Transaction_Date__c<=:endDate];
            
            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                if(objLTS.loan__Other_Loan_Txn__c != NULL){
                    idOtherLoanList.add(objLTS.loan__Other_Loan_Txn__c);
                }
            }
            if(idOtherLoanList.size()>0){
                objDepositList=[SELECT id,
                                    clcommon__Deposit_Amount__c,
                                    loan__Other_Loan_Transaction__c,
                                    clcommon__Transaction_Date__c,
                                    loan__Other_Loan_Transaction__r.id,
                                    loan__Loan_Payment_Transaction__c
                                FROM clcommon__Deposit__c 
                                WHERE loan__Loan_Account__c in: loanIdList];
            }
            for(clcommon__Deposit__c deposit:objDepositList){
                if(deposit.loan__Other_Loan_Transaction__c!= NULL){
                    depositMap.put(deposit.loan__Other_Loan_Transaction__c,deposit.clcommon__Deposit_Amount__c);
                }
                if(deposit.loan__Loan_Payment_Transaction__c!= NULL){
                    depositMap.put(deposit.loan__Loan_Payment_Transaction__c,deposit.clcommon__Deposit_Amount__c);
                }
            }
            
            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                if(objLTS.Transaction_Type__c==ConstantValues.REDRAW){
                    if(objLTS.loan__Loan_Account__c !=NULL && objLTS.loan__Loan_Account__r.loan__Loan_Balance__c!=NULL){
                        objLTS.loan__Current_Loan_Balance__c=objLTS.loan__Loan_Account__r.loan__Loan_Balance__c;
                    }
                    if(depositMap.containskey(objLTS.loan__Other_Loan_Txn__c)){
                        if(objLTS.loan__Current_Loan_Balance__c!=NULL && depositMap.get(objLTS.loan__Other_Loan_Txn__c) != NULL){
                            objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c - depositMap.get(objLTS.loan__Other_Loan_Txn__c);
                        }
                    }
                    redrawTransaction.put(objLTS.loan__Loan_Account__r.id,objLTS.loan__Transaction_Amount__c);
                }
            }
            if(objLTSList.size()>0){
                Database.update(objLTSList,false);
            }
            
            for(loan__Loan_Transaction_Summary__c objLTS:objLTSList){
                if(redrawTransaction.containsKey(objLTS.loan__Loan_Account__r.id) 
                        && objLTS.Transaction_Type__c!=ConstantValues.REDRAW && redrawTransaction.get(objLTS.loan__Loan_Account__r.id)!=NULL){
                    if(objLTS.loan__Loan_Payment_Txn__c != NULL && objLTS.loan__Loan_Payment_Txn__r.loan__Deposit__c != NULL 
                            && depositMap.containskey(objLTS.loan__Loan_Payment_Txn__c) && objLTS.loan__Current_Loan_Balance__c!=NULL && depositMap.get(objLTS.loan__Loan_Payment_Txn__c) != NULL){
                        objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c-depositMap.get(objLTS.loan__Loan_Payment_Txn__c);
                    }else{
                        for(j=0;j<(objDepositList.size()-1);j++){
                            if(objDepositList[j].clcommon__Deposit_Amount__c!=NULL && objDepositList[j].clcommon__Transaction_Date__c<=objLTS.loan__Transaction_Date__c && objDepositList[j+1].clcommon__Transaction_Date__c>objLTS.loan__Transaction_Date__c){
                                objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c-objDepositList[j].clcommon__Deposit_Amount__c;
                            }
                            if(j==objDepositList.size()-2 && objDepositList[j].clcommon__Transaction_Date__c <= objLTS.loan__Transaction_Date__c ){
                                objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c-objDepositList[j].clcommon__Deposit_Amount__c;
                            }
                        }
                    }
                    
                }
            }
            if(objLTSList.size()>0){
                Database.update(objLTSList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertLog('LTSConsolidatedLoanBalanceUpdate', exe);
        }
    }
}