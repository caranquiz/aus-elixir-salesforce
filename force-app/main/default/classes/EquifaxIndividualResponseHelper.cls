/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is used to Parse and Store Apply Individual Response of Equifax 
Development Date : 16/07/2021
Last Modified Date : 20/07/2021
****************************************************************************************************/

public class EquifaxIndividualResponseHelper {
    public class CommonException extends Exception {
    }
    public static Map<String, Object> findInSummaryData(
      List<Object> detailList,
      String referenceValue
    ) {
      if (detailList == null) {
        return new Map<String, Object>();
      }
      for (Object summaryCheck : detailList) {
        if (
          summaryCheck == null ||
          ((String)((Map<String, Object>) summaryCheck).get(ConstantValues.VARIABLE_NAME)) ==
          null
        ) {
          continue;
        }
        if (
          ((String) ((Map<String, Object>) summaryCheck)
              .get(ConstantValues.VARIABLE_NAME)) == referenceValue
        ) {
          return ((Map<String, Object>) summaryCheck);
        }
      }
      return new Map<String, Object>();
    }
    public static String processAddress(Map<String, Object> address) {
      String res = '';
      if (((String)((Map<String, Object>) address).get(ConstantValues.UNIT_NUMBER))!= null) {
        res += ((String)((Map<String, Object>) address).get(ConstantValues.UNIT_NUMBER));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.STREET_NUMBER))!= null){
        res += ' ' + ((String)((Map<String, Object>) address).get(ConstantValues.STREET_NUMBER));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.STREET_NAME)) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get(ConstantValues.STREET_NAME));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.STREET_TYPE))!= null){
        res += ' ' + ((String)((Map<String, Object>) address).get(ConstantValues.STREET_TYPE));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.SUBURB)) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get(ConstantValues.SUBURB));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.STATE))!= null){
        res += ' ' + ((String)((Map<String, Object>) address).get(ConstantValues.STATE));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.POSTCODE)) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get(ConstantValues.POSTCODE));
      }
      if (((String)((Map<String, Object>) address).get(ConstantValues.COUNTRY_CODE)) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get(ConstantValues.COUNTRY_CODE));
      }
      return res;
    }
    public static String processPossiblyMatchedData(
      Map<String,Object> possibleMatchData
    ) {
      String data = '';
      if ((Map<String,Object>)possibleMatchData != null 
          && ((Map<String,Object>)((Map<String,Object>)possibleMatchData).get(ConstantValues.IDENTITY)) != null
      ) {
        if (((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData).get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)) != null) {
          if (
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FIRST_GIVEN_NAME)) != null 
            
          ) {
            data +=
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FIRST_GIVEN_NAME)) +
              ' ';
          }
          if (
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.OTHER_GIVEN_NAME))!=null
          ) {
            data +=
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.OTHER_GIVEN_NAME)) +
              ' ';
          }
          if (
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FAMILY_NAME_DIRECTOR))!=null
          ) {
            data +=
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FAMILY_NAME_DIRECTOR)) +
              ' ';
          }
        }
        if (
          ((String)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get(ConstantValues.IDENTITY)).get(ConstantValues.DATE_OF_BIRTH))!=null
        ) {
          data += '\nD.O.B : ' + ((String)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
          .get(ConstantValues.IDENTITY)).get(ConstantValues.DATE_OF_BIRTH));
        }
      }
      if (
        ((Map<String,Object>)possibleMatchData) != null 
          && ((Object)((Map<String,Object>)possibleMatchData).get(ConstantValues.ADDRESSES)) != null &&
          String.valueOf(
            ((Map<String,Object>)possibleMatchData)
          ).contains(ConstantValues.ADDRESSES_ARRAY)
      ) {
        data += '\nAddresses : ';
        List<Object> addressList=((List<Object>)((Map<String,Object>)possibleMatchData).get(ConstantValues.ADDRESSES));
        for (Object eachAddress : addressList) {
          data += processAddress(((Map<String,Object>) eachAddress)) + '\n';
        }
      }else if(
        ((Map<String,Object>)possibleMatchData) != null 
          && ((Object)((Map<String,Object>)possibleMatchData).get(ConstantValues.ADDRESSES)) != null &&
          String.valueOf(
            ((Map<String,Object>)possibleMatchData)
          ).contains(ConstantValues.ADDRESSES_OBJECT)
      ){
        data += '\nAddresses : ';
        Object eachAddress=((Object)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
                .get(ConstantValues.ADDRESSES)).get(ConstantValues.ADDRESS));
        data += processAddress(((Map<String,Object>) eachAddress)) + '\n';
      }
      return data;
    }
    public static String parse(
    String json,
    clcommon__Party__c partyObj,
    Map<String, Object> response
    ) {
        String returnValue = ConstantValues.APPLY_IND_SUCCESS;
        Map<String,Object> productHeader;
        Map<String,Object> productData;
        Map<String,Object> enquiryReport;
        Map<String,Object> summaryData;
        Map<String,Object> publicReport;
        Map<String,Object> consumerCredit;
        Map<String,Object> commercialCredit;
        Map<String,Object> possibleMatchData;
        List<Object> commonSumEntry;
        List<Payment_Default__c> paymentDefaults = new List<Payment_Default__c>();
        Map<String, Payment_Default__c> accountIdDefaultMap = new Map<String, Payment_Default__c>();
        Map<String, Id> accountIdIdMap = new Map<String, Id>();
        Map<String,Object> publicRecordOrConsumerCreditInformation;
        Id partyId;
        try {
          if(
            ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY)) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                ConstantValues.ENVELOPE_KEY
              )).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.PRODUCT_HEADER)) != null

          ){
            productHeader=((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY
                      )).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.PRODUCT_HEADER));
          }
          if(
            ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY)) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                ConstantValues.ENVELOPE_KEY
              )).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.PRODUCT_DATA)) != null

          ){
            productData=((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY
                      )).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.PRODUCT_DATA));
          }
          if(
            productData!=null && ((Map<String, Object>)productData.get(ConstantValues.ENQUIRY_REPORT))!=null
          ){
            enquiryReport=((Map<String, Object>)productData.get(ConstantValues.ENQUIRY_REPORT));
          }
          if(
            productData!=null && ((Map<String, Object>)productData.get(ConstantValues.SUMMARY_DATA))!=null
          ){
            summaryData=((Map<String, Object>)productData.get(ConstantValues.SUMMARY_DATA));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get(ConstantValues.PUBLIC_CONSUMER_CREDIT))!=null
          ){
            publicReport=((Map<String, Object>)enquiryReport.get(ConstantValues.PUBLIC_CONSUMER_CREDIT));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get(ConstantValues.CONSUMER_CREDIT))!=null
          ){
            consumerCredit=((Map<String, Object>)enquiryReport.get(ConstantValues.CONSUMER_CREDIT));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get(ConstantValues.COMMERCIAL_CREDIT))!=null
          ){
            commercialCredit=((Map<String, Object>)enquiryReport.get(ConstantValues.COMMERCIAL_CREDIT));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get(ConstantValues.PUBLIC_CONSUMER_CREDIT))!=null
          ){
            publicRecordOrConsumerCreditInformation=((Map<String, Object>)enquiryReport.get(ConstantValues.PUBLIC_CONSUMER_CREDIT));
          }
          if (summaryData != null &&
              ((List<Object>) summaryData
                .get(ConstantValues.DATA_BLOCK)) != null
          ) {
              commonSumEntry = ((List<Object>)summaryData 
                .get(ConstantValues.DATA_BLOCK));
          }
          clearPartyObjectData(partyObj);
          if (
            enquiryReport!=null &&
            ((Map<String, Object>) enquiryReport.get(ConstantValues.PRIMARY_MATCH)) !=
            null &&
            ((String) ((Map<String, Object>)enquiryReport.get(ConstantValues.PRIMARY_MATCH)).get(ConstantValues.BUREAU_REFERENCE))!=NUll
          ) {
            partyObj.File_Number__c = ((String) ((Map<String, Object>)enquiryReport.get(ConstantValues.PRIMARY_MATCH)).get(ConstantValues.BUREAU_REFERENCE));
          }
          if(
            productHeader!=null &&
            ((String)productHeader.get(ConstantValues.ENQUIRY_ID))!= null
          ) {
            partyObj.Request_Id__c = ((String)productHeader.get(ConstantValues.ENQUIRY_ID));
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NA8902_age_fle_max'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NA8902_age_fle_max'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.Age_of_Credit_File__c = Decimal.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)))
              .round(System.RoundingMode.HALF_DOWN);
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NY7601_adv_48_84m'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NY7601_adv_48_84m'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              if(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT))=='Y'){
                partyObj.Adverse_on_file__c = ConstantValues.YES_TAG;
              }else if(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT))=='N'){
                partyObj.Adverse_on_file__c = ConstantValues.NO_TAG;
              }
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NX7601_adv_48_84m'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NX7601_adv_48_84m'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              if(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT))=='Y'){
                partyObj.Consumer_Adverse_on_file__c = ConstantValues.YES_TAG;
              }else if(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT))=='N'){
                partyObj.Consumer_Adverse_on_file__c = ConstantValues.NO_TAG;
              }
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NP8500_dr_cur'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NP8500_dr_cur'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.Current_Directorships__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)));
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NP8506_dr_adv_disq_60m_ever'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NP8506_dr_adv_disq_60m_ever'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.External_Administrators__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)));
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NP8512_inslv_bkrpt'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NP8512_inslv_bkrpt'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.Number_of_bankrupt_on_file__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)));
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NP7502_inslv_bkrpt_84m'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NP7502_inslv_bkrpt_84m'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.Number_of_bankrupt_on_file_in_last_84m__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)));
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NP8511_inslv_dis'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NP8511_inslv_dis'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.Number_of_Discharged_Insolvencies__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)));
            }
          }
          if (
            findInSummaryData(
              commonSumEntry,
              'NP8510_inslv'
            ) != null
          ){
            Map<String, Object> tempSummaryEntry = findInSummaryData(
              commonSumEntry,
              'NP8510_inslv'
            );
            if (
              ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.VALUE
                ))
                .get(ConstantValues.ELE_TEXT) != null
            ) {
              partyObj.Number_of_insolvencies_on_file__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get(ConstantValues.VALUE)).get(ConstantValues.ELE_TEXT)));
            }
          }
          if(
            productData!=null &&
            ((Object)productData.get(ConstantValues.SCORE_DATA))!= null &&
            String.valueOf(
              productData
            ).contains(ConstantValues.SCORE_DATA_ARRAY)
          ){
            List<Object> scoreList =((List<Object>)productData.get(ConstantValues.SCORE_DATA));
            for (Object eachScore : scoreList){
              if (
                ((Map<String,Object>)eachScore) == null ||
                ((Map<String,Object>)((Map<String,Object>)eachScore).get(ConstantValues.SCORECARD)) == null ||
                (String)((Map<String,Object>)((Map<String,Object>)eachScore).get(ConstantValues.SCORECARD))
                .get(ConstantValues.SCORECARD_ID) == null
              ) {
                continue;
              }
              String scoreCardIdVal = (String)((Map<String,Object>)((Map<String,Object>)eachScore).get(ConstantValues.SCORECARD))
                    .get(ConstantValues.SCORECARD_ID);
              if (
                scoreCardIdVal.equalsIgnoreCase('VSA_2.0_XY_NR') ||
                scoreCardIdVal.equalsIgnoreCase('CCAI_2.0_YX_NR')
              ) {
                if (
                  ((Map<String,Object>)eachScore) == null ||
                ((String)((Map<String,Object>)eachScore).get(ConstantValues.SCORE_MASTERSCALE)) == null 
                ) {
                  continue;
                }
                partyObj.Credit_Score__c = Decimal.valueOf(
                  ((String)((Map<String,Object>)eachScore).get(ConstantValues.SCORE_MASTERSCALE))
                );
              }
            }
          }else if(
            productData!=null &&
            ((Object)productData.get(ConstantValues.SCORE_DATA))!= null &&
            String.valueOf(
              productData
            ).contains(ConstantValues.SCORE_DATA_OBJECT)
          ){
            Object eachScore =((Object)((Map<String,Object>)productData.get(ConstantValues.SCORE_DATA)).get('score'));
            if (
              ((Map<String,Object>)eachScore) != null ||
              ((Map<String,Object>)((Map<String,Object>)eachScore).get(ConstantValues.SCORECARD)) != null ||
              (String)((Map<String,Object>)((Map<String,Object>)eachScore).get(ConstantValues.SCORECARD))
              .get(ConstantValues.SCORECARD_ID) != null
            ) {
              String scoreCardIdVal = (String)((Map<String,Object>)((Map<String,Object>)eachScore).get(ConstantValues.SCORECARD))
                  .get(ConstantValues.SCORECARD_ID);
              if (
                scoreCardIdVal.equalsIgnoreCase('VSA_2.0_XY_NR') ||
                scoreCardIdVal.equalsIgnoreCase('CCAI_2.0_YX_NR')
              ) {
                if (
                  ((Map<String,Object>)eachScore) != null ||
                ((String)((Map<String,Object>)eachScore).get(ConstantValues.SCORE_MASTERSCALE)) != null 
                ) {
                  partyObj.Credit_Score__c = Decimal.valueOf(
                  ((String)((Map<String,Object>)eachScore).get(ConstantValues.SCORE_MASTERSCALE))
                );
                }
                
              }
            }
            
          }
          if(
            productHeader!=null &&
            ((Map<String,Object>)productHeader.get(ConstantValues.PERMISSION_TYPE))!= null
          ) {
            partyObj.Permission_Type__c = ((String)((Map<String,Object>)productHeader.get(ConstantValues.PERMISSION_TYPE)).get(ConstantValues.ELE_TEXT));
          }
          if (
            productHeader!=null &&
            ((String)productHeader.get(ConstantValues.DATETIME_REQUESTED)) != null
          ) {
            String reportCreateDate = ((String)productHeader.get(ConstantValues.DATETIME_REQUESTED));
            if (reportCreateDate != null && reportCreateDate.length() > 9) {
              partyObj.Report_Created_Date__c = Date.newInstance(
                Integer.valueOf(reportCreateDate.substring(0, 4)),
                Integer.valueOf(reportCreateDate.substring(5, 7)),
                Integer.valueOf(reportCreateDate.substring(8, 10))
              );
            }
          }
          if (
            enquiryReport!=null &&
            ((Object) enquiryReport.get(ConstantValues.EMPLOYMENT)) !=
            null &&
            String.valueOf(
              enquiryReport
            ).contains(ConstantValues.EMPLOYMENT_ARRAY)
          ) {
            List<Object> employmentList=((List<Object>) enquiryReport.get(ConstantValues.EMPLOYMENT));
            for(object eachEmployment:employmentList){
              if(
                ((Map<String,Object>)eachEmployment)!=null &&
                ((String)((Map<String,Object>)eachEmployment).get(ConstantValues.NAME_KEY))!=null
              ){
                partyObj.Employer__c = ((String)((Map<String,Object>)eachEmployment).get(ConstantValues.NAME_KEY));
              }
            }
            
          }else if (
            enquiryReport!=null &&
            ((Object) enquiryReport.get(ConstantValues.EMPLOYMENT)) !=
            null &&
            String.valueOf(
              enquiryReport
            ).contains(ConstantValues.EMPLOYMENT_OBJECT)
          ) {
            Object eachEmployment=((Object)((Map<String,Object>) enquiryReport.get(ConstantValues.EMPLOYMENT))
                    .get(ConstantValues.EMPLOYER));
            if(
              ((Map<String,Object>)eachEmployment)!=null &&
              ((String)((Map<String,Object>)eachEmployment).get(ConstantValues.NAME_KEY))!=null
            ){
              partyObj.Employer__c = ((String)((Map<String,Object>)eachEmployment).get(ConstantValues.NAME_KEY));
            }
          }
          if (
            enquiryReport!=null &&
            ((Object) enquiryReport.get(ConstantValues.ADDRESSES)) !=
            null && String.valueOf(
              enquiryReport
            ).contains(ConstantValues.ADDRESSES_ARRAY)
          ) {
            List<Object> addressList = ((List<Object>) enquiryReport.get(ConstantValues.ADDRESSES));
            for (Object eachAddress : addressList) {
              if (
                ((Map<String,Object>)eachAddress)!=null &&
                ((String)((Map<String,Object>)eachAddress).get(ConstantValues.TYPE))!=null &&
                ((String)((Map<String,Object>)eachAddress).get(ConstantValues.TYPE))=='C'
              ) {
                partyObj.Individual_Address__c = processAddress(((Map<String,Object>)eachAddress));
                break;
              }
            }
          }else if(
            enquiryReport!=null &&
            ((Object) enquiryReport.get(ConstantValues.ADDRESSES)) !=
            null && String.valueOf(
              enquiryReport
            ).contains(ConstantValues.ADDRESSES_OBJECT)
          ){
            Object eachAddress = ((Object)((Map<String,Object>) enquiryReport.get(ConstantValues.ADDRESSES)).get(ConstantValues.ADDRESS));
            if (
              ((Map<String,Object>)eachAddress)!=null &&
              ((String)((Map<String,Object>)eachAddress).get(ConstantValues.TYPE))!=null &&
              ((String)((Map<String,Object>)eachAddress).get(ConstantValues.TYPE))=='C'
            ) {
              partyObj.Individual_Address__c = processAddress(((Map<String,Object>)eachAddress));
              
            }
          }
          if (
            productData!=null &&
            ((Map<String,Object>)((Map<String,Object>)productData).get(ConstantValues.POSSIBLE_MATCHES)) !=
            null &&
            ((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)productData).get(ConstantValues.POSSIBLE_MATCHES))
            .get(ConstantValues.POSSIBLE_MATCH))!=null
          ) {
            possibleMatchData = ((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)productData).get(ConstantValues.POSSIBLE_MATCHES)).get(ConstantValues.POSSIBLE_MATCH));
            partyObj.Possibly_matched_data__c = processPossiblyMatchedData(
              possibleMatchData
            );
          }
          List<Current_Directorship__c> directorships = [
              SELECT Id, Party__c
              FROM Current_Directorship__c
              WHERE Party__c = :partyObj.Id
            ];
          Database.delete(directorships, false);
          directorships=new List<Current_Directorship__c>();
          try{
            if (
              publicReport!=null &&
              ((Object)publicReport.get(
                ConstantValues.DIRECTORSHIPS
              )) != null && String.valueOf(
                publicReport
              ).contains(ConstantValues.DIRECTORSHIPS_ARRAY)
            ) {
              List<Object> refDirShip = ((List<Object>) publicReport.get(
                ConstantValues.DIRECTORSHIPS
              ));
              for (Object eachDirectorship : refDirShip) {
                if(((String) ((Map<String, Object>) eachDirectorship).get(ConstantValues.TYPE))=='C'){
                  Current_Directorship__c currDirector=new Current_Directorship__c();
                  currDirector.Directorship_Type__c = 'Current';
                  currDirector.Party__c=partyObj.id;
                  if (
                    ((Map<String, Object>) eachDirectorship) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                      .get(ConstantValues.ORGANISATION)) != null
                  ){
                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.NAME_KEY)) != null)
                    currDirector.Org_Name__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                        .get(ConstantValues.ORGANISATION)).get(ConstantValues.NAME_KEY));
                  
                    if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.TYPE)) != null
                    && ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.TYPE)).get(ConstantValues.ELE_TEXT)) != null)
                    currDirector.Org_Name__c+=' '+((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                        .get(ConstantValues.ORGANISATION)).get(ConstantValues.TYPE)).get(ConstantValues.ELE_TEXT));
                
                    if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.status)) !=null && 
                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT)) != null )
                    currDirector.Company_Status__c=((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                        .get(ConstantValues.ORGANISATION)).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                  
                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.DIRECTORSHIPS_ABN)) != null)
                    currDirector.ABN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get(ConstantValues.ORGANISATION))
                        .get(ConstantValues.DIRECTORSHIPS_ABN));

                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)).get(ConstantValues.ORGANISATION_NUMBER)) != null)
                    currDirector.ACN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get(ConstantValues.ORGANISATION)).get(ConstantValues.ORGANISATION_NUMBER));
                  
                  }
                  directorships.add(currDirector);
                }
              }
            }else if(
              publicReport!=null &&
              ((Object)publicReport.get(
                ConstantValues.DIRECTORSHIPS
              )) != null && String.valueOf(
                publicReport
              ).contains(ConstantValues.DIRECTORSHIPS_OBJECT)
            ){
              Object eachDirectorship = ((Object)((Map<String, Object>) publicReport.get(ConstantValues.DIRECTORSHIPS)).get(ConstantValues.DIRECTORSHIP));
              if(((String) ((Map<String, Object>) eachDirectorship).get(ConstantValues.TYPE))=='C'){
                Current_Directorship__c currDirector=new Current_Directorship__c();
                currDirector.Directorship_Type__c = 'Current';
                currDirector.Party__c=partyObj.id;
                if (
                  ((Map<String, Object>) eachDirectorship) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get(ConstantValues.ORGANISATION)) != null
                ){
                  if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.NAME_KEY)) != null)
                  currDirector.Org_Name__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get(ConstantValues.ORGANISATION))
                      .get(ConstantValues.NAME_KEY));
                
                  if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.TYPE)) != null
                  && ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.TYPE)).get(ConstantValues.ELE_TEXT)) != null)
                  currDirector.Org_Name__c+=' '+((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                      .get(ConstantValues.ORGANISATION)).get(ConstantValues.TYPE)).get(ConstantValues.ELE_TEXT));
              
                  if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.status)) !=null && 
                  ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT)) != null )
                  currDirector.Company_Status__c=((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                      .get(ConstantValues.ORGANISATION)).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                
                  if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.DIRECTORSHIPS_ABN)) != null)
                  currDirector.ABN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get(ConstantValues.ORGANISATION))
                      .get(ConstantValues.DIRECTORSHIPS_ABN));

                  if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get(ConstantValues.ORGANISATION)).get(ConstantValues.ORGANISATION_NUMBER)) != null)
                  currDirector.ACN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get(ConstantValues.ORGANISATION))
                      .get(ConstantValues.ORGANISATION_NUMBER));
                
                }
                directorships.add(currDirector);
              }
            }else{
              returnValue+='\n'+ ConstantValues.NO_DIRECTORSHIPS;
            }
          }catch(Exception ex){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              ex
            );
          }
          try{
            if (
              publicReport!=null &&
              ((Object) publicReport.get(
                ConstantValues.DISQUALIFIED_DIRECTORSHIPS
              ))!=null &&
              String.valueOf(publicReport).contains(ConstantValues.DISQUALIFIED_DIRECTORSHIPS_ARRAY) 
            ) {
              List<Object> refDisqDirShip = ((List<Object>)publicReport.get(
                ConstantValues.DISQUALIFIED_DIRECTORSHIPS
              ));
              for (Object eachDisqualified : refDisqDirShip) {      
                Current_Directorship__c refDirShip = new Current_Directorship__c();
                refDirShip.Directorship_Type__c = 'Disqualified';
                refDirShip.Party__c = partyObj.Id;
                if (
                  ((Map<String, Object>) eachDisqualified) != null &&
                  ((String) ((Map<String, Object>) eachDisqualified)
                    .get(ConstantValues.DATE_DISQUALIFIED)) != null
                ) {
                  String reportCreateDate =((String) ((Map<String, Object>) eachDisqualified).get(ConstantValues.DATE_DISQUALIFIED));
                  if (reportCreateDate != null && reportCreateDate.length() > 9) {
                    refDirShip.Date_Disqualified__c = Date.newInstance(
                      Integer.valueOf(reportCreateDate.substring(0, 4)),
                      Integer.valueOf(reportCreateDate.substring(5, 7)),
                      Integer.valueOf(reportCreateDate.substring(8, 10))
                    );
                  }
                }
                if (
                  ((Map<String, Object>) eachDisqualified) != null &&
                  ((String) ((Map<String, Object>) eachDisqualified)
                    .get(ConstantValues.DATE_DISQUALIFIED_UNTIL)) != null
                ) {
                  String reportCreateDate =((String) ((Map<String, Object>) eachDisqualified).get(ConstantValues.DATE_DISQUALIFIED_UNTIL));
                  if (reportCreateDate != null && reportCreateDate.length() > 9) {
                    refDirShip.Date_disqualified_until__c = Date.newInstance(
                      Integer.valueOf(reportCreateDate.substring(0, 4)),
                      Integer.valueOf(reportCreateDate.substring(5, 7)),
                      Integer.valueOf(reportCreateDate.substring(8, 10))
                    );
                  }
                }
                directorships.add(refDirShip);
              }
            }else if(
              publicReport!=null &&
              ((Object) publicReport.get(
                ConstantValues.DISQUALIFIED_DIRECTORSHIPS
              ))!=null &&
              String.valueOf(publicReport).contains(ConstantValues.DISQUALIFIED_DIRECTORSHIPS_OBJECT)  
            ){
              Object refDisqDirShip = ((Object)((Map<String, Object>) ((Map<String, Object>)publicReport).get(
                ConstantValues.DISQUALIFIED_DIRECTORSHIPS
              )).get(ConstantValues.DISQUALIFIED_DIRECTORSHIP));
              Current_Directorship__c refDirShip = new Current_Directorship__c();
              refDirShip.Directorship_Type__c = 'Disqualified';
              refDirShip.Party__c = partyObj.Id;
              if (
                ((Map<String, Object>) refDisqDirShip) != null &&
                ((String) ((Map<String, Object>) refDisqDirShip)
                  .get(ConstantValues.DATE_DISQUALIFIED)) != null
              ) {
                String reportCreateDate =((String) ((Map<String, Object>) refDisqDirShip).get(ConstantValues.DATE_DISQUALIFIED));
                if (reportCreateDate != null && reportCreateDate.length() > 9) {
                  refDirShip.Date_Disqualified__c = Date.newInstance(
                    Integer.valueOf(reportCreateDate.substring(0, 4)),
                    Integer.valueOf(reportCreateDate.substring(5, 7)),
                    Integer.valueOf(reportCreateDate.substring(8, 10))
                  );
                }
              }
              
              if (
                ((Map<String, Object>) refDisqDirShip) != null &&
                ((String) ((Map<String, Object>) refDisqDirShip)
                  .get(ConstantValues.DATE_DISQUALIFIED_UNTIL)) != null
              ) {
                String reportCreateDate =((String) ((Map<String, Object>) refDisqDirShip).get(ConstantValues.DATE_DISQUALIFIED_UNTIL));
                if (reportCreateDate != null && reportCreateDate.length() > 9) {
                  refDirShip.Date_disqualified_until__c = Date.newInstance(
                    Integer.valueOf(reportCreateDate.substring(0, 4)),
                    Integer.valueOf(reportCreateDate.substring(5, 7)),
                    Integer.valueOf(reportCreateDate.substring(8, 10))
                  );
                }
              }
              directorships.add(refDirShip);
            }else{
              returnValue+=ConstantValues.NO_DISQUALIFIED_DIRECTORSHIP_FOUND;
            }
          }catch(Exception ex){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              ex
            );
          }
          List<Credit_Enquiry__c> creditEnquiries = [
                                              SELECT Id, Party__c
                                              FROM Credit_Enquiry__c
                                              WHERE Party__c = :partyObj.Id
                                            ];
          Database.delete(creditEnquiries, false);
          creditEnquiries=new List<Credit_Enquiry__c>();
          try{
            if (
              consumerCredit!=null &&
              ((Object) consumerCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              ))!=null && String.valueOf(consumerCredit).contains(ConstantValues.CREDIT_ENQUIRIES_ARRAY)
            ) {
              List<Object> refCreditEnq = ((List<Object>) consumerCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              ));
              for (Object eachCredit : refCreditEnq) {
                Credit_Enquiry__c creditEnquiryObj;
                creditEnquiryObj = new Credit_Enquiry__c();
                creditEnquiryObj.Party__c = partyObj.Id;
                creditEnquiryObj.Credit_Enquiry_Type__c = ConstantValues.CONSUMER;
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_DATE)) != null
                ){
                  String dateString = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_DATE));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date enqDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    creditEnquiryObj.Enquiry_Date__c = enqDate;
                  }
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT)) != null
                ){
                  creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                      .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.CREDIT_ENQUIRER)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY)) != null
                ){
                  creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                      .get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_AMOUNT)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)) != null
                ){
                  creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                      .get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE)) != null
                ) {
                  Integer codeValue = Integer.valueOf(
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP))
                    .get(ConstantValues.CODE))
                  );
                  switch on codeValue {
                    when 1 {
                      creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_SOLE;
                    }
                    when 2 {
                      creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_JOINT;
                    }
                    when 3 {
                      creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.GUARANTOR;
                    }
                  }
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_CLIENT)) !=null
                ) {
                  creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_CLIENT));
                }
                creditEnquiries.add(creditEnquiryObj);
              }
            }else if (
              consumerCredit!=null &&
              ((Object) consumerCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              ))!=null && String.valueOf(consumerCredit).contains(ConstantValues.CREDIT_ENQUIRIES_OBJECT)
            ) {
              Object eachCredit = ((Object)((Map<String, Object>)consumerCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              )).get(ConstantValues.CREDIT_ENQUIRY));
              Credit_Enquiry__c creditEnquiryObj;
              creditEnquiryObj = new Credit_Enquiry__c();
              creditEnquiryObj.Party__c = partyObj.Id;
              creditEnquiryObj.Credit_Enquiry_Type__c = ConstantValues.CONSUMER;
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_DATE)) != null
              ){
                String dateString = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_DATE));
                if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                  Date enqDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditEnquiryObj.Enquiry_Date__c = enqDate;
                }
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT)) != null
              ){
                creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.CREDIT_ENQUIRER)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY)) != null
              ){
                creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_AMOUNT)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)) != null
              ){
                creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE)) != null
              ) {
                Integer codeValue = Integer.valueOf(
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE))
                );
                switch on codeValue {
                  when 1 {
                    creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_SOLE;
                  }
                  when 2 {
                    creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_JOINT;
                  }
                  when 3 {
                    creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.GUARANTOR;
                  }
                }
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_CLIENT)) !=null
              ) {
                creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_CLIENT));
              }
            
              creditEnquiries.add(creditEnquiryObj);
            }else{
              returnValue+=ConstantValues.NO_CONSUMER_CREDIT_ENQUIRIES_FOUND;
            }
          }catch(Exception ex){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              ex
            );
          }
          try{
            if (
              commercialCredit!=null &&
              ((Object) commercialCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              ))!=null && String.valueOf(
                commercialCredit
              ).contains(ConstantValues.CREDIT_ENQUIRIES_ARRAY)
            ) {
              List<Object> refCreditEnq = ((List<Object>) commercialCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              ));
              for (Object eachCredit : refCreditEnq) {
                Credit_Enquiry__c creditEnquiryObj;
                creditEnquiryObj = new Credit_Enquiry__c();
                creditEnquiryObj.Party__c = partyObj.Id;
                creditEnquiryObj.Credit_Enquiry_Type__c = ConstantValues.COMMERCIAL;
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_DATE)) != null
                ){
                  String dateString = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_DATE));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date enqDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    creditEnquiryObj.Enquiry_Date__c = enqDate;
                  }
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT)) != null
                ){
                  creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.CREDIT_ENQUIRER)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY)) != null
                ){
                  creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_AMOUNT)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)) != null
                ){
                  creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE)) != null
                ) {
                  Integer codeValue = Integer.valueOf(
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE))
                  );
                  switch on codeValue {
                    when 1 {
                      creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_SOLE;
                    }
                    when 2 {
                      creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_JOINT;
                    }
                    when 3 {
                      creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.GUARANTOR;
                    }
                  }
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ENQUIRY_CLIENT)) !=null
                ) {
                  creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_CLIENT));
                }
                creditEnquiries.add(creditEnquiryObj);
              }
            }else if (
              commercialCredit!=null &&
              ((Object) commercialCredit.get(
                ConstantValues.CREDIT_ENQUIRIES
              ))!=null && String.valueOf(
                commercialCredit
              ).contains(ConstantValues.CREDIT_ENQUIRIES_OBJECT)
            ) {
              Object eachCredit = ((Object)((Map<String, Object>)commercialCredit.get(ConstantValues.CREDIT_ENQUIRIES)).get(ConstantValues.CREDIT_ENQUIRY));
              Credit_Enquiry__c creditEnquiryObj;
              creditEnquiryObj = new Credit_Enquiry__c();
              creditEnquiryObj.Party__c = partyObj.Id;
              creditEnquiryObj.Credit_Enquiry_Type__c = ConstantValues.COMMERCIAL;
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_DATE)) != null
              ){
                String dateString = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_DATE));
                if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                  Date enqDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditEnquiryObj.Enquiry_Date__c = enqDate;
                }
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT)) != null
              ){
                creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.CREDIT_ENQUIRER)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY)) != null
              ){
                creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.CREDIT_ENQUIRER)).get(ConstantValues.NAME_KEY));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_AMOUNT)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)) != null
              ){
                creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_AMOUNT)).get(ConstantValues.ELE_TEXT)));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE)) != null
              ) {
                Integer codeValue = Integer.valueOf(
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP)).get(ConstantValues.CODE))
                );
                switch on codeValue {
                  when 1 {
                    creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_SOLE;
                  }
                  when 2 {
                    creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.PRINCIPAL_JOINT;
                  }
                  when 3 {
                    creditEnquiryObj.Role_in_Enquiry__c = ConstantValues.GUARANTOR;
                  }
                }
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ENQUIRY_CLIENT)) !=null
              ) {
                creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ENQUIRY_CLIENT));
              }
              creditEnquiries.add(creditEnquiryObj);
            }else{
              returnValue+=ConstantValues.NO_COMMERCIAL_CREDIT_ENQUIRIES_FOUND;
            }
          }catch(Exception ex){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              ex
            );
          }
          List<Credit_Account__c> creditAccounts = [
                SELECT Id, Party__c
                FROM Credit_Account__c
                WHERE Party__c = :partyObj.Id
              ];
          Database.delete(creditAccounts, false);
          creditAccounts=new List<Credit_Account__c>();
          try{
            if(
              commercialCredit!=null &&
              ((Object) commercialCredit.get(
                ConstantValues.ACCOUNTS
              ))!=null && String.valueOf(
                commercialCredit
              ).contains(ConstantValues.ACCOUNTS_ARRAY)
            ) {
              List<Object> refCreditAccount=((List<Object>) commercialCredit.get(ConstantValues.ACCOUNTS));
              for(Object eachCredit:refCreditAccount){
                Credit_Account__c creditAccountObj;
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = ConstantValues.COMMERCIAL;
                if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_ID_ACCOUNT)) !=null){
                  creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_ID_ACCOUNT));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT))!=null
                ){
                  creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
                ) {
                  creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.LATEST_CREDIT_PROVIDER)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
                ) {
                  creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT))!=null
                ) {
                  creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT));
                }
                creditAccounts.add(creditAccountObj);
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_ARRAY)
                ){
                  List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST));
                  for(Object eachDefault:refDefault){
                    Payment_Default__c paymentDefaultObj;
                    paymentDefaultObj = new Payment_Default__c();
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                    ) {
                      paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT))
                      .get(ConstantValues.DATE_RECORDED))!=null
                    ) {
                      String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT))
                          .get(ConstantValues.DATE_RECORDED));
                      if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                        Date statusDate = Date.newInstance(
                          Integer.valueOf(dateString.subString(0, 4)),
                          Integer.valueOf(dateString.subString(5, 7)),
                          Integer.valueOf(dateString.subString(8, 10))
                        );
                        paymentDefaultObj.Status_Date__c = statusDate;
                      }
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT))
                      .get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT))
                      .get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                    ) {
                      paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                      );
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT))
                      .get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT))
                      .get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                    ) {
                      paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT))
                        .get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                      );
                    }
                    if (paymentDefaultObj != null) {
                      if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                        accountIdDefaultMap.put(
                          ConstantValues.COMMERCIAL + creditAccountObj.Account_Id__c,
                          paymentDefaultObj
                        );
                      }
                    }
                  }
                } else if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_OBJECT)
                ){
                  Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST)).get('default'));
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT))
                    .get(ConstantValues.DATE_RECORDED))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault)
                        .get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                    if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                      Date statusDate = Date.newInstance(
                        Integer.valueOf(dateString.subString(0, 4)),
                        Integer.valueOf(dateString.subString(5, 7)),
                        Integer.valueOf(dateString.subString(8, 10))
                      );
                      paymentDefaultObj.Status_Date__c = statusDate;
                    }
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault)
                    .get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault)
                    .get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault)
                      .get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault)
                    .get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault)
                      .get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        ConstantValues.COMMERCIAL + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              }
            }else if(
              commercialCredit!=null &&
              ((Object) commercialCredit.get(
                ConstantValues.ACCOUNTS
              ))!=null && String.valueOf(
                commercialCredit
              ).contains(ConstantValues.ACCOUNTS_OBJECT)
            ) {
              Object eachCredit=((Object)((Map<String, Object>) commercialCredit.get(ConstantValues.ACCOUNTS)).get(ConstantValues.ACCOUNT));
              Credit_Account__c creditAccountObj;
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = ConstantValues.COMMERCIAL;
              if(
              ((Map<String, Object>) eachCredit) != null &&
              ((String) ((Map<String, Object>) eachCredit)
              .get(ConstantValues.ACCOUNT_ID_ACCOUNT)) !=null){
                creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_ID_ACCOUNT));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT))!=null
              ){
                creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
              ) {
                creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.LATEST_CREDIT_PROVIDER)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
              ) {
                creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT))!=null
              ) {
                creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT));
              }
              creditAccounts.add(creditAccountObj);
              if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_ARRAY)
              ){
                List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST));
                for(Object eachDefault:refDefault){
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                    if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                      Date statusDate = Date.newInstance(
                        Integer.valueOf(dateString.subString(0, 4)),
                        Integer.valueOf(dateString.subString(5, 7)),
                        Integer.valueOf(dateString.subString(8, 10))
                      );
                      paymentDefaultObj.Status_Date__c = statusDate;
                    }
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        ConstantValues.COMMERCIAL + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              } else if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_OBJECT)
              ){
                Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST)).get('default'));
                Payment_Default__c paymentDefaultObj;
                paymentDefaultObj = new Payment_Default__c();
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                ) {
                  paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED))!=null
                ) {
                  String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){  
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    paymentDefaultObj.Status_Date__c = statusDate;
                  }
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                ) {
                  paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                  );
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                ) {
                  paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                  );
                }
                if (paymentDefaultObj != null) {
                  if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                    accountIdDefaultMap.put(
                      ConstantValues.COMMERCIAL + creditAccountObj.Account_Id__c,
                      paymentDefaultObj
                    );
                  }
                }
              }
            }else{
              returnValue+=ConstantValues.NO_COMMERCIAL_CREDIT_ACCOUNTS_FOUND;
            }
          }catch(Exception exe){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              exe
            );
          }
          try{
            if(
              consumerCredit!=null &&
              ((Object) consumerCredit.get(
                ConstantValues.ACCOUNTS
              ))!=null && 
              String.valueOf(
                consumerCredit)
              .contains(ConstantValues.ACCOUNTS_ARRAY)
            ) {
              List<Object> refCreditAccount=((List<Object>)consumerCredit.get(ConstantValues.ACCOUNTS));
              for(Object eachCredit:refCreditAccount){
                Credit_Account__c creditAccountObj;
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = ConstantValues.CONSUMER;
                if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_ID_ACCOUNT)) !=null){
                  creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_ID_ACCOUNT));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT))!=null
                ){
                  creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
                ) {
                  creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.LATEST_CREDIT_PROVIDER)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
                ) {
                  creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT))!=null
                ) {
                  creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT));
                }
                creditAccounts.add(creditAccountObj);
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_ARRAY)
                ){
                  List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST));
                  for(Object eachDefault:refDefault){
                    Payment_Default__c paymentDefaultObj;
                    paymentDefaultObj = new Payment_Default__c();
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                    ) {
                      paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED))!=null
                    ) {
                      String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                      if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                        Date statusDate = Date.newInstance(
                          Integer.valueOf(dateString.subString(0, 4)),
                          Integer.valueOf(dateString.subString(5, 7)),
                          Integer.valueOf(dateString.subString(8, 10))
                        );
                        paymentDefaultObj.Status_Date__c = statusDate;
                      }
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                    ) {
                      paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                      );
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                    ) {
                      paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                      );
                    }
                    if (paymentDefaultObj != null) {
                      if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                        accountIdDefaultMap.put(
                          ConstantValues.CONSUMER + creditAccountObj.Account_Id__c,
                          paymentDefaultObj
                        );
                      }
                    }
                  }
                } else if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_OBJECT)
                ){
                  Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST)).get('default'));
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                    if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                      Date statusDate = Date.newInstance(
                        Integer.valueOf(dateString.subString(0, 4)),
                        Integer.valueOf(dateString.subString(5, 7)),
                        Integer.valueOf(dateString.subString(8, 10))
                      );
                      paymentDefaultObj.Status_Date__c = statusDate;
                    }
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        ConstantValues.CONSUMER + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              }
            }else if(
              consumerCredit!=null &&
              ((Object) consumerCredit.get(
                ConstantValues.ACCOUNTS
              ))!=null && 
              String.valueOf(
                consumerCredit)
              .contains(ConstantValues.ACCOUNTS_OBJECT)
            ){
              Object eachCredit=((Object)((Map<String,Object>)consumerCredit.get(ConstantValues.ACCOUNTS)).get(ConstantValues.ACCOUNT));
              Credit_Account__c creditAccountObj;
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = ConstantValues.CONSUMER;
              if(
              ((Map<String, Object>) eachCredit) != null &&
              ((String) ((Map<String, Object>) eachCredit)
              .get(ConstantValues.ACCOUNT_ID_ACCOUNT)) !=null){
                creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_ID_ACCOUNT));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT))!=null
              ){
                creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.ELE_TEXT));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
              ) {
                creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.ORIGINAL_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.LATEST_CREDIT_PROVIDER)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY))!=null
              ) {
                creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.LATEST_CREDIT_PROVIDER)).get(ConstantValues.NAME_KEY));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT))!=null
              ) {
                creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.RELATIONSHIP)).get(ConstantValues.ELE_TEXT));
              }
              creditAccounts.add(creditAccountObj);
              if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_ARRAY)
              ){
                List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST));
                for(Object eachDefault:refDefault){
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                    if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                      Date statusDate = Date.newInstance(
                        Integer.valueOf(dateString.subString(0, 4)),
                        Integer.valueOf(dateString.subString(5, 7)),
                        Integer.valueOf(dateString.subString(8, 10))
                      );
                      paymentDefaultObj.Status_Date__c = statusDate;
                    }
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        ConstantValues.CONSUMER + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              } else if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get(ConstantValues.DEFAULTS_LIST)) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains(ConstantValues.DEFAULT_OBJECT)
              ){
                Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get(ConstantValues.DEFAULTS_LIST)).get('default'));
                Payment_Default__c paymentDefaultObj;
                paymentDefaultObj = new Payment_Default__c();
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT))!=null
                ) {
                  paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED))!=null
                ) {
                  String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DATE_RECORDED));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    paymentDefaultObj.Status_Date__c = statusDate;
                  }
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                ) {
                  paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.CURRENT_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                  );
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT)) !=null
                ) {
                  paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get(ConstantValues.ORIGINAL_DEFAULT)).get(ConstantValues.DEFAULT_AMOUNT)).get(ConstantValues.ELE_TEXT))
                  );
                }
                if (paymentDefaultObj != null) {
                  if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                    accountIdDefaultMap.put(
                      ConstantValues.CONSUMER + creditAccountObj.Account_Id__c,
                      paymentDefaultObj
                    );
                  }
                }
              }
            }else{
              returnValue+=ConstantValues.NO_CONSUMER_CREDIT_ACCOUNTS_FOUND;
            }
          }catch(Exception exe){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              exe
            );
          }
          Database.update(partyObj,false);
          Database.insert(directorships,false);
          Database.insert(creditEnquiries,false);
          Database.insert(creditAccounts,false);
          for (Credit_Account__c eachCreditAccount : creditAccounts) {
            if (String.isNotBlank(eachCreditAccount.Account_Id__c)) {
              accountIdIdMap.put(
                eachCreditAccount.Credit_Account_Type__c +
                eachCreditAccount.Account_Id__c,
                eachCreditAccount.Id
              );
            }
          }
          for (String key : accountIdDefaultMap.keySet()) {
            Payment_Default__c paymentDefaultObj = accountIdDefaultMap.get(key);
            paymentDefaultObj.Credit_Account__c = accountIdIdMap.get(key);
            paymentDefaults.add(paymentDefaultObj);
          }
          Database.insert(paymentDefaults, false);
          creditAccounts = new List<Credit_Account__c>();
          try {
            if(
              publicRecordOrConsumerCreditInformation!=null &&
              ((Object)publicRecordOrConsumerCreditInformation.get(ConstantValues.COURT_ACTIONS)) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains(ConstantValues.COURT_ACTIONS_ARRAY)
            ){
              List<Object> courtActionList=((List<Object>)publicRecordOrConsumerCreditInformation.get(ConstantValues.COURT_ACTIONS));
              for(Object eachCourtAction:courtActionList){
                Credit_Account__c creditAccountObj;
                String courtActionType;
                if (String.isBlank(((String)((Map<String,Object>)eachCourtAction).get(ConstantValues.TYPE)))) {
                  continue;
                } else if (((String)((Map<String,Object>)eachCourtAction).get(ConstantValues.TYPE)) == ConstantValues.DEFAULT_JUDGEMENT) {
                  courtActionType = ConstantValues.DEFAULT_JUDGEMENTS;
                } else {
                  courtActionType = ConstantValues.OTHER_COURT_ACTIONS;
                }
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = courtActionType;
                if (
                    ((Map<String, Object>) eachCourtAction) != null &&
                    ((String) ((Map<String, Object>) eachCourtAction)
                      .get(ConstantValues.CREDITOR)) != null
                ){
                  creditAccountObj.Relationship__c =((String) ((Map<String, Object>) eachCourtAction).get(ConstantValues.CREDITOR));
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((String) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.ACTION_DATE)) != null
                ) {
                  String dateString =((String) ((Map<String, Object>) eachCourtAction).get(ConstantValues.ACTION_DATE));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    creditAccountObj.Default_Date__c = statusDate;
                  }
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_AMOUNT))!=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_AMOUNT)).get(ConstantValues.ELE_TEXT)) != null
                ) {
                  creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction).get(ConstantValues.COURT_ACTION_AMOUNT))
                        .get(ConstantValues.ELE_TEXT))
                  );
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((String) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.PLAINT_NUMBER)) != null
                ) {
                  creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCourtAction).get(ConstantValues.PLAINT_NUMBER));
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_STATUS)) != null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.ELE_TEXT)) != null
                ) {
                  creditAccountObj.Status__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_STATUS)) != null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.DATE_COURT)) != null
                  ) {
                  String dateString = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.DATE_COURT));
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Status_Date__c = statusDate;
                }
                if (creditAccountObj != null) {
                  creditAccounts.add(creditAccountObj);
                }
              }
            }else if(
              publicRecordOrConsumerCreditInformation!=null &&
              ((Object)publicRecordOrConsumerCreditInformation.get(ConstantValues.COURT_ACTIONS)) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains(ConstantValues.COURT_ACTIONS_OBJECT)
            ){
              Object eachCourtAction=((Object)((Map<String,Object>)publicRecordOrConsumerCreditInformation.get(ConstantValues.COURT_ACTIONS)).get('court-action'));
              Credit_Account__c creditAccountObj;
              String courtActionType;
              if (((String)((Map<String,Object>)eachCourtAction).get(ConstantValues.TYPE)) == ConstantValues.DEFAULT_JUDGEMENT) {
                courtActionType = ConstantValues.DEFAULT_JUDGEMENTS;
              } else {
                courtActionType = ConstantValues.OTHER_COURT_ACTIONS;
              }
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = courtActionType;
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((String) ((Map<String, Object>) eachCourtAction)
                  .get(ConstantValues.CREDITOR)) != null
              ){
                creditAccountObj.Relationship__c =((String) ((Map<String, Object>) eachCourtAction).get(ConstantValues.CREDITOR));
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((String) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.ACTION_DATE)) != null
              ) {
                String dateString =((String) ((Map<String, Object>) eachCourtAction).get(ConstantValues.ACTION_DATE));
                if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Default_Date__c = statusDate;
                }
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_AMOUNT))!=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_AMOUNT)).get(ConstantValues.ELE_TEXT)) != null
              ) {
                creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction).get(ConstantValues.COURT_ACTION_AMOUNT)).get(ConstantValues.ELE_TEXT))
                );
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((String) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.PLAINT_NUMBER)) != null
              ) {
                creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCourtAction).get(ConstantValues.PLAINT_NUMBER));
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_STATUS)) != null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.ELE_TEXT)) != null
              ) {
                creditAccountObj.Status__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.ELE_TEXT));
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_STATUS)) != null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.DATE_COURT)) != null
                ) {
                String dateString = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get(ConstantValues.COURT_ACTION_STATUS)).get(ConstantValues.DATE_COURT));
                if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Status_Date__c = statusDate;
                }
              }
              if (creditAccountObj != null) {
                creditAccounts.add(creditAccountObj);
              }
              
            }else{
              returnValue+=ConstantValues.NO_DEFAULT_JUDGEMENT_COURT_ACTION;
            }
          }catch(Exception exe){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              exe
            );
          }
          try{
            if(
              publicRecordOrConsumerCreditInformation!=null &&
              ((Object)publicRecordOrConsumerCreditInformation.get(ConstantValues.PERSONAL_INSOLVENCIES_LIST)) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains(ConstantValues.PERSONAL_INSOLVENCIES_ARRAY)
            ){
              List<Object> personalInsolvencyList=((List<Object>)publicRecordOrConsumerCreditInformation.get(ConstantValues.PERSONAL_INSOLVENCIES_LIST));
              for(Object eachPersonalInsolvency:personalInsolvencyList){
                Credit_Account__c creditAccountObj;
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = ConstantValues.PERSONAL_INSOLVENCIES;
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TYPE))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TYPE))
                  .get(ConstantValues.ELE_TEXT))!=null
                ) {
                  creditAccountObj.Account_Type__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                  .get(ConstantValues.TYPE)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TEXT))!=null
                ) {
                  creditAccountObj.Relationship__c = ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TEXT));
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))
                  .get(ConstantValues.ELE_TEXT))!=null
                ) {
                  creditAccountObj.Status__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                  .get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))
                  .get(ConstantValues.DATE_COURT))!=null
                ) {
                  String dateString =  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                      .get(ConstantValues.status)).get(ConstantValues.DATE_COURT));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    creditAccountObj.Status_Date__c = statusDate;
                  }
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((String)((Map<String,Object>)eachPersonalInsolvency).get('status-date'))!=null
                ) {
                  String dateString =  ((String)((Map<String,Object>)eachPersonalInsolvency).get('status-date'));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    creditAccountObj.Status_Date__c = statusDate;
                  }
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.DATE_DECLARED))!=null
                ) {
                  String dateString = ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.DATE_DECLARED));
                  if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    creditAccountObj.Default_Date__c = statusDate;
                  }
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.ADMINISTRATION_ID))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.ADMINISTRATION_ID))
                  .get(ConstantValues.NUMBER_PERSONAL))!=null
                ) {
                  creditAccountObj.Account_Id__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                      .get(ConstantValues.ADMINISTRATION_ID)).get(ConstantValues.NUMBER_PERSONAL));
                }
                if (creditAccountObj != null) {
                  creditAccounts.add(creditAccountObj);
                }
              }
            }else if(
              publicRecordOrConsumerCreditInformation!=null &&
              ((Object)publicRecordOrConsumerCreditInformation.get(ConstantValues.PERSONAL_INSOLVENCIES_LIST)) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains(ConstantValues.PERSONAL_INSOLVENCIES_OBJECT)
            ){
              Object eachPersonalInsolvency=((Object)((Map<String,Object>)publicRecordOrConsumerCreditInformation.get(ConstantValues.PERSONAL_INSOLVENCIES_LIST)).get('personal-insolvency'));
            
              Credit_Account__c creditAccountObj;
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = ConstantValues.PERSONAL_INSOLVENCIES;
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TYPE))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TYPE))
                .get(ConstantValues.ELE_TEXT))!=null
              ) {
                creditAccountObj.Account_Type__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                .get(ConstantValues.TYPE)).get(ConstantValues.ELE_TEXT));
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TEXT))!=null
              ) {
                creditAccountObj.Relationship__c = ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.TEXT));
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))
                .get(ConstantValues.ELE_TEXT))!=null
              ) {
                creditAccountObj.Status__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                    .get(ConstantValues.status)).get(ConstantValues.ELE_TEXT));
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.status))
                .get(ConstantValues.DATE_COURT))!=null
              ) {
                String dateString =  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency)
                    .get(ConstantValues.status)).get(ConstantValues.DATE_COURT));
                if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Status_Date__c = statusDate;
                }
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.DATE_DECLARED))!=null
              ) {
                String dateString = ((String)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.DATE_DECLARED));
                if(dateString!=NULL && dateString.length()!=0 && dateString.length()>=10){
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Default_Date__c = statusDate;
                }
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.ADMINISTRATION_ID))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.ADMINISTRATION_ID)).get(ConstantValues.NUMBER_PERSONAL))!=null
              ) {
                creditAccountObj.Account_Id__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get(ConstantValues.ADMINISTRATION_ID)).get(ConstantValues.NUMBER_PERSONAL));
              }
              if (creditAccountObj != null) {
                creditAccounts.add(creditAccountObj);
              }
            }else{
              returnValue+=ConstantValues.NO_PERSONAL_INSOLVENCIES_FOUND;
            }

          }catch(Exception exe){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              exe
            );
          }
          Database.insert(creditAccounts,false);
          partyId = partyObj.Id;
          partyObj.Number_of_Credit_Enquiries_in_Last_12_Mo__c = Database.countQuery(
            'SELECT count() FROM Credit_Enquiry__c WHERE Difference_In_Months__c <= 12 AND Party__c =:partyId'
          );
          Database.update(partyObj);
          if (!Test.isRunningTest()) {
            Database.executeBatch(new EquifaxOrgIdSearchBatch(), 1);
          }
          return returnValue;  
        }catch(Exception exe){
            GenericUtility.insertLog(
              'EquifaxIndividualResponseHelper',
              exe
            );
          return ConstantValues.GENERAL_ERROR;
        }
    }
    private static void clearPartyObjectData(clcommon__Party__c partyObj) {
      partyObj.Request_Id__c = null;
      partyObj.Report_Created_Date__c = null;
      partyObj.Permission_Type__c = null;
      partyObj.Possibly_matched_data__c = null;
      partyObj.File_Number__c = null;
      partyObj.Age_of_Credit_File__c = null;
      partyObj.Adverse_on_file__c = null;
      partyObj.Consumer_Adverse_on_file__c = null;
      partyObj.Current_Directorships__c = null;
      partyObj.External_Administrators__c = null;
      partyObj.Number_of_bankrupt_on_file__c = null;
      partyObj.Number_of_bankrupt_on_file_in_last_84m__c = null;
      partyObj.Number_of_Discharged_Insolvencies__c = null;
      partyObj.Number_of_insolvencies_on_file__c = null;
      partyObj.Credit_Score__c = null;
      update partyObj;
    }
}