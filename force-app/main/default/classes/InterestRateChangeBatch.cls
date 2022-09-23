/****************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 18/04/2022
Last Modified By : Rameswari Barman
Last Modified Date : 18/04/2022
Description : This batch calls and is used to update interest rates of LAIs at bulk 
                where new interest rate vaue is present in LAIs and the interest effective rate 
                is equal to current system date
****************************************************************************************************/

global class InterestRateChangeBatch extends clcommon.DynamicJob {

    global InterestRateChangeBatch(){
        //BLANK CONSTRUCTOR
    } 
    
    global override String getRuntimeQuery() {
        String currentSystemDate = ((DateTime) (!Test.isRunningTest()?(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate().addDays(0): Date.Today())).format('yyyy-MM-dd');
        List<String> params = new List<String>{
            currentSystemDate
        };
        String queryString =                   'SELECT Id, '+
                                               'Name, '+
                                               'New_Interest_Rate__c, '+
                                               'New_Interest_Rate_Effective_Date__c, '+
                                               'loan__Next_Installment_Date__c, '+
                                               'Calculated_Upcoming_Repayment_Amount__c, '+
                                               'loan__Interest_Rate__c, '+
                                               'Repayment_Type__c, '+
                                               'Remaining_Loan_Term__c, '+
                                               'Remaining_Term_from_Schedule__c, '+
                                               'Remaining_IO_Period__c, '+
                                               'loan__Due_Day__c, '+
                                               'loan__Frequency_of_Loan_Payment__c, '+
                                               'Interest_Rate_Change_Notification_Date__c, '+
                                               'First_Repayment_Date_After_IR_Change__c, '+
                                               'Second_Repayment_Date_After_IR_Change__c, '+
                                               'loan__Pmt_Amt_Cur__c, '+
                                               'loan__Uncleared_Repayment_Amount__c, '+
                                               'loan__Loan_Status__c, '+
                                               'loan__Delinquent_Amount__c, '+
                                               'loan__Maturity_Date_Current__c, '+
                                               'loan__Previous_Installment_Date__c '+
                                           'FROM loan__Loan_Account__c '+
                                           'WHERE New_Interest_Rate__c != NULL '+
                                           'AND New_Interest_Rate_Effective_Date__c <= {0}'+
                                           'AND loan__Interest_Type__c = \'FIXED\' '+
                                           'AND loan__Invalid_Data__c = FALSE '+
                                           'AND loan__Loan_Status__c IN (\'Active - Good Standing\',\'Active - Bad Standing\',\'Active - Marked for Closure\') '+
                                           'AND (loan__Uncleared_Repayment_Amount__c = 0 '+
                                           'OR loan__Uncleared_Repayment_Amount__c = NULL)'+
                                           'AND loan__Floating_Rate_Index__c = NULL '+
                                           'AND First_Repayment_Date_After_IR_Change__c != NULL '+
                                           'AND Interest_Rate_Change_Notification_Date__c != NULL '+
                                           'AND Remaining_Term_from_Schedule__c > 0';
        String formattedString = String.format(queryString, params);
        return formattedString;
    }
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        InterestRateChangeBatch obj = new InterestRateChangeBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.InterestRateChangeBatch_Job_Size__c != NULL ? Integer.valueOf(batch.InterestRateChangeBatch_Job_Size__c) : 1;  
        database.executebatch(obj,size);
    }
    public override void doexecute(Database.BatchableContext bc, List<Sobject> loanList) {
        try{
            List <loan__Loan_Account__c> objLoanList = loanList;
            InterestRateChangeHandler.updateRate(objLoanList);
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('InterestRateChangeBatch',exe);
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}