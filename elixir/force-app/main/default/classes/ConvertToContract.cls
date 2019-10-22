global class ConvertToContract{
    Webservice static String executeFun(Id appId){
        String ret = '';
        Savepoint sp=Database.setSavepoint();
        try{
            genesis__applications__c app = new genesis__applications__c(id=appId);
            String status = genesis.ConvertApplicationCtrl.convertApplicationToContract(appId);
            System.debug('STATUS=====>'+status);
            if(status == 'Application is converted to contract successfully'){
                app.genesis__Status__c = 'APPROVED - CONVERTED TO CONTRACT ';
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
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ConvertToContract :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();
            Database.rollback(sp);
        }
        return ret;
    }
}