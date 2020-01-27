global class ABNNameCallout2{
    global static void makeABNNameCallout(Id empId){
        String emp;
        String EmpName;
        try{
            List<genesis__Employment_Information__c> empList = [SELECT Id, 
                                                        Name
                                                        FROM genesis__Employment_Information__c
                                                        WHERE Id=:empId];
            if(empList.isEmpty()){
                throw new CustomException('Employee Record Not Found');
            }
            
            emp = empId;
            EmpName = empList.get(0).Name;
            Map<String,Object> empInfo = new Map<String,Object>();
            Map<String,Object> companyMap = new Map<String,Object>();
            empInfo.put('empId',empList.get(0).id);
            companyMap.put('partyInfo',empInfo);
            companyMap.put('ExecutionPriority', 5);

            ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
            System.debug('mc--------'+ mc);
            ints.IntegrationResponseObject responseObject = mc.runPassthroughService(companyMap,'ID Verification','');
            System.debug('responseonj--------'+ responseObject);
            
         //PARSING RESPONSE AND INSERTING RECORDS
            ABNNameResponse.ABNNameWrapperPopulate(responseObject);
            ABNNameResponse.createRecords(emp,'E');
        }
        catch(Exception e){
            insert new clcommon__Log__c(
                        clcommon__Message__c = 'ABN_API :Exception:: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                        clcommon__Time__c = System.Now());
            ExceptionUtilClass.createExceptionLog(e, EmpName);                
            throw new CustomException('Something went wrong in ABNName API. Please contact System Administrator. Reason: '+e);
        }
        
    }
    
     //WEBSERVICE METHOD FOR SKUID BUTTON
        Webservice static String makeABNSkuidCallout2(String empId){
            try{
                //MAKE API CALL
                makeABNNameCallout(empId); 
                return 'SUCCESS';   
            }catch(Exception e){
                return e.getMessage();    
            }
        } 
}