/***************************
Developer : Rameswari Barman
Development Date : 21/05/2019
Last Modified By : Rameswari Barman
Last Modified Date : 21/05/2021
Description : Used to display the list of transactions when Statement button in CL Contract is clicked
*****************************/
public class GenerateStatementController {
    public List<loan__Loan_Transaction_Summary__c> txnList {get; set;}
    public List<loan__Loan_Transaction_Summary__c> payoffList {get; set;}
    public Boolean showRecords{get;set;}
    public String loanId=ApexPages.currentPage().getParameters().get('id');
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    public loan__Loan_Account__c loanRecord{get;set;}
    public GenerateStatementController () {
        showRecords = true;
        if(loanId == null){
            throw new CustomException('Invalid Loan');
        }
        loanRecord = [SELECT id,
                                name 
                            FROM loan__Loan_Account__c 
                            WHERE id = :loanId];
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
                System.debug('I am here 11');
            }
            else{
                loan.Statement_End_Date__c = currentSystemDate;
                System.debug('I am here 12');
            }
            if(EndDate > currentSystemDate){
                ApexPages.addmessage(
                  new ApexPages.message(ApexPages.severity.error, 'End date cant be in future')
                );
                return null;
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
                            AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false
                            AND (loan__Loan_Payment_Txn__r.loan__Cheque_Number__c != 'Loan Payoff'  
                            OR loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c > 0)))
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
            payoffList = [SELECT Id,
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
                                    AND Transaction_Type__c = 'Payment Received' 
                                    AND loan__Loan_Payment_Txn__c != null 
                                    AND loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name not in ('Discount','Internal Transfer') 
                                    AND loan__Loan_Payment_Txn__r.loan__Cheque_Number__c = 'Loan Payoff'  
                                    AND loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c = 0 
                                    AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false and loan__Loan_Payment_Txn__r.loan__Reversed__c = false 
                                    ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC];
            if(payoffList.isEmpty() == false){
                txnList.addAll(payoffList);
            }
            showRecords = true;
        }
        catch(Exception e){
            GenericUtility.insertLog('GenerateStatementController.doSearch', e);
            return null;
        }
        return null;
    }
    public PageReference exportToPDF(){
        Integer k = 0;
        loan__Loan_Account__c loan = [SELECT Id, 
                                            Name, 
                                            loan__Disbursal_Date__c, 
                                            CreatedDate, 
                                            loan__Branch__c, 
                                            loan__Account__c,
                                            Statement_Opening_Balance__c
                                        FROM loan__Loan_Account__c 
                                        WHERE Id =: loanId LIMIT 1];
        List <loan__Other_Transaction__c> otherLoanTxns = [SELECT Id,
                                                                loan__Description__c,
                                                                loan__Txn_Date__c,
                                                                loan__Interest_Rate__c,
                                                                loan__New_Interest_Rate__c,
                                                                Final_Interest_Rate__c,
                                                                loan__Transaction_Type__c,
                                                                Rate_Changed__c,
                                                                Latest_Rate_Change__c
                                                                FROM loan__Other_Transaction__c
                                                                WHERE loan__Loan_Account__c =: loanId
                                                                AND loan__Reversed__c = false 
                                                                AND loan__Rejected__c = false
                                                                AND (loan__Description__c != NULL OR loan__Transaction_Type__c = 'Rate Change')
                                                                AND (loan__Interest_Rate__c != NULL OR loan__New_Interest_Rate__c != NULL)
                                                                ORDER BY loan__Transaction_Time__c DESC, loan__Txn_Date__c DESC, CreatedDate DESC 
                                                            ];
        System.debug('0');
        for(loan__Other_Transaction__c eachTxn : otherLoanTxns){
            eachTxn.Latest_Rate_Change__c = false;
            eachTxn.Final_Interest_Rate__c = false;
            eachTxn.Rate_Changed__c = false;
            Integer numberDaysDue = (eachTxn.loan__Txn_Date__c).daysBetween(currentSystemDate);
            if(eachTxn.loan__Description__c != NULL && (eachTxn.loan__Description__c).containsIgnoreCase(ConstantValues.INT_RATE)){
                System.debug('1'+eachTxn);
                Integer intRateIndex = ((eachTxn.loan__Description__c).indexOf(ConstantValues.INT_RATE)+7);
                Decimal oldRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(intRateIndex,intRateIndex+6));
                Integer lastIntRateIndex = ((eachTxn.loan__Description__c).lastIndexOf(ConstantValues.INT_RATE)+7);
                Decimal newRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(lastIntRateIndex,lastIntRateIndex+4));
                if(numberDaysDue <= 365 && oldRate != newRate){
                    eachTxn.Rate_Changed__c = true;
                    System.debug('3');
                    if(k == 0){
                        eachTxn.Latest_Rate_Change__c = true;
                        k++;
                        System.debug('4');
                    }
                    System.debug('5');
                }
                else if(numberDaysDue > 365 && oldRate != null && newRate != NULL && oldRate != newRate){
                    if(k == 0){
                        eachTxn.Latest_Rate_Change__c = true;
                        k++;
                        System.debug('4');
                    }
                    System.debug('6');
                    eachTxn.Final_Interest_Rate__c = true;
                    break;
                }
                System.debug('7');
            }
            else if(numberDaysDue <= 365){
                if(k == 0){
                    eachTxn.Latest_Rate_Change__c = true;
                    k++;
                    System.debug('4');
                }
                System.debug('8');
                eachTxn.Rate_Changed__c = true;
                System.debug('10');
            }
            else if(numberDaysDue > 365){
                if(k == 0){
                    eachTxn.Latest_Rate_Change__c = true;
                    k++;
                    System.debug('4');
                }
                System.debug('11');
                eachTxn.Final_Interest_Rate__c = true;
                break;
                System.debug('12');
            }
        }
        if(otherLoanTxns.isEmpty() == false){
            update otherLoanTxns;
        }
        if(StartDate != null){
            loan.Statement_Start_Date__c = StartDate;
        }
        else{
            DateTime loanCreationDate = loan.CreatedDate;
            loan.Statement_Start_Date__c = loan.loan__Disbursal_Date__c;
        }
        Date statementStartDate = loan.Statement_Start_Date__c;
        if(EndDate != null){
            loan.Statement_End_Date__c = EndDate;
        }
        else{
            loan.Statement_End_Date__c = currentSystemDate;
        }
        if(EndDate > currentSystemDate){
            ApexPages.addmessage(
              new ApexPages.message(ApexPages.severity.error, 'End date cant be in future')
            );
            return null;
        }
        if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c <= loan.loan__Disbursal_Date__c){
            loan.Statement_Opening_Balance__c = 0;
        }
        else if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c > loan.loan__Disbursal_Date__c){
            loan.Statement_Opening_Balance__c = 0;
            List <loan__Loan_Transaction_Summary__c> openingBalanceList = [SELECT Id,
                                                                                loan__Transaction_Date__c,
                                                                                Transaction_Type__c,
                                                                                Debit__c,
                                                                                Credit__c,
                                                                                loan__Balance__c,
                                                                                loan__Loan_Account__c,
                                                                                loan__Current_Loan_Balance__c,
                                                                                loan__Consolidated_Loan_Balance__c
                                                                            FROM loan__Loan_Transaction_Summary__c 
                                                                            WHERE loan__Transaction_Date__c <: statementStartDate
                                                                            AND loan__Loan_Account__c =: loanId
                                                                            AND loan__Consolidated_Loan_Balance__c != NULL 
                                                                            AND loan__Last_Transaction_Type__c != 'loan__Other_Transaction__c' 
                                                                            AND (Transaction_Type__c in ('Payment Received','Interest','Redraw','Disbursement') 
                                                                            OR loan__Invalid_Data__c = false or loan__Loan_Charge__c != null) 
                                                                            AND (loan__Loan_Payment_Txn__c = null 
                                                                            OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name not in ('Discount','Internal Transfer') 
                                                                            AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false 
                                                                            AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false)) 
                                                                            AND (loan__Interest_Posting_Txn__c = null or loan__Interest_Posting_Txn__r.loan__Reversed__c = false) 
                                                                            AND (loan__Other_Loan_Txn__c = null or loan__Other_Loan_Txn__r.loan__Reversed__c = false) 
                                                                            AND (loan__Loan_Disbursal__c = null or (loan__Loan_Disbursal__r.loan__Reversed__c= false 
                                                                            AND loan__Loan_Disbursal__r.loan__Rejected__c= false and loan__Loan_Disbursal__r.loan__Cleared__c = true)) 
                                                                            AND (loan__Loan_Charge__c= null or (loan__Loan_Charge__r.loan__Waive__c= false)) 
                                                                            ORDER BY loan__Transaction_Date__c DESC, loan__Transaction_Time__c DESC LIMIT 1];
            if(openingBalanceList.size() > 0 && openingBalanceList[0].loan__Consolidated_Loan_Balance__c != NULL){
                loan.Statement_Opening_Balance__c = openingBalanceList[0].loan__Consolidated_Loan_Balance__c;
            }
        }
        update loan;
        WebLink statementLink = [SELECT Id, Name, Url FROM WebLink WHERE Name = 'Generate_Statement_Document' limit 1];
        String statementURL = statementLink.Url;
        if(loan.loan__Account__c != null){
            statementURL = statementURL.replace('{!loan__Loan_Account__c.loan__AccountId__c}',loan.loan__Account__c);
        }
        if(loanId != null){
            statementURL = statementURL.replace('{!loan__Loan_Account__c.Id}',loanId);
        }
        if(loan.loan__Branch__c != null){
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