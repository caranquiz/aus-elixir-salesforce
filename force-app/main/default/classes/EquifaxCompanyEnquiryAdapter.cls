global class EquifaxCompanyEnquiryAdapter extends intframework.BaseIntegrationAdapter {
    global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap)
    {
        String companyACN ='';
        String partyUpdate ;
        String enrichment = ConstantValues.NO;
        String requestBody;
        String applicationName;
        String partyName;
        String partyType;
        String legalEntity;
        Decimal loanAmount;
        Integer lengthACN;
        if(filledInRequestMap == null){
            GenericUtility.insertLog(EquifaxCompanyEnquiryAdapter.class.getName(), new CustomException(ConstantValues.PROBLEM_IN_REQUEST_MAPPING));
            return null;
        }
        try{                    
            Boolean enrichmentType = Boolean.valueOf(filledInRequestMap.get(ConstantValues.ENRICHMENT_REQUIRED));
            Boolean isJoint = Boolean.valueOf(filledInRequestMap.get(ConstantValues.IS_JOINT));
            if(enrichmentType){
                enrichment = ConstantValues.YES;
            } else {
                enrichment = ConstantValues.NO;
            }

            List<Map<String, Object>> applicationList = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.APPLICATION_INFO);
            if(!applicationList.isEmpty()){
                applicationName = String.valueOf(applicationList[0].get(ConstantValues.APPLICATION_NAME));
                if((String.valueOf(applicationList[0].get(ConstantValues.LOAN_AMOUNT))) != null){
                    loanAmount = Decimal.valueOf(String.valueOf(applicationList[0].get(ConstantValues.LOAN_AMOUNT)));
                }
            }    
            List<Map<String, Object>> partyList = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.PARTY_INFO_MAP);
            if(!partyList.isEmpty()){
                partyName = String.valueOf(partyList[0].get(ConstantValues.NAME_KEY));
            }
            List<Map<String, Object>> partyTypeList = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.PARTY_RELATED_INFO);
            if(!partyTypeList.isEmpty()){
                partyType = String.valueOf(partyTypeList[0].get(ConstantValues.PARTY_TYPE_NAME));
            }
                    
            if(partyType == ConstantValues.GUARANTOR){
                partyUpdate = ConstantValues.GUARANTOR_PARTY_UPDATE;
            } else if(isJoint){
                
                partyUpdate = ConstantValues.JOINT;
            } else{
                partyUpdate = ConstantValues.PRINCIPAL;
            }
        
            List<Map<String, Object>> entityList = (List<Map<String, Object>>)filledInRequestMap.get(ConstantValues.ENTITY_RELATED_INFO);
            if(!entityList.isEmpty()){
                legalEntity = String.valueOf(entityList[0].get(ConstantValues.ENTITY_NAME));
            }
            if(legalEntity != null && legalEntity.equals(ConstantValues.COMPANY)){
                companyACN = String.valueOf(partyList[0].get(ConstantValues.COMPANY_ACN));
            } else if(legalEntity != null & legalEntity.equals(ConstantValues.FAMILY_TRUST) || legalEntity.equals(ConstantValues.ENQUIRY_SMSF) || legalEntity.equals(ConstantValues.Trust)) {
                companyACN = String.valueOf(partyList[0].get(ConstantValues.TRUSTEE_ACN));
            } else {
                throw new CustomException(ConstantValues.LEGAL_ENTITY_TYPE_NOT_SUPPORTED);
            }
            if(companyACN != null){
                lengthACN = companyACN.length();
                if(lengthACN < 9){
                    Integer diff = 9 - lengthACN;
                    for (Integer i = 0; i < diff; i++) {
                        companyACN = '0' + companyACN;
                    }
                }
            }
            requestBody='<soapenv:Envelope xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-8.xsd"><soapenv:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>{!$Credential.UserName}</wsse:Username><wsse:Password>{!$Credential.Password}</wsse:Password></wsse:UsernameToken></wsse:Security><wsa:To>https://vedaxml.com/sys2/company-enquiry-v3-2</wsa:To><wsa:Action>http://vedaxml.com/companyEnquiry/ServiceRequest</wsa:Action></soapenv:Header><soapenv:Body><cenq:request xmlns:cenq="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" request-type="REPORT" client-reference="'
            +(String)UserInfo.getUserId()+'"><ns2:subject xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" role="'
            +partyUpdate+'"><ns2:australian-company-number>'
            +companyACN+'</ns2:australian-company-number></ns2:subject><ns2:current-historic-flag xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd">current-and-historical</ns2:current-historic-flag><ns2:enquiry xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" type="credit-enquiry"><ns2:account-type code="RM">REALESTATEMORTGAGE</ns2:account-type><ns2:enquiry-amount currency-code="AUD">'
            +loanAmount+'</ns2:enquiry-amount><ns2:client-reference>'
            +applicationName+'</ns2:client-reference></ns2:enquiry><ns2:collateral-information xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd"><ns2:credit-type>COMMERCIAL</ns2:credit-type><ns2:scoring-required>no</ns2:scoring-required><ns2:enrichment-required>'
            +enrichment+'</ns2:enrichment-required><ns2:ppsr-required>yes</ns2:ppsr-required></ns2:collateral-information></cenq:request></soapenv:Body></soapenv:Envelope>';
            return requestBody;
        } catch (Exception ex){
            GenericUtility.insertLog(EquifaxCompanyEnquiryAdapter.class.getName(), ex);
            return null;
        }
    }
          
    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        try{
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
            GenericUtility.insertLog(EquifaxCompanyEnquiryAdapter.Class.getName(), ex);
            return null;
        }
    }  
}