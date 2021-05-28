/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is to run the TotalSumOfLinkedLoanUpdateBatch batch job 
                from 'Update Total Sum Of Linked Loans' custom button.
Development Date : 20/05/2021
Last Modified Date : 20/05/2021
****************************************************************************************************/

global with sharing class TotalSumOfLinkedLoanBatchExecution {

    Webservice static string executeTotalSumOfLinkedLoanUpdateBatchWS(){
        TotalSumOfLinkedLoanUpdateBatch obj = new TotalSumOfLinkedLoanUpdateBatch();
        Integer size = Integer.valueof(System.label.TotalSumOfLinkedLoanUpdateBatch_Size);  
		Id batchprocessid = Database.executebatch(obj,size);
        return batchprocessid;
    }
}