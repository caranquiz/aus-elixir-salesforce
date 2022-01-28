/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Loan Transaction summary fields 
            if backdated Charge is created.
Development Date : 29/12/2021
Last Modified Date : 30/12/2021
****************************************************************************************************/

global with sharing class LTSChargeUpdateBatch  implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable{
    loan.GlobalLoanUtilFacade glutil = new loan.GlobalLoanUtilFacade();
    Date systemDate=!Test.isRunningTest()?glutil.getCurrentSystemDate():Date.today();
    Date todayDate=Date.today();
    //Query Charge whose Transaction Date is less than system Date.
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                                Name,
                                                loan__Balance__c,
                                                loan__Date__c,
                                                CreatedDate,
                                                loan__Loan_Account__c,
                                                Update_LTS_Charge_Check__c,
                                                loan__Loan_Account__r.Id
                                            FROM loan__Charge__c
                                            WHERE Include_in_Summary__c= true
                                            AND (loan__Date__c <: systemDate
                                            OR Check_loan_Payoff__c = true)
                                            AND Update_LTS_Charge_Check__c = false
                                            ORDER BY loan__Date__c DESC,CreatedDate DESC]);
    }
    //This method updates LTS.
    public void execute(Database.BatchableContext bc, List<loan__Charge__c> objChargeList) {
        try{
            List<Date> startDate=new List<Date>();
            Map<Id,Date> startDateMap=new Map<Id,Date>();
            List<Id> loanIdList=new List<Id>();
            
            for(loan__Charge__c objCharge : objChargeList){
                if((objCharge.loan__Date__c!=objCharge.CreatedDate) || objCharge.Check_loan_Payoff__c==true){
                    loanIdList.add(objCharge.loan__Loan_Account__r.Id);
                    startDate.add(objCharge.loan__Date__c);
                    startDateMap.put(objCharge.loan__Loan_Account__r.Id,objCharge.loan__Date__c);
                }
                objCharge.Update_LTS_Charge_Check__c = true;   
            }
            if(loanIdList.size()>0 && startDate.size()>0){
                LTSCalculateConsolidatedLoanBalance.calculateConsolidatedLoanBalance(loanIdList,startDate,startDateMap);
            }

            Database.update(objChargeList,false);
            
        }catch(Exception exe){
            insert new clcommon__Batch_Process_Log__c(
                clcommon__Message__c = 'LTSChargeUpdateBatch :Exception: '+exe.getStackTraceString()
                                        +'error='+exe.getMessage()+' at Line Number '+exe.getLineNumber(),
                clcommon__Timestamp__c = System.Now());
        }
    }
    public void execute(SchedulableContext sc) {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        LTSChargeUpdateBatch obj = new LTSChargeUpdateBatch();
        Integer size = batch.LTSChargeUpdateBatch__c != NULL ? Integer.valueOf(batch.LTSChargeUpdateBatch__c) : 10;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
    }

}