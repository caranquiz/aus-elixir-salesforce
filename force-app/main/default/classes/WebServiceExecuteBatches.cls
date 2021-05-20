/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is to run the batch job from custom button.
Development Date : 20/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

global with sharing class WebServiceExecuteBatches {
    Webservice static string ExecuteUpdateSumOfLinkedLoanBatch(){
		Id batchprocessid = Database.executebatch(new UpdateSumOfLinkedLoanBatch(),1000);
        return batchprocessid;
    }
}