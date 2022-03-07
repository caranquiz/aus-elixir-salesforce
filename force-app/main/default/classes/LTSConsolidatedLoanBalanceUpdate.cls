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
            List<id> paidOffLoanId=new List<Id>();
            List<Date> paidOffDate=new List<Date>();
            Map<Id,Date> paidOffDateList=new Map<Id,Date>();

            List<loan__Loan_Payment_Transaction__c> lptList=[SELECT id,
                                                                loan__Loan_Account__c,
                                                                loan__Loan_Account__r.id,
                                                                loan__Payoff_Balance__c,
                                                                loan__Transaction_Date__c 
                                                            FROM loan__Loan_Payment_Transaction__c 
                                                            WHERE id=:lptIdList
                                                            AND loan__Payment_Mode__r.Name NOT IN 
                                                            (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER)];
            
            for(loan__Loan_Payment_Transaction__c loanPayment:lptList){
                
                if(loanPayment.loan__Payoff_Balance__c!=NULL && loanPayment.loan__Payoff_Balance__c==0){
                    paidOffLoanId.add(loanPayment.loan__Loan_Account__r.Id);
                    paidOffDate.add(loanPayment.loan__Transaction_Date__c);
                    paidOffDateList.put(loanPayment.loan__Loan_Account__r.Id,loanPayment.loan__Transaction_Date__c);                
                }else{
                    loanIdList.add(loanPayment.loan__Loan_Account__r.id);
                    dateList.add(loanPayment.loan__Transaction_Date__c);
                }
            }
            if(dateList.size()>0 && loanIdList.size()>0){
                List<loan__Loan_Transaction_Summary__c> objLTSList=[SELECT id,
                                                                            Name,
                                                                            loan__Other_Loan_Txn__c,
                                                                            loan__Interest_Posting_Txn__c,
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
                                                                            loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c,
                                                                            loan__Loan_Payment_Txn__r.loan__Excess__c,
                                                                            loan__Interest_Posting_Txn__r.loan__Interest_Posting_Type__c,
                                                                            loan__Interest_Posting_Txn__r.loan__Balance__c,
                                                                            loan__Consolidated_Loan_Balance__c,
                                                                            Debit__c,
                                                                            Credit__c,
                                                                            loan__Loan_Account__r.id
                                                                        FROM loan__Loan_Transaction_Summary__c
                                                                        WHERE Include_in_Summary__c = true
                                                                        AND loan__Loan_Account__c in: loanIdList
                                                                        AND loan__Transaction_Date__c>=: dateList 
                                                                        AND loan__Transaction_Date__c<=:endDate
                                                                        AND loan__Last_Transaction_Type__c NOT IN (:ConstantValues.OTHER_TRANSACTION)
                                                                        AND (Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,
                                                                            :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT) 
                                                                        OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null)
                                                                        AND (loan__Loan_Payment_Txn__c = null
                                                                        OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN 
                                                                            (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                        AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false
                                                                        AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false
                                                                        AND loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c > 0 AND Paid_Off_Check__c=false))
                                                                        AND (loan__Interest_Posting_Txn__c = null OR (loan__Interest_Posting_Txn__r.loan__Reversed__c = false AND Paid_Off_Check__c=false)) 
                                                                        AND (loan__Other_Loan_Txn__c = null OR (loan__Other_Loan_Txn__r.loan__Reversed__c = false AND Paid_Off_Check__c=false)) 
                                                                        AND (loan__Loan_Disbursal__c = null OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                        AND loan__Loan_Disbursal__r.loan__Rejected__c= false AND loan__Loan_Disbursal__r.loan__Cleared__c = true AND Paid_Off_Check__c=false)) 
                                                                        AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false AND Paid_Off_Check__c=false)) 
                                                                        ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC, Name ASC];
                
                List<loan__Loan_Transaction_Summary__c> payoffList = [SELECT Id,
                                                                            Name,
                                                                            loan__Other_Loan_Txn__c,
                                                                            loan__Interest_Posting_Txn__c,
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
                                                                            loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c,
                                                                            loan__Loan_Payment_Txn__r.loan__Excess__c,
                                                                            loan__Interest_Posting_Txn__r.loan__Interest_Posting_Type__c,
                                                                            loan__Interest_Posting_Txn__r.loan__Balance__c,
                                                                            loan__Consolidated_Loan_Balance__c,
                                                                            Debit__c,
                                                                            Credit__c,
                                                                            loan__Loan_Account__r.id
                                                                    FROM loan__Loan_Transaction_Summary__c 
                                                                    WHERE Include_in_Summary__c = true 
                                                                    AND loan__Loan_Account__c in: loanIdList
                                                                    AND loan__Transaction_Date__c>=: dateList 
                                                                    AND loan__Transaction_Date__c<=:endDate
                                                                    AND loan__Consolidated_Loan_Balance__c != NULL 
                                                                    AND  (Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,:ConstantValues.REFUND,
                                                                    :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT)
                                                                    OR loan__Loan_Charge__c != null)
                                                                    AND (loan__Loan_Payment_Txn__c = null 
                                                                    OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN
                                                                        (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                    AND (loan__Loan_Payment_Txn__r.loan__Cheque_Number__c =: ConstantValues.LOAN_PAYOFF
                                                                    OR loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c = 0 OR Paid_Off_Check__c = true)
                                                                    AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false and loan__Loan_Payment_Txn__r.loan__Reversed__c = false ))
                                                                    AND (loan__Other_Loan_Txn__c = null
                                                                    OR (loan__Other_Loan_Txn__r.loan__Reversed__c = false 
                                                                    AND (Paid_Off_Check__c=true OR Transaction_Type__c=:ConstantValues.REFUND)))
                                                                    AND (loan__Loan_Disbursal__c = null 
                                                                    OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                    AND loan__Loan_Disbursal__r.loan__Rejected__c= false 
                                                                    AND loan__Loan_Disbursal__r.loan__Cleared__c = true AND Paid_Off_Check__c=true))
                                                                    AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false AND Paid_Off_Check__c=true))
                                                                    AND (loan__Interest_Posting_Txn__c = null 
                                                                    OR (loan__Interest_Posting_Txn__r.loan__Reversed__c = false AND Paid_Off_Check__c=true))
                                                                    ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC, Name ASC];
                if(payoffList.isEmpty() == false){
                    objLTSList.addAll(payoffList);
                }
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
                                        loan__Loan_Payment_Transaction__c,
                                        loan__Loan_Account__c,
                                        loan__Loan_Account__r.id
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
                            && objLTS.Transaction_Type__c!=ConstantValues.REDRAW ){
                        if(objLTS.loan__Loan_Payment_Txn__c != NULL && objLTS.loan__Loan_Payment_Txn__r.loan__Deposit__c != NULL 
                                && depositMap.containskey(objLTS.loan__Loan_Payment_Txn__c) && objLTS.loan__Current_Loan_Balance__c!=NULL && depositMap.get(objLTS.loan__Loan_Payment_Txn__c) != NULL){
                            objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c-depositMap.get(objLTS.loan__Loan_Payment_Txn__c);
                        }else{
                            for(j=0;j<(objDepositList.size()-1);j++){
                                
                                if(objDepositList[j].loan__Loan_Account__r.id==objLTS.loan__Loan_Account__r.id && objDepositList[j].clcommon__Deposit_Amount__c!=NULL && objDepositList[j].clcommon__Transaction_Date__c<=objLTS.loan__Transaction_Date__c 
                                && objDepositList[j+1].clcommon__Transaction_Date__c>objLTS.loan__Transaction_Date__c ){
                                    objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c-objDepositList[j].clcommon__Deposit_Amount__c;
                                }
                                if(objDepositList[j].loan__Loan_Account__r.id==objLTS.loan__Loan_Account__r.id && j==objDepositList.size()-2 && objDepositList[j].clcommon__Transaction_Date__c <= objLTS.loan__Transaction_Date__c ){
                                    objLTS.loan__Consolidated_Loan_Balance__c=objLTS.loan__Current_Loan_Balance__c-objDepositList[j].clcommon__Deposit_Amount__c;
                                }
                            }
                        }
                        
                    }
                }
                
                if(objLTSList.size()>0){
                    Database.update(objLTSList,false);
                }
            }
            if(paidOffLoanId.size()>0 && paidOffDate.size()>0){
                LTSCalculateConsolidatedLoanBalance.calculateConsolidatedLoanBalance(paidOffLoanId,paidOffDate,paidOffDateList);
            }
        }catch(Exception exe){
            GenericUtility.insertLog('LTSConsolidatedLoanBalanceUpdate', exe);
        }
    }
}