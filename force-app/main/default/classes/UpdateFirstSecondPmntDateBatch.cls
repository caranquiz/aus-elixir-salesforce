/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 12/04/2022
Last Modified By : Rameswari Barman
Last Modified Date : 12/04/2022
Description : This class is used to update first,second payments dates along with schedule balance at the rate change date
 
***********************************************************************************************************************************************************/


global class UpdateFirstSecondPmntDateBatch extends clcommon.DynamicJob{

    global UpdateFirstSecondPmntDateBatch(){
        //BLANK CONSTRUCTOR
    } 
    
    global override String getRuntimeQuery() {
        return                        'SELECT Id, '+
                                            'Name, '+
                                            'First_Repayment_Date_After_IR_Change__c, '+
                                            'Second_Repayment_Date_After_IR_Change__c, '+
                                            'New_Interest_Rate_Effective_Date__c,'+
                                            'New_Interest_Rate__c, '+
                                            'Scheduled_Balance_As_at_IR_change_date__c, '+
                                            'loan__Loan_Amount__c '+
                                        'FROM loan__Loan_Account__c '+
                                        'WHERE loan__Invalid_Data__c = FALSE '+
                                        'AND loan__Loan_Status__c IN (\'Active - Good Standing\',\'Active - Bad Standing\',\'Active - Matured\',\'Active - Marked for Closure\') '+
                                        'AND New_Interest_Rate_Effective_Date__c != NULL '+
                                        'AND New_Interest_Rate__c != NULL '+
                                        'ORDER BY Id';
    }
    
    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        UpdateFirstSecondPmntDateBatch obj = new UpdateFirstSecondPmntDateBatch();
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        Integer size = batch.UpdateFirstSecondPmntDateBatch__c != NULL ? Integer.valueOf(batch.UpdateFirstSecondPmntDateBatch__c) : 200;  
        database.executebatch(obj,size);
    }
    public override void doexecute(Database.BatchableContext bc, List<sobject> objLoanList) {
        try{
            if(objLoanList.isEmpty() == FALSE){
                Integer count = 0;
                List <loan__Loan_Account__c> loanList = objLoanList;
                List <loan__Repayment_Schedule__c> repaymentList = [SELECT Id,
                                                                        loan__Due_Date__c,
                                                                        loan__Loan_Account__c,
                                                                        loan__Balance__c
                                                                        FROM loan__Repayment_Schedule__c
                                                                        WHERE loan__Loan_Account__c IN : objLoanList
                                                                    AND loan__Is_Archived__c = FALSE
                                                                    AND loan__Due_Date__c != NULL
                                                                    AND loan__Balance__c != NULL
                                                                    ORDER BY loan__Loan_Account__c, loan__Due_Date__c ASC];
                Map <Id,List<loan__Repayment_Schedule__c>> loanScheduleMap = new Map <Id,List<loan__Repayment_Schedule__c>>();
                for(loan__Loan_Account__c eachLoan : loanList){
                    count = 0;
                    eachLoan.First_Repayment_Date_After_IR_Change__c = NULL;
                    eachLoan.Second_Repayment_Date_After_IR_Change__c = NULL;
                    eachLoan.Scheduled_Balance_As_at_IR_change_date__c = eachLoan.loan__Loan_Amount__c;
                    for(loan__Repayment_Schedule__c eachSchedule : repaymentList){
                        if(eachSchedule.loan__Loan_Account__c == eachLoan.Id && eachSchedule.loan__Due_Date__c <= eachLoan.New_Interest_Rate_Effective_Date__c){
                            eachLoan.Scheduled_Balance_As_at_IR_change_date__c = eachSchedule.loan__Balance__c;
                        }
                        else if(eachSchedule.loan__Loan_Account__c == eachLoan.Id && eachSchedule.loan__Due_Date__c > eachLoan.New_Interest_Rate_Effective_Date__c){
                            if(count == 0){
                                eachLoan.First_Repayment_Date_After_IR_Change__c = eachSchedule.loan__Due_Date__c;
                                count ++;
                            }
                            else if(count == 1){
                                eachLoan.Second_Repayment_Date_After_IR_Change__c = eachSchedule.loan__Due_Date__c;
                                break;
                            }
                        }
                    }
                }
                update objLoanList;
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('UpdateFirstSecondPmntDateBatch',exe);
        }
    }
    
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}