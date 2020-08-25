global class EquifaxCompanyEnquiryCallout{
    WebService static String companyEnquiryRequest(ID partyid, ID applicationid,Boolean enrichment){
        try{
            clcommon__Party__c ans = [SELECT ID, clcommon__Account__r.clcommon__Legal_Entity_Type__c , clcommon__Type__c
            FROM clcommon__Party__c
            WHERE ID = :partyid];
            
            genesis__Applications__c res = [SELECT Name, genesis__Loan_Amount__c
            FROM genesis__Applications__c
            WHERE ID = :applicationid];
            Map<String, String> queryIDMap = new Map<String, String>();
            queryIDMap.put('partyId', partyid);
            queryIDMap.put('partyTypeId', ans.clcommon__Type__c);
            queryIDMap.put('entityID', ans.clcommon__Account__r.clcommon__Legal_Entity_Type__c);
            
            queryIDMap.put('applicationID', applicationid);
            // queryIDMap.put('enquiryID', enquiryID);
            List<clcommon__Party__c> partyList = [SELECT Id, genesis__Application__c FROM clcommon__Party__c
            WHERE genesis__Application__c = :applicationid];
            Map<String, Object> requestParamMap = new Map<String, Object>();
            requestParamMap.put('enrichmentRequired', enrichment);
            if(partyList.size() > 1){
                requestParamMap.put('isJoint', true);
            }
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
            ConstantValues.EQUIFAX_FAMILY,
            'Company Enquiry',
            queryIDMap,
            requestParamMap 
            );
            System.debug(responseObject.getBody());
            dom.Document docu = new dom.Document();
            docu.load(responseObject.getBody());
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(docu);
            String json = System.JSON.serialize(responseMap);
            
            return EquifaxCompanyEnquiryResponseHelper.parse(json, ans);
        } catch(Exception ex){
            return ex.getMessage()+ex.getLineNumber();  
        }


        // return 'Success';


    }
}