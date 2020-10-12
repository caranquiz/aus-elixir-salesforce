global class EquifaxCompanyEnquiryAdapter extends intframework.BaseIntegrationAdapter {
    global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap)
    {
        String acn ;
        String partyUpdate ;
        String enrType = ConstantValues.NO;
        String s ;
        String requestBody;
        String applicationName;
        String partyName;
        String partyType;
        String legalEntity;
        Decimal loanAmount;
        if(filledInRequestMap == null){
            GenericUtility.insertLog('EquifaxCompanyEnquiryAdapter', new CustomException('Problem in RequestMapping'));
            return null;
        }
        try{                    
            Boolean enrichmentType = (Boolean)filledInRequestMap.get(ConstantValues.ENRICHMENT_REQUIRED);
            Boolean isJoint = (Boolean)filledInRequestMap.get(ConstantValues.IS_JOINT);
            if(enrichmentType){
                enrType = ConstantValues.YES;
            } else {
                enrType = ConstantValues.NO;
            }
            List<Map<String, Object>> applicationMap = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.APPLICATION_INFO);
            applicationName = (String)applicationMap[0].get(ConstantValues.APPLICATION_NAME);
            loanAmount = (Decimal)applicationMap[0].get(ConstantValues.LOAN_AMOUNT);    
                    
            List<Map<String, Object>> partymap = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.PARTY_INFO_MAP);
            partyName = (String)partymap[0].get(ConstantValues.NAME_KEY);
            List<Map<String, Object>> partyTypeMap = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.PARTY_RELATED_INFO);
            partyType = (String)partyTypeMap[0].get(ConstantValues.PARTY_TYPE_NAME);
                    
            if(partyType == ConstantValues.GUARANTOR){
                partyUpdate = ConstantValues.GUARANTOR_PARTY_UPDATE;
            } else if(isJoint){
                    partyUpdate = ConstantValues.JOINT;
            } else{
                partyUpdate = ConstantValues.PRINCIPAL;
            }
        
            List<Map<String, Object>> entityMap = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.ENTITY_RELATED_INFO);
            legalEntity = (String)entityMap[0].get(ConstantValues.ENTITY_NAME);
                        
            if(legalEntity.equals(ConstantValues.ENQUIRY_COMPANY)){
                acn = (String)partymap[0].get(ConstantValues.COMPANY_ACN);
            } else if(legalEntity ==ConstantValues.FAMILY_TRUST || legalEntity ==ConstantValues.ENQUIRY_SMSF || legalEntity ==ConstantValues.Trust) {
                acn = (String)partymap[0].get(ConstantValues.TRUSTEE_ACN);
            } else {
                throw new CustomException('legal entity type not supported');
            }
            s='<soapenv:Envelope xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-8.xsd"><soapenv:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>{!$Credential.UserName}</wsse:Username><wsse:Password>{!$Credential.Password}</wsse:Password></wsse:UsernameToken></wsse:Security><wsa:To>https://vedaxml.com/sys2/company-enquiry-v3-2</wsa:To><wsa:Action>http://vedaxml.com/companyEnquiry/ServiceRequest</wsa:Action></soapenv:Header><soapenv:Body><cenq:request xmlns:cenq="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" request-type="REPORT" client-reference="'
            +applicationName+'"><ns2:subject xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" role="'
            +partyUpdate+'"><ns2:australian-company-number>'
            +acn+'</ns2:australian-company-number></ns2:subject><ns2:current-historic-flag xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd">current-and-historical</ns2:current-historic-flag><ns2:enquiry xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" type="credit-enquiry"><ns2:account-type code="RM">REALESTATEMORTGAGE</ns2:account-type><ns2:enquiry-amount currency-code="AUD">'
            +loanAmount+'</ns2:enquiry-amount><ns2:client-reference>'
            +applicationName+'</ns2:client-reference></ns2:enquiry><ns2:collateral-information xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd"><ns2:credit-type>COMMERCIAL</ns2:credit-type><ns2:scoring-required>no</ns2:scoring-required><ns2:enrichment-required>'
            +enrType+'</ns2:enrichment-required><ns2:ppsr-required>yes</ns2:ppsr-required></ns2:collateral-information></cenq:request></soapenv:Body></soapenv:Envelope>';
            return s;
        } catch (Exception ex){
            GenericUtility.insertLog('EquifaxCompanyEnquiryAdapter', ex);
            return null;
        }
    }
          
    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        try {
            httpReq.setEndpoint('callout:' + apiConfig.apiNamedCredential + apiConfig.apiEndpoint);
            if(Test.isRunningTest()){
            httpReq.setEndpoint(apiConfig.apiEndpoint);
            }
            httpReq.setMethod(apiConfig.httpMethod);
            httpReq.setTimeout(apiConfig.requestTimeout);
            System.Http http = new System.Http();
            System.HTTPResponse res;
            res = http.send(httpReq);
            return res;
        } catch (Exception ex) {
        GenericUtility.insertLog('EquifaxCompanyEnquiryAdapter', ex);
        return null;
        }
    }  
}