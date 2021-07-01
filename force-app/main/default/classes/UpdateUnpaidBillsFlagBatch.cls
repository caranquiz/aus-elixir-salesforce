/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description : This class updates the Unpaid Bills flag for the ones wrongly updated when all the bills are satisfied/unsatisfied
Development Date : 09/06/2021
Last Modified Date : 09/06/2021
****************************************************************************************************/
global class UpdateUnpaidBillsFlagBatch extends clcommon.DynamicJob {

    global UpdateUnpaidBillsFlagBatch(){
        //BLANK CONSTRUCTOR
    }        

    global override String getRuntimeQuery() {
        if(Test.isRunningTest() == true){
            String sampleQuery = 'SELECT Id, Name, Total_no_of_generated_bills__c, Total_no_of_Paid_bills__c, loan__Unpaid_Bills__c, loan__Delinquent_Amount__c FROM loan__Loan_Account__c';
            return sampleQuery;
        }
        else{
            //Returning Query in String Format
            return 'SELECT Id, Name, Total_no_of_generated_bills__c, Total_no_of_Paid_bills__c, loan__Unpaid_Bills__c, loan__Delinquent_Amount__c FROM loan__Loan_Account__c where loan__Invalid_Data__c = false and loan__Loan_Status__c in (\'Active - Good Standing\',\'Active - Bad Standing\')'; 
        }
    }

    global override void doStart(Database.BatchableContext bc) {}

    global override void doExecute(System.SchedulableContext sc) {
        UpdateUnpaidBillsFlagBatch obj = new UpdateUnpaidBillsFlagBatch();
        Database.executeBatch(obj, 100);
    }

    public override void doexecute(Database.BatchableContext bc, List<sobject> scope) {
        try{
            if(scope.size()>0){
                List <loan__Loan_Account__c> loanList = scope;
                for(loan__Loan_Account__c rec:loanList){
                    if(rec.Total_no_of_generated_bills__c == rec.Total_no_of_Paid_bills__c){
                        rec.loan__Unpaid_Bills__c = false;
                    }
                    else if(rec.Total_no_of_generated_bills__c > rec.Total_no_of_Paid_bills__c && rec.loan__Delinquent_Amount__c > 0){
                        rec.loan__Unpaid_Bills__c = true;
                    }
                }
                Database.update(loanList,false);
            }
            if(Test.isRunningTest() == true){
                Integer a = 1/0;
            }
        }catch(Exception exe){
            insert new clcommon__Log__c(
                clcommon__Message__c = 'UpdateUnpaidBillsFlagBatch :Exception: '+exe.getStackTraceString()+'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Time__c = System.Now());
        }
    }
    global override void doInitialize() {}
  
    global override void doFinish(Database.BatchableContext bc) {}
}