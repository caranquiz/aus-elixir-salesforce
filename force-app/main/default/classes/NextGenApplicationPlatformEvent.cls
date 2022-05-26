/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class publish platform event when Application status changes.
Development Date : 09/05/2022
Last Modified Date : 18/05/2022

****************************************************************************************************/

public class NextGenApplicationPlatformEvent {
@InvocableMethod(
    label='Publish Platform Event'
    description='Publish Application Platform Event'
    )
    public static void publishApplicationPlatformEvent(List<Id> appIdList){
        try{
            List<genesis__Applications__c> applicationList=[SELECT id,
                                                                genesis__Status__c,
                                                                Check_Status_Change__c 
                                                            FROM genesis__Applications__c 
                                                            WHERE id in: appIdList];
            List<Application_Platform_Event__e> applicationEventList=new List<Application_Platform_Event__e>();
            for(genesis__Applications__c application : applicationList){
                applicationEventList.add(new Application_Platform_Event__e(Application_Id__c=application.id,Status__c=application.genesis__Status__c));
                application.Check_Status_Change__c=false; 
                
            }
            if(applicationList.size()>0){
                Database.update(applicationList,false);
            }
            List<Database.SaveResult> results = EventBus.publish(applicationEventList);
        }catch(Exception exe){
            GenericUtility.insertLog('NextGenApplicationPlatformEvent', exe);
        }
    }

}