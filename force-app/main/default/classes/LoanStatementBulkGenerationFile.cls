/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This controller class used to re-direct to Conga batches and make some changes in Cl contract
                    when Launch Conga Batch button is clicked and when Update File Visibility is clicked then 
                    ContentDocumentLinkVisibilityUpdateBatch runs.
Development Date : 01/12/2021
Last Modified Date : 09/12/2021
****************************************************************************************************/

public with sharing class LoanStatementBulkGenerationFile {

    static Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
    public APXT_BPM__Conductor__c congaBatch{get;set;}

    public LoanStatementBulkGenerationFile () {
        congaBatch = [SELECT id,
                            name,
                            Statement_Generation_End_Date__c,
                            Statement_Generation_Start_Date__c,
                            APXT_BPM__Title__c
                            FROM APXT_BPM__Conductor__c 
                            WHERE APXT_BPM__Title__c=: ConstantValues.STATEMENT_CONGA_BATCH];
    }
    //Re-direct to Conga Batche page 
	public PageReference clickLaunch() {
        Integer k = 0;
        try{
            List<String> loanStatusList=System.label.Active_CL_Contract_Status.split(',');
            List<Date> statementDateList=new List<Date>();
            List<loan__Loan_Account__c> objloanList=new List<loan__Loan_Account__c>();
            List <loan__Loan_Transaction_Summary__c> openingBalanceList=new List<loan__Loan_Transaction_Summary__c>();
            Integer endMonth,endDate,month,numberDaysDue,intRateIndex,lastIntRateIndex;
            Decimal oldRate,newRate;

            List<loan__Loan_Account__c> loanList = [SELECT Id,
                                                        Name, 
                                                        Statement_Start_Date__c,
                                                        Statement_End_Date__c,
                                                        Conga_Batch_Start_Date__c,
                                                        Conga_Batch_End_Date__c,
                                                        loan__Branch__c,
                                                        loan__Account__c,
                                                        loan__Closed_Date__c,
                                                        loan__Loan_Status__c,
                                                        loan__Disbursal_Date__c 
                                                        FROM loan__Loan_Account__c 
                                                        WHERE loan__Loan_Status__c in: loanStatusList];
            
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
                                                    WHERE loan__Loan_Account__c in: loanList
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
                numberDaysDue = 0;
                if(currentSystemDate != NULL){
                    numberDaysDue = (eachTxn.loan__Txn_Date__c).daysBetween(currentSystemDate);
                }
                if(eachTxn.loan__Description__c != NULL && (eachTxn.loan__Description__c).containsIgnoreCase(ConstantValues.INT_RATE)){
                    //Checks has not been done on index of characters as the field is populated by product and description snapshot always contains new and old description values
                    intRateIndex = ((eachTxn.loan__Description__c).indexOf(ConstantValues.INT_RATE)+7);
                    if(eachTxn.loan__Description__c.length() >= intRateIndex+6){
                        oldRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(intRateIndex,intRateIndex+6));
                    }
                    lastIntRateIndex = ((eachTxn.loan__Description__c).lastIndexOf(ConstantValues.INT_RATE)+7);
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
                database.update(otherLoanTxns,false);
                //Updating certain checkbox for the population of interest rate changes
            }
            //The following lines of code helps in assigning values to Statement Start and End Dates
            
            for(loan__Loan_Account__c loan:loanList){
                if(loan.Conga_Batch_Start_Date__c != null 
                        && loan.Conga_Batch_Start_Date__c!= currentSystemDate && loan.Conga_Batch_Start_Date__c>=loan.loan__Disbursal_Date__c ){
                    if(loan.loan__Loan_Status__c==ConstantValues.CLOSED_OBLIGATIONS_MET){
                        if(loan.Conga_Batch_Start_Date__c<=loan.loan__Closed_Date__c ){
                            loan.Statement_Start_Date__c = loan.Conga_Batch_Start_Date__c;
                            statementDateList.add(loan.Conga_Batch_Start_Date__c);
                        }else{
                            loan.Statement_Start_Date__c = null;
                        }
                    }else{
                        loan.Statement_Start_Date__c = loan.Conga_Batch_Start_Date__c;
                        statementDateList.add(loan.Conga_Batch_Start_Date__c);
                    }
                }else{
                    loan.Statement_Start_Date__c = null;
                }
                if(loan.Conga_Batch_End_Date__c != null 
                        && loan.Conga_Batch_End_Date__c!= currentSystemDate && loan.Conga_Batch_End_Date__c>=loan.loan__Disbursal_Date__c){
                    loan.Statement_End_Date__c = loan.Conga_Batch_End_Date__c;
                    if(loan.loan__Loan_Status__c==ConstantValues.CLOSED_OBLIGATIONS_MET){
                        if(loan.Conga_Batch_Start_Date__c<=loan.loan__Closed_Date__c){
                            if(loan.Conga_Batch_End_Date__c>=loan.loan__Closed_Date__c){
                                loan.Statement_End_Date__c = loan.loan__Closed_Date__c;
                            }else{
                                loan.Statement_End_Date__c = loan.Conga_Batch_End_Date__c;
                            }
                        }else{
                            loan.Statement_End_Date__c = null;
                        }
                    }else{
                        loan.Statement_End_Date__c = loan.Conga_Batch_End_Date__c;
                    }
                }else{
                    loan.Statement_End_Date__c = null;
                }
                if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c > loan.loan__Disbursal_Date__c){
                    objloanList.add(loan);
                }
            }
            openingBalanceList = [SELECT Id,
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
                                    WHERE loan__Loan_Account__c in: objloanList
                                    AND loan__Transaction_Date__c <: statementDateList
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
                                    ORDER BY loan__Transaction_Date__c DESC, loan__Transaction_Time__c DESC ];
            for(loan__Loan_Account__c loan:loanList){
                if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c <= loan.loan__Disbursal_Date__c){
                    loan.Statement_Opening_Balance__c = 0;
                }
                else if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c > loan.loan__Disbursal_Date__c){
                    for(loan__Loan_Transaction_Summary__c openingBalance:openingBalanceList){
                        if(loan.id==openingBalance.loan__Loan_Account__r.id && openingBalance.loan__Consolidated_Loan_Balance__c != NULL 
                                && openingBalance.loan__Transaction_Date__c < loan.Statement_Start_Date__c){
                            loan.Statement_Opening_Balance__c = openingBalance.loan__Consolidated_Loan_Balance__c;
                            break;
                        }
                    }
                }
            }
            for(loan__Loan_Account__c loan:loanList){
                if(loan.Statement_Start_Date__c!=NULL){
                    if((loan.Statement_Start_Date__c).month()>=1 && (loan.Statement_Start_Date__c).month()<=6){
                        month=1;
                        endMonth=6;
                        endDate=30;
                    }else{
                        month=7;
                        endMonth=12;
                        endDate=31;
                    }
                    congaBatch.Statement_Generation_Start_Date__c=Date.newInstance(loan.Statement_Start_Date__c.year(), month, 1);
                    congaBatch.Statement_Generation_End_Date__c=Date.newInstance(loan.Statement_Start_Date__c.year(), endMonth, endDate);
                    break;
                }
            }
            Database.update(loanList,false);
            Database.update(congaBatch,false);
            PageReference pageRef;
            pageRef=new PageReference('/'+congaBatch.id);
            return pageRef;  
        }catch(Exception e){
            GenericUtility.insertLog('LoanStatementBulkGenerationFile.clickLaunch', e);
            return null;
        }        
    }

    // Execute ContentDocumentLinkVisibilityUpdateBatch batch job.
    public void runbatch(){

        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        ContentDocumentLinkVisibilityUpdateBatch obj = new ContentDocumentLinkVisibilityUpdateBatch();
        Integer size = batch.ContentDocumentLinkVisibility_Size__c != NULL ? Integer.valueOf(batch.ContentDocumentLinkVisibility_Size__c) : 10;  
        database.executebatch(obj,size);
        ApexPages.addMessage(
        new ApexPages.Message(
            ApexPages.severity.CONFIRM,
            ConstantValues.BATCH_JOB_START
        )
        );
    }
}