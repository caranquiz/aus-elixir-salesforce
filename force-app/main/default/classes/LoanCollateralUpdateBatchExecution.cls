/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is to run the LoanCollateralUpdateBatch batch job 
                from 'Update Securities Detail' custom button.
Development Date : 14/02/2022
Last Modified Date : 24/02/2022
****************************************************************************************************/

global with sharing class LoanCollateralUpdateBatchExecution {
	Webservice static string executeLoanCollateralUpdateBatchWS(){

        Batch_Job_Size__c batchJobSize=Batch_Job_Size__c.getInstance();
        LoanCollateralUpdateBatch objLoanCollateral = new LoanCollateralUpdateBatch();
        Integer size = batchJobSize.LoanCollateralUpdateBatch_Size__c != NULL ? Integer.valueOf(batchJobSize.LoanCollateralUpdateBatch_Size__c) : 10;
		Id batchprocessid = Database.executebatch(objLoanCollateral,size);
        return batchprocessid;
        
    }
}