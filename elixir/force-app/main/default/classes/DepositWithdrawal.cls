/*Developer Name - Rameswari Barman
Class Name - DepositWithdrawal
Description - Helps in creation of withdrawal from deposit
*/
global with sharing class DepositWithdrawal {
    webservice static void withdrawAmt(Id loanId){
    String msg;
        try{
            clcommon__Deposit__c dep = [select id,clcommon__Parent_Deposit__c,loan__Loan_Account__c from clcommon__Deposit__c where clcommon__Parent_Deposit__c = NULL and loan__Loan_Account__c =: loanId];
            List<loan.LoanAccountParameters.Deposit> depositParametersList1 = new List<loan.LoanAccountParameters.Deposit>();
            loan.LoanAccountParameters.Deposit deposit2 = new loan.LoanAccountParameters.Deposit(dep.Id, false, true, false);
            deposit2.setDepositAdjustmentAmount(-3000);  
            depositParametersList1.add(deposit2);
            loan.LoanAccountParameters loanAccountParams = new loan.LoanAccountParameters(loanId);   
            loanAccountParams.setDepositList(depositParametersList1);
            List<loan.LoanAccountParameters> loanAccountParamList = new List<loan.LoanAccountParameters>();
            loanAccountParamList.add(loanAccountParams);
            loan.LoanActionFactory lAFactory = new loan.LoanActionFactory();
            loan.AbstractLoanActions loanActions = lAFactory.getLoanActionsAPI();
            loanActions.changeDepositAction(loanAccountParamList, null);
            msg = System.label.Deposit_Withdrawal_Message;
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'DepositWithdrawal :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = System.Now(),clcommon__Log_Level__c = 'ERROR');
            throw e;
        }
    }
}