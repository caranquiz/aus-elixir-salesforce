/**********************************************************************************************************************************************************
Company : CloudKaptan Consultancy Services Pvt. Ltd.
Developer : Rameswari Barman
Development Date : 03/05/2021
Last Modified By : Rameswari Barman
Last Modified Date : 03/05/2021
Description : This Handler class is called from before update trigger called from CollateralOwnerTrigger
Helps in checking whether the account owner belong to the application attached with the collateral
***********************************************************************************************************************************************************/
public with sharing class CollateralOwnerTriggerHandler {
    public static void collateralCheck(List<clcommon__Collateral_Owner__c> newList) {
        Set <Id> collateralList = new Set<Id>();
        Set <Id> accountIdList = new Set<Id>();
        try{
            for(clcommon__Collateral_Owner__c eachColOwner : newList){
                collateralList.add(eachColOwner.clcommon__Collateral__c);
            }
            List <clcommon__Party__c> partyList = [SELECT Id,
                                                        clcommon__Account__c
                                                        FROM clcommon__Party__c 
                                                        WHERE genesis__Application__c IN (SELECT genesis__Application__c
                                                                                            FROM genesis__Application_Collateral__c
                                                                                            WHERE genesis__Collateral__c =: collateralList)
                                                        ORDER BY genesis__Application__c];
            for(clcommon__Party__c eachParty : partyList){
                accountIdList.add(eachParty.clcommon__Account__c);
            }
            for(clcommon__Collateral_Owner__c eachColOwner : newList){
                if(accountIdList.contains(eachColOwner.clcommon__Account__c) == false){
                    eachColOwner.clcommon__Account__c.addError('Only accounts from the same application can be added as Collateral Owners.');
                }
            }
        }
        catch(Exception e){
            GenericUtility.insertLog('CollateralOwnerTriggerHandler', e);
        }
    }
}