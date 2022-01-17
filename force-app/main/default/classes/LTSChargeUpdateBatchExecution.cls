/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is to run the LTSChargeUpdateBatch batch job 
                from 'Update LTS Charge ' custom button.
Development Date : 30/12/2021
Last Modified Date : 30/12/2021
****************************************************************************************************/

global with sharing class LTSChargeUpdateBatchExecution {
    Webservice static string executeLTSRedrawUpdateBatchWS(){

        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        LTSChargeUpdateBatch obj = new LTSChargeUpdateBatch();
        Integer size = batch.LTSChargeUpdateBatch__c != NULL ? Integer.valueOf(batch.LTSChargeUpdateBatch__c) : 10;  
        Id batchprocessid = Database.executebatch(obj,size);
        return batchprocessid;
        
    }
}