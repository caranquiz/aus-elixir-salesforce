/***************************
Developer : Priya Agarwal
Development Date : 12/11/2019
Last Modifieds By : Rameswari Barman
Last Modifieds Date : 21/05/2021
Description : Used to display the list of transactions when Statement button in CL Contract is clicked
*****************************/
public class TransactionController {
    public List<loan__Loan_Transaction_Summary__c> txnList {get; set;}
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
            loan__Loan_Account__c loan = [SELECT Id, Name, loan__Branch__c, loan__Account__c FROM loan__Loan_Account__c WHERE Id =: loanId LIMIT 1];
            if(StartDate != null){
                loan.Statement_Start_Date__c = StartDate;
            }
            if(EndDate != null){
                loan.Statement_End_Date__c = EndDate;
            }
            update loan;
            List <loan__Loan_Transaction_Summary__c> txnList =  [SELECT Id,
                                                                    Name,
                                                                    loan__Transaction_Date__c,
                                                                    Transaction_Type__c,
                                                                    Debit__c,
                                                                    Credit__c,
                                                                    loan__Balance__c,
                                                                    loan__Loan_Account__c,
                                                                    loan__Current_Loan_Balance__c,
                                                                    loan__Consolidated_Loan_Balance__c 
                                                                FROM loan__Loan_Transaction_Summary__c 
                                                                WHERE Include_in_Summary__c = true 
                                                                    AND loan__Loan_Account__c =: loanId
                                                                    AND loan__Consolidated_Loan_Balance__c != NULL 
                                                                    AND (Transaction_Type__c = 'Bill' 
                                                                    OR loan__Invalid_Data__c = false) 
                                                                    AND (loan__Loan_Payment_Txn__c = null 
                                                                    OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name not in ('Discount','Internal Transfer') 
                                                                    AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false 
                                                                    AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false)) 
                                                                ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC
                                                                ];
        }
        catch(Exception e){
            GenericUtility.insertLog('TransactionController.doSearch', e);
            return null;
        }
        return null;
    }
    public PageReference exportToPDF(){
        loan__Loan_Account__c loan = [SELECT Id, Name, loan__Branch__c, loan__Account__c FROM loan__Loan_Account__c WHERE Id =: loanId LIMIT 1];
        if(StartDate != null){
            loan.Statement_Start_Date__c = StartDate;
        }
        if(EndDate != null){
            loan.Statement_End_Date__c = EndDate;
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