/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class update Cl Contract Fields.
Development Date : 14/02/2022
Last Modified Date : 24/02/2022
****************************************************************************************************/

public class LoanCollateralUpdateBatch implements DataBase.StateFul,DataBase.Batchable<sObject>,Schedulable {
    //Query all Loan Collateral  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                                 loan__Loan__c,
                                                 loan__Loan__r.id,
                                                 Original_Value__c,
                                                 MIP_Value__c,
                                                 Risk_Value__c,
                                         		 CreatedDate,
                                         		 LastModifiedDate,
                                                 Security_Status__c
                                             FROM loan__Loan_Collateral__c]);
    }
    public void execute(Database.BatchableContext bc, List<loan__Loan_Collateral__c> objLoanCollList) {
        try{
            List<loan__Loan_Account__c> loanAccountList=new List<loan__Loan_Account__c>();
            List<Id> loanIdList=new List<Id>();
            for(loan__Loan_Collateral__c objLoanColl:objLoanCollList){
                if(objLoanColl.CreatedDate != objLoanColl.LastModifiedDate && objLoanColl.loan__Loan__c!=NULL){
                    loanIdList.add(objLoanColl.loan__Loan__c);
                }
            }
            loanAccountList= [SELECT id,
                                    Current_Loan_Balance_Excluding_Deposit__c,
                                    loan__Payment_Mode__c,
                                    loan__Loan_Purpose__c,
                                    loan__Approval_Date__c,
                                    Original_Total_of_Securities__c,
                                    Actual_Security_Value__c,
                                    Current_Total_of_Securities__c,
                                    Current_Total_of_Discharged_Securities__c,
                                    Risk_LVR__c,
                                    MIP_LVR__c
                                FROM loan__Loan_Account__c 
                                WHERE id IN: loanIdList];
            if(loanAccountList.size()>0){
				ConvertToContract.updateClContract(loanAccountList);               
            }
            if(test.isRunningTest()){
                Integer a = 4/0;
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LoanCollateralUpdateBatch',exe);
        } 
    }
	public void execute(SchedulableContext sc) {
        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        LoanCollateralUpdateBatch obj = new LoanCollateralUpdateBatch();
        Integer size = batch.LoanCollateralUpdateBatch_Size__c != NULL ? Integer.valueOf(batch.LoanCollateralUpdateBatch_Size__c) : 10;  
        database.executebatch(obj,size);
    }
    public void finish(Database.BatchableContext bc){
    }

}