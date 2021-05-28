/***************************
Developer : Rameswari Barman
Development Date : 21/05/2019
Last Modified By : Rameswari Barman
Last Modified Date : 21/05/2021
Description : Used to display the list of transactions when Statement button in CL Contract is clicked
*****************************/
public class GenerateStatementController {
    public List<loan__Loan_Transaction_Summary__c> txnList {get; set;}
    public Boolean showRecords{get;set;}
    public String loanId=ApexPages.currentPage().getParameters().get('id');
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    public GenerateStatementController () {
        showRecords = true;
        if(loanId == null){
            throw new CustomException('Invalid Loan');
        }
    }
    public PageReference doSearch() {
        try{
            loan__Loan_Account__c loan = [SELECT Id,
                                                Name, 
                                                loan__Branch__c,
                                                loan__Account__c,
                                                loan__Disbursal_Date__c 
                                                FROM loan__Loan_Account__c 
                                                WHERE Id =: loanId LIMIT 1];
            if(StartDate != null){
                loan.Statement_Start_Date__c = StartDate;
            }
            else{
                loan.Statement_Start_Date__c = loan.loan__Disbursal_Date__c;
            }
            if(EndDate != null){
                loan.Statement_End_Date__c = EndDate;
            }
            else{
                loan.Statement_End_Date__c = currentSystemDate;
            }
            update loan;
             txnList =  [SELECT Id,
                            Name,
                            loan__Transaction_Date__c,
                            Transaction_Type__c,
                            Debit__c,
                            Credit__c,
                            loan__Balance__c,
                            loan__Loan_Account__c,
                            loan__Current_Loan_Balance__c,
                            loan__Consolidated_Loan_Balance__c,
                            Include_in_Summary__c,
                            loan__Invalid_Data__c,
                            loan__Loan_Payment_Txn__r.loan__Payment_Mode__c,
                            loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name,
                            loan__Loan_Payment_Txn__c,
                            loan__Loan_Payment_Txn__r.loan__Rejected__c,
                            loan__Loan_Payment_Txn__r.loan__Reversed__c
                            FROM loan__Loan_Transaction_Summary__c 
                            WHERE Include_in_Summary__c = true 
                            AND loan__Loan_Account__c =: loanId
                            AND loan__Consolidated_Loan_Balance__c != NULL 
                            AND loan__Last_Transaction_Type__c != 'loan__Other_Transaction__c' 
                            AND (Transaction_Type__c in ('Payment Received','Interest','Redraw','Disbursement') 
                            OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null) and (loan__Loan_Payment_Txn__c = null 
                            OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name not in ('Discount','Internal Transfer') 
                            AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false 
                            AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false))
                            AND (loan__Interest_Posting_Txn__c = null 
                            OR loan__Interest_Posting_Txn__r.loan__Reversed__c = false) 
                            AND (loan__Other_Loan_Txn__c = null 
                            OR loan__Other_Loan_Txn__r.loan__Reversed__c = false) 
                            AND (loan__Loan_Disbursal__c = null 
                            OR (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                            AND loan__Loan_Disbursal__r.loan__Rejected__c= false 
                            AND loan__Loan_Disbursal__r.loan__Cleared__c = true))
                            AND (loan__Loan_Charge__c= null OR (loan__Loan_Charge__r.loan__Waive__c= false))
                            ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC
                            ];
            showRecords = true;
        }
        catch(Exception e){
            GenericUtility.insertLog('GenerateStatementController.doSearch', e);
            return null;
        }
        return null;
    }
    public PageReference exportToPDF(){
        loan__Loan_Account__c loan = [SELECT Id, Name, loan__Disbursal_Date__c, CreatedDate, loan__Branch__c, loan__Account__c FROM loan__Loan_Account__c WHERE Id =: loanId LIMIT 1];
        if(StartDate != null){
            loan.Statement_Start_Date__c = StartDate;
        }
        else{
            DateTime loanCreationDate = loan.CreatedDate;
            loan.Statement_Start_Date__c = loan.loan__Disbursal_Date__c;
        }
        if(EndDate != null){
            loan.Statement_End_Date__c = EndDate;
        }
        else{
            loan.Statement_End_Date__c = currentSystemDate;
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
    //This method is called when Back button is clicked in VF page - helps in redirecting to CL Contract page
      public pagereference back() {
        Pagereference pg = new Pagereference('/' + loanId);
        pg.setRedirect(true);
        return pg;
      }
}