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
          ((String)((Map<String, Object>) summaryCheck).get('variable-name')) ==
          null
        ) {
          continue;
        }
        if (
          ((String) ((Map<String, Object>) summaryCheck)
              .get('variable-name')) == referenceValue
        ) {
          return ((Map<String, Object>) summaryCheck);
        }
      }
      return new Map<String, Object>();
    }
    public static String processAddress(Map<String, Object> address) {
      String res = '';
      if (((String)((Map<String, Object>) address).get('unit-number'))!= null) {
        res += ((String)((Map<String, Object>) address).get('unit-number'));
      }
      if (((String)((Map<String, Object>) address).get('street-number'))!= null){
        res += ' ' + ((String)((Map<String, Object>) address).get('street-number'));
      }
      if (((String)((Map<String, Object>) address).get('street-name')) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get('street-name'));
      }
      if (((String)((Map<String, Object>) address).get('street-type'))!= null){
        res += ' ' + ((String)((Map<String, Object>) address).get('street-type'));
      }
      if (((String)((Map<String, Object>) address).get('suburb')) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get('suburb'));
      }
      if (((String)((Map<String, Object>) address).get('state'))!= null){
        res += ' ' + ((String)((Map<String, Object>) address).get('state'));
      }
      if (((String)((Map<String, Object>) address).get('postcode')) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get('postcode'));
      }
      if (((String)((Map<String, Object>) address).get('country-code')) != null) {
        res += ' ' + (String) ((String)((Map<String, Object>) address).get('country-code'));
      }
      return res;
    }
    public static String processPossiblyMatchedData(
      Map<String,Object> possibleMatchData
    ) {
      String data = '';
      if ((Map<String,Object>)possibleMatchData != null 
          && ((Map<String,Object>)((Map<String,Object>)possibleMatchData).get('identity')) != null
      ) {
        if (((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData).get('identity')).get('individual-name')) != null) {
          if (
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('individual-name')).get('first-given-name')) != null 
            
          ) {
            data +=
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('individual-name')).get('first-given-name')) +
              ' ';
          }
          if (
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('individual-name')).get('other-given-name'))!=null
          ) {
            data +=
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('individual-name')).get('other-given-name')) +
              ' ';
          }
          if (
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('individual-name')).get('family-name'))!=null
          ) {
            data +=
            ((String)((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('individual-name')).get('family-name')) +
              ' ';
          }
        }
        if (
          ((String)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
            .get('identity')).get('date-of-birth'))!=null
        ) {
          data += '\nD.O.B : ' + ((String)((Map<String,Object>)((Map<String,Object>)possibleMatchData)
          .get('identity')).get('date-of-birth'));
        }
      }
      if (
        ((Map<String,Object>)possibleMatchData) != null 
          && ((Object)((Map<String,Object>)possibleMatchData).get('addresses')) != null &&
          String.valueOf(
            ((Map<String,Object>)possibleMatchData)
          ).contains('addresses=(')
      ) {
        data += '\nAddresses : ';
        List<Object> addressList=((List<Object>)((Map<String,Object>)possibleMatchData).get('addresses'));
        for (Object eachAddress : addressList) {
          data += processAddress(((Map<String,Object>) eachAddress)) + '\n';
        }
      }else if(
        ((Map<String,Object>)possibleMatchData) != null 
          && ((Object)((Map<String,Object>)possibleMatchData).get('addresses')) != null &&
          String.valueOf(
            ((Map<String,Object>)possibleMatchData)
          ).contains('addresses={')
      ){
        data += '\nAddresses : ';
        Object eachAddress=((Object)((Map<String,Object>)((Map<String,Object>)possibleMatchData).get('addresses')).get('address'));
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
            ((Map<String, Object>) response.get('Envelope')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) response.get(
              'Envelope'
            ))
            .get('Body')) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              'Envelope'
            ))
            .get('Body')).get('response')) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                'Envelope'
              )).get('Body')).get('response')).get('product-header')) != null

          ){
            productHeader=((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get('Envelope'
                      )).get('Body')).get('response')).get('product-header'));
          }
          if(
            ((Map<String, Object>) response.get('Envelope')) !=null &&
            ((Map<String, Object>) ((Map<String, Object>) response.get(
              'Envelope'
            ))
            .get('Body')) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              'Envelope'
            ))
            .get('Body')).get('response')) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                'Envelope'
              )).get('Body')).get('response')).get('product-data')) != null

          ){
            productData=((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get('Envelope'
                      )).get('Body')).get('response')).get('product-data'));
          }
          if(
            productData!=null && ((Map<String, Object>)productData.get('enquiry-report'))!=null
          ){
            enquiryReport=((Map<String, Object>)productData.get('enquiry-report'));
          }
          if(
            productData!=null && ((Map<String, Object>)productData.get('summary-data'))!=null
          ){
            summaryData=((Map<String, Object>)productData.get('summary-data'));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get('public-record-or-consumer-credit-information'))!=null
          ){
            publicReport=((Map<String, Object>)enquiryReport.get('public-record-or-consumer-credit-information'));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get('consumer-credit-file'))!=null
          ){
            consumerCredit=((Map<String, Object>)enquiryReport.get('consumer-credit-file'));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get('commercial-credit-file'))!=null
          ){
            commercialCredit=((Map<String, Object>)enquiryReport.get('commercial-credit-file'));
          }
          if(
            enquiryReport !=null && ((Map<String, Object>)enquiryReport.get('public-record-or-consumer-credit-information'))!=null
          ){
            publicRecordOrConsumerCreditInformation=((Map<String, Object>)enquiryReport.get('public-record-or-consumer-credit-information'));
          }
          if (summaryData != null &&
              ((List<Object>) summaryData
                .get('data-block')) != null
          ) {
              commonSumEntry = ((List<Object>)summaryData 
                .get('data-block'));
          }
          clearPartyObjectData(partyObj);
          if (
            enquiryReport!=null &&
            ((Map<String, Object>) enquiryReport.get('primary-match')) !=
            null &&
            ((String) ((Map<String, Object>)enquiryReport.get('primary-match')).get('bureau-reference'))!=NUll
          ) {
            partyObj.File_Number__c = ((String) ((Map<String, Object>)enquiryReport.get('primary-match')).get('bureau-reference'));
          }
          if(
            productHeader!=null &&
            ((String)productHeader.get('enquiry-id'))!= null
          ) {
            partyObj.Request_Id__c = ((String)productHeader.get('enquiry-id'));
          }
          system.debug('135-->'+commonSumEntry);
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.Age_of_Credit_File__c = Decimal.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')))
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              if(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text'))=='Y'){
                partyObj.Adverse_on_file__c = 'Yes';
              }else if(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text'))=='N'){
                partyObj.Adverse_on_file__c = 'No';
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              if(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text'))=='Y'){
                partyObj.Consumer_Adverse_on_file__c = 'Yes';
              }else if(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text'))=='N'){
                partyObj.Consumer_Adverse_on_file__c = 'No';
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.Current_Directorships__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')));
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.External_Administrators__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')));
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.Number_of_bankrupt_on_file__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')));
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.Number_of_bankrupt_on_file_in_last_84m__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')));
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.Number_of_Discharged_Insolvencies__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')));
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
                'value'
              )) != null &&
              (String) ((Map<String, Object>) tempSummaryEntry.get(
                'value'
                ))
                .get('ele_text') != null
            ) {
              partyObj.Number_of_insolvencies_on_file__c = Integer.valueOf(((String) ((Map<String, Object>) tempSummaryEntry.get('value')).get('ele_text')));
            }
          }
          if(
            productData!=null &&
            ((Object)productData.get('score-data'))!= null &&
            String.valueOf(
              productData
            ).contains('score-data=(')
          ){
            List<Object> scoreList =((List<Object>)productData.get('score-data'));
            for (Object eachScore : scoreList){
              if (
                ((Map<String,Object>)eachScore) == null ||
                ((Map<String,Object>)((Map<String,Object>)eachScore).get('scorecard')) == null ||
                (String)((Map<String,Object>)((Map<String,Object>)eachScore).get('scorecard')).get('id') == null
              ) {
                continue;
              }
              String scoreCardIdVal = (String)((Map<String,Object>)((Map<String,Object>)eachScore).get('scorecard')).get('id');
              if (
                scoreCardIdVal.equalsIgnoreCase('VSA_2.0_XY_NR') ||
                scoreCardIdVal.equalsIgnoreCase('CCAI_2.0_YX_NR')
              ) {
                if (
                  ((Map<String,Object>)eachScore) == null ||
                ((String)((Map<String,Object>)eachScore).get('score-masterscale')) == null 
                ) {
                  continue;
                }
                partyObj.Credit_Score__c = Decimal.valueOf(
                  ((String)((Map<String,Object>)eachScore).get('score-masterscale'))
                );
              }
            }
          }else if(
            productData!=null &&
            ((Object)productData.get('score-data'))!= null &&
            String.valueOf(
              productData
            ).contains('score-data={')
          ){
            Object eachScore =((Object)((Map<String,Object>)productData.get('score-data')).get('score'));
            if (
              ((Map<String,Object>)eachScore) != null ||
              ((Map<String,Object>)((Map<String,Object>)eachScore).get('scorecard')) != null ||
              (String)((Map<String,Object>)((Map<String,Object>)eachScore).get('scorecard')).get('id') != null
            ) {
              String scoreCardIdVal = (String)((Map<String,Object>)((Map<String,Object>)eachScore).get('scorecard')).get('id');
              if (
                scoreCardIdVal.equalsIgnoreCase('VSA_2.0_XY_NR') ||
                scoreCardIdVal.equalsIgnoreCase('CCAI_2.0_YX_NR')
              ) {
                if (
                  ((Map<String,Object>)eachScore) != null ||
                ((String)((Map<String,Object>)eachScore).get('score-masterscale')) != null 
                ) {
                  partyObj.Credit_Score__c = Decimal.valueOf(
                  ((String)((Map<String,Object>)eachScore).get('score-masterscale'))
                );
                }
                
              }
            }
            
          }
          if(
            productHeader!=null &&
            ((Map<String,Object>)productHeader.get('permission-type'))!= null
          ) {
            partyObj.Permission_Type__c = ((String)((Map<String,Object>)productHeader.get('permission-type')).get('ele_text'));
          }
          if (
            productHeader!=null &&
            ((String)productHeader.get('datetime-requested')) != null
          ) {
            String reportCreateDate = ((String)productHeader.get('datetime-requested'));
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
            ((Object) enquiryReport.get('employment')) !=
            null &&
            String.valueOf(
              enquiryReport
            ).contains('employment=(')
          ) {
            List<Object> employmentList=((List<Object>) enquiryReport.get('employment'));
            for(object eachEmployment:employmentList){
              if(
                ((Map<String,Object>)eachEmployment)!=null &&
                ((String)((Map<String,Object>)eachEmployment).get('name'))!=null
              ){
                partyObj.Employer__c = ((String)((Map<String,Object>)eachEmployment).get('name'));
              }
            }
            
          }else if (
            enquiryReport!=null &&
            ((Object) enquiryReport.get('employment')) !=
            null &&
            String.valueOf(
              enquiryReport
            ).contains('employment={')
          ) {
            Object eachEmployment=((Object)((Map<String,Object>) enquiryReport.get('employment')).get('employer'));
            if(
              ((Map<String,Object>)eachEmployment)!=null &&
              ((String)((Map<String,Object>)eachEmployment).get('name'))!=null
            ){
              partyObj.Employer__c = ((String)((Map<String,Object>)eachEmployment).get('name'));
            }
          }
          if (
            enquiryReport!=null &&
            ((Object) enquiryReport.get('addresses')) !=
            null && String.valueOf(
              enquiryReport
            ).contains('addresses=(')
          ) {
            List<Object> addressList = ((List<Object>) enquiryReport.get('addresses'));
            for (Object eachAddress : addressList) {
              if (
                ((Map<String,Object>)eachAddress)!=null &&
                ((String)((Map<String,Object>)eachAddress).get('type'))!=null &&
                ((String)((Map<String,Object>)eachAddress).get('type'))=='C'
              ) {
                partyObj.Individual_Address__c = processAddress(((Map<String,Object>)eachAddress));
                break;
              }
            }
          }else if(
            enquiryReport!=null &&
            ((Object) enquiryReport.get('addresses')) !=
            null && String.valueOf(
              enquiryReport
            ).contains('addresses={')
          ){
            Object eachAddress = ((Object)((Map<String,Object>) enquiryReport.get('addresses')).get('address'));
            if (
              ((Map<String,Object>)eachAddress)!=null &&
              ((String)((Map<String,Object>)eachAddress).get('type'))!=null &&
              ((String)((Map<String,Object>)eachAddress).get('type'))=='C'
            ) {
              partyObj.Individual_Address__c = processAddress(((Map<String,Object>)eachAddress));
              
            }
          }
          if (
            productData!=null &&
            ((Map<String,Object>)((Map<String,Object>)productData).get('possible-matches')) !=
            null &&
            ((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)productData).get('possible-matches')).get('possible-match'))!=
            null
          ) {
            possibleMatchData = ((Map<String,Object>)((Map<String,Object>)((Map<String,Object>)productData).get('possible-matches')).get('possible-match'));
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
                'directorships'
              )) != null && String.valueOf(
                publicReport
              ).contains('directorships=(')
            ) {
              List<Object> refDirShip = ((List<Object>) publicReport.get(
                'directorships'
              ));
              for (Object eachDirectorship : refDirShip) {
                if(((String) ((Map<String, Object>) eachDirectorship).get('type'))=='C'){
                  Current_Directorship__c currDirector=new Current_Directorship__c();
                  currDirector.Directorship_Type__c = 'Current';
                  currDirector.Party__c=partyObj.id;
                  if (
                    ((Map<String, Object>) eachDirectorship) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                      .get('organisation')) != null
                  ){
                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('name')) != null)
                    currDirector.Org_Name__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('name'));
                  
                    if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('type')) != null
                    && ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('type')).get('ele_text')) != null)
                    currDirector.Org_Name__c+=' '+((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('type')).get('ele_text'));
                
                    if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('status')) !=null && 
                    ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('status')).get('ele_text')) != null )
                    currDirector.Company_Status__c=((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('status')).get('ele_text'));
                  
                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('ABN')) != null)
                    currDirector.ABN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('ABN'));

                    if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')).get('organisation-number')) != null)
                    currDirector.ACN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('organisation-number'));
                  
                  }
                  directorships.add(currDirector);
                }
              }
            }else if(
              publicReport!=null &&
              ((Object)publicReport.get(
                'directorships'
              )) != null && String.valueOf(
                publicReport
              ).contains('directorships={')
            ){
              Object eachDirectorship = ((Object)((Map<String, Object>) publicReport.get('directorships')).get('directorship'));
              if(((String) ((Map<String, Object>) eachDirectorship).get('type'))=='C'){
                Current_Directorship__c currDirector=new Current_Directorship__c();
                currDirector.Directorship_Type__c = 'Current';
                currDirector.Party__c=partyObj.id;
                if (
                  ((Map<String, Object>) eachDirectorship) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                    .get('organisation')) != null
                ){
                  if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('name')) != null)
                  currDirector.Org_Name__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('name'));
                
                  if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('type')) != null
                  && ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('type')).get('ele_text')) != null)
                  currDirector.Org_Name__c+=' '+((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('type')).get('ele_text'));
              
                  if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('status')) !=null && 
                  ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('status')).get('ele_text')) != null )
                  currDirector.Company_Status__c=((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('status')).get('ele_text'));
                
                  if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('ABN')) != null)
                  currDirector.ABN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('ABN'));

                  if(((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship)
                  .get('organisation')).get('organisation-number')) != null)
                  currDirector.ACN__c=((String)((Map<String, Object>) ((Map<String, Object>) eachDirectorship).get('organisation')).get('organisation-number'));
                
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
                'disqualified-directorships'
              ))!=null &&
              String.valueOf(publicReport).contains('disqualified-directorships=(') 
            ) {
              List<Object> refDisqDirShip = ((List<Object>)publicReport.get(
                'disqualified-directorships'
              ));
              for (Object eachDisqualified : refDisqDirShip) {      
                Current_Directorship__c refDirShip = new Current_Directorship__c();
                refDirShip.Directorship_Type__c = 'Disqualified';
                refDirShip.Party__c = partyObj.Id;
                if (
                  ((Map<String, Object>) eachDisqualified) != null &&
                  ((String) ((Map<String, Object>) eachDisqualified)
                    .get('date-disqualified')) != null
                ) {
                  String reportCreateDate =((String) ((Map<String, Object>) eachDisqualified).get('date-disqualified'));
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
                    .get('date-disqualified-until')) != null
                ) {
                  String reportCreateDate =((String) ((Map<String, Object>) eachDisqualified).get('date-disqualified-until'));
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
                'disqualified-directorships'
              ))!=null &&
              String.valueOf(publicReport).contains('disqualified-directorships={')  
            ){
              Object refDisqDirShip = ((Object)((Map<String, Object>) ((Map<String, Object>)publicReport).get(
                'disqualified-directorships'
              )).get('disqualified-directorship'));
              Current_Directorship__c refDirShip = new Current_Directorship__c();
              refDirShip.Directorship_Type__c = 'Disqualified';
              refDirShip.Party__c = partyObj.Id;
              if (
                ((Map<String, Object>) refDisqDirShip) != null &&
                ((String) ((Map<String, Object>) refDisqDirShip)
                  .get('date-disqualified')) != null
              ) {
                String reportCreateDate =((String) ((Map<String, Object>) refDisqDirShip).get('date-disqualified'));
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
                  .get('date-disqualified-until')) != null
              ) {
                String reportCreateDate =((String) ((Map<String, Object>) refDisqDirShip).get('date-disqualified-until'));
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
              returnValue+='\nNo Disqualified Directorships found';
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
                'credit-enquiries'
              ))!=null && String.valueOf(consumerCredit).contains('credit-enquiries=(')
            ) {
              List<Object> refCreditEnq = ((List<Object>) consumerCredit.get(
                'credit-enquiries'
              ));
              for (Object eachCredit : refCreditEnq) {
                Credit_Enquiry__c creditEnquiryObj;
                creditEnquiryObj = new Credit_Enquiry__c();
                creditEnquiryObj.Party__c = partyObj.Id;
                creditEnquiryObj.Credit_Enquiry_Type__c = 'Consumer';
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get('enquiry-date')) != null
                ){
                  String dateString = ((String) ((Map<String, Object>) eachCredit).get('enquiry-date'));
                  Date enqDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditEnquiryObj.Enquiry_Date__c = enqDate;
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')).get('ele_text')) != null
                ){
                  creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('credit-enquirer')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('credit-enquirer')).get('name')) != null
                ){
                  creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('credit-enquirer')).get('name'));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('enquiry-amount')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('enquiry-amount')).get('ele_text')) != null
                ){
                  creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('enquiry-amount')).get('ele_text')));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')).get('code')) != null
                ) {
                  Integer codeValue = Integer.valueOf(
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('code'))
                  );
                  switch on codeValue {
                    when 1 {
                      creditEnquiryObj.Role_in_Enquiry__c = 'Principal (sole)';
                    }
                    when 2 {
                      creditEnquiryObj.Role_in_Enquiry__c = 'Principal (joint)';
                    }
                    when 3 {
                      creditEnquiryObj.Role_in_Enquiry__c = 'Guarantor';
                    }
                  }
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get('enquiry-client-reference')) !=null
                ) {
                  creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get('enquiry-client-reference'));
                }
                creditEnquiries.add(creditEnquiryObj);
              }
            }else if (
              consumerCredit!=null &&
              ((Object) consumerCredit.get(
                'credit-enquiries'
              ))!=null && String.valueOf(consumerCredit).contains('credit-enquiries={')
            ) {
              Object eachCredit = ((Object)((Map<String, Object>)consumerCredit.get(
                'credit-enquiries'
              )).get('credit-enquiry'));
              Credit_Enquiry__c creditEnquiryObj;
              creditEnquiryObj = new Credit_Enquiry__c();
              creditEnquiryObj.Party__c = partyObj.Id;
              creditEnquiryObj.Credit_Enquiry_Type__c = 'Consumer';
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get('enquiry-date')) != null
              ){
                String dateString = ((String) ((Map<String, Object>) eachCredit).get('enquiry-date'));
                Date enqDate = Date.newInstance(
                  Integer.valueOf(dateString.subString(0, 4)),
                  Integer.valueOf(dateString.subString(5, 7)),
                  Integer.valueOf(dateString.subString(8, 10))
                );
                creditEnquiryObj.Enquiry_Date__c = enqDate;
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')).get('ele_text')) != null
              ){
                creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('credit-enquirer')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('credit-enquirer')).get('name')) != null
              ){
                creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('credit-enquirer')).get('name'));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('enquiry-amount')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('enquiry-amount')).get('ele_text')) != null
              ){
                creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('enquiry-amount')).get('ele_text')));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')).get('code')) != null
              ) {
                Integer codeValue = Integer.valueOf(
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('code'))
                );
                switch on codeValue {
                  when 1 {
                    creditEnquiryObj.Role_in_Enquiry__c = 'Principal (sole)';
                  }
                  when 2 {
                    creditEnquiryObj.Role_in_Enquiry__c = 'Principal (joint)';
                  }
                  when 3 {
                    creditEnquiryObj.Role_in_Enquiry__c = 'Guarantor';
                  }
                }
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get('enquiry-client-reference')) !=null
              ) {
                creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get('enquiry-client-reference'));
              }
            
              creditEnquiries.add(creditEnquiryObj);
            }else{
              returnValue+='\nNo Consumer Credit Enquiries found';
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
                'credit-enquiries'
              ))!=null && String.valueOf(
                commercialCredit
              ).contains('credit-enquiries=(')
            ) {
              List<Object> refCreditEnq = ((List<Object>) commercialCredit.get(
                'credit-enquiries'
              ));
              for (Object eachCredit : refCreditEnq) {
                Credit_Enquiry__c creditEnquiryObj;
                creditEnquiryObj = new Credit_Enquiry__c();
                creditEnquiryObj.Party__c = partyObj.Id;
                creditEnquiryObj.Credit_Enquiry_Type__c = 'Commercial';
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get('enquiry-date')) != null
                ){
                  String dateString = ((String) ((Map<String, Object>) eachCredit).get('enquiry-date'));
                  Date enqDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditEnquiryObj.Enquiry_Date__c = enqDate;
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')).get('ele_text')) != null
                ){
                  creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('credit-enquirer')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('credit-enquirer')).get('name')) != null
                ){
                  creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('credit-enquirer')).get('name'));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('enquiry-amount')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('enquiry-amount')).get('ele_text')) != null
                ){
                  creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('enquiry-amount')).get('ele_text')));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')).get('code')) != null
                ) {
                  Integer codeValue = Integer.valueOf(
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('code'))
                  );
                  switch on codeValue {
                    when 1 {
                      creditEnquiryObj.Role_in_Enquiry__c = 'Principal (sole)';
                    }
                    when 2 {
                      creditEnquiryObj.Role_in_Enquiry__c = 'Principal (joint)';
                    }
                    when 3 {
                      creditEnquiryObj.Role_in_Enquiry__c = 'Guarantor';
                    }
                  }
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((String) ((Map<String, Object>) eachCredit)
                  .get('enquiry-client-reference')) !=null
                ) {
                  creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get('enquiry-client-reference'));
                }
                creditEnquiries.add(creditEnquiryObj);
              }
            }else if (
              commercialCredit!=null &&
              ((Object) commercialCredit.get(
                'credit-enquiries'
              ))!=null && String.valueOf(
                commercialCredit
              ).contains('credit-enquiries={')
            ) {
              Object eachCredit = ((Object)((Map<String, Object>)commercialCredit.get('credit-enquiries')).get('credit-enquiry'));
              Credit_Enquiry__c creditEnquiryObj;
              creditEnquiryObj = new Credit_Enquiry__c();
              creditEnquiryObj.Party__c = partyObj.Id;
              creditEnquiryObj.Credit_Enquiry_Type__c = 'Commercial';
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get('enquiry-date')) != null
              ){
                String dateString = ((String) ((Map<String, Object>) eachCredit).get('enquiry-date'));
                Date enqDate = Date.newInstance(
                  Integer.valueOf(dateString.subString(0, 4)),
                  Integer.valueOf(dateString.subString(5, 7)),
                  Integer.valueOf(dateString.subString(8, 10))
                );
                creditEnquiryObj.Enquiry_Date__c = enqDate;
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')).get('ele_text')) != null
              ){
                creditEnquiryObj.Account_Type__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('credit-enquirer')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('credit-enquirer')).get('name')) != null
              ){
                creditEnquiryObj.Credit_Enquirer__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('credit-enquirer')).get('name'));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('enquiry-amount')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('enquiry-amount')).get('ele_text')) != null
              ){
                creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('enquiry-amount')).get('ele_text')));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')).get('code')) != null
              ) {
                Integer codeValue = Integer.valueOf(
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('code'))
                );
                switch on codeValue {
                  when 1 {
                    creditEnquiryObj.Role_in_Enquiry__c = 'Principal (sole)';
                  }
                  when 2 {
                    creditEnquiryObj.Role_in_Enquiry__c = 'Principal (joint)';
                  }
                  when 3 {
                    creditEnquiryObj.Role_in_Enquiry__c = 'Guarantor';
                  }
                }
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get('enquiry-client-reference')) !=null
              ) {
                creditEnquiryObj.Reference_No__c = ((String) ((Map<String, Object>) eachCredit).get('enquiry-client-reference'));
              }
              creditEnquiries.add(creditEnquiryObj);
            }else{
              returnValue+='\nNo Commercial Credit Enquiries found';
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
                'accounts'
              ))!=null && String.valueOf(
                commercialCredit
              ).contains('accounts=(')
            ) {
              List<Object> refCreditAccount=((List<Object>) commercialCredit.get('accounts'));
              for(Object eachCredit:refCreditAccount){
                Credit_Account__c creditAccountObj;
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = 'Commercial';
                if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get('account-id')) !=null){
                  creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get('account-id'));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')).get('ele_text'))!=null
                ){
                  creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('original-credit-provider')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('original-credit-provider')).get('name'))!=null
                ) {
                  creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('original-credit-provider')).get('name'));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('latest-credit-provider')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('latest-credit-provider')).get('name'))!=null
                ) {
                  creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('latest-credit-provider')).get('name'));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')).get('ele_text'))!=null
                ) {
                  creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('ele_text'));
                }
                creditAccounts.add(creditAccountObj);
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults=(')
                ){
                  List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get('defaults'));
                  for(Object eachDefault:refDefault){
                    Payment_Default__c paymentDefaultObj;
                    paymentDefaultObj = new Payment_Default__c();
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                    ) {
                      paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                    ) {
                      String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                      Date statusDate = Date.newInstance(
                        Integer.valueOf(dateString.subString(0, 4)),
                        Integer.valueOf(dateString.subString(5, 7)),
                        Integer.valueOf(dateString.subString(8, 10))
                      );
                      paymentDefaultObj.Status_Date__c = statusDate;
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                    ) {
                      paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                      );
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                    ) {
                      paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                      );
                    }
                    if (paymentDefaultObj != null) {
                      if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                        accountIdDefaultMap.put(
                          'Commercial' + creditAccountObj.Account_Id__c,
                          paymentDefaultObj
                        );
                      }
                    }
                  }
                } else if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults={')
                ){
                  Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('defaults')).get('default'));
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    paymentDefaultObj.Status_Date__c = statusDate;
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        'Commercial' + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              }
            }else if(
              commercialCredit!=null &&
              ((Object) commercialCredit.get(
                'accounts'
              ))!=null && String.valueOf(
                commercialCredit
              ).contains('accounts={')
            ) {
              Object eachCredit=((Object)((Map<String, Object>) commercialCredit.get('accounts')).get('account'));
              Credit_Account__c creditAccountObj;
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = 'Commercial';
              if(
              ((Map<String, Object>) eachCredit) != null &&
              ((String) ((Map<String, Object>) eachCredit)
              .get('account-id')) !=null){
                creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get('account-id'));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')).get('ele_text'))!=null
              ){
                creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('original-credit-provider')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('original-credit-provider')).get('name'))!=null
              ) {
                creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('original-credit-provider')).get('name'));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('latest-credit-provider')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('latest-credit-provider')).get('name'))!=null
              ) {
                creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('latest-credit-provider')).get('name'));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')).get('ele_text'))!=null
              ) {
                creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('ele_text'));
              }
              creditAccounts.add(creditAccountObj);
              if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults=(')
              ){
                List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get('defaults'));
                for(Object eachDefault:refDefault){
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    paymentDefaultObj.Status_Date__c = statusDate;
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        'Commercial' + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              } else if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults={')
              ){
                Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('defaults')).get('default'));
                Payment_Default__c paymentDefaultObj;
                paymentDefaultObj = new Payment_Default__c();
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                ) {
                  paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                ) {
                  String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  paymentDefaultObj.Status_Date__c = statusDate;
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                ) {
                  paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                  );
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                ) {
                  paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                  );
                }
                if (paymentDefaultObj != null) {
                  if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                    accountIdDefaultMap.put(
                      'Commercial' + creditAccountObj.Account_Id__c,
                      paymentDefaultObj
                    );
                  }
                }
              }
            }else{
              returnValue+='\nNo Commercial Credit Accounts found';
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
                'accounts'
              ))!=null && 
              String.valueOf(
                consumerCredit)
              .contains('accounts=(')
            ) {
              List<Object> refCreditAccount=((List<Object>)consumerCredit.get('accounts'));
              for(Object eachCredit:refCreditAccount){
                Credit_Account__c creditAccountObj;
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = 'Consumer';
                if(
                ((Map<String, Object>) eachCredit) != null &&
                ((String) ((Map<String, Object>) eachCredit)
                .get('account-id')) !=null){
                  creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get('account-id'));
                }
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('account-type')).get('ele_text'))!=null
                ){
                  creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('original-credit-provider')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('original-credit-provider')).get('name'))!=null
                ) {
                  creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('original-credit-provider')).get('name'));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('latest-credit-provider')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('latest-credit-provider')).get('name'))!=null
                ) {
                  creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('latest-credit-provider')).get('name'));
                }
                if (
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')) !=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                  .get('relationship')).get('ele_text'))!=null
                ) {
                  creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('ele_text'));
                }
                creditAccounts.add(creditAccountObj);
                if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults=(')
                ){
                  List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get('defaults'));
                  for(Object eachDefault:refDefault){
                    Payment_Default__c paymentDefaultObj;
                    paymentDefaultObj = new Payment_Default__c();
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                    ) {
                      paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                      ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                    ) {
                      String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                      Date statusDate = Date.newInstance(
                        Integer.valueOf(dateString.subString(0, 4)),
                        Integer.valueOf(dateString.subString(5, 7)),
                        Integer.valueOf(dateString.subString(8, 10))
                      );
                      paymentDefaultObj.Status_Date__c = statusDate;
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                    ) {
                      paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                      );
                    }
                    if (
                      ((Map<String, Object>) eachDefault) != null &&
                      ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                      ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                    ) {
                      paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                      );
                    }
                    if (paymentDefaultObj != null) {
                      if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                        accountIdDefaultMap.put(
                          'Consumer' + creditAccountObj.Account_Id__c,
                          paymentDefaultObj
                        );
                      }
                    }
                  }
                } else if(
                  ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults={')
                ){
                  Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('defaults')).get('default'));
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    paymentDefaultObj.Status_Date__c = statusDate;
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        'Consumer' + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              }
            }else if(
              consumerCredit!=null &&
              ((Object) consumerCredit.get(
                'accounts'
              ))!=null && 
              String.valueOf(
                consumerCredit)
              .contains('accounts={')
            ){
              Object eachCredit=((Object)((Map<String,Object>)consumerCredit.get('accounts')).get('account'));
              Credit_Account__c creditAccountObj;
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = 'Consumer';
              System.debug('1519-->'+eachCredit);
              if(
              ((Map<String, Object>) eachCredit) != null &&
              ((String) ((Map<String, Object>) eachCredit)
              .get('account-id')) !=null){
                creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCredit).get('account-id'));
              }
              if(
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('account-type')).get('ele_text'))!=null
              ){
                creditAccountObj.Account_Type__c = ((String) ((Map<String, Object>)((Map<String, Object>) eachCredit).get('account-type')).get('ele_text'));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('original-credit-provider')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('original-credit-provider')).get('name'))!=null
              ) {
                creditAccountObj.Original_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('original-credit-provider')).get('name'));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('latest-credit-provider')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('latest-credit-provider')).get('name'))!=null
              ) {
                creditAccountObj.Latest_Credit_Provider__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('latest-credit-provider')).get('name'));
              }
              if (
                ((Map<String, Object>) eachCredit) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')) !=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit)
                .get('relationship')).get('ele_text'))!=null
              ) {
                creditAccountObj.Relationship__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('relationship')).get('ele_text'));
              }
              creditAccounts.add(creditAccountObj);
              if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults=(')
              ){
                List<Object> refDefault=((List<Object>) ((Map<String, Object>) eachCredit).get('defaults'));
                for(Object eachDefault:refDefault){
                  Payment_Default__c paymentDefaultObj;
                  paymentDefaultObj = new Payment_Default__c();
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                  ) {
                    paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                  ) {
                    String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                    Date statusDate = Date.newInstance(
                      Integer.valueOf(dateString.subString(0, 4)),
                      Integer.valueOf(dateString.subString(5, 7)),
                      Integer.valueOf(dateString.subString(8, 10))
                    );
                    paymentDefaultObj.Status_Date__c = statusDate;
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (
                    ((Map<String, Object>) eachDefault) != null &&
                    ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                  ) {
                    paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                      ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                    );
                  }
                  if (paymentDefaultObj != null) {
                    if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                      accountIdDefaultMap.put(
                        'Consumer' + creditAccountObj.Account_Id__c,
                        paymentDefaultObj
                      );
                    }
                  }
                }
              } else if(
                ((Map<String, Object>) eachCredit) != null &&
                  ((Object) ((Map<String, Object>) eachCredit)
                  .get('defaults')) !=null && String.valueOf(
                    ((Map<String, Object>) eachCredit)
                  ).contains('defaults={')
              ){
                Object eachDefault=((Object)((Map<String, Object>) ((Map<String, Object>) eachCredit).get('defaults')).get('default'));
                Payment_Default__c paymentDefaultObj;
                paymentDefaultObj = new Payment_Default__c();
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'))!=null
                ) {
                  paymentDefaultObj.Status__c = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('status')).get('ele_text'));
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                  ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'))!=null
                ) {
                  String dateString = ((String)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('date-recorded'));
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  paymentDefaultObj.Status_Date__c = statusDate;
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount'))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text')) !=null
                ) {
                  paymentDefaultObj.Current_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('current-default')).get('default-amount')).get('ele_text'))
                  );
                }
                if (
                  ((Map<String, Object>) eachDefault) != null &&
                  ((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')) != null &&
                  ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount'))!=null &&
                  ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text')) !=null
                ) {
                  paymentDefaultObj.Original_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) eachDefault).get('original-default')).get('default-amount')).get('ele_text'))
                  );
                }
                if (paymentDefaultObj != null) {
                  if (String.isNotBlank(creditAccountObj.Account_Id__c)) {
                    accountIdDefaultMap.put(
                      'Consumer' + creditAccountObj.Account_Id__c,
                      paymentDefaultObj
                    );
                  }
                }
              }
            }else{
              returnValue+='\nNo Consumer Credit Accounts found';
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
              ((Object)publicRecordOrConsumerCreditInformation.get('court-actions')) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains('court-actions=(')
            ){
              List<Object> courtActionList=((List<Object>)publicRecordOrConsumerCreditInformation.get('court-actions'));
              for(Object eachCourtAction:courtActionList){
                Credit_Account__c creditAccountObj;
                String courtActionType;
                if (String.isBlank(((String)((Map<String,Object>)eachCourtAction).get('type')))) {
                  continue;
                } else if (((String)((Map<String,Object>)eachCourtAction).get('type')) == 'default-judgement') {
                  courtActionType = 'Default Judgements';
                } else {
                  courtActionType = 'Other Court Action';
                }
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = courtActionType;
                if (
                    ((Map<String, Object>) eachCourtAction) != null &&
                    ((String) ((Map<String, Object>) eachCourtAction)
                      .get('creditor')) != null
                ){
                  creditAccountObj.Relationship__c =((String) ((Map<String, Object>) eachCourtAction).get('creditor'));
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((String) ((Map<String, Object>) eachCourtAction)
                  .get('action-date')) != null
                ) {
                  String dateString =((String) ((Map<String, Object>) eachCourtAction).get('action-date'));
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Default_Date__c = statusDate;
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-amount'))!=null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-amount')).get('ele_text')) != null
                ) {
                  creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction).get('court-action-amount')).get('ele_text'))
                  );
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((String) ((Map<String, Object>) eachCourtAction)
                  .get('plaint-number')) != null
                ) {
                  creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCourtAction).get('plaint-number'));
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-status')) != null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-status')).get('ele_text')) != null
                ) {
                  creditAccountObj.Status__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-status')).get('ele_text'));
                }
                if (
                  ((Map<String, Object>) eachCourtAction) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-status')) != null &&
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-status')).get('date')) != null
                  ) {
                  String dateString = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                  .get('court-action-status')).get('date'));
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
              ((Object)publicRecordOrConsumerCreditInformation.get('court-actions')) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains('court-actions={')
            ){
              Object eachCourtAction=((Object)((Map<String,Object>)publicRecordOrConsumerCreditInformation.get('court-actions')).get('court-action'));
              Credit_Account__c creditAccountObj;
              String courtActionType;
              if (((String)((Map<String,Object>)eachCourtAction).get('type')) == 'default-judgement') {
                courtActionType = 'Default Judgements';
              } else {
                courtActionType = 'Other Court Action';
              }
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = courtActionType;
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((String) ((Map<String, Object>) eachCourtAction)
                  .get('creditor')) != null
              ){
                creditAccountObj.Relationship__c =((String) ((Map<String, Object>) eachCourtAction).get('creditor'));
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((String) ((Map<String, Object>) eachCourtAction)
                .get('action-date')) != null
              ) {
                String dateString =((String) ((Map<String, Object>) eachCourtAction).get('action-date'));
                Date statusDate = Date.newInstance(
                  Integer.valueOf(dateString.subString(0, 4)),
                  Integer.valueOf(dateString.subString(5, 7)),
                  Integer.valueOf(dateString.subString(8, 10))
                );
                creditAccountObj.Default_Date__c = statusDate;
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-amount'))!=null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-amount')).get('ele_text')) != null
              ) {
                creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(
                  ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction).get('court-action-amount')).get('ele_text'))
                );
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((String) ((Map<String, Object>) eachCourtAction)
                .get('plaint-number')) != null
              ) {
                creditAccountObj.Account_Id__c = ((String) ((Map<String, Object>) eachCourtAction).get('plaint-number'));
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-status')) != null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-status')).get('ele_text')) != null
              ) {
                creditAccountObj.Status__c = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-status')).get('ele_text'));
              }
              if (
                ((Map<String, Object>) eachCourtAction) != null &&
                ((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-status')) != null &&
                ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-status')).get('date')) != null
                ) {
                String dateString = ((String)((Map<String, Object>) ((Map<String, Object>) eachCourtAction)
                .get('court-action-status')).get('date'));
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
              
            }else{
              returnValue+='\n' + 'No Default Judgements or Court Actions found';
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
              ((Object)publicRecordOrConsumerCreditInformation.get('personal-insolvencies')) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains('personal-insolvencies=(')
            ){
              List<Object> personalInsolvencyList=((List<Object>)publicRecordOrConsumerCreditInformation.get('personal-insolvencies'));
              for(Object eachPersonalInsolvency:personalInsolvencyList){
                Credit_Account__c creditAccountObj;
                creditAccountObj = new Credit_Account__c();
                creditAccountObj.Party__c = partyObj.Id;
                creditAccountObj.Credit_Account_Type__c = 'Personal Insolvencies';
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('type'))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('type')).get('ele_text'))!=null
                ) {
                  creditAccountObj.Account_Type__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('type')).get('ele_text'));
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((String)((Map<String,Object>)eachPersonalInsolvency).get('text'))!=null
                ) {
                  creditAccountObj.Relationship__c = ((String)((Map<String,Object>)eachPersonalInsolvency).get('text'));
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status'))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('ele_text'))!=null
                ) {
                  creditAccountObj.Status__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('ele_text'));
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status'))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('date'))!=null
                ) {
                  String dateString =  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('date'));
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Status_Date__c = statusDate;
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((String)((Map<String,Object>)eachPersonalInsolvency).get('date-declared'))!=null
                ) {
                  String dateString = ((String)((Map<String,Object>)eachPersonalInsolvency).get('date-declared'));
                  Date statusDate = Date.newInstance(
                    Integer.valueOf(dateString.subString(0, 4)),
                    Integer.valueOf(dateString.subString(5, 7)),
                    Integer.valueOf(dateString.subString(8, 10))
                  );
                  creditAccountObj.Default_Date__c = statusDate;
                }
                if (
                  ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                  ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('administration-id'))!=null &&
                  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('administration-id')).get('number'))!=null
                ) {
                  creditAccountObj.Account_Id__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('administration-id')).get('number'));
                }
                if (creditAccountObj != null) {
                  creditAccounts.add(creditAccountObj);
                }
              }
            }else if(
              publicRecordOrConsumerCreditInformation!=null &&
              ((Object)publicRecordOrConsumerCreditInformation.get('personal-insolvencies')) !=null &&
              String.valueOf(
              (publicRecordOrConsumerCreditInformation)
              ).contains('personal-insolvencies={')
            ){
              Object eachPersonalInsolvency=((Object)((Map<String,Object>)publicRecordOrConsumerCreditInformation.get('personal-insolvencies')).get('personal-insolvency'));
            
              Credit_Account__c creditAccountObj;
              creditAccountObj = new Credit_Account__c();
              creditAccountObj.Party__c = partyObj.Id;
              creditAccountObj.Credit_Account_Type__c = 'Personal Insolvencies';
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('type'))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('type')).get('ele_text'))!=null
              ) {
                creditAccountObj.Account_Type__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('type')).get('ele_text'));
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((String)((Map<String,Object>)eachPersonalInsolvency).get('text'))!=null
              ) {
                creditAccountObj.Relationship__c = ((String)((Map<String,Object>)eachPersonalInsolvency).get('text'));
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status'))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('ele_text'))!=null
              ) {
                creditAccountObj.Status__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('ele_text'));
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status'))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('date'))!=null
              ) {
                String dateString =  ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('status')).get('date'));
                Date statusDate = Date.newInstance(
                  Integer.valueOf(dateString.subString(0, 4)),
                  Integer.valueOf(dateString.subString(5, 7)),
                  Integer.valueOf(dateString.subString(8, 10))
                );
                creditAccountObj.Status_Date__c = statusDate;
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((String)((Map<String,Object>)eachPersonalInsolvency).get('date-declared'))!=null
              ) {
                String dateString = ((String)((Map<String,Object>)eachPersonalInsolvency).get('date-declared'));
                Date statusDate = Date.newInstance(
                  Integer.valueOf(dateString.subString(0, 4)),
                  Integer.valueOf(dateString.subString(5, 7)),
                  Integer.valueOf(dateString.subString(8, 10))
                );
                creditAccountObj.Default_Date__c = statusDate;
              }
              if (
                ((Map<String,Object>)eachPersonalInsolvency)!=null &&
                ((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('administration-id'))!=null &&
                ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('administration-id')).get('number'))!=null
              ) {
                creditAccountObj.Account_Id__c = ((String)((Map<String,Object>)((Map<String,Object>)eachPersonalInsolvency).get('administration-id')).get('number'));
              }
              if (creditAccountObj != null) {
                creditAccounts.add(creditAccountObj);
              }
            }else{
              returnValue+='\n' + 'No Personal Insolvencies found';
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