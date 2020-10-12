/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxDeliverDocumentResponseHelper */
/* Created Date         : 01/08/2020 */
/* Developed By         : Souvik */
/* Description          : This class is used to convert deliver document API Response into an more
handlable Object data */
/* Last Modified Date   : 01/08/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

public class EquifaxDeliverDocumentResponseHelper{
    Cls_Envelope envelope;
    class Cls_Envelope {
        Cls_Body body;
    }
    class Cls_Body {
        Cls_deliverDocumentResponse deliverDocumentResponse;
    }
    class Cls_deliverDocumentResponse {
        Cls_deliverDocumentResponseData deliverDocumentResponseData;
        Cls_errors errors;
    }
    class Cls_deliverDocumentResponseData {
        Cls_documentStatus documentStatus;
        Cls_pricePaid pricePaid;
        public Cls_binaryData binaryData;
    }
    class Cls_documentStatus {
        Cls_status status;
        Cls_dateTimeV dateTimeV;
    }
    class Cls_status {
        String nodeValue;
    }
    class Cls_dateTimeV {
        String nodeValue;
    }
    class Cls_pricePaid {
        String nodeValue;
    }
    class Cls_binaryData {
        String nodeValue;
    }
    class Cls_errors {
        Cls_error[] error;
    }
    class Cls_error {
        Cls_errorDetail errorDetail;
        Cls_errorCode errorCode;
    }
    class Cls_errorDetail {
        String nodeValue;
    }
    class Cls_errorCode {
        String nodeValue;
    }

    public static EquifaxCallout.LandTitleDocumentData parse(String json){
        EquifaxCallout.LandTitleDocumentData ltDocumentData = new EquifaxCallout.LandTitleDocumentData();
        String data;
        List<String> queries;
        JsonObjectToArray obj;
        EquifaxDeliverDocumentResponseHelper helperObject;
        try{
            json = GenericUtility.modifyJsonKeysIntoCamelcasingV2(json);
            queries = new List<String>();
            queries.add(ConstantValues.ERROR_KEY);
            obj = new JsonObjectToArray();
            json = obj.modifyAllByRecur(json, queries);
            helperObject = (EquifaxDeliverDocumentResponseHelper) System.JSON.deserialize(json, EquifaxDeliverDocumentResponseHelper.class);
            try{
                ltDocumentData.documentStatus = helperObject.envelope.body.deliverDocumentResponse.deliverDocumentResponseData.documentStatus.status.nodeValue;
            }catch(Exception ex){}
            try{
                ltDocumentData.paidAmount = helperObject.envelope.body.deliverDocumentResponse.deliverDocumentResponseData.pricePaid.nodeValue;
            }catch(Exception ex){}
            try{
                data = helperObject.envelope.body.deliverDocumentResponse.deliverDocumentResponseData.binaryData.nodeValue;
                ltDocumentData.documentAttachment = new Attachment();
                ltDocumentData.documentAttachment.ContentType = ConstantValues.APP_PDF_CONTENT_TYPE;
                ltDocumentData.documentAttachment.Body = EncodingUtil.base64Decode(data);
            }catch(Exception ex){}
            try {
                ltDocumentData.exceptionData = helperObject.envelope.body.deliverDocumentResponse.errors.error[0].errorDetail.nodeValue;
                if(String.isNotBlank(ltDocumentData.exceptionData)){
                    GenericUtility.insertLog('EquifaxDeliverDocumentResponseHelper', new CustomException(ltDocumentData.exceptionData));
                    ltDocumentData.exceptionData = ConstantValues.GENERAL_EXCEPTION;
                }
            } catch (Exception ex) {}
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxDeliverDocumentResponseHelper', ex);
        }
        return ltDocumentData;
    }
}