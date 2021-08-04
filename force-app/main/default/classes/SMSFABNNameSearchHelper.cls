/***************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Description : This class is used to convert response from SuperFundLookup for SMSF Name Search
                 json format into POJO object
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/

public class SMSFABNNameSearchHelper {
  public String errMessage;
  public Cls_SuperFundNamesPayload superFundNamesPayload;
  public class Cls_SuperFundNamesPayload {
    public String nodeValue;
    public Cls_Request request;
    public Cls_Response response;
  }
  public class Cls_Request {
    public String nodeValue;
    public Cls_Guid guid;
    public Cls_Name name;
    public Cls_ActiveFundsOnly activeFundsOnly;
  }
  public class Cls_Guid {
    public String nodeValue;
  }
  public class Cls_Name {
    public String nodeValue;
  }
  public class Cls_ActiveFundsOnly {
    public String nodeValue;
  }
  public class Cls_Response {
    public String nodeValue;
    public Cls_UsageStatement usageStatement;
    public Cls_DateTimeRetrieved dateTimeRetrieved;
    public Cls_MatchingFundNames201908 matchingFundNames201908;
  }
  public class Cls_UsageStatement {
    public String nodeValue;
  }
  public class Cls_DateTimeRetrieved {
    public String nodeValue;
  }
  public class Cls_MatchingFundNames201908 {
    public String nodeValue;
    public Cls_NumberOfRecords numberOfRecords;
    public Cls_MatchingFundName[] matchingFundName;
  }
  public class Cls_NumberOfRecords {
    public String nodeValue;
  }
  public class Cls_MatchingFundName {
    public String nodeValue;
    public Cls_ABN abn;
    public Cls_FundName fundName;
    public Cls_Location location;
  }
  public class Cls_ABN {
    public String nodeValue;
    public Cls_Value value;
    public Cls_IdentifierStatus identifierStatus;
  }
  public class Cls_Value {
    public String nodeValue;
  }
  public class Cls_IdentifierStatus {
    public String nodeValue;
  }
  public class Cls_FundName {
    public String nodeValue;
    public Cls_Name name;
    public Cls_NameType nameType;
    public Cls_Score score;
    public Cls_NameStatus nameStatus;
    public Cls_FundTypeCode fundTypeCode;
    public Cls_FundTypeDescription fundTypeDescription;
  }
  public class Cls_NameType {
    public String nodeValue;
  }
  public class Cls_Score {
    public String nodeValue;
  }
  public class Cls_NameStatus {
    public String nodeValue;
  }
  public class Cls_FundTypeCode {
    public String nodeValue;
  }
  public class Cls_FundTypeDescription {
    public String nodeValue;
  }
  public class Cls_Location {
    public String nodeValue;
    public Cls_StateTerritoryCode stateTerritoryCode;
    public Cls_Postcode postcode;
  }
  public class Cls_StateTerritoryCode {
    public String nodeValue;
  }
  public class Cls_Postcode {
    public String nodeValue;
  }
  //method for parsing the response from SuperFundLookup
  public static SMSFABNNameSearchHelper parse(String json) {
    try {
      if (json != null) {
        return (SMSFABNNameSearchHelper) System.JSON.deserialize(
          json,
          SMSFABNNameSearchHelper.class
        );
      }
      return null;
    } catch (Exception ex) {
      GenericUtility.insertLog('SMSFABNNameSearchHelper', ex);
      return null;
    }
  }
}