/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxEnquiryCallout */
/* Created Date         : 11/08/2020 */
/* Developed By         : Souvik */
/* Description          : This is the callout class for Equifax Apply Individual and Previous Enquiry. */
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
            List<clcommon__Party__c> partyList = [SELECT Id, Party_Type_Name__c FROM clcommon__Party__c WHERE Id = :partyId];
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
            partyList = [SELECT Id FROM clcommon__Party__c
            WHERE genesis__Application__c = :appId AND Party_Type_Name__c IN ('Borrower', 'Co-applicant')];
            if(String.isNotBlank(partyObj.Party_Type_Name__c) && (partyObj.Party_Type_Name__c).equalsIgnoreCase('Guarantor')){
                requestParamMap.put('relationshipCode', '3');
            }
            else if(partyList.size() > 1){
                requestParamMap.put('relationshipCode', '2');
            }else{
                requestParamMap.put('relationshipCode', '1');
            }
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
                ConstantValues.EQUIFAX_FAMILY,
                ConstantValues.APPLY_INDIVIDUAL_API_TYPE,
                queryIdMap,
                requestParamMap
            );
            dom.Document doc = new dom.Document();
            doc.load(responseObject.getBody());
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
                doc
            );
            String json = System.JSON.serialize(responseMap);
            EquifaxApplyIndividualResponseHelper helperObject = EquifaxApplyIndividualResponseHelper.parse(json, partyObj.Id);
            if(helperObject == null){
                return ConstantValues.GENERAL_ERROR;
            }
            return EquifaxApplyIndividualResponseHelper.updatePartyWithApplyIndividualResponse(partyObj, helperObject);
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxEnquiryCallout', ex);
            return ConstantValues.GENERAL_ERROR;
        }
    }
    webService static String equifaxPreviousEnquiry(String enquiryId, Id partyId){
        String pdfData;
        try{
            clcommon__Party__c partyObj = [SELECT Id, clcommon__Account__c, clcommon__Contact__r.FirstName, clcommon__Contact__r.lastName, genesis__Application__c
            FROM clcommon__Party__c WHERE Id = :partyId];
            Map<String, Object> requestParamMap = new Map<String, Object>();
            StaticResource sr = [SELECT Id, Name, Body FROM StaticResource WHERE Name =:ConstantValues.PREV_ENQ_STATIC_RES];
            String requestBody = sr.Body.toString();
            if(sr == null){
                throw new CustomException(ConstantValues.PREV_ENQ_REQ_BODY_SRNAME);
            }
            requestParamMap.put('requestBody', requestBody);
            if(String.isBlank(enquiryId)){
                return ConstantValues.NO_ENQ_ID;
            }
            requestParamMap.put('enquiryId', enquiryId);
            requestParamMap.put('contentType', ConstantValues.APP_PDF_CONTENT_TYPE);
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
                ConstantValues.EQUIFAX_FAMILY,
                ConstantValues.PREVIOUS_ENQUIRY_API_TYPE,
                new Map<String, String>(),
                requestParamMap
            );
            dom.Document doc = new dom.Document();
            doc.load(responseObject.getBody());
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
                doc
            );
            // This inner try catch block terminates the code if any exception occurs during fetching the document
            try{
                pdfData = (String)
                ((Map<String, Object>)
                ((Map<String, Object>)
                ((Map<String, Object>)
                ((Map<String, Object>) responseMap
                .get(ConstantValues.ENVELOPE_KEY))
                .get(ConstantValues.BODY_KEY))
                .get(ConstantValues.RESPONSE_KEY))
                .get(ConstantValues.BINARYDATA_KEY))
                .get(ConstantValues.NODEVALUE_KEY);
                Attachment documentAttachment = new Attachment();
                documentAttachment.ContentType = ConstantValues.APP_PDF_CONTENT_TYPE;
                documentAttachment.Body = EncodingUtil.base64Decode(pdfData);
                documentAttachment.Name = ConstantValues.PREV_ENQ_PDF_NAME_PREF
                + partyObj.clcommon__Contact__r.FirstName + ' '
                + partyObj.clcommon__Contact__r.LastName + ' (OBSOLETE).pdf';
                documentAttachment.parentId = partyObj.Id;
                Database.insert(documentAttachment);
                List<clcommon__Document_Category__c> docCatList =
                [
                    SELECT Id, clcommon__Category_Name__c
                    FROM clcommon__Document_Category__c
                    WHERE clcommon__Category_Name__c =:ConstantValues.PREV_ENQ_DOC_CAT
                    AND genesis__Application__c =:partyObj.genesis__Application__c
                ];
                //Attaching the retrieved document with the collateral
                clcommon__Document_Category__c docCat = docCatList[0];
                clcommon__Category_Attachment_Association__c attachDoc = new clcommon__Category_Attachment_Association__c();
                attachDoc.Name = documentAttachment.Name;
                attachDoc.clcommon__Attachment_Id__c = documentAttachment.Id;
                attachDoc.clcommon__Document_Category__c = docCat.Id;
                Database.insert(attachDoc);
                return ConstantValues.PDF_REPORT_DOWNLOADED;
            }
            catch(Exception ex){
                throw new CustomException(ConstantValues.RESPONSE_PARSE_ERR);
            }
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxEnquiryCallout', ex);
            return ConstantValues.GENERAL_ERROR;
        }
    }
}