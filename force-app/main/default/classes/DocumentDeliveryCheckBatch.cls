/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : DocumentDeliveryCheckBatch */
/* Created Date         : 01/08/2020 */
/* Developed By         : Souvik */
/* Description          : This batch class does query on the collaterals for which order document
has been done previously and do callout with the enquiry Id for delivery document. This batch class
should be executed passing 1 in the batchSize parameter. */
/* Last Modified Date   : 01/08/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

public class DocumentDeliveryCheckBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'Select Id, Document_Enquiry_Id__c, Document_Status__c, Document_Retrived__c '
        + 'FROM clcommon__Collateral__c WHERE Document_Enquiry_Id__c != null AND Document_Status__c != \'FAILURE\' AND Document_Retrived__c = false AND Document_Status__c != \'EXPIRED\'';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        try{
            if(scope == null || scope.isEmpty()){
                return;
            }
            EquifaxCallout.equifaxDeliverDocument((Id)scope[0].get('Id'));
        }
        catch(Exception ex){
            GenericUtility.insertLog('DocumentDeliveryCheckBatch', ex);
        }
    }
    public void finish(Database.BatchableContext bc){}
}