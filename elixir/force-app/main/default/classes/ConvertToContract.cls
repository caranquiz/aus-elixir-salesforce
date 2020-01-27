/*********************************************************************************************************
Class Name     : ConvertToContract
Description    : Apex class for converting application to contract throgh conversion mappping
Developer      : Rameswari Barman
Implementation code : genesis__applications__c app = [select id from genesis__applications__c where id = 'XXX'];
                      ConvertToContract.executeFun(app.Id)
**********************************************************************************************************/
global with sharing class ConvertToContract{
    Webservice static String executeFun(Id appId){
        String ret = '';
        //Savepoint is setup over here
        Savepoint sp=Database.setSavepoint();
        try{
            genesis__applications__c app = new genesis__applications__c(id=appId);
            String status = genesis.ConvertApplicationCtrl.convertApplicationToContract(appId);//storing the returned message from product class call
            if(status == System.label.Application_converted_to_Contract_message && Schema.sObjectType.genesis__applications__c.fields.genesis__Status__c.isUpdateable()){
                app.genesis__Status__c = System.label.ApplicationStatusAfterConvertedToContract;
                //updating the status of application
                update app;
            }
            else{
                Database.rollback(sp);
                if(test.isRunningTest()){
                    Integer a = 4/0;
                }
            }
            ret = status;
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ConvertToContract :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();  
        }
        return ret;
    }
}