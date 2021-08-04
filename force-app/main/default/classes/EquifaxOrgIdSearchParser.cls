/********************************************************************************************
Description : This class parses the response for Equifax Org Id Search and converts JSON 
				 response into Apex POJO Object.
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Pratik Agarwal
Development Date : 2/09/2020
Last Modified Date : 14/10/2020   
********************************************************************************************/
public class EquifaxOrgIdSearchParser {
  public String errMessage;
  public Cls_BCAmessage bcamessage;
  public String asicStatusData;
  public String asicNameData;
  public class Cls_Nodevalue {
    public String nodeValue;
  }
  public class Cls_BCAmessage {
    public String serviceRequestId;
    public Cls_BCAservices bcaservices;
  }
  public class Cls_BCAservices {
    public Cls_BCAservice bcaservice;
  }
  public class Cls_BCAservice {
    public Cls_BCAserviceData bcaserviceData;
  }
  public class Cls_BCAserviceData {
    public Cls_response response;
  }
  public class Cls_response {
    public Cls_orgIdResult[] orgIdResult;
  }
  public class Cls_orgIdResult {
    public Cls_Nodevalue australianBusinessNumber;
    public Cls_asicReport asicReport;
  }
  public class Cls_asicReport {
    public Cls_Nodevalue asicName;
    public Cls_Nodevalue asicStatus;
  }
  public static EquifaxOrgIdSearchParser parse(String json) {
    try {
      //Replacing unwanted characters from variable names
      json = json.replaceAll(ConstantValues.US_SERVICE, ConstantValues.SERVICE);
      json = json.replaceAll(ConstantValues.HS_REQUEST, ConstantValues.REQUEST);
      json = json.replaceAll(ConstantValues.HS_ID, ConstantValues.US_ID);
      json = json.replaceAll(ConstantValues.US_BCA, ConstantValues.LS_BCA);
      json = json.replaceAll(ConstantValues.HS_DATA, ConstantValues.US_DATA);
      json = json.replaceAll(
        ConstantValues.HS_RESULT,
        ConstantValues.US_RESULT
      );
      json = json.replaceAll(
        ConstantValues.HS_BUSINESS,
        ConstantValues.US_BUSINESS
      );
      json = json.replaceAll(
        ConstantValues.HS_NUMBER,
        ConstantValues.US_NUMBER
      );
      json = json.replaceAll(
        ConstantValues.HS_REPORT,
        ConstantValues.US_REPORT
      );
      json = json.replaceAll(ConstantValues.HS_NAME, ConstantValues.US_NAME);
      json = json.replaceAll(
        ConstantValues.HS_STATUS,
        ConstantValues.US_STATUS
      );
      //converting object to array
      List<String> queries = new List<String>();
      queries.add(ConstantValues.ORG_ID_RESULT);
      JsonObjectToArray obj = new JsonObjectToArray();
      json = obj.modifyAllByRecur(json, queries);
      //Deserializing to convert JSON to Apex POJO Object
      return (EquifaxOrgIdSearchParser) System.JSON.deserialize(
        json,
        EquifaxOrgIdSearchParser.class
      );
    } catch (Exception ex) {
      GenericUtility.insertLog('EquifaxOrgIdSearchParser', ex);
      return null;
    }
  }
}