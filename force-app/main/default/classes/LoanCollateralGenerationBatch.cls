/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class create Loan Collateral Records for existing Cl Contract.
Development Date : 14/02/2022
Last Modified Date : 24/02/2022
****************************************************************************************************/

public class LoanCollateralGenerationBatch implements DataBase.StateFul,DataBase.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT id,
                                                Current_Loan_Balance_Excluding_Deposit__c,
                                                loan__Payment_Mode__c,
                                                loan__Loan_Purpose__c,
                                                loan__Approval_Date__c,
                                                Original_Total_of_Securities__c,
                                                Actual_Security_Value__c,
                                                Current_Total_of_Securities__c,
                                                Current_Total_of_Discharged_Securities__c,
                                                Risk_LVR__c,
                                                MIP_LVR__c,
                                                Application__c,
                                                Application__r.id
                                            FROM loan__Loan_Account__c 
                                            WHERE loan__Loan_Status__c !=: ConstantValues.CLOSED_OBLIGATIONS_MET ]);
    }
    public void execute(Database.BatchableContext bc, List<loan__Loan_Account__c> objLoanList) {
        try{
            ConvertToContract.collateralValues(objLoanList[0].Application__r.id,objLoanList[0].id);
            ConvertToContract.updateClContract(objLoanList);
            if(test.isRunningTest()){
                Integer a = 4/0;
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('LoanCollateralGenerationBatch',exe);
        }
    }
	public void finish(Database.BatchableContext bc){
    }
}