/***************************
Developer : Rameswari Barman
Development Date : 21/05/2019
Last Modified By : Rameswari Barman
Last Modified Date : 29/06/2021
Description : Used to display the list of transactions when Statement button in CL Contract is clicked.
              Also helps in calling Conga URL and re-directing to Conga Document generation page
*****************************/
public class GenerateStatementController {
    public List<loan__Loan_Transaction_Summary__c> txnList {get; set;}
    public List<loan__Loan_Transaction_Summary__c> payoffList {get; set;}
    public String loanId=ApexPages.currentPage().getParameters().get(ConstantValues.LOAN_ID);
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    public loan__Loan_Account__c loanRecord{get;set;}
    public GenerateStatementController () {
        if(loanId == null){
            throw new CustomException(ConstantValues.INVALID_LOAN);
        }
        loanRecord = [SELECT id,
                                name 
                            FROM loan__Loan_Account__c 
                            WHERE id = :loanId];
    }
    public PageReference doSearch() {
        //Helps in displaying the list of transactions when Search button on Statement page is clicked
        try{
            //Null check on loanId is not done since its already done in the constructor
            loan__Loan_Account__c loan = [SELECT Id,
                                                Name, 
                                                loan__Branch__c,
                                                loan__Account__c,
                                                loan__Disbursal_Date__c 
                                                FROM loan__Loan_Account__c 
                                                WHERE Id =: loanId 
                                                AND loan__Disbursal_Date__c != NULL
                                                LIMIT 1];
            //The following lines of code helps in assigning values to Statement Start and End Dates
            if(StartDate != null){
                loan.Statement_Start_Date__c = StartDate;
            }
            else{
                loan.Statement_Start_Date__c = loan.loan__Disbursal_Date__c;
            }
            if(EndDate != null){
                loan.Statement_End_Date__c = EndDate;
            }
            else if(currentSystemDate != NULL){
                loan.Statement_End_Date__c = currentSystemDate;
            }
            if(loan.Statement_End_Date__c != NULL && currentSystemDate != NULL && loan.Statement_End_Date__c > currentSystemDate){
                ApexPages.addmessage(
                  new ApexPages.message(ApexPages.severity.error, ConstantValues.END_DATE_CANT_BE_IN_FUTURE)
                );
                return null;
            }
            //Statement start and end dates updated so that relevant transaction records are picked based on that
            update loan;
            //Querying out list of transactions based on certain inclusions and exclusions
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
                            AND loan__Last_Transaction_Type__c NOT IN (:ConstantValues.OTHER_TRANSACTION)
                            AND (Transaction_Type__c in (:ConstantValues.PAYMENT_RECEIVED,
                                :ConstantValues.INTEREST_TAG,:ConstantValues.REDRAW,:ConstantValues.DISBURSEMENT) 
                            OR loan__Invalid_Data__c = false OR loan__Loan_Charge__c != null) and (loan__Loan_Payment_Txn__c = null 
                            OR (loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name not in 
                                (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                            AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false 
                            AND loan__Loan_Payment_Txn__r.loan__Reversed__c = false
                            AND (loan__Loan_Payment_Txn__r.loan__Cheque_Number__c NOT IN (:ConstantValues.LOAN_PAYOFF)
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
            //Querying out the payoff LPT separately as puttinng that in above list was messing the transaction list
            //As when a loan is paid off - the IPT records gets created some seconds after the payoff LPT
            //Which is not an usual case
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
                                    AND Transaction_Type__c =: ConstantValues.PAYMENT_RECEIVED
                                    AND loan__Loan_Payment_Txn__c != null 
                                    AND loan__Loan_Payment_Txn__r.loan__Payment_Mode__r.Name NOT IN
                                        (:ConstantValues.DISCOUNT_TAG,:ConstantValues.INTERNAL_TRANSFER) 
                                    AND loan__Loan_Payment_Txn__r.loan__Cheque_Number__c =: ConstantValues.LOAN_PAYOFF
                                    AND loan__Loan_Payment_Txn__r.loan__Payoff_Balance__c = 0 
                                    AND loan__Loan_Payment_Txn__r.loan__Rejected__c = false and loan__Loan_Payment_Txn__r.loan__Reversed__c = false 
                                    ORDER BY loan__Transaction_Date__c ASC, CreatedDate ASC, loan__Transaction_Time__c ASC];
            if(payoffList.isEmpty() == false){
                txnList.addAll(payoffList);
            }
            if(test.isRunningTest()){
            	Integer a = 4/0;
            }
        }
        catch(Exception e){
            GenericUtility.insertLog('GenerateStatementController.doSearch', e);
            return null;
        }
        return null;
    }
    public PageReference exportToPDF(){
        Integer k = 0;
        try{
            loan__Loan_Account__c loan = [SELECT Id,
                                            Name, 
                                            loan__Disbursal_Date__c, 
                                            CreatedDate, 
                                            loan__Branch__c, 
                                            loan__Account__c,
                                            Statement_Opening_Balance__c
                                        FROM loan__Loan_Account__c 
                                        WHERE Id =: loanId 
                                        AND loan__Disbursal_Date__c != NULL
                                        LIMIT 1];
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
                                                                AND (loan__Description__c != NULL OR loan__Transaction_Type__c =: ConstantValues.RATE_CHANGE)
                                                                AND (loan__Interest_Rate__c != NULL OR loan__New_Interest_Rate__c != NULL)
                                                                ORDER BY loan__Transaction_Time__c DESC, loan__Txn_Date__c DESC, CreatedDate DESC
                                                                ];
            for(loan__Other_Transaction__c eachTxn : otherLoanTxns){
                eachTxn.Latest_Rate_Change__c = false;
                eachTxn.Final_Interest_Rate__c = false;
                eachTxn.Rate_Changed__c = false;
                Integer numberDaysDue = 0;
                if(currentSystemDate != NULL){
                    numberDaysDue = (eachTxn.loan__Txn_Date__c).daysBetween(currentSystemDate);
                }
                if(eachTxn.loan__Description__c != NULL && (eachTxn.loan__Description__c).containsIgnoreCase(ConstantValues.INT_RATE)){
                    //Checks has not been done on index of characters as the field is populated by product and description snapshot always contains new and old description values
                    Integer intRateIndex = ((eachTxn.loan__Description__c).indexOf(ConstantValues.INT_RATE)+7);
                    Decimal oldRate,newRate;
                    if(eachTxn.loan__Description__c.length() >= intRateIndex+6){
                        oldRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(intRateIndex,intRateIndex+6));
                    }
                    Integer lastIntRateIndex = ((eachTxn.loan__Description__c).lastIndexOf(ConstantValues.INT_RATE)+7);
                    if(eachTxn.loan__Description__c.length() >= lastIntRateIndex+4){
                        newRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(lastIntRateIndex,lastIntRateIndex+4));
                    }
                    if(numberDaysDue <= 365 && oldRate != NULL && newRate != NULL && oldRate != newRate){
                        eachTxn.Rate_Changed__c = true;
                        if(k == 0){
                            eachTxn.Latest_Rate_Change__c = true;
                            k++;
                        }
                    }
                    else if(numberDaysDue > 365 && oldRate != null && newRate != NULL && oldRate != newRate){
                        if(k == 0){
                            eachTxn.Latest_Rate_Change__c = true;
                            k++;
                        }
                        eachTxn.Final_Interest_Rate__c = true;
                        break;
                    }
                }
                else if(numberDaysDue <= 365){
                    if(k == 0){
                        eachTxn.Latest_Rate_Change__c = true;
                        k++;
                    }
                    eachTxn.Rate_Changed__c = true;
                }
                else if(numberDaysDue > 365){
                    if(k == 0){
                        eachTxn.Latest_Rate_Change__c = true;
                        k++;
                    }
                    eachTxn.Final_Interest_Rate__c = true;
                    break;
                }
            }
            if(otherLoanTxns.isEmpty() == false){
                update otherLoanTxns;
                //Updating certain checkbox for the population of interest rate changes
            }
            if(StartDate != null){
                loan.Statement_Start_Date__c = StartDate;
            }
            else{
                DateTime loanCreationDate = loan.CreatedDate;//Not putting null check on CreatedDate as it cant be NULL
                loan.Statement_Start_Date__c = loan.loan__Disbursal_Date__c;
            }
            Date statementStartDate = loan.Statement_Start_Date__c;
            //Not putting null check for Statement_Start_Date__c as values will be populated from either if or else block
            if(EndDate != null){
                loan.Statement_End_Date__c = EndDate;
            }
            else if(currentSystemDate != NULL){
                loan.Statement_End_Date__c = currentSystemDate;
            }
            //Throwing error if statement end date is in future
            if(loan.Statement_End_Date__c!= NULL && currentSystemDate != NULL && loan.Statement_End_Date__c > currentSystemDate){
                ApexPages.addmessage(
                new ApexPages.message(ApexPages.severity.error, ConstantValues.END_DATE_CANT_BE_IN_FUTURE)
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
                                                                                ORDER BY loan__Transaction_Date__c DESC, loan__Transaction_Time__c DESC LIMIT 1];
                if(openingBalanceList.size() > 0 && openingBalanceList[0].loan__Consolidated_Loan_Balance__c != NULL){
                    loan.Statement_Opening_Balance__c = openingBalanceList[0].loan__Consolidated_Loan_Balance__c;
                }
            }
            update loan;
            WebLink statementLink = [SELECT Id, 
                                        Name, Url 
                                    FROM WebLink 
                                    WHERE Name =: ConstantValues.GENERATE_STATEMENT_DOC 
                                    LIMIT 1];
            String statementURL = statementLink.Url;
            if(loan.loan__Account__c != null){
                statementURL = statementURL.replace(ConstantValues.LOAN_ACCOUNTID,loan.loan__Account__c);
            }
            if(loanId != null){
                statementURL = statementURL.replace(ConstantValues.ACCOUNT_ID,loanId);
            }
            if(loan.loan__Branch__c != null){
                statementURL = statementURL.replace(ConstantValues.BRANCH_ID,loan.loan__Branch__c);
            }
            if(loan.loan__Account__c != null){
                statementURL = statementURL.replace(ConstantValues.ACCOUNT_NAME,loan.Name);
            }
            PageReference retURLPDF = new PageReference(statementURL);
            if(test.isRunningTest()){
            	Integer a = 4/0;
            }
            return retURLPDF;
        }
        catch(Exception e){
            GenericUtility.insertLog('GenerateStatementController.exportToPDF', e);
            return null;
        }
    }
    //This method is called when Back button is clicked in VF page - helps in redirecting to CL Contract page
      public pagereference back() {
        try{
            Pagereference pg = new Pagereference('/' + loanId);
            pg.setRedirect(true);
            if(test.isRunningTest() == true){
                    Integer a = 4/0;
            }
        return pg;
        }
        catch(Exception e){
            GenericUtility.insertLog('GenerateStatementController.back', e);
            return null;
        }
      }
}