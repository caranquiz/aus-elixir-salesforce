global class CustomGatewayClass implements clcommon.GatewayCommunication {

    protected clcommon.PlatformLog logInstance = clcommon.PlatformLog.getLogger();
    clcommon.CallbackToCM obj;
    /*
     * Build Http request
     */
    public  HttpRequest buildWebServiceRequest(string phNumber,string smsBody) {
        System.debug('Rameswari 1');
        System.debug('phNumber:' + phNumber);
        System.debug('smsBody:' + smsBody);
        List<clcommon__TwilioConfig__c> twilioSettings=clcommon__TwilioConfig__c.getAll().values();
        System.debug('Rameswari 2');
        String accountSid;
        String token;
        Boolean useShortCode;
        System.debug('Rameswari 3');
        System.debug('Rameswari 3.0'+twilioSettings);
        if(!twilioSettings.isEmpty()){
            System.debug('Rameswari 3.1'+(twilioSettings.get(0).clcommon__AccountSid__c));
            accountSid=twilioSettings.get(0).clcommon__AccountSid__c;
            System.debug('Rameswari 3.2'+(twilioSettings.get(0).clcommon__AuthToken__c));
            token=twilioSettings.get(0).clcommon__AuthToken__c;   
            System.debug('Rameswari 3.5');
            useShortCode=twilioSettings.get(0).clcommon__Use_Short_Code__c;
            System.debug('Rameswari 3.6');
            System.debug('Rameswari 4');
        }
        else{
            logInstance.logError(1189,'Label.CL001210');
            System.debug('Rameswari 5');
        }        
        
        String fromPhNumber;

        HttpRequest request = new HttpRequest();
        System.debug('Rameswari 6');
        if(useShortCode){
            System.debug('Rameswari 7');
            fromPhNumber = twilioSettings.get(0).clcommon__CallerId__c;
            if(string.isBlank(fromPhNumber) || fromPhNumber == null){
                String infoMessage = String.format('Label.CL001189', new List<String>{'Short code'});
                logInstance.logError(1189,infoMessage);
                System.debug('Rameswari 8');
            }
        }
        System.debug('Rameswari 1');
        //phNumber = '+61488824684';
        System.debug('To Phone Number 1'+phNumber);
        //phNumber = '+61485828833';
        
        fromPhNumber = '+61'+fromPhNumber;
        System.debug(fromPhNumber+'<====From number');
        
        request.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/Messages');
                            //+'/SMS/Messages.json');
        request.setMethod('POST');
        String VERSION  = '3.2.0';
        //request.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
        //request.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
        //request.setHeader('Accept', 'application/json');
        //request.setHeader('Accept-Charset', 'utf-8');
        request.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(accountSid+
                        ':' +token)));
        request.setBody('To='+EncodingUtil.urlEncode(phNumber,'UTF-8')+'&From='+
                        EncodingUtil.urlEncode(fromPhNumber,'UTF-8')+'&Body='+smsBody);
        
        System.debug('request:' + request);
        System.debug(request.getBody());
        System.debug(request.getEndpoint());
        System.debug(request.getHeader('Authorization'));
        return request;
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
        // Get the callback implementation class from className
        System.Type classNameType = Type.forName(className);
        //EmailManager emailObject = new EmailManager(System.Type.newInstance(classNameType));
        obj = (clcommon.CallbackToCM)classNameType.newInstance();
        List<SObject> someList = [select Id,clcommon__Daily_Limit_Counter__c,LastModifiedDate from clcommon__GatewayConfiguration__c 
                                  where clcommon__Mode_Of_Communication__c = 'Message' 
                                  and clcommon__Implementation_Class__c =:implementationClassName ORDER BY CreatedDate DESC LIMIT 1];
        String listType = 'List<GatewayConfiguration__c>';
        List<sObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
        castRecords.addAll(someList);
        Integer dailyLimit = Integer.valueOf(castRecords.get(0).get('Daily_Limit_Counter__c'));
        Date lastModifiedDate = Date.valueOf(castRecords.get(0).get('LastModifiedDate'));
        if(lastModifiedDate != Date.today()){
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
            obj.callbackToCM(response);
        }
    }

    /*
     * This function sends the message using Twilio and records the responses
     */
    
    global void GatewaySend(List<clcommon__Gateway__c> scope, String className,string implementationClassName) {
        System.debug('Inside Gateway Send method');
        List<HTTPResponse> results = new List<HTTPResponse>();
        clcommon__GatewayConfiguration__c config = [select clcommon__Daily_Limit_Counter__c,clcommon__Max_Daily_Limit__c,LastModifiedDate 
                                                    from clcommon__GatewayConfiguration__c where clcommon__Mode_Of_Communication__c = 'Message' 
                                                    and clcommon__Implementation_Class__c =:implementationClassName ORDER BY CreatedDate DESC LIMIT 1];
        Integer dailyLimit = Integer.valueOf(config.get('clcommon__Daily_Limit_Counter__c')); 
        Integer maxdailyLimit = Integer.valueOf(config.get('clcommon__Max_Daily_Limit__c')); 
        Integer localCounter = dailyLimit;        
            for(clcommon__Gateway__c  gateObj: scope) {
                if(gateObj.clcommon__Mode_Of_Communication__c == 'Message') {
                    HttpRequest request;
                    if(gateObj.clcommon__To__c!=null){
                        request = buildWebServiceRequest((String)gateObj.clcommon__To__c,(String) gateObj.clcommon__Content__c);
                        System.debug('Request:' + request);
                    }
                    if(GateObj.clcommon__To__c == 'null'){
                        Map<Id, Map<String, String>> ToBeMergedwithID = new Map<Id, Map<String, String>>();
                        map<string,string> TemplateFieldValues = new map<string,string>();
                        clcommon__Template_Configuration__c template = [Select clcommon__To__c from clcommon__Template_Configuration__c 
                                                                        where Id =: GateObj.clcommon__Template_Name__c And clcommon__Template_Type__c='Message'];
                        TemplateFieldValues.put('To',template.clcommon__To__c);
                        ToBeMergedwithID.put(GateObj.clcommon__Merged_Object_Id__c, TemplateFieldValues);
                        map<id,Boolean> MergeSuccessful = clcommon.DynamicMergeField.mergeCode(ToBeMergedwithID);
                        GateObj.clcommon__To__c = ToBeMergedwithID.get(GateObj.clcommon__Merged_Object_Id__c).get('To');
                        request = buildWebServiceRequest((String)gateObj.clcommon__To__c,(String) gateObj.clcommon__Content__c);
                    }
                    Http http = new Http();
                    if(localCounter < maxdailyLimit){
                        System.debug('I m here 1');
                        HTTPResponse response = invokeWebService(http,request);
                        System.debug('I m here 2'+response);
                        results.add(response);
                        System.debug('I m here 3'+results);
                        localCounter++;
                    }    
                    else{
                                                System.debug('I m here 2');
                        String infoMessage = String.format('Label.CL001185', new List<String>{'SMS'});
                        logInstance.logError(1004,infoMessage);
                        gateObj.clcommon__Error_Message__c = infoMessage;
                    }
                }
            }
            // Call a helper method to inspect the returned results
            handleWebServiceResponse(results,scope,className,implementationClassName);
            System.debug('Eameswari 10');
        }

    public class errorResponseWrapper{

        String code;

        String message;

        String moreInfo;

        String status;  
    }
}