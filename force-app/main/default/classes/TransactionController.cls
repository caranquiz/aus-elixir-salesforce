/***************************
Developer : Priya Agarwal
Development Date : 12/11/2019
Description : Used to display the list of transactions when Statement button in CL Contract is clicked
*****************************/
public class TransactionController {
    public List<loan__Transaction_Summary__c> txnList {get; set;}
    public String loanId=ApexPages.currentPage().getParameters().get('id');
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    public TransactionController() {
        if(loanId == null){
            throw new CustomException('Invalid Loan');
        }
    }
    public PageReference doSearch() {
         try{
             List<loan__Transaction_Summary__c> txnList2 = [SELECT Id FROM loan__Transaction_Summary__c
                                                                     WHERE loan__Loan_Account__c =: loanId];
             if(txnList2 !=null && txnList2.size()>0){
                 delete txnList2;
             }
             loan.LoanActionFactory factory = new  loan.LoanActionFactory();
             loan.LoanAction5 loanAction = factory.getLoanAction5API();
             List<loan__Transaction_Summary__c> transList = loanAction.getTransactionSummary(loanId, StartDate, EndDate);
             if(transList != NULL && transList.size() > 0){
                 insert transList;
             }
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
                 }
                 catch(Exception e){
                    insert new clcommon__Log__c(
                        clcommon__Message__c = 'TransactionController :Exception: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                        clcommon__Time__c = System.Now());
            return null;
        }
            return null;
    }
    public PageReference exportToPDF(){
        //PageReference retURLPDF = new PageReference('/apex/TrasnactionPDF?'+loanId);
        loan__Loan_Account__c loan = [SELECT Id, Name, loan__Branch__c, loan__Account__c FROM loan__Loan_Account__c WHERE Id =: loanId LIMIT 1];
        if(StartDate != null){
            loan.Statement_Start_Date__c = StartDate;
        }
        else {
            loan.Statement_Start_Date__c = null;
        }
        if(EndDate != null){
            loan.Statement_End_Date__c = EndDate;
        }
        else {
            loan.Statement_End_Date__c = null;
        }
        update loan;
        WebLink statementLink = [SELECT Id, Name, Url FROM WebLink WHERE Name = 'Generate_Statement_Document' limit 1];
        String statementURL = statementLink.Url;
        if(loan.loan__Branch__c != null){
            statementURL = statementURL.replace('{!loan__Loan_Account__c.loan__AccountId__c}',loan.loan__Account__c);
        }
        if(loanId != null){
            statementURL = statementURL.replace('{!loan__Loan_Account__c.Id}',loanId);
        }
        if(loan.loan__Account__c != null){
            statementURL = statementURL.replace('{!loan__Loan_Account__c.loan__BranchId__c}',loan.loan__Branch__c);
        }
        if(loan.loan__Account__c != null){
            statementURL = statementURL.replace('{!loan__Loan_Account__c.Name}',loan.Name);
        }
        PageReference retURLPDF = new PageReference(statementURL);
        return retURLPDF;
    }
}