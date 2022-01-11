/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This batch class query all Active Loans and update the Statement Start date,
                Statement End date and Statement Opening Balance.
Development Date : 10/01/2022
Last Modified Date : 10/01/2022
****************************************************************************************************/

public class StatementBulkGenerationLoanUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable{
    List<String> loanStatusList=System.label.Active_CL_Contract_Status.split(',');
    Date currentSystemDate =(Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
	//Query all Active Cl Contract  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id,
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
                                             WHERE loan__Loan_Status__c in: loanStatusList
                                             Order By Id]);
    }
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> loanList) {
        try{
            List<Date> statementDateList=new List<Date>();
            Map<Id,Date> openingTxnsDateMap=new Map<Id,Date>();
            Map<Id,Decimal> openinigConsolidatedMap =new Map<Id,Decimal>();
            List<loan__Loan_Account__c> objloanList=new List<loan__Loan_Account__c>();
            Map<Id,Integer> countMap=new Map<Id,Integer>();
            List <loan__Loan_Transaction_Summary__c> openingBalanceList=new List<loan__Loan_Transaction_Summary__c>();
            Integer endMonth,endDate,month,numberDaysDue,intRateIndex,lastIntRateIndex;
            Decimal oldRate,newRate;
            for(loan__Loan_Account__c objloan:loanList){
                countMap.put(objloan.id,0);
            }
            List <loan__Other_Transaction__c> otherLoanTxnsList = [SELECT Id,
                                                                        loan__Description__c,
                                                                        loan__Txn_Date__c,
                                                                        loan__Interest_Rate__c,
                                                                        loan__New_Interest_Rate__c,
                                                                        Final_Interest_Rate__c,
                                                                        loan__Loan_Account__c,
                                                                        loan__Loan_Account__r.id,
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

            for(loan__Other_Transaction__c eachTxn : otherLoanTxnsList){
                eachTxn.Latest_Rate_Change__c = false;
                eachTxn.Final_Interest_Rate__c = false;
                eachTxn.Rate_Changed__c = false;
                numberDaysDue = 0;
                if(currentSystemDate != NULL){
                    numberDaysDue = (eachTxn.loan__Txn_Date__c).daysBetween(currentSystemDate);
                }
                if(eachTxn.loan__Description__c != NULL && (eachTxn.loan__Description__c).containsIgnoreCase(ConstantValues.INT_RATE)){
                    //Checks has not been done on index of characters as the field is populated by product and description snapshot always contains new and old description values
                    intRateIndex = ((eachTxn.loan__Description__c).indexOf(ConstantValues.INT_RATE)+ConstantValues.SEVEN);
                    if(eachTxn.loan__Description__c.length() >= intRateIndex+ConstantValues.SIX){
                        oldRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(intRateIndex,intRateIndex+ConstantValues.SIX));
                    }
                    lastIntRateIndex = ((eachTxn.loan__Description__c).lastIndexOf(ConstantValues.INT_RATE)+ConstantValues.SEVEN);
                    if(eachTxn.loan__Description__c.length() >= lastIntRateIndex+ConstantValues.FOUR){
                        newRate = Decimal.valueOf((eachTxn.loan__Description__c).substring(lastIntRateIndex,lastIntRateIndex+ConstantValues.FOUR));
                    }
                    if(numberDaysDue <= ConstantValues.THREE_SIXTY_FIVE && oldRate != NULL && newRate != NULL && oldRate != newRate){
                        eachTxn.Rate_Changed__c = true;
                        if(countMap.containsKey(eachTxn.loan__Loan_Account__r.id) 
                                && countMap.get(eachTxn.loan__Loan_Account__r.id)!=null && countMap.get(eachTxn.loan__Loan_Account__r.id)==0){
                            eachTxn.Latest_Rate_Change__c = true;
                            countMap.put(eachTxn.loan__Loan_Account__r.id,countMap.get(eachTxn.loan__Loan_Account__r.id)+1);
                        }
                    }
                    else if(numberDaysDue > ConstantValues.THREE_SIXTY_FIVE && oldRate != null && newRate != NULL && oldRate != newRate){
                        if(countMap.containsKey(eachTxn.loan__Loan_Account__r.id) 
                                && countMap.get(eachTxn.loan__Loan_Account__r.id)!=null && countMap.get(eachTxn.loan__Loan_Account__r.id)== 0){
                            eachTxn.Latest_Rate_Change__c = true;
                            countMap.put(eachTxn.loan__Loan_Account__r.id,countMap.get(eachTxn.loan__Loan_Account__r.id)+1);
                        }
                        eachTxn.Final_Interest_Rate__c = true;
                        break;
                    }
                }
                else if(numberDaysDue <= ConstantValues.THREE_SIXTY_FIVE){
                    if(countMap.containsKey(eachTxn.loan__Loan_Account__r.id) 
                            && countMap.get(eachTxn.loan__Loan_Account__r.id)!=null && countMap.get(eachTxn.loan__Loan_Account__r.id)==0){
                        eachTxn.Latest_Rate_Change__c = true;
                        countMap.put(eachTxn.loan__Loan_Account__r.id,countMap.get(eachTxn.loan__Loan_Account__r.id)+1);
                    }
                    eachTxn.Rate_Changed__c = true;
                }
                else if(numberDaysDue > ConstantValues.THREE_SIXTY_FIVE){
                    if(countMap.containsKey(eachTxn.loan__Loan_Account__r.id) 
                            && countMap.get(eachTxn.loan__Loan_Account__r.id)!=null && countMap.get(eachTxn.loan__Loan_Account__r.id)==0){
                        eachTxn.Latest_Rate_Change__c = true;
                        countMap.put(eachTxn.loan__Loan_Account__r.id,countMap.get(eachTxn.loan__Loan_Account__r.id)+1);
                    }
                    eachTxn.Final_Interest_Rate__c = true;
                    break;
                }
            }
            if(otherLoanTxnsList.isEmpty() == false){
                database.update(otherLoanTxnsList,false);
                //Updating certain checkbox for the population of interest rate changes
            }
            //The following lines of code helps in assigning values to Statement Start and End Dates
            
            for(loan__Loan_Account__c loan:loanList){
                if(loan.Conga_Batch_Start_Date__c != null && loan.loan__Disbursal_Date__c!=null
                        && loan.Conga_Batch_Start_Date__c!= currentSystemDate && loan.Conga_Batch_Start_Date__c>=loan.loan__Disbursal_Date__c 
                        && (loan.loan__Loan_Status__c!=ConstantValues.CLOSED_OBLIGATIONS_MET 
                        || (loan.loan__Loan_Status__c==ConstantValues.CLOSED_OBLIGATIONS_MET 
                        && loan.loan__Closed_Date__c !=null && loan.Conga_Batch_Start_Date__c<=loan.loan__Closed_Date__c))){

                    loan.Statement_Start_Date__c = loan.Conga_Batch_Start_Date__c;
                    statementDateList.add(loan.Conga_Batch_Start_Date__c);
                    openingTxnsDateMap.put(loan.Id,loan.Conga_Batch_Start_Date__c);
                    
                }else{
                    loan.Statement_Start_Date__c = null;
                }
                if(loan.Conga_Batch_End_Date__c != null && loan.loan__Disbursal_Date__c!=null
                        && loan.Conga_Batch_End_Date__c!= currentSystemDate && loan.Conga_Batch_End_Date__c>=loan.loan__Disbursal_Date__c){
                    loan.Statement_End_Date__c = loan.Conga_Batch_End_Date__c;
                    if(loan.loan__Loan_Status__c==ConstantValues.CLOSED_OBLIGATIONS_MET){
                        if(loan.Conga_Batch_Start_Date__c!=null && loan.Conga_Batch_Start_Date__c<=loan.loan__Closed_Date__c){
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
            if(statementDateList.size()>0 && objloanList.size()>0){
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
            }
            for(loan__Loan_Transaction_Summary__c openingBalance:openingBalanceList){
                if(!openinigConsolidatedMap.containsKey(openingBalance.loan__Loan_Account__r.id) && openingTxnsDateMap.containsKey(openingBalance.loan__Loan_Account__r.id) 
                        && openingTxnsDateMap.get(openingBalance.loan__Loan_Account__r.id)!=NULL && openingBalance.loan__Transaction_Date__c < openingTxnsDateMap.get(openingBalance.loan__Loan_Account__r.id)){
                    openinigConsolidatedMap.put(openingBalance.loan__Loan_Account__r.id,openingBalance.loan__Consolidated_Loan_Balance__c);
                }
            }
            for(loan__Loan_Account__c loan:loanList){
                if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c!=NULL 
                        && loan.Statement_Start_Date__c <= loan.loan__Disbursal_Date__c){
                    loan.Statement_Opening_Balance__c = 0;
                }
                else if(loan.loan__Disbursal_Date__c != NULL && loan.Statement_Start_Date__c!=NULL 
                        && loan.Statement_Start_Date__c > loan.loan__Disbursal_Date__c && openinigConsolidatedMap.containsKey(loan.id) ){
                        if(openinigConsolidatedMap.get(loan.id) != NULL ){
                            loan.Statement_Opening_Balance__c = openinigConsolidatedMap.get(loan.id);
                        }
                }
            }
            APXT_BPM__Conductor__c congaBatch=[SELECT id,
                                                    name,
                                                    Statement_Generation_End_Date__c,
                                                    Statement_Generation_Start_Date__c,
                                                    APXT_BPM__Title__c
                                                    FROM APXT_BPM__Conductor__c 
                                                    WHERE APXT_BPM__Title__c=: ConstantValues.STATEMENT_CONGA_BATCH];
            for(loan__Loan_Account__c loan:loanList){
                if(loan.Statement_Start_Date__c!=NULL){
                    if((loan.Statement_Start_Date__c).month()>=ConstantValues.ONE && (loan.Statement_Start_Date__c).month()<=ConstantValues.SIX){
                        month=ConstantValues.ONE;
                        endMonth=ConstantValues.SIX;
                        endDate=ConstantValues.THIRTY;
                    }else{
                        month=ConstantValues.SEVEN;
                        endMonth=ConstantValues.TWELVE;
                        endDate=ConstantValues.THIRTY_ONE;
                    }
                    congaBatch.Statement_Generation_Start_Date__c=Date.newInstance(loan.Statement_Start_Date__c.year(), month, ConstantValues.ONE);
                    congaBatch.Statement_Generation_End_Date__c=Date.newInstance(loan.Statement_Start_Date__c.year(), endMonth, endDate);
                    break;
                }
            }
            Database.update(loanList,false);
            Database.update(congaBatch,false);
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'StatementBulkGenerationLoanUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        StatementBulkGenerationLoanUpdateBatch obj = new StatementBulkGenerationLoanUpdateBatch();
        Integer size = batch.StatementBulkGenerationLoanUpdateBatch__c != NULL ? Integer.valueOf(batch.StatementBulkGenerationLoanUpdateBatch__c) : 10;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){

    }

}