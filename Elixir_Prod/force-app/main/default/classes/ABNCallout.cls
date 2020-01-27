/******************************************
* Descrption : This is the callout class for ABN Integration. 
*              This class called the adapter class.
*              And also responsible for store the response of ABN.
*
* Developer : Soumik Sarkar
*************************************************/

global class ABNCallout{
    Webservice static String makeABNCallout(Id partyId){
        try{
            List<clcommon__Party__c> empList = [SELECT Id, 
                                                        Name
                                                        FROM clcommon__Party__c
                                                        WHERE Id=:partyId];


            Map<String,Object> empInfo = new Map<String,Object>();
            Map<String,Object> companyMap = new Map<String,Object>();
            empInfo.put('partyId',empList.get(0).id);
            companyMap.put('partyInfo',empInfo);
            companyMap.put('ExecutionPriority', 1);

            ints.AbstractMockService   mc  = ints.APIFactory.getPassthroughService();
            ints.IntegrationResponseObject responseObject = mc.runPassthroughService(companyMap,'ID Verification','');
            
            ABN_Information__c abnObj = new ABN_Information__c();
            abnObj = ABNResponse.saveResponse(responseObject);
            abnObj.Party__c = empList[0].id;
            insert abnObj;
            return ConstantValues.ABN_GENERATED;
            
        }
        catch(Exception e){
            insert new clcommon__Log__c(
                        clcommon__Message__c = 'ABN_API :Exception:: '+e.getStackTraceString()+'error='+e.getMessage()+' at Line Number '+e.getLineNumber(),
                        clcommon__Time__c = System.Now());
            return ConstantValues.EXCEPTION_OCCURED;
        }
        
    }
    
}