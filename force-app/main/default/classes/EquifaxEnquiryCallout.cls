/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxEnquiryCallout */
/* Created Date         : 11/08/2020 */
/* Developed By         : Souvik */
/* Description          : This is the callout class for Equifax Apply Individual. */
/* Last Modified Date   : 12/08/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global with sharing class EquifaxEnquiryCallout {
    webService static String equifaxApplyIndividual(Id appId, Id partyId, Id conId, Id addressId){
        try{
            genesis__Applications__c appObj;
            clcommon__Party__c partyObj;
            Contact conObj;
            clcommon__Address__c addressObj;
            List<genesis__Applications__c> appList = [SELECT Id FROM genesis__Applications__c WHERE Id = :appId];
            if(appList.isEmpty()){
                return ConstantValues.NO_APPLICATION;
            }
            appObj = appList[0];
            List<clcommon__Party__c> partyList = [SELECT Id FROM clcommon__Party__c WHERE Id = :partyId];
            if(partyList.isEmpty()){
                return ConstantValues.NO_PARTY;
            }
            partyObj = partyList[0];
            List<Contact> contactList = [SELECT Id FROM Contact WHERE Id = :conId];
            if(contactList.isEmpty()){
                return ConstantValues.NO_CONTACT;
            }
            conObj = contactList[0];
            List<clcommon__Address__c> addressList = [SELECT Id FROM clcommon__Address__c WHERE Id = :addressId];
            if(addressList.isEmpty()){
                return ConstantValues.NO_ADDRESS;
            }
            addressObj = addressList[0];
            Map<String, String> queryIdMap = new Map<String, String>();
            queryIdMap.put('appId', appObj.Id);
            queryIdMap.put('partyId', partyObj.Id);
            queryIdMap.put('conId', conObj.Id);
            queryIdMap.put('addressId', addressObj.Id);
            Map<String, Object> requestParamMap = new Map<String, Object>();
            requestParamMap.put('addressType', 'C');
            requestParamMap.put('relationshipCode', '1');
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
                ConstantValues.EQUIFAX_FAMILY,
                ConstantValues.APPLY_INDIVIDUAL_API_TYPE,
                queryIdMap,
                requestParamMap
            );
            System.debug(responseObject.getBody());
            dom.Document doc = new dom.Document();
            doc.load(responseObject.getBody());
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
                doc
            );
            String json = System.JSON.serialize(responseMap);
            EquifaxApplyIndividualResponseHelper helperObject = EquifaxApplyIndividualResponseHelper.parse(json);
            return EquifaxApplyIndividualResponseHelper.updatePartyWithApplyIndividualResponse(partyObj, helperObject);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxEnquiryCallout', ex);
            return ConstantValues.GENERAL_ERROR;
        }
    }
}