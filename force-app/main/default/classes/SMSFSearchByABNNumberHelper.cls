/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Description : This class is used to convert response from SuperFundLookup for SMSF ABN Number Search
                 json format into POJO object
Development Date : 2/09/2020
Last Modified Date : 14/10/2020
****************************************************************************************************/

public class SMSFSearchByABNNumberHelper {
  public String errMessage;
  public Cls_SuperFundPayload superFundPayload;
  public class Cls_SuperFundPayload {
    public String nodeValue;
    public Cls_Request request;
    public Cls_Response response;
  }
  public class Cls_Request {
    public String nodeValue;
    public Cls_Guid guid;
    public Cls_ABN abn;
  }
  public class Cls_Guid {
    public String nodeValue;
  }
  public class Cls_ABN {
    public String nodeValue;
  }
  public class Cls_Response {
    public String nodeValue;
    public Cls_UsageStatement usageStatement;
    public Cls_DateTimeRetrieved dateTimeRetrieved;
    public Cls_SuperannuationFund2015 superannuationFund2015;
  }
  public class Cls_UsageStatement {
    public String nodeValue;
  }
  public class Cls_DateTimeRetrieved {
    public String nodeValue;
  }
  public class Cls_SuperannuationFund2015 {
    public String nodeValue;
    public Cls_RecordLastUpdatedDate recordLastUpdatedDate;
    public Cls_OrganisationName organisationName;
    public Cls_Identifier identifier;
    public Cls_FundType fundType;
    public Cls_Address address;
    public Cls_ComplyingStatus complyingStatus;
  }
  public class Cls_RecordLastUpdatedDate {
    public String nodeValue;
  }
  public class Cls_OrganisationName {
    public String nodeValue;
    public Cls_Name name;
    public Cls_TypeCode typeCode;
    public Cls_StartDate startDate;
  }
  public class Cls_Name {
    public String nodeValue;
  }
  public class Cls_TypeCode {
    public String nodeValue;
  }
  public class Cls_StartDate {
    public String nodeValue;
  }
  public class Cls_Identifier {
    public String nodeValue;
    public Cls_Value value;
    public Cls_Name name;
    public Cls_IdentifierStatus identifierStatus;
  }
  public class Cls_Value {
    public String nodeValue;
  }
  public class Cls_IdentifierStatus {
    public String nodeValue;
    public Cls_Description description;
    public Cls_StartDate startDate;
  }
  public class Cls_Description {
    public String nodeValue;
  }
  public class Cls_FundType {
    public String nodeValue;
    public Cls_Code code;
    public Cls_Description description;
  }
  public class Cls_Code {
    public String nodeValue;
  }
  public class Cls_Address {
    public String nodeValue;
    public Cls_PurposeCode purposeCode;
    public Cls_Line1 line1;
    public Cls_Line2 line2;
    public Cls_SuburbLocalityName suburbLocalityName;
    public Cls_StateTerritoryCode stateTerritoryCode;
    public Cls_Postcode postcode;
    public Cls_CountryName countryName;
  }
  public class Cls_PurposeCode {
    public String nodeValue;
  }
  public class Cls_Line1 {
    public String nodeValue;
  }
  public class Cls_Line2 {
    public String nodeValue;
  }
  public class Cls_SuburbLocalityName {
    public String nodeValue;
  }
  public class Cls_StateTerritoryCode {
    public String nodeValue;
  }
  public class Cls_Postcode {
    public String nodeValue;
  }
  public class Cls_CountryName {
    public String nodeValue;
  }
  public class Cls_ComplyingStatus {
    public String nodeValue;
    public Cls_Code code;
    public Cls_Description description;
  }
  //method to parse the response from SuperFundLookup
  public static SMSFSearchByABNNumberHelper parse(String json) {
    try {
      return (SMSFSearchByABNNumberHelper) System.JSON.deserialize(
        json,
        SMSFSearchByABNNumberHelper.class
      );
    } catch (Exception ex) {
      GenericUtility.insertLog('SMSFSearchByABNNumberHelper', ex);
      return null;
    }
  }
}
