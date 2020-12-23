/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : GenericUtility */
/* Created Date         : 20/07/2020 */
/* Developed By         : Rameswari Barman */
/* Description          : This class contains some common methods to use. */
/* Last Modified Date   : 20/07/2020 */
/* Last Modified By     : Rameswari Barman */
/****************************************************************************************************/
public with sharing class GenericUtility {
  /*** This method is used to insert logs, for debug purpose ***/
  public static void insertLog(String name, Exception ex) {
    Database.insert(
      new clcommon__Log__c(
        Name = name,
        clcommon__Message__c = name +
          '|::Exception occured in::' +
          ex.getStackTraceString() +
          '|::Error::' +
          ex.getMessage() +
          ' at Line Number::' +
          ex.getLineNumber(),
        clcommon__Time__c = System.Now()
      )
    );
  }
  public static void insertLog(String name, String message) {
    Database.insert(
      new clcommon__Log__c(
        Name = name,
        clcommon__Message__c = message,
        clcommon__Time__c = System.Now()
      )
    );
  }
  public static void insertCustomExceptionLog(
    String name,
    String customMessage
  ) {
    Database.insert(
      new clcommon__Log__c(
        Name = name,
        clcommon__Message__c = '|::Exception message ::' + customMessage,
        clcommon__Time__c = System.Now()
      )
    );
  }
  // This method is used to insert batch process logs, for debug purpose
  public static void insertBatchProcessLog(String name, Exception ex) {
    Database.insert(
      new Loan__Batch_Process_log__c(
        loan__Message__c = name +
          '|::Exception occured in::' +
          ex.getStackTraceString() +
          '|::Error::' +
          ex.getMessage() +
          ' at Line Number::' +
          ex.getLineNumber(),
        loan__Time__c = System.Now(),
        loan__Log_Level__c = 'ERROR'
      )
    );
  }
  // This method is used to insert Integration Logs
  public static void insertRestResourceIntegrationLog(
    String name,
    String requestLog,
    String responseLog,
    String enquiryId
  ) {
    insertRestResourceIntegrationLog(
      name,
      false,
      requestLog,
      responseLog,
      enquiryId,
      (Exception) null
    );
  }
  public static void insertRestResourceIntegrationLog(
    String name,
    Boolean isFailed,
    String requestLog,
    String responseLog,
    String enquiryId,
    Exception ex
  ) {
    String status;
    String errorMessage;
    if (isFailed) {
      status = 'FAILED';
      errorMessage =
        name +
        '|::Exception Occured in::' +
        ex.getStackTraceString() +
        '|::Error::' +
        ex.getMessage() +
        ' at Line Number::' +
        ex.getLineNumber();
    } else {
      status = 'SUCCESS';
      errorMessage = name + '|::No Exception Occured';
    }
    Database.insert(
      new intframework__Integration_Log__c(
        intframework__Error_Message__c = errorMessage,
        intframework__Request_Log__c = requestLog,
        intframework__Response_Log__c = responseLog,
        intframework__Processing_Status__c = status,
        notify_event_enquiry_id__c = enquiryId
      )
    );
  }
  public static String modifyJsonKeysIntoCamelcasing(String json) {
    json = json.replaceAll('NodeValue', 'nodeValue');
    json = json.replaceAll('Envelope', 'envelope');
    json = json.replaceAll('Body', 'body');
    json = json.replaceAll(
      ConstantValues.HS_LANDTITLE,
      ConstantValues.US_LANDTITLE
    );
    json = json.replaceAll(ConstantValues.HS_TITLE, ConstantValues.US_TITLE);
    json = json.replaceAll(ConstantValues.HS_HEADER, ConstantValues.US_HEADER);
    json = json.replaceAll(
      ConstantValues.HS_RESPONSE,
      ConstantValues.US_RESPONSE
    );
    json = json.replaceAll(ConstantValues.HS_DATA, ConstantValues.US_DATA);
    json = json.replaceAll(ConstantValues.HS_PAID, ConstantValues.US_PAID);
    json = json.replaceAll(
      ConstantValues.HS_TERRITORY,
      ConstantValues.US_TERRITORY
    );
    json = json.replaceAll(ConstantValues.HS_LAND, ConstantValues.US_LAND);
    json = json.replaceAll(
      ConstantValues.HS_REGISTRY,
      ConstantValues.US_REGISTRY
    );
    json = json.replaceAll(
      ConstantValues.HS_REFERENCE,
      ConstantValues.US_REFERENCE
    );
    json = json.replaceAll(
      ConstantValues.HS_DESCRIPTION,
      ConstantValues.US_DESCRIPTION
    );
    json = json.replaceAll(ConstantValues.HS_PRICE, ConstantValues.US_PRICE);
    json = json.replaceAll(ConstantValues.HS_VALUE, ConstantValues.US_VALUE);
    json = json.replaceAll(ConstantValues.HS_DETAIL, ConstantValues.US_DETAIL);
    json = json.replaceAll(
      ConstantValues.HS_DOCUMENT,
      ConstantValues.US_DOCUMENT
    );
    json = json.replaceAll(ConstantValues.HS_DATA, ConstantValues.US_DATA);
    json = json.replaceAll(ConstantValues.HS_ID, ConstantValues.US_ID);
    json = json.replaceAll(ConstantValues.HS_STATUS, ConstantValues.US_STATUS);
    json = json.replaceAll(ConstantValues.HS_TIME, ConstantValues.US_TIME);
    json = json.replaceAll(ConstantValues.HS_CODE, ConstantValues.US_CODE);
    json = json.replaceAll(ConstantValues.HS_RECORD, ConstantValues.US_RECORD);
    json = json.replaceAll('-or', 'Or');
    json = json.replaceAll('-to', 'To');
    json = json.replaceAll('-consumer', 'Consumer');
    json = json.replaceAll('-credit', 'Credit');
    json = json.replaceAll('-report', 'Report');
    json = json.replaceAll('-enquir', 'Enquir');
    json = json.replaceAll('-file', 'File');
    json = json.replaceAll('-information', 'Information');
    json = json.replaceAll('-match', 'Match');
    return json;
  }
  // !NOTE : If the response is too large please try to not use the following method
  public static String modifyJsonKeysIntoCamelcasingV2(String json) {
    json = json.replaceAll('-a', 'A');
    json = json.replaceAll('-b', 'B');
    json = json.replaceAll('-c', 'C');
    json = json.replaceAll('-d', 'D');
    json = json.replaceAll('-e', 'E');
    json = json.replaceAll('-f', 'F');
    json = json.replaceAll('-g', 'G');
    json = json.replaceAll('-h', 'H');
    json = json.replaceAll('-i', 'I');
    json = json.replaceAll('-j', 'J');
    json = json.replaceAll('-k', 'K');
    json = json.replaceAll('-l', 'L');
    json = json.replaceAll('-m', 'M');
    json = json.replaceAll('-n', 'N');
    json = json.replaceAll('-o', 'O');
    json = json.replaceAll('-p', 'P');
    json = json.replaceAll('-q', 'Q');
    json = json.replaceAll('-r', 'R');
    json = json.replaceAll('-s', 'S');
    json = json.replaceAll('-t', 'T');
    json = json.replaceAll('-u', 'U');
    json = json.replaceAll('-v', 'V');
    json = json.replaceAll('-w', 'W');
    json = json.replaceAll('-x', 'X');
    json = json.replaceAll('-y', 'Y');
    json = json.replaceAll('-z', 'Z');
    return json;
  }
  public static String convert2StreetTypeCode(String streetType) {
    String res = '';
    String code;
    streetType = streetType.trim().toUppercase();
    List<Street_Type_Code__mdt> streetTypeCodeList = [
      SELECT MasterLabel, Type_Code__c, Type__c
      FROM Street_Type_Code__mdt
      WHERE Type__c = 'ToStreetTypeCode'
    ];
    Map<String, String> streetTypeCodeMap2 = new Map<String, String>();
    for (Street_Type_Code__mdt each : streetTypeCodeList) {
      streetTypeCodeMap2.put(each.MasterLabel, each.Type_Code__c);
    }
    if (streetTypeCodeMap2.get(streetType) != null) {
      return streetTypeCodeMap2.get(streetType);
    }
    return streetType;
  }
  public static void isValid(String value, String msg) {
    if (String.isBlank(value)) {
      throw new CustomException(msg);
    }
  }
  public static void isListValid(List<Map<String, Object>> value, String msg) {
    if (value.isEmpty()) {
      throw new CustomException(msg);
    }
  }
  public static String convertToDescription(String asicStatus) {
    asicStatus = asicStatus.trim().toUppercase();
    List<Street_Type_Code__mdt> streetTypeCodeList = [
      SELECT MasterLabel, Type_Code__c, Type__c
      FROM Street_Type_Code__mdt
      WHERE Type__c = 'ToDescription'
    ];
    Map<String, String> asicStatusCodeMap = new Map<String, String>();
    for (Street_Type_Code__mdt each : streetTypeCodeList) {
      asicStatusCodeMap.put(each.MasterLabel, each.Type_Code__c);
    }
    if (asicStatusCodeMap.get(asicStatus) != null) {
      return asicStatusCodeMap.get(asicStatus);
    }
    if (asicStatusCodeMap.get(asicStatus) != null) {
      return asicStatusCodeMap.get(asicStatus);
    }
    return asicStatus;
  }
  public static void createAttachment(String name, String body, String sfId){
    if(String.isNotBlank(name) && String.isNotBlank(body) && String.isNotBlank(sfId)){
      Attachment attachmentInstance = new Attachment();
      attachmentInstance.Body = Blob.valueOf(body);
      attachmentInstance.Name = name; 
      attachmentInstance.ParentID = sfId;
      attachmentInstance.ContentType = 'text/xml';
      INSERT attachmentInstance;
    }
  }   
}