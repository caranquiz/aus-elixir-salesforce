/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is to run the LTSRedrawUpdateBatch batch job 
                from 'Update LTS Redraw ' custom button.
Development Date : 14/06/2021
Last Modified Date : 14/06/2021
****************************************************************************************************/

global with sharing class LTSRedrawUpdateBatchExecution {
    
    Webservice static string executeLTSRedrawUpdateBatchWS(){

        Batch_Job_Size__c batch=Batch_Job_Size__c.getInstance();
        LTSRedrawUpdateBatch obj = new LTSRedrawUpdateBatch();
        Integer size = batch.LTSRedrawUpdateBatch_Size__c != NULL ? Integer.valueOf(batch.LTSRedrawUpdateBatch_Size__c) : 10;  
		Id batchprocessid = Database.executebatch(obj,size);
        return batchprocessid;
        
    }

}