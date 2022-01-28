/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Loan Transaction summary Consolidated Loan Balance fields .
Development Date : 21/01/2022
Last Modified Date : 24/01/2022
****************************************************************************************************/

public class LTSCalculateConsolidatedLoanBalance {
    
    public static void calculateConsolidatedLoanBalance(List<Id> loanIdList,List<Date> startDate,Map<Id,Date> startDateMap){
        try{
            Map<Id,Id> loanStatementCheckMap=new Map<Id,Id>();
            Map<Id,Decimal> openStatement=new Map<Id,Decimal>();

            List <loan__Loan_Transaction_Summary__c> transactionSummaryList = [SELECT Id,
                                                                                    Name,
                                                                                    loan__Transaction_Date__c,
                                                                                    Transaction_Type__c,
                                                                                    Debit__c,
                                                                                    Credit__c,
                                                                                    loan__Balance__c,
                                                                                    loan__Loan_Account__c,
                                                                                    loan__Current_Loan_Balance__c,
                                                                                    loan__Loan_Account__r.id,
                                                                                    loan__Consolidated_Loan_Balance__c
                                                                                FROM loan__Loan_Transaction_Summary__c
                                                                                WHERE loan__Transaction_Date__c >=: startDate
                                                                                AND loan__Loan_Account__c in: loanIdList
                                                                                AND Include_in_Summary__c = true
                                                                                AND loan__Consolidated_Loan_Balance__c != NULL
                                                                                AND loan__Last_Transaction_Type__c NOT IN (:ConstantValues.OTHER_TRANSACTION)
                                                                                AND (Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,
                                                                                    :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT) 
                                                                                OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null)
                                                                                AND (loan__Loan_Payment_Txn__c = null
                                                                                OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN 
                                                                                    (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                                AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false
                                                                                AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false
                                                                                AND loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c > 0))
                                                                                AND (loan__Interest_Posting_Txn__c = null OR loan__Interest_Posting_Txn__r.loan__Reversed__c = false) 
                                                                                AND (loan__Other_Loan_Txn__c = null OR loan__Other_Loan_Txn__r.loan__Reversed__c = false) 
                                                                                AND (loan__Loan_Disbursal__c = null OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                                AND loan__Loan_Disbursal__r.loan__Rejected__c= false AND loan__Loan_Disbursal__r.loan__Cleared__c = true)) 
                                                                                AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false)) 
                                                                                ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC, Name ASC];
            List <loan__Loan_Transaction_Summary__c> payoffList = [SELECT Id,
                                                                        Name,
                                                                        loan__Transaction_Date__c,
                                                                        Transaction_Type__c,
                                                                        Debit__c,
                                                                        Credit__c,
                                                                        loan__Balance__c,
                                                                        loan__Loan_Account__c,
                                                                        loan__Current_Loan_Balance__c,
                                                                        loan__Loan_Account__r.id,
                                                                        loan__Consolidated_Loan_Balance__c
                                                                    FROM loan__Loan_Transaction_Summary__c
                                                                    WHERE loan__Transaction_Date__c >=: startDate
                                                                    AND loan__Loan_Account__c in: loanIdList
                                                                    AND Include_in_Summary__c=true
                                                                    AND loan__Consolidated_Loan_Balance__c != NULL 
                                                                    AND Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,:ConstantValues.REFUND)
                                                                    AND (loan__Loan_Payment_Txn__c = null 
                                                                    OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN
                                                                        (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                    AND (loan__Loan_Payment_Txn__r.loan__Cheque_Number__c =: ConstantValues.LOAN_PAYOFF
                                                                    OR loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c = 0)
                                                                    AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false and loan__Loan_Payment_Txn__r.loan__Reversed__c = false ))
                                                                    AND (loan__Other_Loan_Txn__c = null
                                                                    OR loan__Other_Loan_Txn__r.loan__Reversed__c = false)
                                                                    ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC, Name ASC];
            if(payoffList.isEmpty() == false){
                transactionSummaryList.addAll(payoffList);
            }
            List <loan__Loan_Transaction_Summary__c> openingBalanceList = [SELECT Id,
                                                                                loan__Transaction_Date__c,
                                                                                Transaction_Type__c,
                                                                                Debit__c,
                                                                                Credit__c,
                                                                                loan__Balance__c,
                                                                                loan__Loan_Account__c,
                                                                                loan__Loan_Account__r.id,
                                                                                loan__Current_Loan_Balance__c,
                                                                                loan__Consolidated_Loan_Balance__c
                                                                            FROM loan__Loan_Transaction_Summary__c
                                                                            WHERE loan__Loan_Account__c in: loanIdList
                                                                            AND loan__Transaction_Date__c <: startDate
                                                                            AND Include_in_Summary__c = true
                                                                            AND loan__Consolidated_Loan_Balance__c != NULL
                                                                            AND loan__Last_Transaction_Type__c NOT IN (:ConstantValues.OTHER_TRANSACTION)
                                                                            AND (Transaction_Type__c IN (:ConstantValues.PAYMENT_RECEIVED,
                                                                                :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT) 
                                                                            OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null)
                                                                            AND (loan__Loan_Payment_Txn__c = null
                                                                            OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN 
                                                                                (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                                                            AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false
                                                                            AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false))
                                                                            AND (loan__Interest_Posting_Txn__c = null OR loan__Interest_Posting_Txn__r.loan__Reversed__c = false) 
                                                                            AND (loan__Other_Loan_Txn__c = null OR loan__Other_Loan_Txn__r.loan__Reversed__c = false) 
                                                                            AND (loan__Loan_Disbursal__c = null OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                            AND loan__Loan_Disbursal__r.loan__Rejected__c= false AND loan__Loan_Disbursal__r.loan__Cleared__c = true)) 
                                                                            AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false)) 
                                                                            ORDER BY loan__Transaction_Date__c DESC, CreatedDate DESC, loan__Transaction_Time__c DESC, Name DESC ];   
            system.debug(startDate);
            for(Id loanId:loanIdList){
                for(loan__Loan_Transaction_Summary__c openingBalance:openingBalanceList){
                    if(loanId==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL 
                    && startDateMap.get(openingBalance.loan__Loan_Account__r.id)!=NULL&& openingBalance.loan__Transaction_Date__c < startDateMap.get(openingBalance.loan__Loan_Account__r.id)){
                        openStatement.put(loanId,openingBalance.loan__Consolidated_Loan_Balance__c);
                        break;
                    }
                }
            }
            system.debug(openStatement);
            for(loan__Loan_Transaction_Summary__c transactionBalance:transactionSummaryList){
                loanStatementCheckMap.put(transactionBalance.id,transactionBalance.loan__Loan_Account__r.id);
            }
            for(loan__Loan_Transaction_Summary__c openingBalance:transactionSummaryList){
                if(loanStatementCheckMap.containsKey(openingBalance.id) && loanStatementCheckMap.get(openingBalance.id)!=NULL 
                    && loanStatementCheckMap.get(openingBalance.id)==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL 
                    && startDateMap.get(openingBalance.loan__Loan_Account__r.id)!=NULL&& openingBalance.loan__Transaction_Date__c>=startDateMap.get(openingBalance.loan__Loan_Account__r.id)
                    && openStatement.containsKey(openingBalance.loan__Loan_Account__r.id) && openStatement.get(openingBalance.loan__Loan_Account__r.id)!=NULL){
                    
                    if(openingBalance.Debit__c!=NULL){
                        openingBalance.loan__Consolidated_Loan_Balance__c=openStatement.get(openingBalance.loan__Loan_Account__r.id) + openingBalance.Debit__c;
                    }else if(openingBalance.Credit__c!=NULL){
                        openingBalance.loan__Consolidated_Loan_Balance__c=openStatement.get(openingBalance.loan__Loan_Account__r.id) - openingBalance.Credit__c;
                    }
                    openStatement.put(openingBalance.loan__Loan_Account__r.id,openingBalance.loan__Consolidated_Loan_Balance__c);
                }
            }
            
            if(transactionSummaryList.size()>0){
                Database.update(transactionSummaryList,false);
            }
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'LTSChargeUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
}