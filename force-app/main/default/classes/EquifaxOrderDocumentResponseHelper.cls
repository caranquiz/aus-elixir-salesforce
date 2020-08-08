/****************************************************************************************************/
/* Company              : Cloudkaptan Consultancy Services Pvt. Ltd. */
/* Class Name           : EquifaxOrderDocumentResponseHelper */
/* Created Date         : 01/08/2020 */
/* Developed By         : Souvik */
/* Description          : This class is used to convert order document API Response into an more
handlable Object data */
/* Last Modified Date   : 01/08/2020 */
/* Last Modified By     : Souvik */
/****************************************************************************************************/

public class EquifaxOrderDocumentResponseHelper{
    Cls_Envelope envelope;
    class Cls_Envelope {
        Cls_Body body;
    }
    class Cls_Body {
        Cls_orderDocumentResponse orderDocumentResponse;
    }
    class Cls_orderDocumentResponse {
        Cls_orderDocumentResponseData orderDocumentResponseData;
        Cls_errors errors;
    }
    class Cls_orderDocumentResponseData {
        Cls_orderDetails orderDetails;
        Cls_priceValue priceValue;
    }
    class Cls_orderDetails {
        Cls_enquiryId enquiryId;
    }
    class Cls_enquiryId {
        String nodeValue;
    }
    class Cls_errors {
        Cls_error[] error;
    }
    class Cls_error {
        Cls_errorDetail errorDetail;
    }
    class Cls_errorDetail {
        String nodeValue;
    }
    class Cls_priceValue {
        String nodeValue;
    }

    public static EquifaxCallout.OrderDocumentData parse(String json){
        EquifaxCallout.OrderDocumentData orderDocdata = new EquifaxCallout.OrderDocumentData();
        try{
            json = GenericUtility.modifyJsonKeysIntoCamelcasing(json);
            List<String> queries = new List<String>();
            queries.add(ConstantValues.ERROR_KEY);
            JsonObjectToArray obj = new JsonObjectToArray();
            json = obj.modifyAllByRecur(json, queries);
            EquifaxOrderDocumentResponseHelper helperObject = (EquifaxOrderDocumentResponseHelper) System.JSON.deserialize(json, EquifaxOrderDocumentResponseHelper.class);
            try{
                orderDocdata.enquiryId = helperObject.envelope.body.orderDocumentResponse.orderDocumentResponseData.orderDetails.enquiryId.nodeValue;
            }catch(Exception ex){}
            try{
                orderDocdata.exceptionData = helperObject.envelope.body.orderDocumentResponse.errors.error[0].errorDetail.nodeValue;
                if(String.isNotBlank(orderDocdata.exceptionData)){
                    GenericUtility.insertLog('Equifax/orderDocument', new CustomException(orderDocdata.exceptionData));
                    orderDocdata.exceptionData = ConstantValues.GENERAL_EXCEPTION;
                }
            }catch(Exception ex){}
            try{
                orderDocdata.priceValue = helperObject.envelope.body.orderDocumentResponse.orderDocumentResponseData.priceValue.nodeValue;
            }catch(Exception ex){}
            return orderDocdata;
        }
        catch(Exception ex){
            GenericUtility.insertLog('EquifaxDeliverDocumentResponseHelper', ex);
        }
        return orderDocdata;
    }
}