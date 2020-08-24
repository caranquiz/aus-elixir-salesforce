global class EquifaxCompanyEnquiryAdapter extends intframework.BaseIntegrationAdapter {
global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap)
      {
          try{
                String acn = '';
                String partyUpdate = '';
                String enrType = 'no';
                
                Boolean enrichmentType = (Boolean)filledInRequestMap.get('enrichmentRequired');
                
                if(enrichmentType){
                    enrType = 'yes';
                } else {
                    enrType = 'no';
                }
                
                System.debug(enrType);
                
                
                System.debug(filledInRequestMap);
                System.debug(filledInRequestMap.get('partyinfo'));
                
                List<Map<String, Object>> applicationMap = (List<Map<String, Object>>)filledInRequestMap.get('applicationInfo');
                String applicationName = (String)applicationMap[0].get('applicationName');
                Decimal loanAmount = (Decimal)applicationMap[0].get('loanAmount');    
                
                List<Map<String, Object>> partymap = (List<Map<String, Object>>)filledInRequestMap.get('partyinfo');
                String partyName = (String)partymap[0].get('name');
                
                System.debug(partymap[0].get('companyACN'));
                
                
                List<Map<String, Object>> partyTypeMap = (List<Map<String, Object>>)filledInRequestMap.get('partyRelatedInfo');
                String partyType = (String)partyTypeMap[0].get('partyTypeName');
                
                if(partyType == 'Borrower'){
                    partyUpdate = 'principal';
                }
                else if(partyType == 'Co-Applicant'){
                    partyUpdate = 'coborrower';
                }
                else if(partyType == 'Guarantor'){
                    partyUpdate = 'guarantor';
                }
                else {
                    throw new CustomException('Party type not supported');
                }
                
                System.debug(partyUpdate);
                
                List<Map<String, Object>> entityMap = (List<Map<String, Object>>)filledInRequestMap.get('entityRelatedInfo');
                String legalEntity = (String)entityMap[0].get('entityName');
                    
                if(legalEntity.equals('Company')){
                    acn = (String)partymap[0].get('companyACN');
                }
                else if(legalEntity =='Family Trust' || legalEntity =='SMSF' || legalEntity =='Trust') {
                    acn = (String)partymap[0].get('trusteeACN');
                }
                else {
                    throw new CustomException('legal entity type not supported');
                }
                System.debug(acn);
                
                String s='<soapenv:Envelope xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-8.xsd"><soapenv:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>{!$Credential.UserName}</wsse:Username><wsse:Password>{!$Credential.Password}</wsse:Password></wsse:UsernameToken></wsse:Security><wsa:To>https://vedaxml.com/sys2/company-enquiry-v3-2</wsa:To><wsa:Action>http://vedaxml.com/companyEnquiry/ServiceRequest</wsa:Action></soapenv:Header><soapenv:Body><cenq:request xmlns:cenq="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" request-type="REPORT" client-reference="'
                +partyName+'"><ns2:subject xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" role="'
                +partyUpdate+'"><ns2:australian-company-number>'
                +acn+'</ns2:australian-company-number></ns2:subject><ns2:current-historic-flag xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd">current-and-historical</ns2:current-historic-flag><ns2:enquiry xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" type="credit-enquiry"><ns2:account-type code="L">LEASING</ns2:account-type><ns2:enquiry-amount currency-code="AUD">'
                +loanAmount+'</ns2:enquiry-amount><ns2:client-reference>'
                +partyName+'</ns2:client-reference></ns2:enquiry><ns2:collateral-information xmlns:ns2="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd"><ns2:credit-type>COMMERCIAL</ns2:credit-type><ns2:scoring-required>no</ns2:scoring-required><ns2:enrichment-required>'
                +enrType+'</ns2:enrichment-required><ns2:ppsr-required>no</ns2:ppsr-required></ns2:collateral-information></cenq:request></soapenv:Body></soapenv:Envelope>';
            System.debug(s);
            return s;

        } catch (Exception ex){
            System.debug(ex.getLineNumber()+ex.getMessage());
            return 'error';
        }
      
      
      }
      
 global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        //try {
          httpReq.setEndpoint('callout:' + apiConfig.apiNamedCredential + apiConfig.apiEndpoint);
          if(Test.isRunningTest()){
            httpReq.setEndpoint(apiConfig.apiEndpoint);
          }
          httpReq.setMethod(apiConfig.httpMethod);
          httpReq.setTimeout(apiConfig.requestTimeout);
          System.Http http = new System.Http();
          System.HTTPResponse res;
          res = http.send(httpReq);
          System.debug(res);
          return res;
        //} catch (Exception ex) {
          //GenericUtility.insertLog('EquifaxDeliverDocumentAdapter', ex);
          //return null;
        //}
    }
      
}