/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is the helper class of UpdateValueDateTrigger and UpdateValuationDateExpiry
Development Date : 31/08/2021
Last Modified Date : 31/08/2021
****************************************************************************************************/

global with sharing class ValuationDateExpiryUpdateHelper {
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
    global static void valueUpdate(List<Id> appId){
        
        List<genesis__Applications__c> appList=new List<genesis__Applications__c>();
        List<genesis__Application_Collateral__c> appCollateralList=new List<genesis__Application_Collateral__c>();
        try{
            appList=[SELECT id,
                            Actual_Security_Value__c,
                            Expected_security_value__c	
                        FROM genesis__Applications__c 
                        WHERE id IN: appId];
            appCollateralList=[SELECT id,
                                    genesis__Collateral__c,
                                    genesis__Application__c,
                                    genesis__Application__r.id,
                                    genesis__Collateral__r.clcommon__Value__c,
                                    genesis__Collateral__r.Estimated_Value__c,
                                    genesis__Collateral__r.clcommon__Collateral_Name__c
                                FROM genesis__Application_Collateral__c 
                                WHERE genesis__Application__c IN: appId];
            Map<Id,Double> sumOfValueMap=new Map<Id,Double>();
            Map<Id,Double> sumOfExpectedMap=new Map<Id,Double>();
            for(genesis__Applications__c application:appList){
                sumOfValueMap.put(application.id, 0.0);
                sumOfExpectedMap.put(application.id, 0.0);
            }
            for(genesis__Application_Collateral__c appColl:appCollateralList){
                if(sumOfValueMap.containsKey(appColl.genesis__Application__r.id) 
                        && sumOfValueMap.get(appColl.genesis__Application__r.id)!=NULL
                        && appColl.genesis__Collateral__c != NULL
                        && appColl.genesis__Collateral__r.clcommon__Value__c!=NULL){
                    sumOfValueMap.put(appColl.genesis__Application__r.id,sumOfValueMap.get(appColl.genesis__Application__r.id)+appColl.genesis__Collateral__r.clcommon__Value__c);
                }
                if(sumOfExpectedMap.containsKey(appColl.genesis__Application__r.id) 
                        && sumOfExpectedMap.get(appColl.genesis__Application__r.id)!=NULL 
                        && appColl.genesis__Collateral__c!=NULL
                        && appColl.genesis__Collateral__r.Estimated_Value__c!=NULL){
                    sumOfExpectedMap.put(appColl.genesis__Application__r.id,sumOfExpectedMap.get(appColl.genesis__Application__r.id)+appColl.genesis__Collateral__r.Estimated_Value__c);
                }
            }
            for(genesis__Applications__c application:appList){
                if(sumOfValueMap.containsKey(application.id) 
                        && sumOfValueMap.get(application.id)!=NULL){
                    application.Actual_Security_Value__c=sumOfValueMap.get(application.id);
                }
                if(sumOfExpectedMap.containsKey(application.id) 
                        && sumOfExpectedMap.get(application.id)!=NULL){
                    application.Expected_security_value__c=sumOfExpectedMap.get(application.id);
                }
            }
            if(appList.size()>0){
                Database.update(appList,false);
            }
        }catch(Exception e){
            GenericUtility.insertLog('ValuationDateExpiryUpdateHelper.valueUpdate',e);
        }
    }
}