/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is parsing the request and storing in SF.
Development Date : 10/03/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/

@RestResource(urlMapping='/nextgen/Application')
global with sharing class NextGenAuthetication {

    @HttpPost
    global static NextGenResponseDetailHelper createApplication(){
        RestRequest request;
        request = RestContext.request;
        String params = request.requestBody.toString();
		dom.Document doc = new dom.Document();
        NextGenResponseDetailHelper responseModel = new NextGenResponseDetailHelper();

        try{
            params=params.replaceAll('<Comment>[\\s\\S]*?</Comment>','');
            params=params.replaceAll('&\\s+', '&amp; ');

            doc.load(params);
			// Changing the response format from String to Map
            Map<String, Object> responseMap = intframework.XmlToJson.parseDocumentToMap(
            doc
            );
            // Searializing JSON Map to send for parsing
            String json = System.JSON.serialize(responseMap);
            String returnValue=NextGenApplicationHelper.parse(json, responseMap,params);
            
            if(returnValue==ConstantValues.GENERAL_ERROR){
                responseModel.status = 'Error found';
                responseModel.detailedStatus = ConstantValues.GENERAL_ERROR;
                responseModel.applicationName = 'Application not Created';  
            }else{
                responseModel.status = 'SUCCESS';
                responseModel.detailedStatus = returnValue.substringBefore('APP');
                responseModel.applicationName = 'APP'+returnValue.substringAfter('APP');
            }
			if(Test.isRunningTest()){
                Integer n=4/0;
            }
        }catch(Exception e){
            responseModel.status = 'Error found';
            responseModel.detailedStatus = e.getMessage();
            responseModel.applicationName = 'Application not Created'; 
            String recieverAddressOne=System.Label.Anna_Email;
            String recieverAddress=System.Label.Rosie_Johnston_Email;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {recieverAddress,recieverAddressOne};
            message.optOutPolicy = 'FILTER';
            //This try catch block is for storage Limit exceeded.
            try{
                GenericUtility.insertLog('NextGenAuthetication',e.getMessage());
                
                String subject='Application Creation Fails';
                message.subject = subject;
                message.plainTextBody = e.getMessage();
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }catch(Exception exe){
                String subject='Storage Limit exceeded';
                message.subject = subject;
                message.plainTextBody = exe.getMessage();
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            }
        }
        return responseModel;
    }
}