/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : LandTitleDocumentStatus */
/* Created Date         : 04/08/2020 */
/* Developed By         : Souvik */
/* Description          : This class is used to handle the notification request from Equifax. This
 class gets called when post request on the mentioned url gets called. */
/* Last Modified Date   : 04/08/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

@RestResource(urlMapping='/DocumentStatus/*')
global class LandTitleDocumentStatus {
  @HttpPost
  global static void createRecord() {
    clcommon__Collateral__c collateralObj;
    Integer exceptionCount;
    String enquiryId;
    String status;
    DateTime currentDateTime = DateTime.Now();
    String dateTimeValue = currentDateTime.format('dd-MM-yy') + 'T' + currentDateTime.format('hh:mm:ss');
    String clientReference;
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    if (req == null && req.requestBody == null) {
      return;
    }
    try {
      Blob blb = req.requestBody;
      String requestBody = blb.toString();
      dom.Document doc = new dom.Document();
      doc.load(requestBody);
      Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
        doc
      );
      if (
        responseMap.containsKey('Envelope') &&
        responseMap.get('Envelope') != null
      ) {
        responseMap = (Map<String, Object>) responseMap.get('Envelope');
        if (
          responseMap.containsKey('Body') && responseMap.get('Body') != null
        ) {
          responseMap = (Map<String, Object>) responseMap.get('Body');
          if (
            responseMap.containsKey('notify-event-request') &&
            responseMap.get('notify-event-request') != null
          ) {
            responseMap = (Map<String, Object>) responseMap.get(
              'notify-event-request'
            );
            if (
              responseMap.containsKey('request-header') &&
              responseMap.get('request-header') != null
            ) {
              Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get(
                'request-header'
              );
              if (
                tempResponseMap.containsKey('client-reference') &&
                tempResponseMap.get('client-reference') != null
              ) {
                tempResponseMap = (Map<String, Object>) tempResponseMap.get(
                  'client-reference'
                );
                if (
                  tempResponseMap.containsKey('NodeValue') &&
                  tempResponseMap.get('NodeValue') != null
                ) {
                  clientReference = (String) tempResponseMap.get('NodeValue');
                }
              }
            }
            if (
              responseMap.containsKey('notify-event-data') &&
              responseMap.get('notify-event-data') != null
            ) {
              responseMap = (Map<String, Object>) responseMap.get(
                'notify-event-data'
              );
              if (
                responseMap.containsKey('enquiry-id') &&
                responseMap.get('enquiry-id') != null
              ) {
                Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get(
                  'enquiry-id'
                );
                if (
                  tempResponseMap.containsKey('NodeValue') &&
                  tempResponseMap.get('NodeValue') != null
                ) {
                  enquiryId = (String) tempResponseMap.get('NodeValue');
                }
              }
              if (
                responseMap.containsKey('status') &&
                responseMap.get('status') != null
              ) {
                Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get(
                  'status'
                );
                if (
                  tempResponseMap.containsKey('NodeValue') &&
                  tempResponseMap.get('NodeValue') != null
                ) {
                  status = (String) tempResponseMap.get('NodeValue');
                }
              }
            }
          }
        }
      }
      exceptionCount = [
        SELECT count()
        FROM intframework__Integration_Log__c
        WHERE notify_event_enquiry_id__c =:enquiryId
      ];
      if(String.isNotBlank(enquiryId)
      && exceptionCount != null
      && exceptionCount < Integer.valueOf(System.label.notify_event_retry_count)){
        res.statusCode = 200;
      } else {
        res.statusCode = 500;
      }
      collateralObj = [
        SELECT Id, Name, Document_Enquiry_Id__c
        FROM clcommon__Collateral__c
        WHERE Document_Enquiry_Id__c = :enquiryId
        LIMIT 1
      ];
      collateralObj.Document_Status__c = status;
      List<clcommon__Category_Attachment_Association__c> catAttach = [
        SELECT Id,
            clcommon__Document_Category__c,
            clcommon__Reason__c,
            clcommon__Document_Category__r.clcommon__Category_Name__c,
            clcommon__Document_Category__r.clcommon__Collateral__c,
            clcommon__Document_Category__r.clcommon__Collateral__r.Document_Enquiry_Id__c
            FROM clcommon__Category_Attachment_Association__c
            WHERE clcommon__Document_Category__r.clcommon__Category_Name__c = :ConstantValues.TITLE_SEARCH_DOCUMENT_CATEGORY_NAME
            AND clcommon__Document_Category__r.clcommon__Collateral__c = :collateralObj.Id
            ORDER BY LastModifiedDate DESC
      ];
      if(catAttach.isEmpty()
      || catAttach[0].clcommon__Reason__c != enquiryId) {
        Equifaxcallout.equifaxDeliverDocument(collateralObj.Id, enquiryId);
      }
      Database.update(collateralObj);
      // Responding to Equifax's notify-event request
      res.responseBody = Blob.valueOf(
        ConstantValues.RES_HEADER +
        '<evnt:enquiry-id>' +
        enquiryId +
        '</evnt:enquiry-id>\n' +
        '<evnt:status>ACK</evnt:status>\n' +
        '<evnt:date-time>' +
        dateTimeValue +
        '</evnt:date-time>\n' +
        ConstantValues.RES_FOOTER
      );
      // Inserting Integration Log on SUCCESS status
      GenericUtility.insertRestResourceIntegrationLog(
        '@RestResource|:LandTitleDocumentStatus',
        (req.requestBody).toString(),
        (res.responseBody).toString(),
        enquiryId
      );
    } catch (Exception ex) {
      // Responding to Equifax's notify-event request
      res.statusCode = 500;
      res.addHeader('Content-Type', 'application/soap+xml');
      res.responseBody = Blob.valueOf(
        ConstantValues.RES_HEADER +
        '<evnt:enquiry-id>' +
        enquiryId +
        '</evnt:enquiry-id>\n' +
        '<evnt:status>ACK</evnt:status>\n' +
        '<evnt:date-time>' +
        dateTimeValue +
        '</evnt:date-time>\n' +
        ConstantValues.RES_FOOTER
      );
      // Inserting Integration Log on FAILED status
      GenericUtility.insertRestResourceIntegrationLog(
        '@RestResource|:LandTitleDocumentStatus',
        true,
        (req.requestBody).toString(),
        (res.responseBody).toString(),
        enquiryId,
        ex
      );
    }
  }
}