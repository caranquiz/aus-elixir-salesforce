/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is the helper class of UpdateValueDateTrigger and UpdateValuationDateExpiry
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/

global class ValuationDateExpiryUpdateHelper {
    global static void colletaralValuationDateExpiry(List <Id> collId){
        List<genesis__Applications__c> appList=new List<genesis__Applications__c>();
        List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
        List<genesis__Application_Collateral__c> appCollateralList2=new List<genesis__Application_Collateral__c>();
        Set<Id> appId=new Set<Id>();
        try{
            appCollateralList=[SELECT id,
                                genesis__Collateral__c,
                                genesis__Application__c,
                                genesis__Collateral__r.Valuation_Date_Expiry__c 
                            FROM genesis__Application_Collateral__c 
                            WHERE genesis__Collateral__c in: collId];

            for(genesis__Application_Collateral__c coll:appCollateralList){
                appId.add(coll.genesis__Application__c);
            }
            valuationDateUpdate(appId);
        }catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ValuationDateExpiryUpdateHelper :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        }
    }
    global static void applicationColletaralValueDate(List <genesis__Application_Collateral__c > newList){
        Set<Id> collId=new Set<Id>();
        Set<Id> appId=new Set<Id>();
        try{
            for (genesis__Application_Collateral__c collateral: newList) {
                collId.add(collateral.Id);
                appId.add(collateral.genesis__Application__c);
            }
            valuationDateUpdate(appId);
        }catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ValuationDateExpiryUpdateHelper :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        }
    }
    public static void valuationDateUpdate(Set<Id> appId){

        List<genesis__Applications__c> appList=new List<genesis__Applications__c>();
        List<genesis__Application_Collateral__c> appCollateralList2=new List<genesis__Application_Collateral__c>();
        try{
            appList=[SELECT id,
                            Valuation_Date_Expiry__c 
                        FROM genesis__Applications__c 
                        Where id in:appId];
            appCollateralList2=[SELECT id,
                                    genesis__Collateral__c,
                                    genesis__Application__c,
                                    genesis__Collateral__r.Valuation_Date_Expiry__c 
                                FROM genesis__Application_Collateral__c 
                                WHERE genesis__Application__c in:appId];
            
            for(genesis__Applications__c application:appList){
                application.Valuation_Date_Expiry__c=Null;
                for(genesis__Application_Collateral__c appColl:appCollateralList2){
                    if(application.Id==appColl.genesis__Application__c && appColl.genesis__Collateral__r.Valuation_Date_Expiry__c!=Null){
                        if(application.Valuation_Date_Expiry__c==Null){
                            application.Valuation_Date_Expiry__c=appColl.genesis__Collateral__r.Valuation_Date_Expiry__c;
                        }else if(application.Valuation_Date_Expiry__c>appColl.genesis__Collateral__r.Valuation_Date_Expiry__c){
                            application.Valuation_Date_Expiry__c=appColl.genesis__Collateral__r.Valuation_Date_Expiry__c;
                        }
                    }
                }
            }
            
            if(appList.size()>0){
                Database.update(appList,false);
            }
        }catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ValuationDateExpiryUpdateHelper :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                    System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        }
    }
}