/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Hamza Yousuf
Development Date : 21/07/2020
Last Modified By : Hamza Yousuf
Last Modified Date : 07/04/2021
Last Modified By : Rameswari Barman
Description : This class is used to Parse and Store Company Enquiry of Equifax
***********************************************************************************************************************************************************/
public class EquifaxCompanyEnquiryResponseHelper {
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
        ((Map<String, Object>) summaryCheck).get(ConstantValues.SUMMARY_NAME) ==
        null
      ) {
        continue;
      }
      if (
        (String) ((Map<String, Object>) ((Map<String, Object>) summaryCheck)
            .get(ConstantValues.SUMMARY_NAME))
          .get(ConstantValues.NODE_VALUE) == referenceValue
      ) {
        return ((Map<String, Object>) summaryCheck);
      }
    }
    return new Map<String, Object>();
  }

  public static String dirFullName(Map<String, Object> name) {
    String directorName = '';
    if (
      ((Map<String, Object>) name.get(ConstantValues.FAMILY_NAME_DIRECTOR)) !=
      null
    ) {
      directorName +=
        (String) ((Map<String, Object>) name.get(
            ConstantValues.FAMILY_NAME_DIRECTOR
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) name.get(ConstantValues.FIRST_GIVEN_NAME)) != null
    ) {
      directorName +=
        (String) ((Map<String, Object>) name.get(
            ConstantValues.FIRST_GIVEN_NAME
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) name.get(ConstantValues.OTHER_GIVEN_NAME)) != null
    ) {
      directorName +=
        (String) ((Map<String, Object>) name.get(
            ConstantValues.OTHER_GIVEN_NAME
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }

    return directorName;
  }

  public static String indSharefullName(Map<String, Object> name) {
    String shareholderName = '';
    if (
      ((Map<String, Object>) name.get(
        ConstantValues.FAMILY_NAME_SHAREHOLDER
      )) != null
    ) {
      shareholderName +=
        (String) ((Map<String, Object>) name.get(
            ConstantValues.FAMILY_NAME_SHAREHOLDER
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) name.get(ConstantValues.FIRST_GIVEN_NAME)) != null
    ) {
      shareholderName +=
        (String) ((Map<String, Object>) name.get(
            ConstantValues.FIRST_GIVEN_NAME
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) name.get(ConstantValues.OTHER_GIVEN_NAME)) != null
    ) {
      shareholderName +=
        (String) ((Map<String, Object>) name.get(
            ConstantValues.OTHER_GIVEN_NAME
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }

    return shareholderName;
  }

  public static string processAddressLines(Map<String, Object> address) {
    String fullAddress = '';
    if (((Map<String, Object>) address.get(ConstantValues.CARE_OF)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.CARE_OF))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) address.get(ConstantValues.ADDRESS_PREFIX)) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(
            ConstantValues.ADDRESS_PREFIX
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) address.get(ConstantValues.STREET_DETAILS)) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(
            ConstantValues.STREET_DETAILS
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) address.get(ConstantValues.LOCALITY_DETAILS)) !=
      null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(
            ConstantValues.LOCALITY_DETAILS
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (((Map<String, Object>) address.get(ConstantValues.STATE)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.STATE))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (((Map<String, Object>) address.get(ConstantValues.POSTCODE)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.POSTCODE))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (((Map<String, Object>) address.get(ConstantValues.COUNTRY)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.COUNTRY))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    return fullAddress;
  }

  public static String securedParty(Map<String, Object> orgAddress) {
    String fullAddress = '';
    if (
      ((Map<String, Object>) orgAddress.get(
        ConstantValues.ORGANISATION_NAME
      )) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) orgAddress.get(
            ConstantValues.ORGANISATION_NAME
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) orgAddress.get(
        ConstantValues.ORGANISATION_NUMBER_TYPE
      )) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) orgAddress.get(
            ConstantValues.ORGANISATION_NUMBER_TYPE
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) orgAddress.get(
        ConstantValues.ORGANISATION_NUMBER
      )) != null
    ) {
      fullAddress += (String) ((Map<String, Object>) orgAddress.get(
          ConstantValues.ORGANISATION_NUMBER
        ))
        .get(ConstantValues.NODE_VALUE);
    }
    return fullAddress;
  }

  public static String processAddress(Map<String, Object> address) {
    String fullAddress = '';
    if (
      ((Map<String, Object>) address.get(ConstantValues.UNIT_NUMBER)) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.UNIT_NUMBER))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) address.get(ConstantValues.STREET_NUMBER)) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(
            ConstantValues.STREET_NUMBER
          ))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) address.get(ConstantValues.STREET_NAME)) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.STREET_NAME))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (
      ((Map<String, Object>) address.get(ConstantValues.STREET_TYPE)) != null
    ) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.STREET_TYPE))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (((Map<String, Object>) address.get(ConstantValues.SUBURB)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.SUBURB))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (((Map<String, Object>) address.get(ConstantValues.STATE)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.STATE))
          .get(ConstantValues.NODE_VALUE) + ' ';
    }
    if (((Map<String, Object>) address.get(ConstantValues.POSTCODE)) != null) {
      fullAddress +=
        (String) ((Map<String, Object>) address.get(ConstantValues.POSTCODE))
          .get(ConstantValues.NODE_VALUE) + '';
    }
    return fullAddress;
  }

  public static String parse(
    String json,
    clcommon__Party__c partyObj,
    Map<String, Object> response
  ) {
    String returnValue = ConstantValues.COMPANY_ENQUIRY_RESPONSE_RECEIVED_SUCCESSFULLY;
    String errorForUser = '';
    Map<String, Object> commonComId;
    List<Object> commonSumEntry;
    Map<String, Object> commonOrgReport;
    Map<String, Object> commonOrgCred;
    Map<String, Object> commonOwnOff;
    Map<String, Object> commonPpsr;
    Map<String, Object> commonComResponse;
    Map<String, Object> commonComReport;
    try {
      if (
        ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY)) !=
        null &&
        ((Map<String, Object>) ((Map<String, Object>) response.get(
            ConstantValues.ENVELOPE_KEY
          ))
          .get(ConstantValues.BODY_KEY)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY))
          .get(ConstantValues.FAULT)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                ConstantValues.ENVELOPE_KEY
              ))
              .get(ConstantValues.BODY_KEY))
            .get(ConstantValues.FAULT))
          .get(ConstantValues.DETAIL)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                  ConstantValues.ENVELOPE_KEY
                ))
                .get(ConstantValues.BODY_KEY))
              .get(ConstantValues.FAULT))
            .get(ConstantValues.DETAIL))
          .get(ConstantValues.ERRORKEY)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                    ConstantValues.ENVELOPE_KEY
                  ))
                  .get(ConstantValues.BODY_KEY))
                .get(ConstantValues.FAULT))
              .get(ConstantValues.DETAIL))
            .get(ConstantValues.ERRORKEY))
          .get(ConstantValues.DESCRIPTION)) != null
      ) {
        errorForUser = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                      ConstantValues.ENVELOPE_KEY
                    ))
                    .get(ConstantValues.BODY_KEY))
                  .get(ConstantValues.FAULT))
                .get(ConstantValues.DETAIL))
              .get(ConstantValues.ERRORKEY))
            .get(ConstantValues.DESCRIPTION))
          .get(ConstantValues.NODE_VALUE);
        if (errorForUser != null) {
          return errorForUser;
        }
      }

      if (
        ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY)) !=
        null &&
        ((Map<String, Object>) ((Map<String, Object>) response.get(
            ConstantValues.ENVELOPE_KEY
          ))
          .get(ConstantValues.BODY_KEY)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY))
          .get(ConstantValues.DESCRIPTION)) != null
      ) {
        errorForUser = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                ConstantValues.ENVELOPE_KEY
              ))
              .get(ConstantValues.BODY_KEY))
            .get(ConstantValues.DESCRIPTION))
          .get(ConstantValues.NODE_VALUE);
        if (errorForUser != null) {
          return errorForUser;
        }
      }

      if (
        ((Map<String, Object>) response.get(ConstantValues.ENVELOPE_KEY)) !=
        null &&
        ((Map<String, Object>) ((Map<String, Object>) response.get(
            ConstantValues.ENVELOPE_KEY
          ))
          .get(ConstantValues.BODY_KEY)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
              ConstantValues.ENVELOPE_KEY
            ))
            .get(ConstantValues.BODY_KEY))
          .get(ConstantValues.RESPONSE_KEY)) != null &&
        ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                ConstantValues.ENVELOPE_KEY
              ))
              .get(ConstantValues.BODY_KEY))
            .get(ConstantValues.RESPONSE_KEY))
          .get(ConstantValues.COMPANY_ENQUIRY_REPORT)) != null
      ) {
        commonComReport = ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) response.get(
                ConstantValues.ENVELOPE_KEY
              ))
              .get(ConstantValues.BODY_KEY))
            .get(ConstantValues.RESPONSE_KEY))
          .get(ConstantValues.COMPANY_ENQUIRY_REPORT));
      }

      if (
        ((Map<String, Object>) commonComReport.get(
          ConstantValues.COMPANY_RESPONSE
        )) != null
      ) {
        commonComResponse = ((Map<String, Object>) commonComReport.get(
          ConstantValues.COMPANY_RESPONSE
        ));
      }

      if (
        ((Map<String, Object>) commonComResponse.get(
          ConstantValues.COMPANY_IDENTITY
        )) != null
      ) {
        commonComId = ((Map<String, Object>) commonComResponse.get(
          ConstantValues.COMPANY_IDENTITY
        ));
      }

      if (
        ((Map<String, Object>) commonComResponse.get(
          ConstantValues.SUMMARY_DATA
        )) != null &&
        ((List<Object>) ((Map<String, Object>) commonComResponse.get(
            ConstantValues.SUMMARY_DATA
          ))
          .get(ConstantValues.SUMMARY_ENTRY)) != null
      ) {
        commonSumEntry = ((List<Object>) ((Map<String, Object>) commonComResponse.get(
            ConstantValues.SUMMARY_DATA
          ))
          .get(ConstantValues.SUMMARY_ENTRY));
      }

      if (
        ((Map<String, Object>) commonComReport.get(
          ConstantValues.ORGANISATION_REPORT_HEADER
        )) != null
      ) {
        commonOrgReport = ((Map<String, Object>) commonComReport.get(
          ConstantValues.ORGANISATION_REPORT_HEADER
        ));
      }
      if (
        ((Map<String, Object>) commonComResponse.get(
          ConstantValues.ORGANISATION_CREDIT_HISTORY
        )) != null
      ) {
        commonOrgCred = ((Map<String, Object>) commonComResponse.get(
          ConstantValues.ORGANISATION_CREDIT_HISTORY
        ));
      }
      if (
        ((Map<String, Object>) commonComResponse.get(
          ConstantValues.OWNERSHIP_OFFICERS
        )) != null
      ) {
        commonOwnOff = ((Map<String, Object>) commonComResponse.get(
          ConstantValues.OWNERSHIP_OFFICERS
        ));
      }
      if (
        ((Map<String, Object>) commonComResponse.get(
          ConstantValues.PPSR_REGISTRATIONS
        )) != null
      ) {
        commonPpsr = ((Map<String, Object>) commonComResponse.get(
          ConstantValues.PPSR_REGISTRATIONS
        ));
      }

      clearPartyObjectData(partyObj);

      if (
        ((Map<String, Object>) commonComId.get(ConstantValues.BUREAU_INFO)) !=
        null &&
        ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
            ConstantValues.BUREAU_INFO
          ))
          .get(ConstantValues.BUREAU_REFERENCE)) != null
      ) {
        partyObj.File_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
              ConstantValues.BUREAU_INFO
            ))
            .get(ConstantValues.BUREAU_REFERENCE))
          .get(ConstantValues.NODE_VALUE);
      }

      if (
        ((Map<String, Object>) commonOrgReport.get(
          ConstantValues.REQUEST_ID
        )) != null
      ) {
        partyObj.Request_Id__c = (String) ((Map<String, Object>) commonOrgReport.get(
            ConstantValues.REQUEST_ID
          ))
          .get(ConstantValues.NODE_VALUE);
      }

      if (
        ((Map<String, Object>) commonOrgReport.get(
          ConstantValues.REPORT_CREATE_DATE
        )) != null
      ) {
        String reportCreateDate = (String) ((Map<String, Object>) commonOrgReport.get(
            ConstantValues.REPORT_CREATE_DATE
          ))
          .get(ConstantValues.NODE_VALUE);
        if (reportCreateDate != null && reportCreateDate.length() > 9) {
          partyObj.Report_Created_Date__c = Date.newInstance(
            Integer.valueOf(reportCreateDate.substring(0, 4)),
            Integer.valueOf(reportCreateDate.substring(5, 7)),
            Integer.valueOf(reportCreateDate.substring(8, 10))
          );
        }
      }

      //to insert number of credit enquiry for last 12 months
      if (
        findInSummaryData(
          commonSumEntry,
          ConstantValues.CREDIT_ENQUIRIES_LESS_THAN_12_MONTHS
        ) != null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.CREDIT_ENQUIRIES_LESS_THAN_12_MONTHS
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.Number_of_Credit_Enquiries_in_Last_12_Mo__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }
      //to find no of external admin
      if (
        findInSummaryData(commonSumEntry, ConstantValues.EXTERNAL_ADMIN) != null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.EXTERNAL_ADMIN
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.External_Administrators__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }
      //for asic extract date
      if (
        ((Map<String, Object>) commonOrgReport.get(
          ConstantValues.EXTRACT_DATE
        )) != null &&
        ((Map<String, Object>) ((Map<String, Object>) commonOrgReport.get(
            ConstantValues.EXTRACT_DATE
          ))
          .get(ConstantValues.ASIC_EXTRACT_DATE)) != null
      ) {
        String asicDate = (String) ((Map<String, Object>) ((Map<String, Object>) commonOrgReport.get(
              ConstantValues.EXTRACT_DATE
            ))
            .get(ConstantValues.ASIC_EXTRACT_DATE))
          .get(ConstantValues.NODE_VALUE);
        if (asicDate != null && asicDate.length() > 9) {
          partyObj.ASIC_Extract_Date__c = Date.newInstance(
            Integer.valueOf(asicDate.substring(0, 4)),
            Integer.valueOf(asicDate.substring(5, 7)),
            Integer.valueOf(asicDate.substring(8, 10))
          );
        }
      }
      //for incorporation date
      if (
        ((Map<String, Object>) commonComId.get(ConstantValues.INCORPORATION)) !=
        null &&
        ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
            ConstantValues.INCORPORATION
          ))
          .get(ConstantValues.INCORPORATION_DATE)) != null
      ) {
        String strIncorDate = (String) ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
              ConstantValues.INCORPORATION
            ))
            .get(ConstantValues.INCORPORATION_DATE))
          .get(ConstantValues.NODE_VALUE);
        if (strIncorDate != null && strIncorDate.length() > 9) {
          partyObj.Incorporation_Date__c = Date.newInstance(
            Integer.valueOf(strIncorDate.substring(0, 4)),
            Integer.valueOf(strIncorDate.substring(5, 7)),
            Integer.valueOf(strIncorDate.substring(8, 10))
          );
        }
      }

      if (
        ((Map<String, Object>) commonComId.get(
          ConstantValues.ORGANISATION_STATUS
        )) != null &&
        ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
            ConstantValues.ORGANISATION_STATUS
          ))
          .get(ConstantValues.TYPE)) != null
      ) {
        partyObj.Organization_Status__c = (String) ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
              ConstantValues.ORGANISATION_STATUS
            ))
            .get(ConstantValues.TYPE))
          .get(ConstantValues.NODE_VALUE);
      }
      // for registered office
      if (
        ((Map<String, Object>) commonComId.get(
          ConstantValues.REGISTERED_OFFICE
        )) != null &&
        ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
            ConstantValues.REGISTERED_OFFICE
          ))
          .get(ConstantValues.ADDRESS_LINES)) != null
      ) {
        partyObj.Registered_Office__c = processAddressLines(
          ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
              ConstantValues.REGISTERED_OFFICE
            ))
            .get(ConstantValues.ADDRESS_LINES))
        );
      }
      //  to find file create date
      if (
        ((Map<String, Object>) commonComId.get(ConstantValues.BUREAU_INFO)) !=
        null &&
        ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
            ConstantValues.BUREAU_INFO
          ))
          .get(ConstantValues.FILE_CREATION_DATE)) != null
      ) {
        String fileCreateDate = (String) ((Map<String, Object>) ((Map<String, Object>) commonComId.get(
              ConstantValues.BUREAU_INFO
            ))
            .get(ConstantValues.FILE_CREATION_DATE))
          .get(ConstantValues.NODE_VALUE);
        if (fileCreateDate != null && fileCreateDate.length() > 9) {
          partyObj.File_Create_Date__c = Date.newInstance(
            Integer.valueOf(fileCreateDate.substring(0, 4)),
            Integer.valueOf(fileCreateDate.substring(5, 7)),
            Integer.valueOf(fileCreateDate.substring(8, 10))
          );
        }
      }
      //to find court writs
      if (
        findInSummaryData(commonSumEntry, ConstantValues.WRITS_AND_SUMMONS) !=
        null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.WRITS_AND_SUMMONS
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.Court_Writs__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }
      //to find court writs amount
      if (
        findInSummaryData(
          commonSumEntry,
          ConstantValues.WRITS_AND_SUMMONS_VALUE
        ) != null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.WRITS_AND_SUMMONS_VALUE
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.Court_Writ_Amount__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }
      //to find court actions
      if (
        findInSummaryData(commonSumEntry, ConstantValues.JUDGEMENTS) != null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.JUDGEMENTS
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.Court_Actions__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }
      //to find court action amount
      if (
        findInSummaryData(commonSumEntry, ConstantValues.JUDGEMENTS_VALUE) !=
        null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.JUDGEMENTS_VALUE
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.Court_Action_Amount__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }
      //to find petitions count
      if (findInSummaryData(commonSumEntry, ConstantValues.PETITIONS) != null) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.PETITIONS
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null &&
          (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE) != null
        ) {
          partyObj.Petitions__c = Integer.valueOf(
            (String) ((Map<String, Object>) tempSummaryEntry.get(
                ConstantValues.SUMMARY_VALUE
              ))
              .get(ConstantValues.NODE_VALUE)
          );
        }
      }

      //to find company director adverse
      if (
        findInSummaryData(commonSumEntry, ConstantValues.DIRECTORS_ADVERSE) !=
        null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.DIRECTORS_ADVERSE
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null
        ) {
          partyObj.Company_Director_s_Adverse__c = (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE);
        }
      }
      //to find company director related entity adverse
      if (
        findInSummaryData(
          commonSumEntry,
          ConstantValues.DIRECTORS_RELATED_ENTITY_ADVERSE
        ) != null
      ) {
        Map<String, Object> tempSummaryEntry = findInSummaryData(
          commonSumEntry,
          ConstantValues.DIRECTORS_RELATED_ENTITY_ADVERSE
        );
        if (
          ((Map<String, Object>) tempSummaryEntry.get(
            ConstantValues.SUMMARY_VALUE
          )) != null
        ) {
          partyObj.Company_Director_s_Related_Entity_Advers__c = (String) ((Map<String, Object>) tempSummaryEntry.get(
              ConstantValues.SUMMARY_VALUE
            ))
            .get(ConstantValues.NODE_VALUE);
        }
      }

      List<Director__c> entityList = [
        SELECT Id, party__c
        FROM Director__c
        WHERE party__c = :partyObj.Id
      ];
      try {
        delete entityList;
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }
      entityList = new List<Director__c>();
      try {
        if (
          ((Map<String, Object>) commonOwnOff.get(
            ConstantValues.DIRECTORS_LIST
          )) != null &&
          String.valueOf(
              ((Map<String, Object>) commonOwnOff.get(
                ConstantValues.DIRECTORS_LIST
              ))
            )
            .contains(ConstantValues.DIRECTORS_ARRAY)
        ) {
          List<Object> refDirectors = ((List<Object>) ((Map<String, Object>) commonOwnOff.get(
              ConstantValues.DIRECTORS_LIST
            ))
            .get(ConstantValues.DIRECTORS));

          for (Object each : refDirectors) {
            Director__c dirObj = new Director__c();
            dirObj.Party__c = partyObj.Id;
            dirObj.Entity_Type__c = ConstantValues.DIRECTOR;
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.INDIVIDUAL_NAME)) != null
            ) {
              dirObj.Entity_Name__c = dirFullName(
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.INDIVIDUAL_NAME))
              );
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ADDRESS)) != null
            ) {
              dirObj.Address__c = processAddress(
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ADDRESS))
              );
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.BUREAU_REFERENCE)) != null
            ) {
              dirObj.File_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.BUREAU_REFERENCE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.DATE_OF_BIRTH)) != null
            ) {
              String dirDOB = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.DATE_OF_BIRTH))
                .get(ConstantValues.NODE_VALUE);
              if (dirDOB != null && dirDOB.length() > 9) {
                dirObj.Date_of_birth__c = Date.newInstance(
                  Integer.valueOf(dirDOB.substring(0, 4)),
                  Integer.valueOf(dirDOB.substring(5, 7)),
                  Integer.valueOf(dirDOB.substring(8, 10))
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.GENDER)) != null
            ) {
              dirObj.Gender__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.GENDER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.RESIDENCY_OVERSEAS)) != null
            ) {
              dirObj.Resident_Overseas__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.RESIDENCY_OVERSEAS))
                .get(ConstantValues.NODE_VALUE);
            }
            entityList.add(dirObj);
          }
        } else if (
          ((Map<String, Object>) commonOwnOff.get(
            ConstantValues.DIRECTORS_LIST
          )) != null &&
          String.valueOf(
              ((Map<String, Object>) commonOwnOff.get(
                ConstantValues.DIRECTORS_LIST
              ))
            )
            .contains(ConstantValues.DIRECTORS_OBJECT)
        ) {
          Object refDirectors = ((Object) ((Map<String, Object>) commonOwnOff.get(
              ConstantValues.DIRECTORS_LIST
            ))
            .get(ConstantValues.DIRECTORS));
          Director__c dirObj = new Director__c();
          dirObj.Party__c = partyObj.Id;
          dirObj.Entity_Type__c = ConstantValues.DIRECTOR;
          if (
            ((Map<String, Object>) refDirectors) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refDirectors)
              .get(ConstantValues.INDIVIDUAL_NAME)) != null
          ) {
            dirObj.Entity_Name__c = dirFullName(
              ((Map<String, Object>) ((Map<String, Object>) refDirectors)
                .get(ConstantValues.INDIVIDUAL_NAME))
            );
          }
          if (
            ((Map<String, Object>) refDirectors) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refDirectors)
              .get(ConstantValues.ADDRESS)) != null
          ) {
            dirObj.Address__c = processAddress(
              ((Map<String, Object>) ((Map<String, Object>) refDirectors)
                .get(ConstantValues.ADDRESS))
            );
          }
          if (
            ((Map<String, Object>) refDirectors) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refDirectors)
              .get(ConstantValues.BUREAU_REFERENCE)) != null
          ) {
            dirObj.File_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) refDirectors)
                .get(ConstantValues.BUREAU_REFERENCE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refDirectors) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refDirectors)
              .get(ConstantValues.DATE_OF_BIRTH)) != null
          ) {
            String dirDOB = (String) ((Map<String, Object>) ((Map<String, Object>) refDirectors)
                .get(ConstantValues.DATE_OF_BIRTH))
              .get(ConstantValues.NODE_VALUE);
            if (dirDOB != null && dirDOB.length() > 9) {
              dirObj.Date_of_birth__c = Date.newInstance(
                Integer.valueOf(dirDOB.substring(0, 4)),
                Integer.valueOf(dirDOB.substring(5, 7)),
                Integer.valueOf(dirDOB.substring(8, 10))
              );
            }
          }
          if (
            ((Map<String, Object>) refDirectors) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refDirectors)
              .get(ConstantValues.GENDER)) != null
          ) {
            dirObj.Gender__c = (String) ((Map<String, Object>) ((Map<String, Object>) refDirectors)
                .get(ConstantValues.GENDER))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refDirectors) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refDirectors)
              .get(ConstantValues.RESIDENCY_OVERSEAS)) != null
          ) {
            dirObj.Resident_Overseas__c = (String) ((Map<String, Object>) ((Map<String, Object>) refDirectors)
                .get(ConstantValues.RESIDENCY_OVERSEAS))
              .get(ConstantValues.NODE_VALUE);
          }
          entityList.add(dirObj);
        } else {
          returnValue += ConstantValues.NO_DIRECTORS_FOUND;
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }
      try {
        if (
          ((Map<String, Object>) commonOwnOff.get(
            ConstantValues.SHARE_HOLDER_LIST
          )) != null &&
          String.valueOf(
              ((Map<String, Object>) commonOwnOff.get(
                ConstantValues.SHARE_HOLDER_LIST
              ))
            )
            .contains(ConstantValues.SHARE_HOLDER_ARRAY)
        ) {
          List<Object> refShareholders = new List<Object>();
          Map<String, Object> shareHolderMap = ((Map<String, Object>) commonOwnOff.get(ConstantValues.SHARE_HOLDER_LIST));
          if(shareHolderMap != NULL && String.valueOf(shareHolderMap).contains(ConstantValues.SHARE_HOLDER_ARRAY_LIST) && (String.valueOf(shareHolderMap).contains(ConstantValues.SHARE_HOLDER_OBJECT) == false || String.valueOf(shareHolderMap).contains(ConstantValues.SINGLE_SHARE_HOLDER_OBJECT) == false)){
            refShareholders = ((List<Object>) ((Map<String, Object>) commonOwnOff.get(
              ConstantValues.SHARE_HOLDER_LIST
            ))
            .get(ConstantValues.SHARE_HOLDER));
          }
          else if(shareHolderMap != NULL && String.valueOf(shareHolderMap).contains(ConstantValues.SHARE_HOLDER_OBJECT) && String.valueOf(shareHolderMap).contains(ConstantValues.SINGLE_SHARE_HOLDER_OBJECT) == true){
            refShareholders.add(((Map<String, Object>) commonOwnOff.get(
              ConstantValues.SHARE_HOLDER_LIST
            ))
            .get(ConstantValues.SHARE_HOLDER));
          }
            Integer check;
          for (Object each : refShareholders) {
            check = 0;
            Map<String,Object> reMap = (Map<String,Object>)each;
            Director__c shareholderObj = new Director__c();
            shareholderObj.Party__c = partyObj.Id;
            shareholderObj.Entity_Type__c = ConstantValues.SHAREHOLDER;
            if(reMap != null && reMap.get(ConstantValues.INDIVIDUAL_SHARE_HOLDER) != null){
              if(String.valueOf(reMap).contains(ConstantValues.SHARE_HOLDER_ARRAY)){
                List<Object> individualShareholderList = (List<Object>)reMap.get(ConstantValues.INDIVIDUAL_SHARE_HOLDER);
                if(individualShareholderList.size() > 0){
                  check ++;
                  for(Object eachindividualShareholder : individualShareholderList){
                    shareholderObj = new Director__c();
                    shareholderObj.Party__c = partyObj.Id;
                    shareholderObj.Entity_Type__c = ConstantValues.SHAREHOLDER;
                    if (eachindividualShareholder != NULL && ((Map<String,Object>)eachindividualShareholder).get(ConstantValues.INDIVIDUAL_NAME) != null) {
                      shareholderObj.Entity_Name__c = indSharefullName((Map<String,Object>)((Map<String,Object>)eachindividualShareholder).get(ConstantValues.INDIVIDUAL_NAME)
                      );
                    }
                    if (eachindividualShareholder != NULL && ((Map<String, Object>)eachindividualShareholder).get(ConstantValues.ADDRESS_LINES) != null) {
                      shareholderObj.Address__c = processAddressLines((Map<String, Object>)((Map<String, Object>)eachindividualShareholder).get(ConstantValues.ADDRESS_LINES));
                    }
                    if (
                      ((Map<String, Object>) each) != null &&
                      ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.BENEFICIAL_OWNERSHIP)) != null
                    ) {
                      shareholderObj.Beneficially_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.BENEFICIAL_OWNERSHIP))
                        .get(ConstantValues.NODE_VALUE);
                    }
                    if (
                      ((Map<String, Object>) each) != null &&
                      ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.SHARE_CLASS_CODE)) != null
                    ) {
                      shareholderObj.Class_of_shares__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.SHARE_CLASS_CODE))
                        .get(ConstantValues.NODE_VALUE);
                    }
                    if (
                      ((Map<String, Object>) each) != null &&
                      ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.SHARES_HELD)) != null &&
                      (String) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.SHARES_HELD))
                        .get(ConstantValues.NODE_VALUE) != null
                    ) {
                      String shareIssued = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.SHARES_HELD))
                        .get(ConstantValues.NODE_VALUE);
                      if (shareIssued != null) {
                        shareholderObj.Number_of_shares_issued__c = Decimal.valueOf(
                          shareIssued
                        );
                      }
                    }
                    if (
                      ((Map<String, Object>) each) != null &&
                      ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.JOINTLY_HELD)) != null
                    ) {
                      shareholderObj.Jointly_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.JOINTLY_HELD))
                        .get(ConstantValues.NODE_VALUE);
                    }
                    entityList.add(shareholderObj);
                  }
                }
              }
              else{
                if (
                  ((Map<String, Object>) each) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
                    .get(ConstantValues.INDIVIDUAL_NAME)) != null
                  ) { 
                    shareholderObj.Entity_Name__c = indSharefullName(
                      ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
                        .get(ConstantValues.INDIVIDUAL_NAME))
                    );
                  }
                  if (
                    ((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
                      .get(ConstantValues.ADDRESS_LINES)) != null
                  ) {
                    shareholderObj.Address__c = processAddressLines(
                      ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
                        .get(ConstantValues.ADDRESS_LINES))
                    );
                  }
              }
            }
            if(reMap != null && reMap.get(ConstantValues.ORGANISATION_SHARE_HOLDER) != null && String.valueOf(reMap).contains(ConstantValues.SHARE_HOLDER_ARRAY)){
              List<Object> organisationShareholderList = (List<Object>)reMap.get(ConstantValues.ORGANISATION_SHARE_HOLDER);
              if(organisationShareholderList.size() > 0){
                check ++;
                for(Object eachorgShareholder : organisationShareholderList){
                  shareholderObj = new Director__c();
                  shareholderObj.Party__c = partyObj.Id;
                  shareholderObj.Entity_Type__c = ConstantValues.SHAREHOLDER;
                  if (
                    eachorgShareholder != null &&
                    ((Map<String, Object>) eachorgShareholder).get(ConstantValues.ORGANISATION_NAME) != null
                  ) {
                    shareholderObj.Entity_Name__c = (String) ((Map<String, Object>)((Map<String, Object>)eachorgShareholder).get(ConstantValues.ORGANISATION_NAME))
                      .get(ConstantValues.NODE_VALUE);
                  }
                  if (eachorgShareholder != NULL && ((Map<String, Object>)eachorgShareholder).get(ConstantValues.ADDRESS_LINES) != null) {
                    shareholderObj.Address__c = processAddressLines((Map<String, Object>)((Map<String, Object>)eachorgShareholder).get(ConstantValues.ADDRESS_LINES));
                  }
                  if (
                    ((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.BENEFICIAL_OWNERSHIP)) != null
                  ) {
                    shareholderObj.Beneficially_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.BENEFICIAL_OWNERSHIP))
                      .get(ConstantValues.NODE_VALUE);
                  }
                  if (
                    ((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.SHARE_CLASS_CODE)) != null
                  ) {
                    shareholderObj.Class_of_shares__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.SHARE_CLASS_CODE))
                      .get(ConstantValues.NODE_VALUE);
                  }
                  if (
                    ((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.SHARES_HELD)) != null &&
                    (String) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.SHARES_HELD))
                      .get(ConstantValues.NODE_VALUE) != null
                  ) {
                    String shareIssued = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.SHARES_HELD))
                      .get(ConstantValues.NODE_VALUE);
                    if (shareIssued != null) {
                      shareholderObj.Number_of_shares_issued__c = Decimal.valueOf(
                        shareIssued
                      );
                    }
                  }
                  if (
                    ((Map<String, Object>) each) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.JOINTLY_HELD)) != null
                  ) {
                    shareholderObj.Jointly_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.JOINTLY_HELD))
                      .get(ConstantValues.NODE_VALUE);
                  }
                  entityList.add(shareholderObj);
                }
              }
            }
            else {
              if (
                ((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ORGANISATION_SHARE_HOLDER)) != null &&
                ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
                  .get(ConstantValues.ORGANISATION_NAME)) != null
              ) {
                shareholderObj.Entity_Name__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
                    .get(ConstantValues.ORGANISATION_NAME))
                  .get(ConstantValues.NODE_VALUE);
              }
              if (
                ((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ORGANISATION_SHARE_HOLDER)) != null &&
                ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
                  .get(ConstantValues.ADDRESS_LINES)) != null
              ) {
                shareholderObj.Address__c = processAddressLines(
                  ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
                    .get(ConstantValues.ADDRESS_LINES))
                );
              }
              if (
                ((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.BENEFICIAL_OWNERSHIP)) != null
              ) {
                shareholderObj.Beneficially_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.BENEFICIAL_OWNERSHIP))
                  .get(ConstantValues.NODE_VALUE);
              }
              if (
                ((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.SHARE_CLASS_CODE)) != null
              ) {
                shareholderObj.Class_of_shares__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.SHARE_CLASS_CODE))
                  .get(ConstantValues.NODE_VALUE);
              }
              if (
                ((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.SHARES_HELD)) != null &&
                (String) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.SHARES_HELD))
                  .get(ConstantValues.NODE_VALUE) != null
              ) {
                String shareIssued = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.SHARES_HELD))
                  .get(ConstantValues.NODE_VALUE);
                if (shareIssued != null) {
                  shareholderObj.Number_of_shares_issued__c = Decimal.valueOf(
                    shareIssued
                  );
                }
              }
              if (
                ((Map<String, Object>) each) != null &&
                ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.JOINTLY_HELD)) != null
              ) {
                shareholderObj.Jointly_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.JOINTLY_HELD))
                  .get(ConstantValues.NODE_VALUE);
              }
            }
            if(check == 0){
              entityList.add(shareholderObj);
            }
          }
        } else if (
          ((Map<String, Object>) commonOwnOff.get(
            ConstantValues.SHARE_HOLDER_LIST
          )) != null &&
          String.valueOf(
              ((Map<String, Object>) commonOwnOff.get(
                ConstantValues.SHARE_HOLDER_LIST
              ))
            )
            .contains(ConstantValues.SHARE_HOLDER_OBJECT)
        ) {
          Object refShareholders = ((Object) ((Map<String, Object>) commonOwnOff.get(
              ConstantValues.SHARE_HOLDER_LIST
            ))
            .get(ConstantValues.SHARE_HOLDER));
          Director__c shareholderObj = new Director__c();
          shareholderObj.Party__c = partyObj.Id;
          shareholderObj.Entity_Type__c = ConstantValues.SHAREHOLDER;
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
              .get(ConstantValues.INDIVIDUAL_NAME)) != null
          ) {
            shareholderObj.Entity_Name__c = indSharefullName(
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                  .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
                .get(ConstantValues.INDIVIDUAL_NAME))
            );
          }
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.ORGANISATION_SHARE_HOLDER)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
              .get(ConstantValues.ORGANISATION_NAME)) != null
          ) {
            shareholderObj.Entity_Name__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                  .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
                .get(ConstantValues.ORGANISATION_NAME))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
              .get(ConstantValues.ADDRESS_LINES)) != null
          ) {
            shareholderObj.Address__c = processAddressLines(
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                  .get(ConstantValues.INDIVIDUAL_SHARE_HOLDER))
                .get(ConstantValues.ADDRESS_LINES))
            );
          }
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.ORGANISATION_SHARE_HOLDER)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
              .get(ConstantValues.ADDRESS_LINES)) != null
          ) {
            shareholderObj.Address__c = processAddressLines(
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                  .get(ConstantValues.ORGANISATION_SHARE_HOLDER))
                .get(ConstantValues.ADDRESS_LINES))
            );
          }
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.BENEFICIAL_OWNERSHIP)) != null
          ) {
            shareholderObj.Beneficially_Held__c = (String) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.BENEFICIAL_OWNERSHIP))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.SHARE_CLASS_CODE)) != null
          ) {
            shareholderObj.Class_of_shares__c = (String) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.SHARE_CLASS_CODE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refShareholders) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refShareholders)
              .get(ConstantValues.SHARES_HELD)) != null &&
            (String) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.SHARES_HELD))
              .get(ConstantValues.NODE_VALUE) != null
          ) {
            String shareIssued = (String) ((Map<String, Object>) ((Map<String, Object>) refShareholders)
                .get(ConstantValues.SHARES_HELD))
              .get(ConstantValues.NODE_VALUE);
            if (shareIssued != null) {
              shareholderObj.Number_of_shares_issued__c = Decimal.valueOf(
                shareIssued
              );
            }
          }
          entityList.add(shareholderObj);
        } else {
          returnValue += ConstantValues.NO_SHAREHOLDERS_FOUND;
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }

      try {
        if (
          ((Map<String, Object>) commonPpsr.get(
            ConstantValues.REGISTRATION_LIST
          )) != null &&
          (String.valueOf(
              ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
                ConstantValues.REGISTRATION_LIST
              )))
            ))
            .contains(ConstantValues.REGISTRATION_LIST_ARRAY)
        ) {
          List<Object> refRegistrationList = ((List<Object>) ((Map<String, Object>) commonPpsr.get(
              ConstantValues.REGISTRATION_LIST
            ))
            .get(ConstantValues.REGISTRATION_DETAIL));
          for (Object each : refRegistrationList) {
            Director__c registrationListObj = new Director__c();
            registrationListObj.Party__c = partyObj.Id;
            registrationListObj.Entity_Type__c = ConstantValues.REGISTRATIONS;
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.REGISTRATION_NUMBER)) != null
            ) {
              registrationListObj.Registration_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.REGISTRATION_NUMBER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.REGISTRATION_START_DATE)) != null
            ) {
              String startDate = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.REGISTRATION_START_DATE))
                .get(ConstantValues.NODE_VALUE);
              if (startDate != null && startDate.length() > 9) {
                registrationListObj.Start_Date__c = Date.newInstance(
                  Integer.valueOf(startDate.substring(0, 4)),
                  Integer.valueOf(startDate.substring(5, 7)),
                  Integer.valueOf(startDate.substring(8, 10))
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.MIGRATED_FLAG)) != null
            ) {
              registrationListObj.Migration__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.MIGRATED_FLAG))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.COLLATERAL_CLASS)) != null
            ) {
              registrationListObj.Collateral__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.COLLATERAL_CLASS))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.PMSI_FLAG)) != null
            ) {
              registrationListObj.Pmsi__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.PMSI_FLAG))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.SECURED_PARTIES)) != null
            ) {
              if (
                String.valueOf(
                    ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.SECURED_PARTIES))
                  )
                  .contains(ConstantValues.SECURED_PARTY_LIST)
              ) {
                List<Object> securedPartyList = ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.SECURED_PARTIES))
                  .get(ConstantValues.SECURED_PARTY));
                for (Object secureAddress : securedPartyList) {
                  if (
                    ((Map<String, Object>) ((Map<String, Object>) secureAddress)
                      .get(ConstantValues.ORGANISATION)) != null
                  ) {
                    registrationListObj.Secured_Parties__c = securedParty(
                      ((Map<String, Object>) ((Map<String, Object>) secureAddress)
                        .get(ConstantValues.ORGANISATION))
                    );
                  }
                }
              } else {
                if (
                  ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                      .get(ConstantValues.SECURED_PARTIES))
                    .get(ConstantValues.SECURED_PARTY)) != null &&
                  ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                        .get(ConstantValues.SECURED_PARTIES))
                      .get(ConstantValues.SECURED_PARTY))
                    .get(ConstantValues.ORGANISATION)) != null
                ) {
                  registrationListObj.Secured_Parties__c = securedParty(
                    ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                          .get(ConstantValues.SECURED_PARTIES))
                        .get(ConstantValues.SECURED_PARTY))
                      .get(ConstantValues.ORGANISATION))
                  );
                }
              }
            }
            entityList.add(registrationListObj);
          }
        } else if (
          ((Map<String, Object>) commonPpsr.get(
            ConstantValues.REGISTRATION_LIST
          ) != null) &&
          (String.valueOf(
              ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
                ConstantValues.REGISTRATION_LIST
              )))
            ))
            .contains(ConstantValues.REGISTRATION_LIST_OBJECT)
        ) {
          Object refRegistrationList = ((Object) ((Map<String, Object>) commonPpsr.get(
              ConstantValues.REGISTRATION_LIST
            ))
            .get(ConstantValues.REGISTRATION_DETAIL));
          Director__c registrationListObj = new Director__c();
          registrationListObj.Party__c = partyObj.Id;
          registrationListObj.Entity_Type__c = ConstantValues.REGISTRATIONS;
          if (
            ((Map<String, Object>) refRegistrationList) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
              .get(ConstantValues.REGISTRATION_NUMBER)) != null
          ) {
            registrationListObj.Registration_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                .get(ConstantValues.REGISTRATION_NUMBER))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refRegistrationList) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
              .get(ConstantValues.REGISTRATION_START_DATE)) != null
          ) {
            String startDate = (String) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                .get(ConstantValues.REGISTRATION_START_DATE))
              .get(ConstantValues.NODE_VALUE);
            if (startDate != null && startDate.length() > 9) {
              registrationListObj.Start_Date__c = Date.newInstance(
                Integer.valueOf(startDate.substring(0, 4)),
                Integer.valueOf(startDate.substring(5, 7)),
                Integer.valueOf(startDate.substring(8, 10))
              );
            }
          }
          if (
            ((Map<String, Object>) refRegistrationList) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
              .get(ConstantValues.MIGRATED_FLAG)) != null
          ) {
            registrationListObj.Migration__c = (String) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                .get(ConstantValues.MIGRATED_FLAG))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refRegistrationList) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
              .get(ConstantValues.COLLATERAL_CLASS)) != null
          ) {
            registrationListObj.Collateral__c = (String) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                .get(ConstantValues.COLLATERAL_CLASS))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refRegistrationList) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
              .get(ConstantValues.PMSI_FLAG)) != null
          ) {
            registrationListObj.Pmsi__c = (String) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                .get(ConstantValues.PMSI_FLAG))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refRegistrationList) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
              .get(ConstantValues.SECURED_PARTIES)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                .get(ConstantValues.SECURED_PARTIES))
              .get(ConstantValues.SECURED_PARTY)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                  .get(ConstantValues.SECURED_PARTIES))
                .get(ConstantValues.SECURED_PARTY))
              .get(ConstantValues.ORGANISATION)) != null
          ) {
            registrationListObj.Secured_Parties__c = securedParty(
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refRegistrationList)
                    .get(ConstantValues.SECURED_PARTIES))
                  .get(ConstantValues.SECURED_PARTY))
                .get(ConstantValues.ORGANISATION))
            );
          }
          entityList.add(registrationListObj);
        } else {
          returnValue += ConstantValues.NO_REGISTRATION_LIST_FOUND;
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }

      List<Credit_Enquiry__c> finalCreditEnquiryList = [
        SELECT Id, party__c
        FROM Credit_Enquiry__c
        WHERE party__c = :partyObj.Id
      ];
      try {
        delete finalCreditEnquiryList;
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }
      try {
        finalCreditEnquiryList = new List<Credit_Enquiry__c>();
        /*********************************************************/
        //Changes made by Rameswari on 07/04/2021 to facilitate the storing of single credit enquiry
        List <Object> creditEnquirylist = new List <Object>();
        Integer counter = 0;
        if(((Map<String, Object>) commonOrgCred.get(
          ConstantValues.ALL_CREDIT_ENQUIRY_LIST
        )) != null){
          if(((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
            ConstantValues.ALL_CREDIT_ENQUIRY_LIST
          ))
          .get(ConstantValues.CREDIT_ENQUIRY_LIST)) != null){
            if(String.ValueOf(((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
              ConstantValues.ALL_CREDIT_ENQUIRY_LIST
            ))
            .get(ConstantValues.CREDIT_ENQUIRY_LIST))).contains(ConstantValues.CREDIT_ENQUIRY_OBJECT) && ((Object) ((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
              ConstantValues.ALL_CREDIT_ENQUIRY_LIST
              ))
              .get(ConstantValues.CREDIT_ENQUIRY_LIST))
            .get(ConstantValues.CREDIT_ENQUIRY)) != null){
              creditEnquirylist.add(((Object) ((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
                ConstantValues.ALL_CREDIT_ENQUIRY_LIST
                ))
                .get(ConstantValues.CREDIT_ENQUIRY_LIST))
              .get(ConstantValues.CREDIT_ENQUIRY)));
            }
            else if(String.ValueOf(((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
              ConstantValues.ALL_CREDIT_ENQUIRY_LIST
            ))
            .get(ConstantValues.CREDIT_ENQUIRY_LIST))).contains(ConstantValues.CREDIT_ENQUIRY_LIST_BRACES) &&
            ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
              ConstantValues.ALL_CREDIT_ENQUIRY_LIST
              ))
              .get(ConstantValues.CREDIT_ENQUIRY_LIST))
            .get(ConstantValues.CREDIT_ENQUIRY)) != null){
              counter++;
            }
          }
        }
        if (creditEnquirylist.size() > 0 || counter == 1) {
          List<Object> refCreditEnquiry = new List<Object>();
          if(creditEnquirylist.size() == 1 && counter == 0){
            refCreditEnquiry = creditEnquirylist;
          }
          else if(counter == 1){
            //Changes made by Rameswari on 07/04/2021 to facilitate the storing of single credit enquiry
            /*********************************************************/
            refCreditEnquiry = ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) commonOrgCred.get(
                ConstantValues.ALL_CREDIT_ENQUIRY_LIST
              ))
              .get(ConstantValues.CREDIT_ENQUIRY_LIST))
            .get(ConstantValues.CREDIT_ENQUIRY));
          }
          for (Object each : refCreditEnquiry) {
            Credit_Enquiry__c creditEnquiryObj = new Credit_Enquiry__c();
            creditEnquiryObj.Party__c = partyObj.Id;
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ACCOUNT_TYPE)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ACCOUNT_TYPE))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditEnquiryObj.Account_Type__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ACCOUNT_TYPE))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ENQUIRER)) != null
            ) {
              creditEnquiryObj.Credit_Enquirer__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ENQUIRER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.AMOUNT)) != null
            ) {
              String strEnqAmount = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.AMOUNT))
                .get(ConstantValues.NODE_VALUE);
              creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(
                strEnqAmount
              );
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ENQUIRY_DATE)) != null
            ) {
              String strEnqDat = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ENQUIRY_DATE))
                .get(ConstantValues.NODE_VALUE);
              if (strEnqDat != null && strEnqDat.length() > 9) {
                creditEnquiryObj.Enquiry_Date__c = Date.newInstance(
                  Integer.valueOf(strEnqDat.substring(0, 4)),
                  Integer.valueOf(strEnqDat.substring(5, 7)),
                  Integer.valueOf(strEnqDat.substring(8, 10))
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.REF_NUMBER)) != null
            ) {
              creditEnquiryObj.Reference_No__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.REF_NUMBER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ROLE)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ROLE))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditEnquiryObj.Role_in_Enquiry__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ROLE))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            finalCreditEnquiryList.add(creditEnquiryObj);
          }
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
        returnValue += ConstantValues.NO_CREDIT_ENQUIRIES_FOUND;
      }

      PPSR_Registration__c ppsrRegistrationData;
      List<PPSR_Registration__c> ppsrRegistrationList = [
        SELECT Party__c, Id
        FROM PPSR_Registration__c
        WHERE Party__c = :partyObj.id
      ];
      if (ppsrRegistrationList.isEmpty()) {
        ppsrRegistrationData = new PPSR_Registration__c();
        ppsrRegistrationData.Party__c = partyObj.Id;
        try {
          insert ppsrRegistrationData;
        } catch (Exception ex) {
          GenericUtility.insertLog(
            ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
            ex
          );
        }
      } else {
        ppsrRegistrationData = ppsrRegistrationList[0];
        ppsrRegistrationData.Search_Date__c = null;
        ppsrRegistrationData.Search_Number__c = null;
        ppsrRegistrationData.Total_Registrations__c = null;
      }
      try {
        if (
          ((Map<String, Object>) commonPpsr.get(
            ConstantValues.REPORT_INFORMATION
          )) != null &&
          ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
              ConstantValues.REPORT_INFORMATION
            ))
            .get(ConstantValues.SEARCH_DATE)) != null
        ) {
          String searchDatePPSR = (String) ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
                ConstantValues.REPORT_INFORMATION
              ))
              .get(ConstantValues.SEARCH_DATE))
            .get(ConstantValues.NODE_VALUE);
          if (searchDatePPSR != null && searchDatePPSR.length() > 9) {
            ppsrRegistrationData.Search_Date__c = Date.newInstance(
              Integer.valueOf(searchDatePPSR.substring(0, 4)),
              Integer.valueOf(searchDatePPSR.substring(5, 7)),
              Integer.valueOf(searchDatePPSR.substring(8, 10))
            );
          }
        }
        if (
          ((Map<String, Object>) commonPpsr.get(
            ConstantValues.REPORT_INFORMATION
          )) != null &&
          ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
              ConstantValues.REPORT_INFORMATION
            ))
            .get(ConstantValues.SEARCH_NUMBER)) != null
        ) {
          ppsrRegistrationData.Search_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
                ConstantValues.REPORT_INFORMATION
              ))
              .get(ConstantValues.SEARCH_NUMBER))
            .get(ConstantValues.NODE_VALUE);
        }
        if (
          ((Map<String, Object>) commonPpsr.get(
            ConstantValues.REGISTRATION_SUMMARY
          )) != null &&
          ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
              ConstantValues.REGISTRATION_SUMMARY
            ))
            .get(ConstantValues.TOTAL_REGISTRATIONS)) != null
        ) {
          String totalregistrations = (String) ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
                ConstantValues.REGISTRATION_SUMMARY
              ))
              .get(ConstantValues.TOTAL_REGISTRATIONS))
            .get(ConstantValues.NODE_VALUE);
          if (totalregistrations != null) {
            ppsrRegistrationData.Total_Registrations__c = Decimal.valueOf(
              (String) ((Map<String, Object>) ((Map<String, Object>) commonPpsr.get(
                    ConstantValues.REGISTRATION_SUMMARY
                  ))
                  .get(ConstantValues.TOTAL_REGISTRATIONS))
                .get(ConstantValues.NODE_VALUE)
            );
          }
        }
      } catch (Exception Ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
        return ConstantValues.NO_PPSR_REGISTRATIONS_FOUND;
      }

      List<Credit_Account__c> creditAccountList = [
        SELECT Party__c, Id
        FROM Credit_Account__c
        WHERE Party__c = :partyObj.Id
      ];
      try {
        delete creditAccountList;
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }
      creditAccountList = new List<Credit_Account__c>();

      try {
        if (
          ((Map<String, Object>) commonOrgCred.get(
            ConstantValues.PAYMENT_DEFAULT_LIST
          )) != null &&
          String.valueOf(
              (((Map<String, Object>) commonOrgCred.get(
                ConstantValues.PAYMENT_DEFAULT_LIST
              )))
            )
            .contains(ConstantValues.PAYMENT_DEFAULT_ARRAY)
        ) {
          List<Object> refCreditAccount = ((List<Object>) ((Map<String, Object>) commonOrgCred.get(
              ConstantValues.PAYMENT_DEFAULT_LIST
            ))
            .get(ConstantValues.PAYMENT_DEFAULTS));

          for (Object each : refCreditAccount) {
            Credit_Account__c creditAccountObj = new Credit_Account__c();
            creditAccountObj.Party__c = partyObj.id;
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ACCOUNT_TYPE)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ACCOUNT_TYPE))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditAccountObj.Account_Type__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ACCOUNT_TYPE))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ROLE)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ROLE))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditAccountObj.Role__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ROLE))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ACCOUNT_NUMBER)) != null
            ) {
              creditAccountObj.Account_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ACCOUNT_NUMBER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.PROVIDER)) != null
            ) {
              creditAccountObj.Latest_Credit_Provider__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.PROVIDER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ORIGINAL_PROVIDER)) != null
            ) {
              creditAccountObj.Original_Credit_Provider__c = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ORIGINAL_PROVIDER))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.AMOUNT)) != null
            ) {
              String strCurrDefAmt = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.AMOUNT))
                .get(ConstantValues.NODE_VALUE);
              if (strCurrDefAmt != null) {
                creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(
                  strCurrDefAmt
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.DEFAULT_DATE)) != null
            ) {
              String strDefDate = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.DEFAULT_DATE))
                .get(ConstantValues.NODE_VALUE);
              if (strDefDate != null && strDefDate.length() > 9) {
                creditAccountObj.Default_Date__c = Date.newInstance(
                  Integer.valueOf(strDefDate.substring(0, 4)),
                  Integer.valueOf(strDefDate.substring(5, 7)),
                  Integer.valueOf(strDefDate.substring(8, 10))
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.REPORT_REASON)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.REPORT_REASON))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditAccountObj.Report_Reason__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.REPORT_REASON))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ORIGINAL_DEFAULT_DATE)) != null
            ) {
              String orgDefDate = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ORIGINAL_DEFAULT_DATE))
                .get(ConstantValues.NODE_VALUE);
              if (orgDefDate != null && orgDefDate.length() > 9) {
                creditAccountObj.Original_Default_Date__c = Date.newInstance(
                  Integer.valueOf(orgDefDate.substring(0, 4)),
                  Integer.valueOf(orgDefDate.substring(5, 7)),
                  Integer.valueOf(orgDefDate.substring(8, 10))
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ORIGINAL_AMOUNT)) != null
            ) {
              String strDefaultAmount = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ORIGINAL_AMOUNT))
                .get(ConstantValues.NODE_VALUE);
              if (strDefaultAmount != null) {
                creditAccountObj.Original_Default_Amount__c = Decimal.valueOf(
                  strDefaultAmount
                );
              }
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.ORIGINAL_REPORT_REASON)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.ORIGINAL_REPORT_REASON))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditAccountObj.Original_Report_Reason__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.ORIGINAL_REPORT_REASON))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.PAYMENT_STATUS)) != null &&
              ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.PAYMENT_STATUS))
                .get(ConstantValues.TYPE)) != null
            ) {
              creditAccountObj.Status__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) each)
                    .get(ConstantValues.PAYMENT_STATUS))
                  .get(ConstantValues.TYPE))
                .get(ConstantValues.NODE_VALUE);
            }
            if (
              ((Map<String, Object>) each) != null &&
              ((Map<String, Object>) ((Map<String, Object>) each)
                .get(ConstantValues.STATUS_DATE)) != null
            ) {
              String statDate = (String) ((Map<String, Object>) ((Map<String, Object>) each)
                  .get(ConstantValues.STATUS_DATE))
                .get(ConstantValues.NODE_VALUE);
              if (statDate != null && statDate.length() > 9) {
                creditAccountObj.Status_Date__c = Date.newInstance(
                  Integer.valueOf(statDate.substring(0, 4)),
                  Integer.valueOf(statDate.substring(5, 7)),
                  Integer.valueOf(statDate.substring(8, 10))
                );
              }
            }
            creditAccountList.add(creditAccountObj);
          }
        } else if (
          ((Map<String, Object>) commonOrgCred.get(
            ConstantValues.PAYMENT_DEFAULT_LIST
          )) != null &&
          String.valueOf(
              (((Map<String, Object>) commonOrgCred.get(
                ConstantValues.PAYMENT_DEFAULT_LIST
              )))
            )
            .contains(ConstantValues.PAYMENT_DEFAULT_OBJECT)
        ) {
          Object refCreditAccount = ((Object) ((Map<String, Object>) commonOrgCred.get(
              ConstantValues.PAYMENT_DEFAULT_LIST
            ))
            .get(ConstantValues.PAYMENT_DEFAULTS));
          Credit_Account__c creditAccountObj = new Credit_Account__c();
          creditAccountObj.Party__c = partyObj.id;
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ACCOUNT_TYPE)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ACCOUNT_TYPE))
              .get(ConstantValues.TYPE)) != null
          ) {
            creditAccountObj.Account_Type__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                  .get(ConstantValues.ACCOUNT_TYPE))
                .get(ConstantValues.TYPE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ROLE)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ROLE))
              .get(ConstantValues.TYPE)) != null
          ) {
            creditAccountObj.Role__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                  .get(ConstantValues.ROLE))
                .get(ConstantValues.TYPE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ACCOUNT_NUMBER)) != null
          ) {
            creditAccountObj.Account_Number__c = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ACCOUNT_NUMBER))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.PROVIDER)) != null
          ) {
            creditAccountObj.Latest_Credit_Provider__c = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.PROVIDER))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ORIGINAL_PROVIDER)) != null
          ) {
            creditAccountObj.Original_Credit_Provider__c = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ORIGINAL_PROVIDER))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.AMOUNT)) != null
          ) {
            String strCurrDefAmt = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.AMOUNT))
              .get(ConstantValues.NODE_VALUE);
            if (strCurrDefAmt != null) {
              creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(
                strCurrDefAmt
              );
            }
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.DEFAULT_DATE)) != null
          ) {
            String strDefDate = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.DEFAULT_DATE))
              .get(ConstantValues.NODE_VALUE);
            if (strDefDate != null && strDefDate.length() > 9) {
              creditAccountObj.Default_Date__c = Date.newInstance(
                Integer.valueOf(strDefDate.substring(0, 4)),
                Integer.valueOf(strDefDate.substring(5, 7)),
                Integer.valueOf(strDefDate.substring(8, 10))
              );
            }
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.REPORT_REASON)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.REPORT_REASON))
              .get(ConstantValues.TYPE)) != null
          ) {
            creditAccountObj.Report_Reason__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                  .get(ConstantValues.REPORT_REASON))
                .get(ConstantValues.TYPE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ORIGINAL_DEFAULT_DATE)) != null
          ) {
            String orgDefDate = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ORIGINAL_DEFAULT_DATE))
              .get(ConstantValues.NODE_VALUE);
            if (orgDefDate != null && orgDefDate.length() > 9) {
              creditAccountObj.Original_Default_Date__c = Date.newInstance(
                Integer.valueOf(orgDefDate.substring(0, 4)),
                Integer.valueOf(orgDefDate.substring(5, 7)),
                Integer.valueOf(orgDefDate.substring(8, 10))
              );
            }
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ORIGINAL_AMOUNT)) != null
          ) {
            String strDefaultAmount = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ORIGINAL_AMOUNT))
              .get(ConstantValues.NODE_VALUE);
            if (strDefaultAmount != null) {
              creditAccountObj.Original_Default_Amount__c = Decimal.valueOf(
                strDefaultAmount
              );
            }
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.ORIGINAL_REPORT_REASON)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.ORIGINAL_REPORT_REASON))
              .get(ConstantValues.TYPE)) != null
          ) {
            creditAccountObj.Original_Report_Reason__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                  .get(ConstantValues.ORIGINAL_REPORT_REASON))
                .get(ConstantValues.TYPE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.PAYMENT_STATUS)) != null &&
            ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.PAYMENT_STATUS))
              .get(ConstantValues.TYPE)) != null
          ) {
            creditAccountObj.Status__c = (String) ((Map<String, Object>) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                  .get(ConstantValues.PAYMENT_STATUS))
                .get(ConstantValues.TYPE))
              .get(ConstantValues.NODE_VALUE);
          }
          if (
            ((Map<String, Object>) refCreditAccount) != null &&
            ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
              .get(ConstantValues.STATUS_DATE)) != null
          ) {
            String statDate = (String) ((Map<String, Object>) ((Map<String, Object>) refCreditAccount)
                .get(ConstantValues.STATUS_DATE))
              .get(ConstantValues.NODE_VALUE);
            if (statDate != null && statDate.length() > 9) {
              creditAccountObj.Status_Date__c = Date.newInstance(
                Integer.valueOf(statDate.substring(0, 4)),
                Integer.valueOf(statDate.substring(5, 7)),
                Integer.valueOf(statDate.substring(8, 10))
              );
            }
          }
          creditAccountList.add(creditAccountObj);
        } else {
          returnValue += ConstantValues.NO_PAYMENT_DEFAULTS_FOUND;
        }
      } catch (Exception ex) {
        GenericUtility.insertLog(
          ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
          ex
        );
      }
      Database.update(partyObj);
      Database.update(ppsrRegistrationData);
      Database.insert(entityList, false);
      Database.insert(finalCreditEnquiryList, false);
      Database.insert(creditAccountList, false);
      return returnValue;
    } catch (Exception ex) {
      GenericUtility.insertLog(
        ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER,
        ex
      );
      return ConstantValues.GENERAL_ERROR;
    }
  }
  private static void clearPartyObjectData(clcommon__Party__c partyObj) {
    partyObj.Request_Id__c = null;
    partyObj.Report_Created_Date__c = null;
    partyObj.File_Number__c = null;
    partyObj.Number_of_Credit_Enquiries_in_Last_12_Mo__c = null;
    partyObj.External_Administrators__c = null;
    partyObj.ASIC_Extract_Date__c = null;
    partyObj.Incorporation_Date__c = null;
    partyObj.Organization_Status__c = null;
    partyObj.Registered_Office__c = null;
    partyObj.File_Create_Date__c = null;
    partyObj.Court_Writs__c = null;
    partyObj.Court_Writ_Amount__c = null;
    partyObj.Court_Actions__c = null;
    partyObj.Court_Action_Amount__c = null;
    partyObj.Petitions__c = null;
    partyObj.Company_Director_s_Adverse__c = null;
    partyObj.Company_Director_s_Related_Entity_Advers__c = null;
    update partyObj;
  }
}