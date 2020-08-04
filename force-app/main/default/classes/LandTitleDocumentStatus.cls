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
global without sharing class LandTitleDocumentStatus {
    @HttpPost
    global static void createRecord() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String enquiryId;
        String status;
        String dateTimeValue;
        String clientReference;
        try {
            Blob blb = req.requestBody;
            String requestBody = blb.toString();
            dom.Document doc = new dom.Document();
            doc.load(requestBody);
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(doc);
            if(responseMap.containsKey('Envelope') && responseMap.get('Envelope') != null){
                responseMap = (Map<String, Object>) responseMap.get('Envelope');
                if(responseMap.containsKey('Body') && responseMap.get('Body') != null){
                    responseMap = (Map<String, Object>) responseMap.get('Body');
                    if(responseMap.containsKey('notify-event-request') && responseMap.get('notify-event-request') != null){
                        responseMap = (Map<String, Object>) responseMap.get('notify-event-request');
                        if(responseMap.containsKey('request-header') && responseMap.get('request-header') != null){
                            Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get('request-header');
                            if(tempResponseMap.containsKey('client-reference') && tempResponseMap.get('client-reference') != null){
                                tempResponseMap = (Map<String, Object>) tempResponseMap.get('client-reference');
                                if(tempResponseMap.containsKey('NodeValue') && tempResponseMap.get('NodeValue') != null){
                                    clientReference = (String) tempResponseMap.get('NodeValue');
                                }
                            }
                        }
                        if(responseMap.containsKey('notify-event-data') && responseMap.get('notify-event-data') != null){
                            responseMap = (Map<String, Object>) responseMap.get('notify-event-data');
                            if(responseMap.containsKey('enquiry-id') && responseMap.get('enquiry-id') != null){
                                Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get('enquiry-id');
                                if(tempResponseMap.containsKey('NodeValue') && tempResponseMap.get('NodeValue') != null){
                                    enquiryId = (String) tempResponseMap.get('NodeValue');
                                }
                            }
                            if(responseMap.containsKey('status') && responseMap.get('status') != null){
                                Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get('status');
                                if(tempResponseMap.containsKey('NodeValue') && tempResponseMap.get('NodeValue') != null){
                                    status = (String) tempResponseMap.get('NodeValue');
                                }
                            }
                            if(responseMap.containsKey('date-time') && responseMap.get('date-time') != null){
                                Map<String, Object> tempResponseMap = (Map<String, Object>) responseMap.get('date-time');
                                if(tempResponseMap.containsKey('NodeValue') && tempResponseMap.get('NodeValue') != null){
                                    dateTimeValue = (String) tempResponseMap.get('NodeValue');
                                }
                            }
                        }
                    }
                }
            }
            clcommon__Collateral__c collateralObj = [
                SELECT Id, Name, Document_Enquiry_Id__c
                FROM clcommon__Collateral__c
                WHERE Name =:clientReference LIMIT 1
            ];
            collateralObj.Document_Status__c = status;
            collateralObj.Document_Enquiry_Id__c = enquiryId;
            Database.update(collateralObj);
            res.statusCode = 200;
            res.addHeader('Content-Type', 'application/soap+xml');
            res.responseBody = Blob.valueOf(ConstantValues.RES_HEADER + '<enquiry-id>' + enquiryId + '</enquiry-id>\n'
            + '<status>' + status + '</status>\n' + '<date-time>' + dateTimeValue + '</date-time>\n' + ConstantValues.RES_FOOTER);
        } catch (Exception ex) {
            res.statusCode = 500;
            res.addHeader('Content-Type', 'application/soap+xml');
            res.responseBody = Blob.valueOf(ConstantValues.RES_HEADER + '<errors><error><error-detail>'
            + ex.getMessage() + '</error-detail></error></errors>' + ConstantValues.RES_FOOTER);
        }
    }
}