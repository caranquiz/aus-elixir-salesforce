/********************************************************************************
Class Name : CustomGatewayClass
Description : This class is used to fire SMS when collection strategy is fired
Developer : Rameswari Barman
Development Date : 11/10/2022
Last Modified Date : 11/10/2022
*********************************************************************************/
global class CustomGatewayClass implements clcommon.GatewayCommunication {

    protected clcommon.PlatformLog logInstance = clcommon.PlatformLog.getLogger();
    clcommon.CallbackToCM obj;
    /*
     * Build Http request
     */
    public  HttpRequest buildWebServiceRequest(string phNumber,string smsBody) {
        HttpRequest request = new HttpRequest();
        try{
            List<clcommon__TwilioConfig__c> twilioSettings=clcommon__TwilioConfig__c.getAll().values();
            String accountSid;
            String token;
            Boolean useShortCode;
            if(!twilioSettings.isEmpty() && twilioSettings.get(0).clcommon__AccountSid__c != NULL 
                && twilioSettings.get(0).clcommon__AuthToken__c != NULL && twilioSettings.get(0).clcommon__Use_Short_Code__c != NULL){
                accountSid=twilioSettings.get(0).clcommon__AccountSid__c;
                token=twilioSettings.get(0).clcommon__AuthToken__c;   
                useShortCode=twilioSettings.get(0).clcommon__Use_Short_Code__c;
            }
            else{
                logInstance.logError(1189,'Label.CL001210');
            }        
            
            String fromPhNumber;
            if(useShortCode){
                fromPhNumber = twilioSettings.get(0).clcommon__CallerId__c;
                if(string.isBlank(fromPhNumber) || fromPhNumber == null){
                    String infoMessage = String.format('Label.CL001189', new List<String>{'Short code'});
                    logInstance.logError(1189,infoMessage);
                }
            }
            fromPhNumber = ConstantValues.AUTRALIA_COUNTRY_CODE + fromPhNumber;
            String twilioEndpoint = System.Label.Twilio_Endpoint_URL;
            if(twilioEndpoint != NULL){
                twilioEndpoint = twilioEndpoint.replace(ConstantValues.ACCOUNT_SID,accountSid);
            }
            request.setEndpoint(twilioEndpoint);
            request.setMethod(ConstantValues.POST);
            String VERSION  = ConstantValues.TWILIO_VERSION;
            request.setHeader(ConstantValues.AUTHORIZATION,ConstantValues.BASIC + EncodingUtil.base64Encode(Blob.valueOf(accountSid+
                            ':' +token)));
            request.setBody('To='+EncodingUtil.urlEncode(phNumber,'UTF-8')+'&From='+
                            EncodingUtil.urlEncode(fromPhNumber,'UTF-8')+'&Body='+smsBody);
            
            return request;
        }catch(Exception e){
            GenericUtility.insertLog('CustomGatewayClass', e);
            return request;
        }
    }  

    /*
     * invoke Web service
     */
    public HttpResponse invokeWebService(Http h, HttpRequest request) {
        //Invoke Web Service
        HttpResponse response;
        try{
            response = h.send(request);
        }
        catch(Exception e){
            String infoMessage = String.format('Label.CL001188', new List<String>{'SMS'});
            logInstance.logException(1188,infoMessage,e);
        }
        return response;
    }

    /*
     * handle the response
     */
    public  void handleWebServiceResponse(list<HttpResponse> results,list<clcommon__Gateway__c> scope,string className,string implementationClassName) {
        try{
            // Get the callback implementation class from className
            if(Test.isRunningTest() == False){
                System.Type classNameType = Type.forName(className);
                obj = (clcommon.CallbackToCM)classNameType.newInstance();
            }
            List<SObject> someList = [select Id,clcommon__Daily_Limit_Counter__c,LastModifiedDate from clcommon__GatewayConfiguration__c 
                                    where clcommon__Mode_Of_Communication__c = 'Message' 
                                    and clcommon__Implementation_Class__c =:implementationClassName ORDER BY CreatedDate DESC LIMIT 1];
            String listType = 'List<clcommon__GatewayConfiguration__c>';
            List<sObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
            castRecords.addAll(someList);
            Integer dailyLimit;
            Date lastModifiedDate;
            if(castRecords.size() > 0){
                dailyLimit = Integer.valueOf(castRecords.get(0).get('clcommon__Daily_Limit_Counter__c'));
                lastModifiedDate = Date.valueOf(castRecords.get(0).get('LastModifiedDate'));
            }
            if(lastModifiedDate != null && lastModifiedDate != Date.today()){
                dailyLimit = 0;
            }
            List<clcommon__Response__c> response = new List<clcommon__Response__c>();
            if(results != null) {
                //Create response Object
                for(Integer i = 0; i < results.size(); i++) {
                    if(!String.isEmpty(results[i].getBody())){
                        Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(results[i].getBody());
                        scope.get(i).clcommon__Message_Sid__c = String.valueOf(responseBody.get('sid'));    
                    }                
                    if(results[i].getStatusCode()==201) {
                        dailyLimit = dailyLimit+1;
                        scope.get(i).clcommon__Status__c = 'SUCCESS';
                        scope.get(i).clcommon__Sent_Date__c = Date.today();                  
                        response.add(new clcommon__Response__c(clcommon__Request_ID__c = scope.get(i).Id, clcommon__Request_Status__c = 'SUCCESS',
                                                clcommon__Salesforce_ID__c = scope.get(i).Id, clcommon__Sent_Time__c = datetime.now(),
                                                clcommon__Retry_Attempt__c = scope.get(i).clcommon__Retry_Attempt__c + 1
                                                ));
                    }
                    else {
                        scope.get(i).clcommon__Error_Message__c = results.get(i).getStatus();
                        response.add(new clcommon__Response__c(clcommon__Request_ID__c = scope.get(i).Id, clcommon__Request_Status__c = 'Failure',
                                                clcommon__Salesforce_ID__c = scope.get(i).Id, clcommon__Sent_Time__c = dateTime.now(),
                                                clcommon__Retry_Attempt__c = scope.get(i).clcommon__Retry_Attempt__c + 1
                                                ));
                    }                
                }
                castRecords.get(0).put('Daily_Limit_Counter__c',dailyLimit);
                UPDATE castRecords;
                UPDATE scope;
                //Insert all the responses
                INSERT response;
                //Send all the responses back to Callback Function
                logInstance.commitToDB();
                if(Test.isRunningTest() == False){
                    obj.callbackToCM(response);
                }
            }
        }catch(Exception e){
            GenericUtility.insertLog('CustomGatewayClass', e);
        }
    }

    /*
     * This function sends the message using Twilio and records the responses
     */
    
    global void GatewaySend(List<clcommon__Gateway__c> scope, String className,string implementationClassName) {
        try{
            List<HTTPResponse> results = new List<HTTPResponse>();
            clcommon__GatewayConfiguration__c config = [select clcommon__Daily_Limit_Counter__c,clcommon__Max_Daily_Limit__c,LastModifiedDate 
                                                        from clcommon__GatewayConfiguration__c where clcommon__Mode_Of_Communication__c = 'Message' 
                                                        and clcommon__Implementation_Class__c =:implementationClassName ORDER BY CreatedDate DESC LIMIT 1];
            Integer dailyLimit,maxdailyLimit;
            if(config!= NULL){
                dailyLimit = Integer.valueOf(config.get('clcommon__Daily_Limit_Counter__c')); 
                maxdailyLimit = Integer.valueOf(config.get('clcommon__Max_Daily_Limit__c')); 
            }
            Integer localCounter = dailyLimit; 
            List <String> templateList = new List<String>();
            for(clcommon__Gateway__c  gateObj: scope){
                templateList.add(gateObj.clcommon__Template_Name__c);
            }
            List <clcommon__Template_Configuration__c> templateConfigList = [Select Id,
                                                                                clcommon__To__c 
                                                                           from clcommon__Template_Configuration__c 
                                                                           where Id IN: templateList
                                                                           And clcommon__Template_Type__c =: ConstantValues.MESSAGE];       
            Map <String,clcommon__Template_Configuration__c> templateMap = new Map <String,clcommon__Template_Configuration__c>();
            for(clcommon__Gateway__c  gateObj: scope){
                for(clcommon__Template_Configuration__c eachTemplate : templateConfigList){
                    if(eachTemplate.Id == gateObj.clcommon__Template_Name__c){
                        templateMap.put(gateObj.clcommon__Template_Name__c,eachTemplate);
                    }
                }
            }
                for(clcommon__Gateway__c  gateObj: scope) {
                    if(gateObj.clcommon__Mode_Of_Communication__c == 'Message') {
                        HttpRequest request;
                        if(gateObj.clcommon__To__c!=null){
                            request = buildWebServiceRequest((String)gateObj.clcommon__To__c,(String) gateObj.clcommon__Content__c);
                        }
                        if(GateObj.clcommon__To__c == 'null'){
                            Map<Id, Map<String, String>> ToBeMergedwithID = new Map<Id, Map<String, String>>();
                            map<string,string> TemplateFieldValues = new map<string,string>();
                            if(templateMap.size() > 0 && templateMap.get(gateObj.clcommon__Template_Name__c) != NULL){
                                clcommon__Template_Configuration__c template = templateMap.get(gateObj.clcommon__Template_Name__c);
                                TemplateFieldValues.put('To',template.clcommon__To__c);
                                ToBeMergedwithID.put(GateObj.clcommon__Merged_Object_Id__c, TemplateFieldValues);
                                map<id,Boolean> MergeSuccessful = clcommon.DynamicMergeField.mergeCode(ToBeMergedwithID);
                                GateObj.clcommon__To__c = ToBeMergedwithID.get(GateObj.clcommon__Merged_Object_Id__c).get('To');
                                request = buildWebServiceRequest((String)gateObj.clcommon__To__c,(String) gateObj.clcommon__Content__c);
                            }
                        }
                        Http http = new Http();
                        if(localCounter < maxdailyLimit){
                            HTTPResponse response = invokeWebService(http,request);
                            results.add(response);
                            localCounter++;
                        }    
                        else{
                            String infoMessage = String.format('Label.CL001185', new List<String>{'SMS'});
                            logInstance.logError(1004,infoMessage);
                            gateObj.clcommon__Error_Message__c = infoMessage;
                        }
                    }
                }
                // Call a helper method to inspect the returned results
                handleWebServiceResponse(results,scope,className,implementationClassName);
        }catch(Exception e){
            GenericUtility.insertLog('CustomGatewayClass', e);
        }
    }

    public class errorResponseWrapper{

        String code;

        String message;

        String moreInfo;

        String status;  
    }
}