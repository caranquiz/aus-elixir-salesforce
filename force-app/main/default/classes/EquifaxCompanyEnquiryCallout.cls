global class EquifaxCompanyEnquiryCallout{
    WebService static String companyEnquiryRequest(ID partyid, ID applicationid,Boolean enrichment){
        try{
            String json;
            clcommon__Party__c ans = [SELECT ID, clcommon__Account__r.clcommon__Legal_Entity_Type__c , clcommon__Type__c
            FROM clcommon__Party__c
            WHERE ID = :partyid];
            
            genesis__Applications__c res = [SELECT Name, genesis__Loan_Amount__c
            FROM genesis__Applications__c
            WHERE ID = :applicationid];
            Map<String, String> queryIDMap = new Map<String, String>();
            queryIDMap.put(ConstantValues.PARTY_ID, partyid);
            queryIDMap.put(ConstantValues.PARTY_TYPE_ID, ans.clcommon__Type__c);
            queryIDMap.put(ConstantValues.ENTITY_ID, ans.clcommon__Account__r.clcommon__Legal_Entity_Type__c);
            
            queryIDMap.put(ConstantValues.APPLICATION_ID, applicationid);
            List<clcommon__Party__c> partyList = [SELECT Id, genesis__Application__c, Party_Type_Name__c FROM clcommon__Party__c
            WHERE genesis__Application__c = :applicationid AND Party_Type_Name__c IN (:ConstantValues.BORROWER, :ConstantValues.CO_APPLICANT)];
            Map<String, Object> requestParamMap = new Map<String, Object>();
            requestParamMap.put(ConstantValues.ENRICHMENT_REQUIRED, enrichment);
            if(partyList.size() > 1){
                requestParamMap.put(ConstantValues.IS_JOINT, true);
            }else{
                requestParamMap.put(ConstantValues.IS_JOINT, false);
            }
        
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
            ConstantValues.EQUIFAX_FAMILY,
            ConstantValues.COMPANY_ENQUIRY_API_TYPE,
            queryIDMap,
            requestParamMap     
            );
            dom.Document docu = new dom.Document();
            docu.load(responseObject.getBody());
            Map<String, Object> responseMap;
            try {
                responseMap = intframework.XmlToJson.parseDocumentToMap(docu);
            } catch (Exception ex) {
                GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_CALLOUT, ex);
                return ConstantValues.SOMETHING_WENT_WRONG;
            }
            return EquifaxCompanyEnquiryResponseHelper.parse(json, ans, responseMap);
        } catch(Exception ex){
            return ex.getMessage()+ex.getLineNumber();  
        }
    }
}