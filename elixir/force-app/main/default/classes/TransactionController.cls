public class TransactionController {
 
    public List<loan__Transaction_Summary__c> txnList {get; set;}
    public String loanId=ApexPages.currentPage().getParameters().get('id');
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    public TransactionController() {
    }
  
    public PageReference doSearch() {
         List<loan__Transaction_Summary__c> txnList2 = [SELECT Id FROM loan__Transaction_Summary__c
                                                                 WHERE loan__Loan_Account__c =: loanId];
         if(txnList2 !=null && txnList2.size()>0){
             delete txnList2;
         }
         loan.LoanActionFactory factory = new  loan.LoanActionFactory();
         loan.LoanAction5 loanAction = factory.getLoanAction5API();
         List<loan__Transaction_Summary__c> transList = loanAction.getTransactionSummary(loanId, StartDate, EndDate);
         System.debug('transList = ' + transList);
         insert transList;
         txnList =  [SELECT Id,
                        Name,
                        loan__Loan_Account__c, 
                        loan__Loan_Account__r.Name,
                        loan__Additional_Interest_Amt__c, 
                        loan__Archived__c, 
                        loan__Balance__c, 
                        loan__Billing_Method__c, 
                        loan__Cleared__c, 
                        loan__Due_Date__c, 
                        loan__Excess__c, 
                        loan__Fee_Name__c, 
                        loan__Fees__c, 
                        loan__Frequency_of_Loan_Payment__c, 
                        loan__Interest_Only_Period__c, 
                        loan__Interest_Rate__c, 
                        loan__Interest__c, 
                        loan__Loan_Snapshot__c, 
                        loan__Master_Archive_Object__c, 
                        loan__Number_of_Installments__c, 
                        loan__OT_ACH_Account_Number__c, 
                        loan__OT_ACH_Account_Type__c, 
                        loan__OT_ACH_Bank_Name__c, 
                        loan__OT_ACH_Debit_Date__c, 
                        loan__OT_ACH_Drawer_Address1__c, 
                        loan__OT_ACH_Drawer_Address2__c, 
                        loan__OT_ACH_Drawer_City__c, 
                        loan__OT_ACH_Drawer_Name__c, 
                        loan__OT_ACH_Drawer_State__c, 
                        loan__OT_ACH_Drawer_Zip__c, 
                        loan__OT_ACH_Fee_Amount__c, 
                        loan__OT_ACH_Payment_Amount__c, 
                        loan__OT_ACH_Routing_Number__c, 
                        loan__OT_ACH_Relationship_Type__c, 
                        loan__Passed_Term__c, 
                        loan__Pay_Off_Date__c, 
                        loan__Principal_Remaining__c, 
                        loan__Principal__c, 
                        loan__Rejected__c, 
                        loan__Repayment_Extension_Days__c, 
                        loan__Repayment_Start_Date__c, 
                        loan__Reversed__c, 
                        loan__Same_monthly_payment__c, 
                        loan__Summary_Record_Id__c, 
                        loan__Summary__c, 
                        loan__Total_Fees_Due__c, 
                        loan__Total_Interest_Due__c, 
                        loan__Transaction_Id__c, 
                        loan__Transaction_Time__c, 
                        loan__Transaction_Type__c, 
                        loan__Txn_Amt__c, 
                        loan__Txn_Date__c, 
                        loan__Type__c
                 FROM loan__Transaction_Summary__c
                 Where loan__Loan_Account__c =: loanId];
                  System.debug('transList = ' + txnList);
                  return null;
                    // AND loan__Txn_Date__c >=:StartDate
                   //  AND loan__Txn_Date__c <=:EndDate];
       
    }
    public PageReference exportToPDF(){
        PageReference retURLPDF = new PageReference('/apex/TrasnactionPDF?'+loanId);
        return retURLPDF;
    }
}