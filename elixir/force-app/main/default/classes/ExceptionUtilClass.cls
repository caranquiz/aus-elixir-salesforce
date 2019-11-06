/****************************************
 This class runs the exception snippet
  ****************************************/

global class ExceptionUtilClass{
    public static clcommon.Response systemExceptionSnippet(clcommon.Response r, Exception e){
        r = new clcommon.Response();
        r.status       = clcommon.Constants.ERROR;
        r.errorMessage = e.getMessage();
        System.debug('====='+'====='+'Custom Exception: '+e.getMessage()+e.getLineNumber()+'==='+e.getStackTraceString());
        return r;
    } 
    
    global static void createExceptionLog(Exception e, String message){
        String consolidatedMsg = message + ':' + e.getMessage() + '\n ' + e.getLineNumber() + '\n ' + e.getStackTraceString();
        clcommon__Log__c logObj = new clcommon__Log__c(
            clcommon__Message__c = consolidatedMsg,
            clcommon__Time__c = System.now()
        );
        
        INSERT logObj;
    }  
}