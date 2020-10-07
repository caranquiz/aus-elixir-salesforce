/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxOrgIdSearchBatch */
/* Created Date         : 06/10/2020 */
/* Developed By         : Souvik */
/* Description          : This batch class does query on the current directorships for which the
organisation identification search is needed it does the callout and update those records. */
/* Last Modified Date   : 06/10/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

public class EquifaxOrgIdSearchBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id, Org_Id_verified__c, Party__c, ABN__c, ACN__c '
        + 'FROM Current_Directorship__c WHERE Org_Id_verified__c = false AND ABN__c != null AND Party__c != null';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        try{
            if(scope == null || scope.isEmpty()){
                return;
            }
            String calloutResult = EquifaxOrgIdSearchCallout.searchByABN((String) scope[0].get('Party__c'), (String) scope[0].get('ABN__c'));
            if(String.isBlank(calloutResult)){
                GenericUtility.insertLog('EquifaxOrgIdSearchBatch', new CustomException('Response is null or blank'));
                return;
            }
            EquifaxOrgIdSearchParser helperObject = (EquifaxOrgIdSearchParser) System.JSON.deserialize((String) calloutResult, EquifaxOrgIdSearchParser.class);
            if(String.isNotBlank(helperObject.errMessage)){
                GenericUtility.insertLog('EquifaxOrgIdSearchBatch', new CustomException(helperObject.errMessage));
                return;
            }
            insert new clcommon__Log__c(Name = 'TEST', clcommon__Message__c = calloutResult);
            scope[0].put('Id_reference__c', helperObject.bcamessage.serviceRequestId);
            scope[0].put('Org_Id_verified_Asic_name__c', helperObject.asicNameData);
            scope[0].put('Org_Id_verified_Asic_status__c', helperObject.asicStatusData);
            scope[0].put('Org_Id_verified__c', true);
            update(scope);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxOrgIdSearchBatch', ex);
        }
    }
    public void finish(Database.BatchableContext bc){}
}