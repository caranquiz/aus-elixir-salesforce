/**********************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxApplyIndividualAdapter */
/* Created Date         : 11/08/2020 */
/* Developed By         : Souvik */
/* Description          : This is the adapter class for Apply Individual API of Equifax */
/* Last Modified Date   : 11/08/2020 */
/* Last Modified By     : Souvik */
/*********************************************************************************************************/

global class EquifaxApplyIndividualAdapter extends intframework.BaseIntegrationAdapter {
    global override virtual String generateRequestBody(Map<String, Object> filledInRequestMap) {
        Map<String, Object> appInfo;
        Map<String, Object> partyInfo;
        Map<String, Object> conInfo;
        Map<String, Object> addressInfo;
        Boolean nccpStatusIsRegulated;
        String addressType;
        String relationshipCode;
        String requestbody;
        try {
            StaticResource sr = [SELECT Id, Name, Body FROM StaticResource WHERE Name =:ConstantValues.APPLY_IND_REQUEST_SR];
            requestbody = sr.Body.toString();
            List<Map<String, Object>> refFieldsList = (List<Map<String, Object>>) filledInRequestMap.get(
                'appInfo'
            );
            appInfo = refFieldsList[0];
            if(!appInfo.containsKey('nccpStatus') && String.isBlank((String) appInfo.get('nccpStatus'))){
                throw new CustomException(ConstantValues.NCCP_STATUS_NOT_FOUND);
            }
            String nccpStatus = (String) appInfo.get('nccpStatus');
            if(nccpStatus.equalsIgnoreCase(ConstantValues.NCCP_REGULATED)){
                nccpStatusIsRegulated = true;
            } else if(nccpStatus.equalsIgnoreCase(ConstantValues.NCCP_NON_REGULATED)){
                nccpStatusIsRegulated = false;
            } else{
                throw new CustomException(ConstantValues.NCCP_STATUS_NOT_FOUND);
            }
            if(!appInfo.containsKey('loanAmount') && String.isBlank((String) appInfo.get('loanAmount'))){
                throw new CustomException(ConstantValues.LOAN_AMOUNT_MISSING);
            }
            if(!appInfo.containsKey('appName') && String.isBlank((String) appInfo.get('appName'))){
                throw new CustomException(ConstantValues.APP_REF_MISSING);
            }
            refFieldsList = (List<Map<String, Object>>) filledInRequestMap.get(
                'partyInfo'
            );
            partyInfo = refFieldsList[0];
            refFieldsList = (List<Map<String, Object>>) filledInRequestMap.get(
                'conInfo'
            );
            conInfo = refFieldsList[0];
            if(!conInfo.containsKey('firstName') && String.isBlank((String) conInfo.get('firstName'))){
                throw new CustomException(ConstantValues.FIRST_NAME_MISSING);
            }
            if(!conInfo.containsKey('lastName') && String.isBlank((String) conInfo.get('lastName'))){
                throw new CustomException(ConstantValues.LAST_NAME_MISSING);
            }
            if(!conInfo.containsKey('gender') && String.isBlank((String) conInfo.get('gender'))){
                throw new CustomException(ConstantValues.GENDER_MISSING);
            }
            if(!conInfo.containsKey('dob') && conInfo.get('dob') != null){
                throw new CustomException(ConstantValues.DOB_MISSING);
            }
            refFieldsList = (List<Map<String, Object>>) filledInRequestMap.get(
                'addressInfo'
            );
            addressInfo = refFieldsList[0];
            if(!addressInfo.containsKey('streetNo') && String.isBlank((String) conInfo.get('streetNo'))){
                throw new CustomException(ConstantValues.STREET_NUMBER_MISSING);
            }
            if(!addressInfo.containsKey('streetName') && String.isBlank((String) conInfo.get('streetName'))){
                throw new CustomException(ConstantValues.STREET_NAME_MISSING);
            }
            if(!addressInfo.containsKey('streetType') && String.isBlank((String) conInfo.get('streetType'))){
                throw new CustomException(ConstantValues.STREET_TYPE_MISSING);
            }
            if(!addressInfo.containsKey('suburb') && String.isBlank((String) conInfo.get('suburb'))){
                throw new CustomException(ConstantValues.SUBURB_MISSING);
            }
            if(!addressInfo.containsKey('state') && String.isBlank((String) conInfo.get('state'))){
                throw new CustomException(ConstantValues.STATE_MISSING);
            }
            if(!addressInfo.containsKey('postCode') && String.isBlank((String) conInfo.get('postCode'))){
                throw new CustomException(ConstantValues.POST_CODE_MISSING);
            }
            if(!addressInfo.containsKey('country') && String.isBlank((String) conInfo.get('country'))){
                throw new CustomException(ConstantValues.COUNTRY_MISSING);
            }
            // Dynamic Data Parameters
            if(filledInRequestMap.containsKey('addressType') && String.isNotBlank((String) filledInRequestMap.get('addressType'))){
                addressType = (String) filledInRequestMap.get('addressType');
            }
            if(filledInRequestMap.containsKey('relationshipCode') && String.isNotBlank((String) filledInRequestMap.get('relationshipCode'))){
                relationshipCode = (String) filledInRequestMap.get('relationshipCode');
            }
            requestbody = requestbody.replace(ConstantValues.USERNAME_KEY, ConstantValues.NC_USERNAME);
            requestbody = requestbody.replace(ConstantValues.PASSWORD_KEY, ConstantValues.NC_PASSWORD);

            requestbody = requestbody.replaceAll(ConstantValues.CLIENT_REFERENCE, (String) UserInfo.getUserId());
            requestbody = requestbody.replaceAll(ConstantValues.ENQ_CLIENT_REFERENCE, (String) appInfo.get('appName'));
            if(nccpStatusIsRegulated){
                requestbody = requestbody.replace(ConstantValues.PERMISSION_TYPE_CODE, 'XY');
            } else {
                requestbody = requestbody.replace(ConstantValues.PERMISSION_TYPE_CODE, 'YX');
            }
            requestbody = requestbody.replace(ConstantValues.PRODUCT_DATA_LEVEL_CODE, 'N');
            if(nccpStatusIsRegulated){
                requestbody = requestbody.replace(ConstantValues.SCORECARD_ID1, 'VSA_2.0_XY_NR');
                requestbody = requestbody.replace(ConstantValues.SCORECARD_ID2, 'VS_1.1_XY_NR');
            } else {
                requestbody = requestbody.replace(ConstantValues.SCORECARD_ID1, 'CCAI_2.0_YX_NR');
                requestbody = requestbody.replace(ConstantValues.SCORECARD_ID2, 'VS_1.1_YX_NR');
            }
            requestbody = requestbody.replace(ConstantValues.CUSTOM_IP_PARAM_KEY, 'ITH');
            requestbody = requestbody.replace(ConstantValues.CUSTOM_IP_PARAM_VALUE, String.valueOf(true));
            requestbody = requestbody.replace(ConstantValues.IND_LASTNAME, (String) conInfo.get('lastName'));
            requestbody = requestbody.replace(ConstantValues.IND_FIRSTNAME, (String) conInfo.get('firstName'));
            if(conInfo.containsKey('middleName') && String.isNotBlank((String) conInfo.get('middleName'))){
                requestbody = requestbody.replace(ConstantValues.IND_MIDNAME_WKEY,
                '<ved:other-given-name>' + (String) conInfo.get('middleName') + '</ved:other-given-name>');
            } else{
                requestbody = requestbody.replace(ConstantValues.IND_MIDNAME_WKEY, '');
            }
            requestbody = requestbody.replace(ConstantValues.ADDR_TYPE, addressType);
            if(addressInfo.containsKey('unitNo') && String.isNotBlank((String) addressInfo.get('unitNo'))){
                requestbody = requestbody.replace(ConstantValues.ADDR_UNITNUMBER_WKEY,
                '<ved:unit-number>' + EncodingUtil.urlEncode((String) addressInfo.get('unitNo'), 'UTF-8') + '</ved:unit-number>');
            } else{
                requestbody = requestbody.replace(ConstantValues.ADDR_UNITNUMBER_WKEY, '');
            }
            requestbody = requestbody.replace(ConstantValues.ADDR_STREETNUMBER, (String) addressInfo.get('streetNo'));
            requestbody = requestbody.replace(ConstantValues.ADDR_STREETNAME, (String) addressInfo.get('streetName'));
            requestbody = requestbody.replace(ConstantValues.ADDR_STREETTYPE, GenericUtility.convert2StreetTypeCode((String) addressInfo.get('streetType')));
            requestbody = requestbody.replace(ConstantValues.ADDR_SUBURB, (String) addressInfo.get('suburb'));
            requestbody = requestbody.replace(ConstantValues.ADDR_STATE, (String) addressInfo.get('state'));
            requestbody = requestbody.replace(ConstantValues.ADDR_POSTCODE, (String) addressInfo.get('postCode'));
            if(((String) addressInfo.get('country')).equalsIgnoreCase('Australia')){
                requestbody = requestbody.replace(ConstantValues.ADDR_COUNTRYCODE, 'AUS');
            } else if(((String) addressInfo.get('country')).equalsIgnoreCase('New Zealand')){
                requestbody = requestbody.replace(ConstantValues.ADDR_COUNTRYCODE, 'NZL');
            }
            if(((String) conInfo.get('gender')).equalsIgnoreCase('Male')){
                requestbody = requestbody.replace(ConstantValues.IND_GENDERCODE, 'M');
            } else if(((String) conInfo.get('gender')).equalsIgnoreCase('Female')){
                requestbody = requestbody.replace(ConstantValues.IND_GENDERCODE, 'F');
            } else{
                requestbody = requestbody.replace(ConstantValues.IND_GENDERCODE, 'U');
            }
            Date dob = (Date) conInfo.get('dob');
            requestbody = requestbody.replace(ConstantValues.IND_DOB, String.valueOf(dob.year())
            + '-' + String.valueOf(dob.month()).leftPad(2, '0') + '-' + String.valueOf(dob.day()).leftPad(2, '0'));
            requestbody = requestbody.replace(ConstantValues.ACCOUNT_TYPE_CODE, 'RM');
            requestbody = requestbody.replace(ConstantValues.CURRENCY_CODE, 'AUD');
            requestbody = requestbody.replace(ConstantValues.ENQ_AMT,
            String.valueOf(((Decimal) appInfo.get('loanAmount')).round(System.RoundingMode.HALF_DOWN)));
            requestbody = requestbody.replace(ConstantValues.RELATIONSHIP_CODE, relationshipCode);
        } catch (Exception ex) {
          GenericUtility.insertLog('EquifaxApplyIndividualAdapter', ex);
        }
        return requestbody;
    }

    global override System.HttpResponse sendRequest(System.HttpRequest httpReq) {
        System.HTTPResponse res;
        try {
          httpReq.setEndpoint('callout:' + apiConfig.apiNamedCredential + apiConfig.apiEndpoint);
          if(Test.isRunningTest()){
            httpReq.setEndpoint(apiConfig.apiEndpoint);
          }
          httpReq.setMethod(apiConfig.httpMethod);
          httpReq.setTimeout(apiConfig.requestTimeout);
          System.Http http = new System.Http();
          res = http.send(httpReq);
        } catch (Exception ex) {
          GenericUtility.insertLog('EquifaxApplyIndividualAdapter', ex);
        }
        return res;
    }
}