/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class the callout class for sending BCM to NextGen.
Development Date : 09/05/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/

global with sharing class NextGenBCMCallout {
    public static void searchByAppId(Id appId){
        Map<String, Object> queryIdMap = new Map<String, Object>();
    	Map<String, Object> requestParamMap = new Map<String, Object>();
        try{
            StaticResource nextGenBCMRequest = [SELECT Body
                                            FROM StaticResource 
                                            WHERE Name = 'NextGenBCMRequestBody'
                                            LIMIT 1];
            List<genesis__Applications__c> applicationList=[SELECT id,
                                                                Solicitor_Status__c,
                                                                genesis__Status__c,
                                                                Check_Status_Change__c 
                                                                FROM genesis__Applications__c 
                                                                WHERE id=:appId];

            String uniqueId=getUUID();
            queryIdMap.put('appId', appId);
            requestParamMap.put(
                'nextGenXMLRequestBody',
                nextGenBCMRequest.Body.toString()
            );
            requestParamMap.put(
                'messageBatch',
                'MessageBatch-'+uniqueId
            );
            requestParamMap.put(
                'message',
                'Message-'+uniqueId
            );
            if(applicationList.size()>0){
                if(applicationList[0].Check_Status_Change__c==true 
                    && (applicationList[0].Solicitor_Status__c==ConstantValues.READY_TO_BOOK 
                    || applicationList[0].Solicitor_Status__c==ConstantValues.SETTLEMENT_BOOKED)){
                    requestParamMap.put(
                        'appStatus',
                        applicationList[0].Solicitor_Status__c
                    );
                }else{
                    requestParamMap.put(
                        'appStatus',
                        applicationList[0].genesis__Status__c
                    );
                }
            }
            
            intframework.AbstractIntegrationService baseintegrationService = intframework.IntegrationServiceFactory.getBaseIntegrationService();
            intframework.BaseIntegrationResponse responseObject;

            // Calling the adapter class, by specifying integraiton family and api type in the base integration service
            responseObject = (intframework.BaseIntegrationResponse) baseintegrationService.runSynchronousIntegrationService(
                'NextGen BCM',
                'NextGen BCM API',
                queryIdMap,
                requestParamMap
            );

        } catch(Exception exe){
            GenericUtility.insertLog(
                'NextGenBCMCallout',
                exe
            );
        }      
                
    }

    public static String getUUID()
    {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid;
        if(h.length()>=20){
            guid= h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + 
                    h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        }
        return guid;
    }

    @InvocableMethod(
    label='call seachByAppId callout Method'
    description='Call seachByAppId callout'
    )
    public static void nextGenBCMCallout(List<Id> appIdList){
        try{
            for(Id appId:appIdList){
                searchByAppId(appId);
            }
        }catch(Exception exe){
            GenericUtility.insertLog(
                'NextGenBCMCallout',
                exe
            );
        }
        
    }
}